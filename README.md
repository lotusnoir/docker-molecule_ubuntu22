# Docker Image with Ubuntu 22 base image

This repo was created in order to test ansible roles with molecule.

## Build it locally

docker build - < Dockerfile

## Use it from dockerhub

    https://hub.docker.com/repository/docker/lotusnoir/ansible_molecule_test_images:ubuntu22

## Run locally

    docker pull lotusnoir/ansible_molecule_test_images:ubuntu22
    docker run -d --privileged --volume=/sys/fs/cgroup:/sys/fs/cgroup:ro lotusnoir/ansible_molecule_test_images:ubuntu22
    docker ps -a
    ocker exec -t DOCKER_ID /bin/bash
