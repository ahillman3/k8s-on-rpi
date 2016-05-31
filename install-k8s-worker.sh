#!/bin/bash

cd "$( dirname "${BASH_SOURCE[0]}" )"

apt-get install bridge-utils

echo "Copying kubernetes service configuration files"
cp -f ./rootfs/lib/systemd/system/k8s-flannel.service /lib/systemd/system/k8s-flannel.service
cp -f ./rootfs/lib/systemd/system/k8s-worker.service /lib/systemd/system/k8s-worker.service

echo "Reloading the system service configuration"
systemctl daemon-reload

echo "Enabling the new services"
systemctl enable k8s-flannel.service k8s-worker.service

echo "Pulling necessary flannel Docker image"
docker pull andrewpsuedonym/flanneld
echo "Starting the flannel service"
systemctl start k8s-flannel.service

echo "Pulling necessary hyperkube Docker image"
docker pull gcr.io/google_containers/hyperkube-arm:v1.1.2
echo "Starting the kubernetes worker service"
systemctl start k8s-worker.service

