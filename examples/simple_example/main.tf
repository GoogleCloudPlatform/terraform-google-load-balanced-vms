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

module "load_balanced_vms" {
  source  = "GoogleCloudPlatform/load-balanced-vms/google"
  version = "~> 0.5"

  project_id = var.project_id
  region     = "us-central1"
  zone       = "us-central1-a"
  nodes      = "2"
  // param for testing multiple deployments in a single project
  deployment_name = var.deployment_name
}
