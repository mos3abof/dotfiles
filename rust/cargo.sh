#!/bin/bash
set -exv

# Install cargo packages
cargo install $(cat packages)
