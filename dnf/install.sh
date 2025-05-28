#!/usr/bin/env bash

dnf install "$(cat packages-list.txt)" -y
