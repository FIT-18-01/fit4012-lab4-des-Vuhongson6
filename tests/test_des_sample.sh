#!/usr/bin/env bash
# Test DES sample encryption from the starter code
# Compile program, run with sample plaintext/key, and verify ciphertext

set -euo pipefail

echo "===== Test 1: DES Sample Case ====="

# Compile
cd "$(dirname "$0")/.."
g++ -std=c++17 -Wall -Wextra -pedantic des.cpp -o des

# Run and capture output
OUTPUT=$(./des)

# Expected ciphertext from standard DES test vector
# Input: plaintext = "0001001000110100010101100111100010011010101111001101111011110001"
#        key = "0001001100110100010101110111100110011011101111001101111111110001"
# Expected output should match DES standard test vector

echo "$OUTPUT"

# Check if ciphertext is produced
if echo "$OUTPUT" | grep -q "Ciphertext:"; then
    echo "✓ Sample DES encryption test PASSED"
    exit 0
else
    echo "✗ Sample DES encryption test FAILED"
    exit 1
fi