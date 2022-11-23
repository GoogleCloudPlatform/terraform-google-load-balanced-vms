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

locals {
  default_machine_type = "e2-medium"
}

# Enabling services in your GCP project
module "project-services" {
  source                      = "terraform-google-modules/project-factory/google//modules/project_services"
  version                     = "~> 13.0"
  disable_services_on_destroy = false

  project_id  = var.project_id
  enable_apis = var.enable_apis

  activate_apis = [
    "compute.googleapis.com"
  ]
}

module "vpc" {
  source  = "terraform-google-modules/network/google"
  version = "~> 4.0"

  project_id   = var.project_id
  network_name = "${var.deployment_name}-network"
  routing_mode = "GLOBAL"

  subnets = [
    {
      subnet_name   = "subnet-01"
      subnet_ip     = "10.10.10.0/24"
      subnet_region = var.region
    }
  ]

  depends_on = [
    module.project-services
  ]

}

resource "google_compute_firewall" "private-allow-ssh" {
  name    = "${var.deployment_name}-allow-ssh"
  project = var.project_id
  network = module.vpc.network_id

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]

  target_tags = ["private-ssh"]
}

data "local_file" "index" {
  filename = "${path.module}/files/index.html"

}

# Create Instance Exemplar on which to base Managed VMs
resource "google_compute_instance" "exemplar" {
  name         = "${var.deployment_name}-exemplar"
  machine_type = local.default_machine_type
  zone         = var.zone
  project      = var.project_id
  labels       = var.labels

  tags                    = ["http-server", "private-ssh"]
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
    subnetwork         = module.vpc.subnets["${var.region}/subnet-01"].self_link
    subnetwork_project = var.project_id
    access_config {
      // Ephemeral public IP
    }
  }

  depends_on = [module.vpc]
}

resource "time_sleep" "startup_completion" {
  create_duration = "120s"
  depends_on      = [google_compute_instance.exemplar]
}

resource "google_compute_snapshot" "main" {
  project           = var.project_id
  name              = "${var.deployment_name}-snapshot"
  source_disk       = google_compute_instance.exemplar.boot_disk[0].device_name
  zone              = var.zone
  storage_locations = [var.region]
  depends_on        = [time_sleep.startup_completion]
  labels            = var.labels
}

# Create Disk Image for Instance Template
resource "google_compute_image" "exemplar" {
  project         = var.project_id
  name            = "${var.deployment_name}-latest"
  family          = var.deployment_name
  source_snapshot = google_compute_snapshot.main.self_link
  depends_on      = [google_compute_snapshot.main]
  labels          = var.labels
}

# Create Instance Template
resource "google_compute_instance_template" "main" {
  project     = var.project_id
  name        = "${var.deployment_name}-template"
  description = "This template is used to create app server instances."
  tags        = ["http-server", "private-ssh"]
  labels      = var.labels

  metadata_startup_script = "sed -i.bak \"s/{{NODENAME}}/$HOSTNAME/\" /var/www/html/index.html"

  instance_description = "${var.deployment_name} node"
  machine_type         = local.default_machine_type
  can_ip_forward       = false

  // Create a new boot disk from an image
  disk {
    source_image = google_compute_image.exemplar.self_link
    auto_delete  = true
    boot         = true
  }

  network_interface {
    subnetwork         = module.vpc.subnets["${var.region}/subnet-01"].self_link
    subnetwork_project = var.project_id
    access_config {
      // Ephemeral public IP
    }
  }

}

# Create Managed Instance Group
resource "google_compute_instance_group_manager" "main" {
  project            = var.project_id
  provider           = google-beta
  name               = "${var.deployment_name}-mig"
  zone               = var.zone
  target_size        = var.nodes
  base_instance_name = "${var.deployment_name}-mig"

  version {
    instance_template = google_compute_instance_template.main.id
  }

  all_instances_config {
    labels = var.labels
  }

  named_port {
    name = "http"
    port = "80"
  }

}

module "gce-lb-http" {
  source  = "GoogleCloudPlatform/lb-http/google"
  version = "~> 6.3"

  project = var.project_id
  name    = "${var.deployment_name}-lb"

  firewall_networks = [module.vpc.network_name]

  backends = {
    default = {
      description                     = null
      protocol                        = "HTTP"
      port                            = "80"
      port_name                       = "http"
      timeout_sec                     = 10
      enable_cdn                      = false
      custom_request_headers          = null
      custom_response_headers         = null
      security_policy                 = null
      connection_draining_timeout_sec = null
      session_affinity                = null
      affinity_cookie_ttl_sec         = null



      health_check = {
        check_interval_sec  = null
        timeout_sec         = null
        healthy_threshold   = null
        unhealthy_threshold = null
        request_path        = "/"
        port                = "80"
        name                = "${var.deployment_name}-health-chk"
        host                = null
        logging             = null
      }

      log_config = {
        enable      = true
        sample_rate = 1.0
      }

      groups = [
        {
          group                        = google_compute_instance_group_manager.main.instance_group
          balancing_mode               = null
          capacity_scaler              = null
          description                  = null
          max_connections              = null
          max_connections_per_instance = null
          max_connections_per_endpoint = null
          max_rate                     = null
          max_rate_per_instance        = null
          max_rate_per_endpoint        = null
          max_utilization              = null
        },
      ]

      iap_config = {
        enable               = false
        oauth2_client_id     = null
        oauth2_client_secret = null
      }
    }
  }
}
