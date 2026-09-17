#!/bin/bash

set -e

FTP_DIR="/var/wired/data"
VSFTPD_CONF="/etc/vsftpd.conf"
USERLIST="/etc/vsftpd.user_list"

echo "======================================"
echo "   Setup FTP Server - Chisa"
echo "======================================"

# Pastikan vsftpd terinstall
if ! command -v vsftpd >/dev/null 2>&1; then
    echo "[+] Installing vsftpd..."
    apt-get update
    apt-get install -y vsftpd
else
    echo "[+] vsftpd sudah terinstall."
fi

# Membuat user jika belum ada
for USER in alice mika eiri; do
    if id "$USER" >/dev/null 2>&1; then
        echo "[+] User $USER sudah ada."
    else
        echo "[+] Membuat user $USER..."
        useradd -m -s /bin/bash "$USER"
    fi
done

# Mengatur password user FTP
echo "[+] Mengatur password user FTP..."

echo "alice:alice123" | chpasswd
echo "mika:mika123" | chpasswd
echo "eiri:eiri123" | chpasswd

echo "[+] Password user berhasil diatur."

# Shared directory
echo "[+] Membuat shared folder: $FTP_DIR"
mkdir -p "$FTP_DIR"

# Alice sebagai owner => read/write
# Mika sebagai group => read-only
echo "[+] Mengatur ownership dan permission..."
chown alice:mika "$FTP_DIR"
chmod 755 "$FTP_DIR"

# FTP user blacklist
echo "[+] Membuat FTP blacklist..."
cat > "$USERLIST" <<EOF
eiri
EOF

# Konfigurasi vsftpd
echo "[+] Menulis konfigurasi vsftpd..."

cat > "$VSFTPD_CONF" <<EOF
listen=YES
listen_ipv6=NO

anonymous_enable=NO
local_enable=YES
write_enable=YES

local_umask=022

local_root=$FTP_DIR

userlist_enable=YES
userlist_deny=YES
userlist_file=$USERLIST

xferlog_enable=YES
connect_from_port_20=YES

pasv_enable=YES
pasv_min_port=30000
pasv_max_port=30100

use_localtime=YES
EOF

# Pastikan directory dapat diakses oleh FTP
chmod 755 "$FTP_DIR"

# Validasi konfigurasi
echo "[+] Mengecek konfigurasi vsftpd..."
timeout 2 vsftpd -olisten=NO -olisten_ipv6=NO /etc/vsftpd.conf || true
echo "[+] Konfigurasi vsftpd selesai dicek."

# Restart service
echo "[+] Restart vsftpd..."

if command -v service >/dev/null 2>&1; then
    service vsftpd restart
else
    pkill vsftpd 2>/dev/null || true
    /usr/sbin/vsftpd "$VSFTPD_CONF" &
fi

echo
echo "======================================"
echo "   Konfigurasi FTP selesai"
echo "======================================"

echo
echo "[*] Directory:"
ls -ld "$FTP_DIR"

echo
echo "[*] User:"
id alice
id mika
id eiri

echo
echo "[*] FTP blacklist:"
cat "$USERLIST"

echo
echo "[*] vsftpd listening:"
ss -lntp | grep ':21' || true

echo
echo "[+] Selesai."