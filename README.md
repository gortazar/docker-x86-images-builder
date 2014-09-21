# Docker x86 images builder

This project provides a script for building x86 (32 bits) docker base images. In order to enable easy testing (to check if it fits your needs), a Vagrantfile is provided. 

## Usage

If don't want to polute you environment, just use the vagrant configuration (you need Vagrant and VirtualBox). Open Vagrantfile and look for the line 

    config.vm.provision "shell", inline: "cd /vagrant_data && ./build-base-image.sh gortazar"

Replace the username "gortazar" with your username, and then

    vagrant up

This will:

* fire up an Ubuntu Trusty x86 virtual machine; 
* run build-docker-image.sh script on it, which in turn will build a base docker image that would be available in your local repository as `<your_username>/<ubuntu_version>-base32:0.1` 

You can publish this image to your Docker Hub repository for further usage if you want. This may ease building other docker x86 images. I've published the image for Ubuntu Trusty [in my repository](https://registry.hub.docker.com/u/gortazar/base32/).

## Checking everything is in place

We can check the image creation by login into the vm

    vagrant ssh

And listing the images

    sudo docker images

    REPOSITORY               TAG                 IMAGE ID            CREATED             VIRTUAL SIZE
    gortazar/trusty-base32   0.1                 58e345ace251        5 minutes ago       216.8 MB

To test the image, a Dockerfile is provided. This Dockerfile builds a docker image with curl installed. cd to the shared folder

    cd /vagrant_data

Change the line 

    FROM gortazar/base32

to the image name listed by docker

    FROM gortazar/trusty-base32:0.1

Build the image

    sudo docker build -t <your username>/curl:0.1 .

Run the image using curl

    sudo docker run -t <your username>/curl:0.1 /usr/bin/curl https://github.com

## The script

The ubuntu x86 docker image is built with the build-base-image.sh script. I've prepared the script to work with any Ubuntu version. However, I only checked Trusty. So there's no guarantee that it will work on other versions. Anyway shouldn't be too hard to adapt the script to whatever Ubuntu version you want to build images for.

## Acknowledgements

Most work here is based on [this](http://mwhiteley.com/linux-containers/2013/08/31/docker-on-i386.html) Matt Whiteley blog post about building docker x86 binaries and images. 
