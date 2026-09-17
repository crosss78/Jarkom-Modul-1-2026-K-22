#!/bin/bash

set -e

echo "======================================"
echo "    Setup Port Scan Target - Knights"
echo "======================================"

# ======================================
# 1. Setup SSH Server - Port 22
# ======================================
echo
echo "[1] Mengecek SSH server..."

if command -v sshd >/dev/null 2>&1; then
    echo "[+] SSH server sudah terinstall."
else
    echo "[+] SSH server belum terinstall."
    echo "[+] Installing openssh-server..."

    apt-get update
    apt-get install -y openssh-server
fi

echo
echo "[+] Menjalankan SSH server..."

service ssh start 2>/dev/null || service ssh restart

# ======================================
# 2. Setup Netcat
# ======================================
echo
echo "[2] Mengecek Netcat..."

if command -v nc >/dev/null 2>&1; then
    echo "[+] Netcat sudah terinstall."
else
    echo "[+] Netcat belum terinstall."
    echo "[+] Installing netcat-openbsd..."

    apt-get update
    apt-get install -y netcat-openbsd
fi

echo
echo "[+] Netcat:"
which nc

# ======================================
# 3. Membuka Port 80
# ======================================
echo
echo "[3] Mengecek port 80..."

if ss -lnt | grep -q ':80 '; then
    echo "[+] Port 80 sudah OPEN."
else
    echo "[+] Membuka port 80 dengan Netcat..."

    nc -lvkp 80 >/dev/null 2>&1 &
    sleep 1

    if ss -lnt | grep -q ':80 '; then
        echo "[SUCCESS] Port 80 OPEN."
    else
        echo "[ERROR] Gagal membuka port 80."
        exit 1
    fi
fi

# ======================================
# 4. Memastikan Port 7777 Tertutup
# ======================================
echo
echo "[4] Mengecek port 7777..."

if ss -lnt | grep -q ':7777 '; then
    echo "[WARNING] Port 7777 sedang OPEN."
    echo "[ERROR] Port 7777 harus CLOSED untuk requirement."
    exit 1
else
    echo "[+] Port 7777 CLOSED sesuai requirement."
fi

# ======================================
# 5. Verifikasi Port
# ======================================
echo
echo "======================================"
echo "       STATUS PORT KNIGHTS"
echo "======================================"

echo
echo "[*] Port 22 (SSH):"
if ss -lnt | grep -q ':22 '; then
    echo "[OPEN]"
    ss -lnt | grep ':22 '
else
    echo "[CLOSED]"
fi

echo
echo "[*] Port 80 (HTTP/Netcat):"
if ss -lnt | grep -q ':80 '; then
    echo "[OPEN]"
    ss -lnt | grep ':80 '
else
    echo "[CLOSED]"
fi

echo
echo "[*] Port 7777 (Secret):"
if ss -lnt | grep -q ':7777 '; then
    echo "[OPEN]"
else
    echo "[CLOSED]"
fi

echo
echo "======================================"
echo "             SELESAI"
echo "======================================"