# Development Server Environment
by jyhuh

## Ubuntu 16.04 / Mint 19

## gcc and android build environment.

---

## Steps for development
- `./development.sh` : Install packages for development and Server Setup.( FTP / SAMBA / NFS / TFTTP... )
- `./add_user.sh jyhuh` : Add user tto Server and set-up permissions.
- powerline prompt: Append `\n` to `__powerline_set_prompt` in  `/usr/share/powerline/bindings/bash/powerline.sh` or `/usr/local/lib/python2.7/dist-packages/powerline/bindings/bash/powerline.sh`.

---

## ISSUE: EFI Boot using Virtualbox for Windows in Physical Disk.

1. EFI for Virtualbox using Physical Sorage
2. Rename /EFI/Boot to /EFI/Boot-org
   - Backup Original files
3. Copy /EFI/Microsoftt/Boot to /EFI/Boot
   - There is Window Boot files by EFI
4. Rename /EFI/Boot/bootmgfw.efi tto /EFI/Boot/bootx64.efi
   - /EFI/Boot/bootx64.efi is Default boot image by EFI.
