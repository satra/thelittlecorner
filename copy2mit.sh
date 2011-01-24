#! /usr/bin/env bash
kinit
rsync -auv _build/html/. satra@linux.dialup.mit.edu:www/.