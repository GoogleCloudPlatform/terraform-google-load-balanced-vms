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
output "endpoint" {
  value       = google_compute_global_address.default.address
  description = "The url of the front end which we want to surface to the user"
}

# Output loadbalancer details
output "console_page" {
  value       = "/net-services/loadbalancing/details/http/${google_compute_url_map.lb.name}?project=${var.project_id}"
  description = "The url of the load balancer page in console"
}
