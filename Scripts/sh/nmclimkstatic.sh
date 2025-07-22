#!/bin/bash
# nmclimkstatic.sh
#
# This script creates a new nmcli connection for a static IP address and subnet mask if it doesn't already exist.
#
# Usage:
#   nmclimkstatic 192.168.1.100 24
#
# - The first argument is the static IP address (e.g., 192.168.1.100).
# - The second argument is the subnet mask in CIDR notation (e.g., 24).
#
# If the number of arguments is not exactly 2, it prints the usage example and exits immediately.
# If the connection already exists, it does not create a new one.
# The script outputs only the name of the connection.
#
# Example:
#   nmclimkstatic 192.168.1.100 24

  if [ "$#" -ne 2 ]; then
    echo 'Usage: nmclimkstatic 192.168.1.100 23'
    return 1
  fi
  local ip="$1"
  local mask="$2"
  local conn_name="static-${ip//./-}"

  # Check if connection exists
  if nmcli -t -f NAME connection show | grep -Fxq "$conn_name"; then
    echo "$conn_name"
    return 0
  fi

  # Create the new connection
  nmcli connection add type ethernet ifname "" con-name "$conn_name" ipv4.method manual ipv4.addresses "$ip/$mask" ipv4.gateway "" ipv4.dns "" ipv6.method ignore 1>/dev/null 2>/dev/null
  echo "$conn_name"

