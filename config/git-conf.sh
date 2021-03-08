#!/bin/sh

echo "[ GIT ] Enter Username: \c"
read name
echo "[ GIT ] Enter email: \c"
read email

git config --global user.name "$name"
git config --global user.email "$email"
git config --global core.autocrlf input
git config --global core.eol lf
git config core.filemode true

echo -e "[ GPG ] Register GPG key."
echo -e "git config --global commit.gpgsign true"
echo -e "git config --global user.signingkey [keyid]"

# Register to gitconfig
#git config --global commit.gpgsign true
#git config --global user.signingkey 7DADA874

## Generate a GPG Key pair
## gpg version > 2.1.17
#gpg --full-generate-key
## gpg version < 2.1.17
#gpg --default-new-key-algo rsa4096 --gen-key

#gpg --delete-secret-key [id]
#gpg --delete-key [id]

#gpg --list-keys --keyid-format SHORT

## Import Public key
#gpg --import [filename.pub]
#gpg --import [filename.secret]

## Export Secret key
#gpg --armor --output [filename] --export [keyid]
#gpg --armor --output [filename] --export-secret-keys [keyid]
