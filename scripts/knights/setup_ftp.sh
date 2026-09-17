#!/bin/bash

set -e

echo "======================================"
echo "      Setup FTP Client - $(hostname)"
echo "======================================"

echo
echo "[+] Updating package list..."
apt-get update

echo
echo "[+] Installing FTP client..."
apt-get install -y ftp

echo
echo "[+] Verifying FTP client..."
if command -v ftp >/dev/null 2>&1; then
    echo "[SUCCESS] FTP client berhasil terinstall."
    echo
    echo "Location:"
    which ftp

else
    echo "[ERROR] FTP client gagal terinstall."
    exit 1
fi

echo
echo "======================================"
echo "       Setup FTP Client Selesai"
echo "======================================"