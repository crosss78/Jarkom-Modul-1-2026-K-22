# usb_hid_decoder.py

HID_KEYCODES = {
    0x04: 'a', 0x05: 'b', 0x06: 'c', 0x07: 'd', 0x08: 'e',
    0x09: 'f', 0x0A: 'g', 0x0B: 'h', 0x0C: 'i', 0x0D: 'j',
    0x0E: 'k', 0x0F: 'l', 0x10: 'm', 0x11: 'n', 0x12: 'o',
    0x13: 'p', 0x14: 'q', 0x15: 'r', 0x16: 's', 0x17: 't',
    0x18: 'u', 0x19: 'v', 0x1A: 'w', 0x1B: 'x', 0x1C: 'y',
    0x1D: 'z', 0x1E: '1', 0x1F: '2', 0x20: '3', 0x21: '4',
    0x22: '5', 0x23: '6', 0x24: '7', 0x25: '8', 0x26: '9',
    0x27: '0', 0x28: '\n', 0x2C: ' ', 0x2D: '-', 0x2E: '=',
    0x2F: '[', 0x30: ']', 0x31: '\\', 0x33: ';', 0x34: "'",
    0x35: '`', 0x36: ',', 0x37: '.', 0x38: '/'
}

SHIFTED_CHARS = {
    '1': '!', '2': '@', '3': '#', '4': '$', '5': '%',
    '6': '^', '7': '&', '8': '*', '9': '(', '0': ')',
    '-': '_', '=': '+', '[': '{', ']': '}', '\\': '|',
    ';': ':', "'": '"', '`': '~', ',': '<', '.': '>', '/': '?'
}

def decode_hid_report(line):
    line = line.strip()
    if len(line) < 16:
        return ''

    # Konversi string hex menjadi list integer per byte
    bytes_list = [int(line[i:i+2], 16) for i in range(0, 16, 2)]

    modifier = bytes_list[0]
    keycodes = bytes_list[2:]

    # Deteksi apakah tombol Left Shift (0x02) atau Right Shift (0x20) ditekan
    shift = modifier & 0x22

    keys = []
    for keycode in keycodes:
        if keycode == 0 or keycode == 1 or keycode == 255:
            continue
        char = HID_KEYCODES.get(keycode)
        if char:
            if shift and char in SHIFTED_CHARS:
                keys.append(SHIFTED_CHARS[char])
            elif shift:
                keys.append(char.upper())
            else:
                keys.append(char)
    return ''.join(keys)

# ---- MAIN ----
decoded = []
previous_line_was_empty = True

# Ganti nama file input sesuai output hasil tshark (hid.txt)
with open("hid.txt") as f:
    for line in f:
        line = line.strip()
        if len(line) < 16:
            continue

        # Jika baris data berisi nol semua (berarti tombol dilepas/release)
        if line == "0000000000000000":
            previous_line_was_empty = True
            continue

        # Proses decoding paket ketikan jika paket sebelumnya adalah kondisi kosong/release
        if previous_line_was_empty:
            char = decode_hid_report(line)
            if char:
                decoded.append(char)
            previous_line_was_empty = False

# Tampilkan hasil akhir bendera flag
print("Hasil Decode:")
print("".join(decoded))