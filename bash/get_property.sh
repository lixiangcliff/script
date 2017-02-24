#!/usr/bin/env bash

# Usage: get_property FILE KEY
grep "^$2=" "$1" | cut -d'=' -f2