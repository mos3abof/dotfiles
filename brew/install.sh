#!/bin/bash

for pkg in $(cat packages); do brew install "${pkg}"; done
for font in $(cat fonts); do brew install "${font}"; done
