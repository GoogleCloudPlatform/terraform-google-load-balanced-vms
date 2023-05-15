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

# Waiting for website to be serving http
output "load_balancer_endpoint" {
  value       = "http://${module.gce-lb-http.external_ip}/"
  description = "The url of the front end which we want to surface to the user"
}

output "neos_tutorial_url" {
  value       = "https://console.cloud.google.com/products/solutions/catalog?walkthrough_id=solutions-in-console--load-balanced-vms--tour&project=${var.project_id}"
  description = "The URL to launch the in-console tutorial for the Load balanced managed VMs solution"
}

# Output loadbalancer details
output "console_page_for_load_balancer" {
  value       = "https://console.cloud.google.com/net-services/loadbalancing/details/http/${var.deployment_name}-lb-url-map?project=${var.project_id}"
  description = "The url of the load balancer page in console"
}
