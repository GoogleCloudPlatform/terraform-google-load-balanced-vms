/**
 * Copyright 2021 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */


data "google_project" "project" {
  project_id = var.project_id
}



# Enabling services in your GCP project
variable "gcp_service_list" {
  description = "The list of apis necessary for the project"
  type        = list(string)
  default = [
    "compute.googleapis.com",
  ]
}

resource "google_project_service" "all" {
  for_each                   = toset(var.gcp_service_list)
  project                    = data.google_project.project.number
  service                    = each.key
  disable_dependent_services = false
  disable_on_destroy         = false
}

resource "google_compute_network" "vpc_network" {
  name = "${var.deployment_name}-network"
  project      = var.project_id
}

# Create Instance Exemplar on which to base Managed VMs
resource "google_compute_instance" "exemplar" {
  name         = "${var.deployment_name}-exemplar"
  machine_type = "n1-standard-1"
  zone         = var.zone
  project      = var.project_id

  tags                    = ["http-server"]
  metadata_startup_script = "apt-get update -y \n apt-get install nginx -y \n  printf '${data.local_file.index.content}'  | tee /var/www/html/index.html \n chgrp root /var/www/html/index.html \n chown root /var/www/html/index.html \n chmod +r /var/www/html/index.html"

  boot_disk {
    auto_delete = true
    device_name = "${var.deployment_name}-exemplar"
    initialize_params {
      image = "family/debian-10"
      size  = 200
      type  = "pd-standard"
    }
  }

  network_interface {
    network = google_compute_network.vpc_network.id
    access_config {
      // Ephemeral public IP
    }
  }

  depends_on = [google_project_service.all]
}

data "local_file" "index" {
  filename = "${path.module}/code/index.html"
}

resource "time_sleep" "startup_completion" {
  create_duration = "120s"
  depends_on      = [google_compute_instance.exemplar]
}

resource "google_compute_snapshot" "snapshot" {
  project           = var.project_id
  name              = "${var.deployment_name}-snapshot"
  source_disk       = google_compute_instance.exemplar.boot_disk[0].device_name
  zone              = var.zone
  storage_locations = ["${var.region}"]
  depends_on        = [time_sleep.startup_completion]
}

# Create Disk Image for Instance Template
resource "google_compute_image" "exemplar" {
  project         = var.project_id
  name            = "${var.deployment_name}-latest"
  family          = var.deployment_name
  source_snapshot = google_compute_snapshot.snapshot.self_link
  depends_on      = [google_compute_snapshot.snapshot]
}

# Create Instance Template
resource "google_compute_instance_template" "default" {
  project     = var.project_id
  name        = "${var.deployment_name}-template"
  description = "This template is used to create app server instances."
  tags        = ["httpserver"]

  metadata_startup_script = "sed -i.bak \"s/{{NODENAME}}/$HOSTNAME/\" /var/www/html/index.html"

  instance_description = "BasicLB node"
  machine_type         = "n1-standard-1"
  can_ip_forward       = false

  // Create a new boot disk from an image
  disk {
    source_image = google_compute_image.exemplar.self_link
    auto_delete  = true
    boot         = true
  }

  network_interface {
    network = google_compute_network.vpc_network.id
  }

  depends_on = [google_compute_image.exemplar]
}

# Create Managed Instance Group
resource "google_compute_instance_group_manager" "default" {
  project            = var.project_id
  name               = "${var.deployment_name}-mig"
  zone               = var.zone
  target_size        = var.nodes
  base_instance_name = "${var.deployment_name}-mig"


  version {
    instance_template = google_compute_instance_template.default.id
  }

  named_port {
    name = "http"
    port = "80"
  }

  depends_on = [google_compute_instance_template.default]
}

# Creating External IP
resource "google_compute_global_address" "default" {
  project    = var.project_id
  name       = "${var.deployment_name}-ip"
  ip_version = "IPV4"
}

# Standing up Load Balancer
resource "google_compute_health_check" "http" {
  project = var.project_id
  name    = "${var.deployment_name}-health-chk"

  tcp_health_check {
    port = "80"
  }
}

resource "google_compute_firewall" "allow-health-check" {
  project       = var.project_id
  name          = "${var.deployment_name}-allow-health-check"
  network       = google_compute_network.vpc_network.self_link
  source_ranges = ["130.211.0.0/22", "35.191.0.0/16"]

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }
}

resource "google_compute_backend_service" "default" {
  project               = var.project_id
  name                  = "${var.deployment_name}-service"
  load_balancing_scheme = "EXTERNAL"
  protocol              = "HTTP"
  port_name             = "http"
  backend {
    group = google_compute_instance_group_manager.default.instance_group
  }

  health_checks = [google_compute_health_check.http.id]
}

resource "google_compute_url_map" "lb" {
  project         = var.project_id
  name            = "${var.deployment_name}-lb"
  default_service = google_compute_backend_service.default.id
}

# Enabling HTTP
resource "google_compute_target_http_proxy" "default" {
  project = var.project_id
  name    = "${var.deployment_name}-lb-proxy"
  url_map = google_compute_url_map.lb.id
}

resource "google_compute_forwarding_rule" "google_compute_forwarding_rule" {
  project               = var.project_id
  name                  = "${var.deployment_name}-http-lb-forwarding-rule"
  provider              = google-beta
  region                = "none"
  load_balancing_scheme = "EXTERNAL"
  port_range            = "80"
  target                = google_compute_target_http_proxy.default.id
  ip_address            = google_compute_global_address.default.id
}
