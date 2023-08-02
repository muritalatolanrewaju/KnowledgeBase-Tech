#!/bin/bash

DRY_RUN=0
if [ "$1" == "-d" ] || [ "$1" == "--dry-run" ]; then
  DRY_RUN=1
fi

read -p "Enter your name: " name
read -p "Enter your email: " email

echo "Choose your editor:"
echo "1. VS Code"
echo "2. Vim"
read -p "Enter your choice (1 or 2): " editor_choice

if [ $editor_choice -eq 1 ]
then
    editor="code --wait"
elif [ $editor_choice -eq 2 ]
then
    editor="vim -w"
else
    echo "Invalid choice. Defaulting to VS Code."
    editor="code --wait"
fi

function git_config() {
  if [ $DRY_RUN -eq 1 ]; then
    echo "Would run: git config --global $1 \"$2\""
  else
    git config --global "$1" "$2"
  fi
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

read -p "Do you want to save the Git configuration? (y/n): " save_choice
if [ "$save_choice" == "y" ] || [ "$save_choice" == "Y" ]
then
  if [ $DRY_RUN -eq 1 ]; then
    echo "Would run: git config --global --edit"
  else
    git config --global --edit
  fi
else
  echo "Git configuration not saved."
fi