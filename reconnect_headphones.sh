#!/usr/bin/env bash

DEVICE="soundcore Space One Pro"

# 1. Get the MAC address of the device from known devices
MAC=$(bluetoothctl devices | grep -F "$DEVICE" | head -n1 | awk '{print $2}')

if [ -z "$MAC" ]; then
  echo "Error: Could not find MAC address for '$DEVICE'."
  echo "Make sure it has been paired to this computer at least once."
  exit 1
fi

echo "Found $DEVICE at $MAC"

# 2. Disconnect if currently connected
echo "Disconnecting..."
bluetoothctl disconnect "$MAC" 2>/dev/null || true

# 3. Restart the Bluetooth controller
echo "Restarting Bluetooth controller..."
bluetoothctl power off
sleep 1 # Give the controller a second to fully power down
bluetoothctl power on
sleep 2 # Give the controller time to wake up and initialize

# 4. Reconnect
echo "Reconnecting to $DEVICE..."
bluetoothctl connect "$MAC"