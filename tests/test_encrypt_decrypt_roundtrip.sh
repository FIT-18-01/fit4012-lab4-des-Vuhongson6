#!/usr/bin/env bash
# Test that plaintext -> encrypt -> decrypt returns original plaintext
# This is the fundamental property of a working cipher

set -euo pipefail

echo "===== Test 2: Encrypt-Decrypt Round-trip ====="

cd "$(dirname "$0")/.."

# Compile if not already compiled
if [ ! -f des ]; then
    g++ -std=c++17 -Wall -Wextra -pedantic des.cpp -o des
fi

# Run encryption/decryption test
OUTPUT=$(./des)

echo "$OUTPUT"

# Check both encryption and decryption results
if echo "$OUTPUT" | grep -q "Match: YES"; then
    echo "✓ Round-trip encryption/decryption test PASSED"
    exit 0
else
    echo "✗ Round-trip encryption/decryption test FAILED"
    exit 1
fi