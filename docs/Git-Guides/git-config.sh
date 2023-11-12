#!/bin/bash

read -p "Enter your name: " name
read -p "Enter your email: " email

echo "Choose your editor:"
echo "1. VS Code"
echo "2. Nano"
echo "3. Vi"
read -p "Enter your choice (1, 2, or 3): " editor_choice

if [ "$editor_choice" == "1" ]; then
    editor="code --wait"
elif [ "$editor_choice" == "2" ]; then
    editor="nano -w"
elif [ "$editor_choice" == "3" ]; then
    editor="vi"
else
    echo "Invalid choice. Defaulting to VI."
    editor="vi"
fi

function git_config() {
  git config --global "$1" "$2"
}

echo "Setting Git configurations..."

git_config "user.name" "$name"
git_config "user.email" "$email"
git_config "core.editor" "$editor"

if [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "cygwin" ]] || [[ "$OSTYPE" == "win32" ]] 
then
    git_config "core.autocrlf" "true"
else
    git_config "core.autocrlf" "input"
fi

git_config "credential.helper" "store"

echo "Git configurations have been set."

echo "Listing saved Git configurations:"
cat ~/.gitconfig
