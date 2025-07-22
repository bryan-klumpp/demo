#!/bin/bash
# nmcliassoc.sh
#
# This function uses nmcli to associate a network adapter with an existing predefined network connection configuration.
#
# Usage:
#   nmcliassoc eth0 "My WiFi"
#
# - The first argument is the network adapter name (e.g., eth0).
# - The second argument is the connection name (e.g., "My WiFi").
#
# If the number of arguments is not exactly 2, it prints the usage example and exits immediately.
# If the connection does not exist, it prints a relevant error.
# If the interface name (adapter) does not exist, it prints a relevant error.
#
# Example:
#   nmcliassoc eth0 "My WiFi"

  if [ "$#" -ne 2 ]; then
    echo 'Usage: nmcliassoc eth0 "My WiFi"'
    return 1
  fi
  local adapter="$1"
  local connection="$2"

  # Check if connection exists
  if ! nmcli -t -f NAME connection show | grep -Fxq "$connection"; then
    echo "Error: Connection '$connection' does not exist."
    return 2
  fi

  # Check if adapter exists
  if ! nmcli -t -f DEVICE device status | grep -Fxq "$adapter"; then
    echo "Error: Network adapter '$adapter' does not exist or is not available."
    return 3
  fi

  nmcli connection modify "$connection" connection.interface-name "$adapter" &&
    echo "Successfully associated adapter '$adapter' with connection '$connection'."

