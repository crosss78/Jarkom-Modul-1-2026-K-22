#!/bin/bash

echo "======================================"
echo "       Fix DNS - $(hostname)"
echo "======================================"

echo "[+] Mengatur DNS resolver..."

cat > /etc/resolv.conf <<DNS
nameserver 8.8.8.8
DNS

echo
echo "[+] Isi /etc/resolv.conf:"
cat /etc/resolv.conf

ping -c 3 google.com

echo
echo "[+] Testing DNS..."
if getent hosts deb.debian.org; then
    echo
    echo "[SUCCESS] DNS berhasil."
else
    echo
    echo "[ERROR] DNS masih bermasalah."
    exit 1
fi