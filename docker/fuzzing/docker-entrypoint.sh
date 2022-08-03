#!/bin/bash
set -e

# Set permissions
user="$(id -u)"
if [ "$user" = '0' ]; then
	[ -d "/home/mosquitto" ] && chown -R mosquitto:mosquitto /home/mosquitto || true
fi

exec "$@"
