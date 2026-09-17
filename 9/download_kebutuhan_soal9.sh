#!/bin/bash

set -e

DRIVE_URL="https://drive.google.com/drive/folders/1S3hG0dnZBTkCta4uILWwKVc6dSYYGRJ6"
FTP_DIR="/var/wired/data"
DOWNLOAD_DIR="/tmp/protocol7"

echo "======================================"
echo "   Setup Protocol Tujuh - Chisa"
echo "======================================"

# ======================================
# 1. Install gdown & unzip
# ======================================
echo
echo "[1] Mengecek gdown..."

if command -v gdown >/dev/null 2>&1; then
    echo "[+] gdown sudah terinstall."
else
    echo "[+] gdown belum terinstall."
    echo "[+] Installing gdown..."

    apt-get update
    apt-get install -y python3-pip

    python3 -m pip install --break-system-packages gdown
fi

echo "[+] gdown:"
which gdown

echo
echo "[2] Mengecek unzip..."

if command -v unzip >/dev/null 2>&1; then
    echo "[+] unzip sudah terinstall."
else
    echo "[+] unzip belum terinstall."
    echo "[+] Installing unzip..."

    apt-get update
    apt-get install -y unzip
fi

echo "[+] unzip:"
which unzip

# ======================================
# 2. Siapkan directory sementara
# ======================================
echo
echo "[2] Menyiapkan directory sementara..."

rm -rf "$DOWNLOAD_DIR"
mkdir -p "$DOWNLOAD_DIR"
mkdir -p "$FTP_DIR"

# ======================================
# 3. Download dari Google Drive
# ======================================
echo
echo "[3] Mengunduh protocol7_manifesto.zip..."
echo "[+] Source:"
echo "$DRIVE_URL"

gdown --folder "$DRIVE_URL" -O "$DOWNLOAD_DIR"

# ======================================
# 4. Cari file ZIP
# ======================================
echo
echo "[4] Mencari protocol7_manifesto.zip..."

ZIP_FILE=$(find "$DOWNLOAD_DIR" -type f -name "protocol7_manifesto.zip" | head -n 1)

if [ -z "$ZIP_FILE" ]; then
    echo "[ERROR] protocol7_manifesto.zip tidak ditemukan."
    exit 1
fi

echo "[+] ZIP ditemukan:"
echo "$ZIP_FILE"

# ======================================
# 5. Extract ZIP
# ======================================
echo
echo "[5] Mengekstrak ZIP..."

EXTRACT_DIR="$DOWNLOAD_DIR/extracted"
mkdir -p "$EXTRACT_DIR"

unzip -o "$ZIP_FILE" -d "$EXTRACT_DIR"

# ======================================
# 6. Cari file TXT
# ======================================
echo
echo "[6] Mencari protocol7_manifesto.txt..."

TXT_FILE=$(find "$EXTRACT_DIR" -type f -name "protocol7_manifesto.txt" | head -n 1)

if [ -z "$TXT_FILE" ]; then
    echo "[ERROR] protocol7_manifesto.txt tidak ditemukan."
    exit 1
fi

echo "[+] TXT ditemukan:"
echo "$TXT_FILE"

# ======================================
# 7. Copy ke FTP shared directory
# ======================================
echo
echo "[7] Menempatkan file ke FTP Server..."

cp "$TXT_FILE" "$FTP_DIR/protocol7_manifesto.txt"

# ======================================
# 8. Hapus file sementara
# ======================================
echo
echo "[8] Membersihkan file sementara..."

rm -rf "$DOWNLOAD_DIR"

echo "[+] Directory sementara dihapus."

# ======================================
# 9. Verifikasi
# ======================================
echo
echo "======================================"
echo "        VERIFIKASI FILE"
echo "======================================"

ls -l "$FTP_DIR/protocol7_manifesto.txt"

echo
echo "[+] Isi directory FTP:"
ls -lah "$FTP_DIR"

echo
echo "======================================"
echo "             SELESAI"
echo "======================================"

echo
echo "[+] File tersedia di:"
echo "$FTP_DIR/protocol7_manifesto.txt"