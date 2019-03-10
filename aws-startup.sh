#!/bin/sh
git config --global credential.helper '!aws codecommit credential-helper $@'
git config --global credential.UseHttpPath true
POSTFIX=$(cat postfix)
git clone https://git-codecommit.eu-west-1.amazonaws.com/v1/repos/do-prace-na-kole-secrets$POSTFIX secrets
ln -s secrets/docker.env docker.env
POSTFIX=$(cat postfix)
if [ "${POSTFIX}" == "-test" ]; then
    BRANCH="devel"
elif  [ "${POSTFIX}" == "-prod" ]; then
    BRANCH="master"
fi
curl https://raw.githubusercontent.com/auto-mat/do-prace-na-kole-infrastructure/$BRANCH/restart_docker_containers > restart_docker_containers
chmod +x restart_docker_containers
bash restart_docker_containers
