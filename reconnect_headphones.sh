#!/usr/bin/env bash

DEVICE="soundcore Space One Pro"

bluetoothctl disconnect "$DEVICE" 2>/dev/null || true
bluetoothctl remove "$DEVICE" 2>/dev/null || true

bluetoothctl power off
bluetoothctl power on

bluetoothctl scan on >/dev/null 2>&1 &
SCAN_PID=$!

until bluetoothctl devices | grep -Fq "$DEVICE"; do
  sleep 1
done

kill "$SCAN_PID" 2>/dev/null || true
bluetoothctl scan off >/dev/null 2>&1

bluetoothctl connect "$(bluetoothctl devices | grep -F "$DEVICE" | head -n1 | awk '{print $2}')"
