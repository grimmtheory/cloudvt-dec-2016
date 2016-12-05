#!/bin/bash
echo -e "parameters:" > ../../heat/heat-env.yaml
terraform show | grep ": " | sed -e 's/ = / /g' | sed -e 's/\[0m//g' >> ../../heat/heat-env.yaml
cat ../../heat/heat-env.yaml
