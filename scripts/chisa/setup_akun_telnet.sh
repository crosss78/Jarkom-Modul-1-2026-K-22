#!/bin/bash

set -e

USER="phantom_user"
PASSWORD="wired_ghost"

echo "======================================"
echo "     Setup Telnet Server - Chisa"
echo "======================================"

# ======================================
# 1. Install telnetd
# ======================================
echo
echo "[1] Mengecek telnetd..."

if command -v telnetd >/dev/null 2>&1; then
    echo "[+] telnetd sudah terinstall."
else
    echo "[+] telnetd belum terinstall."
    echo "[+] Installing telnetd..."

    apt-get update
    apt-get install -y telnetd
fi

echo "[+] telnetd:"
which telnetd

# ======================================
# 2. Membuat user
# ======================================
echo
echo "[2] Mengecek user $USER..."

if id "$USER" >/dev/null 2>&1; then
    echo "[+] User $USER sudah ada."
else
    echo "[+] Membuat user $USER..."
    useradd -m -s /bin/bash "$USER"
fi

# ======================================
# 3. Mengatur password
# ======================================
echo
echo "[3] Mengatur password..."

echo "$USER:$PASSWORD" | chpasswd

echo "[+] Password berhasil diatur."

# ======================================
# 4. Verifikasi user
# ======================================
echo
echo "[4] Verifikasi user..."

id "$USER"
passwd -S "$USER"

# ======================================
# 5. Menjalankan Telnet server
# ======================================
echo
echo "[5] Menjalankan Telnet server..."

if command -v service >/dev/null 2>&1; then
    service inetutils-telnetd restart 2>/dev/null || \
    service openbsd-inetd restart 2>/dev/null || \
    service inetd restart 2>/dev/null || true
fi

# Jalankan inetd jika tersedia
if command -v inetd >/dev/null 2>&1; then
    pgrep -x inetd >/dev/null 2>&1 || inetd
fi

echo "telnet stream tcp nowait root /usr/sbin/telnetd telnetd" > /etc/inetd.conf
service inetutils-inetd restart

# ======================================
# 6. Verifikasi port Telnet
# ======================================
echo
echo "[6] Mengecek Telnet port 23..."

if ss -lntp | grep -q ':23'; then
    echo "[SUCCESS] Telnet server listening pada port 23."
    ss -lntp | grep ':23'
else
    echo "[WARNING] Port 23 belum terlihat listening."
    echo "Silakan cek konfigurasi inetd/telnetd."
fi

echo
echo "======================================"
echo "       Setup Telnet Selesai"
echo "======================================"

echo
echo "[+] User      : $USER"
echo "[+] Password  : $PASSWORD"
echo "[+] Target    : port 23"