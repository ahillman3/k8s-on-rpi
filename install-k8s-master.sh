#!/bin/bash

cd "$( dirname "${BASH_SOURCE[0]}" )"

apt-get install bridge-utils

echo "Copying kubernetes service configuration files"
mkdir /etc/kubernetes
cp -f ./rootfs/etc/kubernetes/k8s.conf /etc/kubernetes/k8s.conf
cp -f ./rootfs/lib/systemd/system/k8s-etcd.service /lib/systemd/system/k8s-etcd.service
cp -f ./rootfs/lib/systemd/system/k8s-flannel.service /lib/systemd/system/k8s-flannel.service
cp -f ./rootfs/lib/systemd/system/k8s-master.service /lib/systemd/system/k8s-master.service

echo "Reloading the system service configuration"
systemctl daemon-reload

echo "Enabling the new services"
systemctl enable k8s-etcd.service k8s-flannel.service k8s-master.service

echo "Pulling necessary etcd Docker image"
docker pull andrewpsuedonym/etcd:2.1.1
echo "Starting the etcd service"
systemctl start k8s-etcd.service

echo "Pulling necessary flannel Docker image"
docker pull andrewpsuedonym/flanneld
echo "Starting the flannel service"
systemctl start k8s-flannel.service

echo "Pulling necessary hyperkube Docker image"
docker pull gcr.io/google_containers/hyperkube-arm:v1.1.2
echo "Starting the kubernetes master service"
systemctl start k8s-master.service

