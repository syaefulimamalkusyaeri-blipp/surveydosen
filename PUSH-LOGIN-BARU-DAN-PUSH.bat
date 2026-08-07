@echo off
setlocal EnableExtensions
cd /d "%~dp0"

set "OWNER=syaefulimamalkusyaeri-blipp"
set "REPO=surveydosen"
set "REMOTE=https://%OWNER%@github.com/%OWNER%/%REPO%.git"

echo ===============================================
echo  RESET LOGIN GITHUB + PUSH SURVEY DOSEN
echo ===============================================
echo Repository: https://github.com/%OWNER%/%REPO%.git
echo Akun GitHub yang harus dipakai: %OWNER%
echo.

where git >nul 2>nul
if errorlevel 1 (
  echo [ERROR] Git belum terpasang atau belum masuk PATH.
  echo Install Git for Windows lalu jalankan file ini lagi.
  pause
  exit /b 1
)

if not exist ".git" (
  git init
  if errorlevel 1 goto :fail
)

git branch -M main

rem Bedakan kredensial GitHub berdasarkan URL/repository agar beberapa akun bisa dipakai.
git config credential.https://github.com.useHttpPath true

rem Hapus cache login GitHub lama (contoh: akun aifrfx) agar Git meminta login lagi.
git credential-manager --version >nul 2>nul
if not errorlevel 1 (
  echo Menghapus cache login GitHub lama...
  (echo protocol=https& echo host=github.com& echo.) | git credential-manager erase >nul 2>nul
  (echo protocol=https& echo host=github.com& echo path=%OWNER%/%REPO%.git& echo.) | git credential-manager erase >nul 2>nul
) else (
  echo [INFO] Git Credential Manager tidak terdeteksi.
  echo Jika push masih memakai akun lama, hapus kredensial GitHub lewat Windows Credential Manager.
)

rem Username dimasukkan pada URL supaya Git Credential Manager memilih identitas yang benar.
git remote get-url origin >nul 2>nul
if errorlevel 1 (
  git remote add origin "%REMOTE%"
) else (
  git remote set-url origin "%REMOTE%"
)

rem Identitas commit tidak sama dengan akun autentikasi, jadi hanya diminta bila belum ada.
git config user.name >nul 2>nul
if errorlevel 1 (
  set /p GIT_NAME=Masukkan nama untuk commit Git: 
  git config user.name "%GIT_NAME%"
)

git config user.email >nul 2>nul
if errorlevel 1 (
  set /p GIT_EMAIL=Masukkan email untuk commit Git: 
  git config user.email "%GIT_EMAIL%"
)

git add .
if errorlevel 1 goto :fail

git diff --cached --quiet
if errorlevel 1 (
  git commit -m "feat: dashboard penilaian dan kontrol buka tutup survei"
  if errorlevel 1 goto :fail
) else (
  echo Tidak ada perubahan baru untuk di-commit.
)

echo.
echo PENTING:
echo Saat browser/login GitHub terbuka, gunakan akun:
echo %OWNER%
echo Jangan pilih akun aifrfx.
echo.
echo Mendorong branch main ke GitHub...
git push -u origin main
if errorlevel 1 goto :fail

echo.
echo [OK] Project berhasil di-push ke GitHub.
echo https://github.com/%OWNER%/%REPO%
pause
exit /b 0

:fail
echo.
echo [ERROR] Push belum berhasil.
echo Jika muncul "denied to aifrfx", buka:
echo Control Panel ^> Credential Manager ^> Windows Credentials

echo lalu hapus kredensial GitHub/git:https://github.com dan jalankan file ini lagi.
pause
exit /b 1
