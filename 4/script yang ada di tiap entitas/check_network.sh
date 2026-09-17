#!/bin/bash

echo "======================================"
echo "     Network Check - $(hostname)"
echo "======================================"

echo
echo "[1] IP Address"
ip -br a

echo
echo "[2] Routing Table"
ip route

echo
echo "[3] Gateway Test"
ping -c 3 -W 2 192.222.1.1

echo
echo "[4] Internet Connectivity Test"
ping -c 3 -W 2 8.8.8.8

echo
echo "[5] DNS Resolution Test"
getent hosts deb.debian.org

echo
echo "======================================"
echo "             SELESAI"
echo "======================================"