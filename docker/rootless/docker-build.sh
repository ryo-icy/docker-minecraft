#!/bin/bash
docker build --tag minecraft --build-arg UID=$(id -u) .
