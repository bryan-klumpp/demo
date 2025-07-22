#!/bin/bash
# nmcliregfunct.sh
#
# This script contains and registers two functions for use with nmcli:
#   1. nmcliassoc - Associates a network adapter with a predefined network connection.
#   2. nmclimkstatic - Creates a new nmcli connection for a static IP address and subnet mask if it doesn't already exist.
#
# --- nmcliassoc ---
# Usage:
#   nmcliassoc eth0 "My WiFi"
# - The first argument is the network adapter name (e.g., eth0).
# - The second argument is the connection name (e.g., "My WiFi").
# If the number of arguments is not exactly 2, it prints the usage example and exits immediately.
# If the connection does not exist, it prints a relevant error.
# If the interface name (adapter) does not exist, it prints a relevant error.
# Example:
#   nmcliassoc eth0 "My WiFi"

nmcliassoc() {
  if [ "$#" -ne 2 ]; then
    echo 'Usage: nmcliassoc eth0 "My WiFi"'
    return 1
  fi
  local adapter="$1"
  local connection="$2"
  if ! nmcli -t -f NAME connection show | grep -Fxq "$connection"; then
    echo "Error: Connection '$connection' does not exist."
    return 2
  fi
  if ! nmcli -t -f DEVICE device status | grep -Fxq "$adapter"; then
    echo "Error: Network adapter '$adapter' does not exist or is not available."
    return 3
  fi
  echo "Please execute this:  sudo nmcli connection modify \"$connection\" connection.interface-name \"$adapter\""
}

# --- nmclimkstatic ---
# Usage:
#   nmclimkstatic 192.168.1.100 24
# - The first argument is the static IP address (e.g., 192.168.1.100).
# - The second argument is the subnet mask in CIDR notation (e.g., 24).
# If the number of arguments is not exactly 2, it prints the usage example and exits immediately.
# If the connection already exists, it does not create a new one.
# The script outputs only the name of the connection.
# Example:
#   nmclimkstatic 192.168.1.100 23

nmclimkstatic() {
  if [ "$#" -ne 2 ]; then
    echo 'Usage: nmclimkstatic 192.168.1.100 23'
    return 1
  fi
  local ip="$1"
  local mask="$2"
  local conn_name="static-${ip//./-}"
  if nmcli -t -f NAME connection show | grep -Fxq "$conn_name"; then
    echo "$conn_name"
    return 0
  fi
  #echo "sudo nmcli connection add type ethernet ifname '' con-name \"$conn_name\" ipv4.method manual ipv4.addresses \"$ip/$mask\" ipv4.gateway '' ipv4.dns '' ipv6.method ignore"
  echo "$conn_name"
}

# --- nmcliapplyconndynamic ---
# Usage:
#   nmcliapplyconndynamic "My WiFi"
# - Takes one argument: the connection name.
# - Validates that the connection exists.
# - Applies the connection to all real network adapters that do not already have a static IP address and are not docker or loopback devices.
#
nmcliapplyconndynamic() {
  if [ "$#" -ne 1 ]; then
    echo 'Usage: nmcliapplyconndynamic "Connection Name"'
    return 1
  fi
  local connection="$1"
  # Validate connection exists
  if ! nmcli -t -f NAME connection show | grep -Fxq "$connection"; then
    echo "Error: Connection '$connection' does not exist."
    return 2
  fi
  # Get all real adapters (not docker, not loopback, not already static)
  nmcli -t -f DEVICE,TYPE,STATE device status | \
    awk -F: '$2=="ethernet" && $3!="unavailable" && $1!~/(docker|br-|veth|lo)/ {print $1}' | while read -r adapter; do
    # Skip if adapter already has a static IP
    if nmcli -g connection.interface-name,ipv4.method connection show | \
         grep -A1 "^$adapter$" | grep -q '^manual$'; then
      continue
    fi
    echo "Please execute this command:  sudo nmcli connection modify \"$connection\" connection.interface-name \"$adapter\""
    echo "# To apply '$connection' to $adapter"
  done
}

# --- lucky_push ---
# Usage:
#   lucky_push
# - Shows git status and waits 5 seconds for user to press Ctrl+C to cancel.
# - If not cancelled, runs git add *, commits with a lazy message, and pushes.
lucky_push() {
  git status
  echo "Press Ctrl+C within 5 seconds to cancel push..."
  sleep 5 && {}
  git add *
  git commit -m "Sorry, I'm being lazy"
  git push
}
}
