#!/bin/bash

set -e

USER="mika_admin"
SSH_DIR="/home/$USER/.ssh"
PRIVATE_KEY="$SSH_DIR/id_ed25519"
PUBLIC_KEY="$SSH_DIR/id_ed25519.pub"

echo "======================================"
echo "       Setup SSH Client - Mika"
echo "======================================"

# ======================================
# 1. Install OpenSSH Client
# ======================================
echo
echo "[1] Mengecek SSH client..."

if command -v ssh >/dev/null 2>&1; then
    echo "[+] OpenSSH Client sudah terinstall."
else
    echo "[+] OpenSSH Client belum terinstall."
    echo "[+] Installing openssh-client..."

    apt-get update
    apt-get install -y openssh-client
fi

echo "[+] ssh:"
which ssh

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

chown "$USER:$USER" "$SSH_DIR"
chmod 700 "$SSH_DIR"

# ======================================
# 4. Generate SSH Key Pair
# ======================================
echo
echo "[4] Mengecek SSH key pair..."

if [ -f "$PRIVATE_KEY" ] && [ -f "$PUBLIC_KEY" ]; then
    echo "[+] SSH key pair sudah ada."
else
    echo "[+] Membuat SSH key pair Ed25519..."

    runuser -u "$USER" -- ssh-keygen \
        -t ed25519 \
        -f "$PRIVATE_KEY" \
        -N ""
fi

# ======================================
# 5. Permission
# ======================================
chmod 600 "$PRIVATE_KEY"
chmod 644 "$PUBLIC_KEY"

chown "$USER:$USER" "$PRIVATE_KEY"
chown "$USER:$USER" "$PUBLIC_KEY"

# ======================================
# 6. Tampilkan Public Key
# ======================================
echo
echo "======================================"
echo "           PUBLIC KEY MIKA"
echo "======================================"

cat "$PUBLIC_KEY"

echo
echo "======================================"
echo "Salin public key di atas."
echo "Masukkan ke setup_ssh_server.sh"
echo "pada node Knights."
echo "======================================"

echo
echo "[+] Fingerprint:"
ssh-keygen -lf "$PUBLIC_KEY"

echo
echo "======================================"
echo "       SETUP SSH CLIENT SELESAI"
echo "======================================"