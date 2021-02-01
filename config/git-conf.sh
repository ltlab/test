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
