#!/bin/sh

echo -n "[ GIT ] Enter Username: "
read name
echo -n "[ GIT ] Enter email: "
read email

git config --global user.name "$name"
git config --global user.email "$email"
git config --global core.autocrlf input
git config --global core.eol lf
