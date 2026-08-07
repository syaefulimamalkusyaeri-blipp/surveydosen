# Memperbaiki Error 403: Permission denied to aifrfx

Error seperti ini:

```text
remote: Permission to syaefulimamalkusyaeri-blipp/surveydosen.git denied to aifrfx.
fatal: unable to access ... 403
```

berarti URL repository sudah benar, tetapi Windows/Git Credential Manager masih memakai login GitHub `aifrfx`.

## Cara otomatis

Jalankan:

```text
PUSH-LOGIN-BARU-DAN-PUSH.bat
```

Script akan menghapus cache autentikasi GitHub lama, mengatur repository tujuan, lalu meminta autentikasi ulang saat push.

Saat browser GitHub terbuka, login sebagai:

```text
syaefulimamalkusyaeri-blipp
```

## Jika browser tetap memilih akun lama

1. Tutup proses push.
2. Buka **Control Panel**.
3. Pilih **Credential Manager**.
4. Pilih **Windows Credentials**.
5. Hapus entri GitHub, misalnya `git:https://github.com`.
6. Logout akun `aifrfx` dari GitHub di browser jika masih aktif.
7. Jalankan kembali `PUSH-LOGIN-BARU-DAN-PUSH.bat`.
8. Login sebagai `syaefulimamalkusyaeri-blipp`.
