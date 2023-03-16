endpoint=$(terraform output load_balancer_endpoint)  
endpoint=${endpoint/\"/}
endpoint=${endpoint/\"/}
echo "Waiting for the client to be active"

attempt_counter=0
max_attempts=100

until $(curl --output /dev/null --silent --head --fail $endpoint); do
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
    attempt_counter=$(($attempt_counter+1))
    sleep 5
done

echo "Success, architecture is ready."
echo "To see for yourself, go check out:"
echo "$endpoint"