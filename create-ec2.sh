#!/bin/bash

NAMES=("mongodb" "redis" "mysql" "rabbitmq" "catalogue" "user" "cart" "shipping" "payment" "dispatch" "web")

for item in "${NAMES[@]}"
do
    echo "NAME : $item \n"
done