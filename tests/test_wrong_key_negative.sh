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
WRONG_KEY="0001001100110100010101110111100110011011101111001101111111110010"

CIPHERTEXT=$(printf "1\n%s\n%s\n" "$PLAINTEXT" "$KEY" | ./des | grep -Eo 'Ciphertext: [01]+' | awk '{print $2}')
if [[ -z "$CIPHERTEXT" ]]; then
  fail "Không tìm th?y ciphertext t? chuong trình."
fi

DECRYPTED_WITH_WRONG_KEY=$(printf "2\n%s\n%s\n" "$CIPHERTEXT" "$WRONG_KEY" | ./des | grep -Eo 'Decrypted: [01]+' | awk '{print $2}')
if [[ -z "$DECRYPTED_WITH_WRONG_KEY" ]]; then
  fail "Không tìm th?y decrypted output t? chuong trình khi dùng wrong key."
fi

if [[ "$DECRYPTED_WITH_WRONG_KEY" == "$PLAINTEXT" ]]; then
  fail "Wrong key test failed: ciphertext gi?i mã dúng v?i khóa sai."
fi

pass "Wrong-key negative test passed: khóa sai không gi?i mã ra plaintext g?c."
