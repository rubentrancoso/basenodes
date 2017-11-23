#!/bin/bash

. scripts/PARAMETERS

docker run -p 3000:3000 -it "$IMAGENAME"
