#!/bin/bash

# Run this script as sudo and provide a username to tag image

if [ -z "$1" ] ; then
  echo "You must supply a username to tag image"
  exit 1
fi

USERNAME=$1
VERSION=$(lsb_release -a | grep Codename | sed "s/Codename:\s*//g")

echo "Building base image for Ubuntu version $VERSION"

apt-get update && apt-get install -y debootstrap docker.io

debootstrap $VERSION /tmp/rootfs
for d in $VERSION $VERSION-security $VERSION-updates $VERSION-backports
  do echo "deb http://archive.ubuntu.com/ubuntu ${d} main universe multiverse"
  done | sudo tee /tmp/rootfs/etc/apt/sources.list

tar czf /home/vagrant/$VERSION_base32_rootfs.tgz -C /tmp/rootfs .

cat /home/vagrant/$VERSION_base32_rootfs.tgz | docker import - $USERNAME/$VERSION-base32:0.1

