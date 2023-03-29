#!/bin/bash
# Copyright 2023 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

endpoint=$(terraform output load_balancer_endpoint)
endpoint=${endpoint/\"/}
endpoint=${endpoint/\"/}
echo "Waiting for the client to be active"

attempt_counter=0
# max_attempts=100
max_attempts=2

until curl --output /dev/null --silent --head --fail "$endpoint"; do
    if [ ${attempt_counter} -eq ${max_attempts} ];then
    repo=$(git config --get remote.origin.url)
    echo "Max attempts reached."
    echo "Solution was not successfully installed."
    echo
    echo "If the problem persists, please file an issue with the Github repo:"
    echo "${repo/.git/}/issues"
    exit 1
    fi

    printf '.'
    attempt_counter=$((attempt_counter+1))
    sleep 5
done

echo "Success, architecture is ready."
echo "To see for yourself, go check out:"
echo "$endpoint"
