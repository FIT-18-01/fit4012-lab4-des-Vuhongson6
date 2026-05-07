#!/usr/bin/env bash
set -euo pipefail

fail() {
  echo "[FAIL] $1" >&2
  exit 1
}

pass() {
  echo "[PASS] $1"
}

cd "$(dirname "$0")/.."

if [ ! -f des ]; then
  g++ -std=c++17 -Wall -Wextra -pedantic des.cpp -o des
fi

PLAINTEXT="0110000101100010011000110110010001100101011001100110011101101000"
KEY="0001001100110100010101110111100110011011101111001101111111110001"

CIPHERTEXT=$(printf "1\n%s\n%s\n" "$PLAINTEXT" "$KEY" | ./des | grep -Eo 'Ciphertext: [01]+' | awk '{print $2}')
if [[ -z "$CIPHERTEXT" ]]; then
  fail "Không tìm th?y ciphertext t? chuong trình."
fi

INDEX=10
ORIGINAL_BIT=${CIPHERTEXT:INDEX:1}
FLIPPED_BIT=$([[ "$ORIGINAL_BIT" == "0" ]] && echo 1 || echo 0)
TAMPERED_CIPHERTEXT="${CIPHERTEXT:0:INDEX}${FLIPPED_BIT}${CIPHERTEXT:INDEX+1}"

DECRYPTED=$(printf "2\n%s\n%s\n" "$TAMPERED_CIPHERTEXT" "$KEY" | ./des | grep -Eo 'Decrypted: [01]+' | awk '{print $2}')
if [[ -z "$DECRYPTED" ]]; then
  fail "Không tìm th?y decrypted output t? chuong trình khi dùng ciphertext dã b? tamper."
fi

if [[ "$DECRYPTED" == "$PLAINTEXT" ]]; then
  fail "Tampered ciphertext v?n gi?i mã ra plaintext g?c."
fi

pass "Tamper negative test passed: flipping 1 bit làm thay d?i plaintext gi?i mã."
