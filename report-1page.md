# Report 1 page - Lab 4 DES / TripleDES

## Mục tiêu

Mục tiêu của bài lab này là:
- Cài đặt thuật toán DES (Data Encryption Standard) 16 vòng Feistel hoàn chỉnh
- Hiểu được cơ chế khoá (Key Schedule) tạo 16 round key từ khoá gốc 64-bit
- Thực hiện mã hoá (Encryption) và giải mã (Decryption) 
- Kiểm thử với các trường hợp: normal case, round-trip, multi-block, tamper detection, wrong key detection

## Cách làm / Method

### 1. Mở rộng file DES gốc

File `des.cpp` gốc đã có:
- Hàm sử dụng bit-level: `Xor()`, `convert_decimal_to_binary()`, `convert_binary_to_decimal()`
- Các bảng hoán vị: IP, IP^-1, expansion table, S-boxes, permutation table
- Lớp `KeyGenerator`: tạo 16 round key từ 64-bit key gốc
- Lớp `DES`: mã hoá với 16 vòng Feistel

### 2. Bổ sung hỗ trợ Decryption

- Tạo lớp `DESDecrypt` với:
  - Cùng expansion table, S-boxes, permutation table
  - Vòng Feistel lặp **từ 15 xuống 0** (order ngược)
  - Sử dụng **cùng round key nhưng theo thứ tự ngược**
  - Hoán vị đầu cuối: IP -> IP^-1 (như encryption)

### 3. Hàm hỗ trợ (Helper functions)

- `add_zero_padding()`: Thêm padding zero để đủ 64-bit block
- `string_to_binary()`: Chuyển ASCII string sang binary (8-bit per char)
- `binary_to_string()`: Chuyển binary về ASCII (bỏ trailing zeros)
- `split_into_blocks()`: Chia binary string thành blocks 64-bit

### 4. Main function

- Nhập plaintext và key mẫu (64-bit each, dạng binary string)
- Tạo KeyGenerator, sinh 16 round key, in ra (optional)
- Mã hoá với DES
- Giải mã với DESDecrypt
- So sánh kết quả giải mã với plaintext gốc

### 5. Test scripts

5 file test bash trong `tests/`:
1. **test_des_sample.sh**: Compile, chạy mẫu, kiểm tra ciphertext được tạo
2. **test_encrypt_decrypt_roundtrip.sh**: Kiểm tra `decrypt(encrypt(P)) == P`
3. **test_multiblock_padding.sh**: Verify padding functions available
4. **test_tamper_negative.sh**: Demo bit-flip -> output khác plaintext
5. **test_wrong_key_negative.sh**: Demo key khác -> decrypt sai

## Kết quả / Result

### Mã hoá / Encryption:
```
Plaintext:   0001001000110100010101100111100010011010101111001101111011110001
Key:         0001001100110100010101110111100110011011101111001101111111110001
Key 1:       [16 round keys được sinh]
Ciphertext:  [64-bit binary output]
```

### Giải mã / Decryption:
```
Ciphertext:  [từ encryption]
Decrypted:   0001001000110100010101100111100010011010101111001101111011110001
Match:       YES
```

### Test kết quả:
- ✓ Sample encryption test: PASSED (ciphertext được tạo)
- ✓ Round-trip test: PASSED (decrypt(encrypt(P)) == P)
- ✓ Padding functions: PASSED (add_zero_padding, split_into_blocks available)
- ✓ Tamper detection: PASSED (bit-flip -> khác plaintext)
- ✓ Wrong key detection: PASSED (decrypt với key khác sai)

## Kết luận / Conclusion

### Điều học được:
1. **DES structure**: IP -> 16 Feistel rounds -> IP^-1
2. **Key schedule**: PC1 permutation, split CD halves, rotate & PC2 
3. **Symmetric cipher**: Decryption = reverse of encryption (round order reversed)
4. **Padding**: Zero padding đơn giản, chỉ dùng trong learning context

### Hạn chế hiện tại:
1. **Single block only**: Code hiện chỉ xử lý 1 block 64-bit
2. **Binary input only**: Chỉ nhận binary string, không string ASCII trực tiếp
3. **Zero padding weakness**: Khi plaintext all-zeros, không biết padding end
4. **No TripleDES**: Chưa mở rộng sang 3DES (encrypt-decrypt-encrypt)
5. **Manual round key printing**: In ra tất cả key, có thể remove để tối ưu

### Hướng mở rộng:
- [ ] Hỗ trợ **TripleDES** (3 lần DES với 3 key)
- [ ] Hỗ trợ **multi-block** với CBC/ECB mode
- [ ] Chuyển ASCII input thành binary tự động
- [ ] Thay `add_zero_padding()` thành **PKCS#7 padding** (an toàn hơn)
- [ ] Thêm **key derivation** từ password
- [ ] Performance optimization: dùng lookup table thay vì array 2D