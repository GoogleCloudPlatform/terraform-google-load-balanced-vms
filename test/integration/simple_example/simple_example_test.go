// Copyright 2022 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

package multiple_buckets

import (
	"fmt"
	"os"
	"strconv"
	"testing"

	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/gcloud"
	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/tft"
	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/utils"
	"github.com/stretchr/testify/assert"
)

func TestServiceActivated(t *testing.T) {
	example := tft.NewTFBlueprintTest(t)

	example.DefineVerify(func(assert *assert.Assertions) {
		example.DefaultVerify(assert)

		projectID := os.Getenv("TF_VAR_project_id")
		services := gcloud.Run(t, "services list", gcloud.WithCommonArgs([]string{"--project", projectID, "--format", "json"})).Array()

		match := utils.GetFirstMatchResult(t, services, "config.name", "compute.googleapis.com")
		assert.Equal("ENABLED", match.Get("state").String(), "compute service should be enabled")
	})
	example.Test()
}

func TestCount(t *testing.T) {
	example := tft.NewTFBlueprintTest(t)

	example.DefineVerify(func(assert *assert.Assertions) {
		// TODO: See if there is a better way to use input ENV variables.
		// I don't want these to be output, but it might be required.
		projectID := os.Getenv("TF_VAR_project_id")
		prefix := os.Getenv("TF_VAR_deployment_name")
		nodes := os.Getenv("TF_VAR_nodes")
		cmdstr := "compute instances list"
		ops := gcloud.WithCommonArgs([]string{"--project", projectID, "--format", "json", "--filter", fmt.Sprintf("name:%s-mig", prefix)})
		template := gcloud.Run(t, cmdstr, ops).Array()
		assert.Equal(nodes, strconv.Itoa(len(template)), fmt.Sprintf("should be %s instances", nodes))
	})
	example.Test()
}

func TestInfrastructureExists(t *testing.T) {
	// TODO: See if there is a better way to use input ENV variables.
	// I don't want these to be output, but it might be required.
	projectID := os.Getenv("TF_VAR_project_id")
	prefix := os.Getenv("TF_VAR_deployment_name")
	zone := os.Getenv("TF_VAR_zone")

	example := tft.NewTFBlueprintTest(t)

	tests := map[string]struct {
		subsection string
		global     bool
		zone       bool
		expected   string
	}{
		"Instance Group":      {subsection: "instance-groups managed", global: false, zone: true, expected: fmt.Sprintf("%s-mig", prefix)},
		"Image":               {subsection: "images", global: false, expected: fmt.Sprintf("%s-latest", prefix)},
		"Template":            {subsection: "instance-templates", global: false, expected: fmt.Sprintf("%s-template", prefix)},
		"Forwarding Rules":    {subsection: "forwarding-rules", global: true, expected: fmt.Sprintf("%s-http-lb-forwarding-rule", prefix)},
		"Target HTTP Proxies": {subsection: "target-http-proxies", global: true, expected: fmt.Sprintf("%s-lb-proxy", prefix)},
		"URL Maps":            {subsection: "url-maps", global: true, expected: fmt.Sprintf("%s-lb", prefix)},
		"Backend Services":    {subsection: "backend-services", global: true, expected: fmt.Sprintf("%s-service", prefix)},
		"Address":             {subsection: "addresses", global: true, expected: fmt.Sprintf("%s-ip", prefix)},
	}

	for name, tc := range tests {
		t.Run(name, func(t *testing.T) {
			example.DefineVerify(func(assert *assert.Assertions) {
				gcloudOps := gcloud.WithCommonArgs([]string{"--project", projectID, "--format", "json"})
				if tc.global {
					gcloudOps = gcloud.WithCommonArgs([]string{"--project", projectID, "--format", "json", "--global"})
				}
				if tc.zone {
					gcloudOps = gcloud.WithCommonArgs([]string{"--project", projectID, "--format", "json", "--zone", zone})
				}

				cmdstr := fmt.Sprintf("compute %s describe %s", tc.subsection, tc.expected)
				template := gcloud.Run(t, cmdstr, gcloudOps).Array()

				match := utils.GetFirstMatchResult(t, template, "name", tc.expected)
				assert.Equal(tc.expected, match.Get("name").String(), fmt.Sprintf("should find %s", tc.expected))
			})
			example.Test()
		})
	}
}
