# Development Server Environment #
by jay.jyhuh@gmail.com

> Support version: Ubuntu 16.04, 18.04 / Mint 19
> gcc and android build environment.

## Script files
- `cp_to_admin.sh`
  - Copy admin script files to `~/.bin-admin` directory.
> 💡 **Do NOT use `cp_to_admin.sh` directly.**
> **`cp_to_admin.sh` should be executed in `development.sh`.**
- `development.sh`
  - Install Packages for development and service.
- `./script/aosp-dev.sh`: `AOSP` build envirionment.
- `add_user.sh`
  - All setup and configuration such as `vimrc`, `bashrc`, `tmux`, and so on...
  - default samba user password: `123456`
  - NFS Default path: `/nfs`. `$HOME/nfs` for user. `/nfs/[USER_ID]` is a symbolic link to user's nfs path.
  - TFTP Default path: `/tftpboot`. `$HOME/tftpboot` is a symbolic link to `/tftpboot`.
- `del_user.sh`

## Steps for development
1. `./development.sh` : Install packages for development and Server Setup.( FTP / SAMBA / NFS / TFTTP... )
2. `./add_user.sh [ USER ID ]` : Generate user id and set-up permissions for services.
3. `./script/aosp-dev.sh`: `AOSP` build envirionment.
4. **powerline prompt**: Append `\n` to `__powerline_set_prompt` in  `/usr/share/powerline/bindings/bash/powerline.sh` or `/usr/local/lib/python2.7/dist-packages/powerline/bindings/bash/powerline.sh`.

    ```bash
    PS1="$(_powerline_prompt aboveleft $last_exit_code $jobnum)\n$ "
    ```
---

## ISSUE: EFI Boot using Virtualbox for Windows in Physical Disk.

1. EFI for Virtualbox using Physical Sorage
2. Rename `/EFI/Boot` to `/EFI/Boot-org`
   - Backup Original files
3. Copy `/EFI/Microsoftt/Boot` to `/EFI/Boot`
   - There is Window Boot files by EFI
4. Rename `/EFI/Boot/bootmgfw.efi` to `/EFI/Boot/bootx64.efi`
   - `/EFI/Boot/bootx64.efi` is Default boot image by EFI.