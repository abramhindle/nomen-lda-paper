#!/bin/sh
sh list-slides.sh | sed -e 's/order/numbered/' | sed -e 's/\.[a-zA-Z]*$/.pdf/'
