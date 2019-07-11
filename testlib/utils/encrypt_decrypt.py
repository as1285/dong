#!/usr/bin/env python
# coding=utf-8


from Crypto.Cipher import DES
import base64


class EncryptDecrypt:


    def __init__(self):
        key = 'bf_perpe'
        iv = '12345678'
        self.key = key.encode()
        self.iv = iv.encode()
        self.mode = DES.MODE_CBC

    def encrypt(self, text):
        BS = 8
        pad_it = lambda s: s + (BS - len(s) % BS) * chr(BS - len(s) % BS)
        generator = DES.new(self.key, self.mode, self.iv)
        crypt = generator.encrypt(pad_it(text).encode())
        encrypted_str = base64.b64encode(crypt)
        return encrypted_str.decode()

    def decrypt(self, text):
        unpad = lambda s: s[0:-ord(s.decode()[-1])]
        generator = DES.new(self.key, self.mode, self.iv)
        crypt = generator.decrypt(base64.b64decode(text))
        decrypted_str = unpad(crypt)
        return decrypted_str.decode()


if __name__ == '__main__':
    app = EncryptDecrypt()
    print(app.encrypt('1770265'))
    print(app.decrypt('A+WPdv4ctdc='))
