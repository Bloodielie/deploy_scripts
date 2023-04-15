#!/bin/bash

url="${1:-$REGISTRATION_URL}"
registration_token="${2:-$REGISTRATION_TOKEN}"

sudo curl -L --output /usr/local/bin/gitlab-runner "https://gitlab-runner-downloads.s3.amazonaws.com/latest/binaries/gitlab-runner-linux-amd64"
sudo chmod +x /usr/local/bin/gitlab-runner
sudo useradd --comment 'GitLab Runner' --create-home gitlab-runner --shell /bin/bash
sudo gitlab-runner install --user=gitlab-runner --working-directory=/home/gitlab-runner
sudo gitlab-runner start

sudo gitlab-runner register --url $url --registration-token $registration_token

# set privileged = true in /etc/gitlab-runner/config.toml