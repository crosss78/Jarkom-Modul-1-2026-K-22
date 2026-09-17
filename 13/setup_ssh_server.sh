#!/bin/bash

set -e

USER="mika_admin"
SSH_DIR="/home/$USER/.ssh"
AUTHORIZED_KEYS="$SSH_DIR/authorized_keys"
SSHD_CONFIG="/etc/ssh/sshd_config"

echo "======================================"
echo "      Setup SSH Server - Knights"
echo "======================================"

# ======================================
# 1. Install OpenSSH Server
# ======================================
echo
echo "[1] Mengecek OpenSSH Server..."

if command -v sshd >/dev/null 2>&1; then
    echo "[+] OpenSSH Server sudah terinstall."
else
    echo "[+] OpenSSH Server belum terinstall."
    echo "[+] Installing openssh-server..."

    apt-get update
    apt-get install -y openssh-server
fi

echo "[+] sshd:"
which sshd

# ======================================
# 2. Membuat user mika_admin
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
# 3. Membuat SSH directory
# ======================================
echo
echo "[3] Menyiapkan SSH directory..."

mkdir -p "$SSH_DIR"

chmod 700 "$SSH_DIR"
chown "$USER:$USER" "$SSH_DIR"

# ======================================
# 4. Memasukkan Public Key
# ======================================
echo
echo "======================================"
echo "      PUBLIC KEY CONFIGURATION"
echo "======================================"

echo
echo "Paste public key dari Mika."
echo "Contoh:"
echo "ssh-ed25519 AAAA... mika_admin@Mika"
echo

read -r -p "Public Key: " PUBLIC_KEY

if [[ ! "$PUBLIC_KEY" =~ ^ssh-(ed25519|rsa|ecdsa) ]]; then
    echo
    echo "[ERROR] Format public key tidak valid."
    exit 1
fi

echo "$PUBLIC_KEY" > "$AUTHORIZED_KEYS"

chmod 600 "$AUTHORIZED_KEYS"
chown "$USER:$USER" "$AUTHORIZED_KEYS"

echo
echo "[+] Public key berhasil dipasang."

# ======================================
# 5. Konfigurasi SSH
# ======================================
echo
echo "[5] Mengatur konfigurasi SSH..."

# Backup konfigurasi
cp "$SSHD_CONFIG" "${SSHD_CONFIG}.backup"

# Hapus konfigurasi aktif yang mungkin sudah ada
sed -i '/^[[:space:]]*PubkeyAuthentication[[:space:]]/d' "$SSHD_CONFIG"
sed -i '/^[[:space:]]*PasswordAuthentication[[:space:]]/d' "$SSHD_CONFIG"
sed -i '/^[[:space:]]*KbdInteractiveAuthentication[[:space:]]/d' "$SSHD_CONFIG"

cat >> "$SSHD_CONFIG" <<EOF

# SSH configuration for mika_admin
PubkeyAuthentication yes
PasswordAuthentication no
KbdInteractiveAuthentication no
EOF

# ======================================
# 6. Validasi konfigurasi
# ======================================
echo
echo "[6] Memvalidasi konfigurasi SSH..."

sshd -t

echo "[SUCCESS] Konfigurasi SSH valid."

# ======================================
# 7. Start / Restart SSH
# ======================================
echo
echo "[7] Menjalankan SSH Server..."

if service ssh restart 2>/dev/null; then
    echo "[+] SSH server berhasil direstart."
else
    echo "[WARNING] Gagal restart melalui service."
fi

# ======================================
# 8. Verifikasi
# ======================================
echo
echo "======================================"
echo "          VERIFIKASI SSH"
echo "======================================"

echo
echo "[*] User:"
id "$USER"

echo
echo "[*] Authorized Keys:"
ls -l "$AUTHORIZED_KEYS"

echo
echo "[*] SSH Configuration:"
grep -E '^(PubkeyAuthentication|PasswordAuthentication|KbdInteractiveAuthentication)' "$SSHD_CONFIG"

echo
echo "[*] Port 22:"
ss -lntp | grep ':22' || true

echo
echo "======================================"
echo "          SETUP SSH SELESAI"
echo "======================================"