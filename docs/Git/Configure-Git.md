# Git Guide

This guide provides a comprenhensive overview of Git and how to use it.

## Install Git

- Check if Git is already installed on your system:

    ```bash
    git --version
    ```

If you haven't already, install Git on your system. You can find instructions for your operating system [here](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git).

## Configure Git

For initial configuration, you need to set:

- Your name
- Your email address
- Your preferred editor
- Line endings
- Credential helper

These configurations can be set at multiple levels:

- System level: All users
- Global level: All repositories for the current user
- Local level: The current repository

Follow these steps to manually configure Git:

1. **Set your username**

    ```bash
    git config --global user.name "<Your Name>"
    ```

    Replace `"Your Name"` with your actual name.

2. **Set your email**

    ```bash
    git config --global user.email "<Your Email>"
    ```

    Replace `"Your Email"` with your actual email.

3. **Select default editor**

    - For VS Code:

      ```bash
      git config --global core.editor "code --wait"
      ```

    - For Nano:

      ```bash
      git config --global core.editor "nano -w"
      ```

    - For Vim:

      ```bash
      git config --global core.editor "vim -w"
      ```

4. **Configure line endings**

    - On Windows workstations:

      ```bash
      git config --global core.autocrlf true
      ```

    - On Linux/macOS workstations:

      ```bash
      git config --global core.autocrlf input
      ```

5. **Set the credential helper**

    ```bash
    git config --global credential.helper store
    ```

## Get Help

- **Get help for Git**

    ```bash
    git --help
    ```

- **Get help for a specific Git command**

    ```bash
    git --help <command>
    ```

    Replace `<command>` with the Git command you need help with.

- **Get help for a specific Git subcommand**

    ```bash
    git <command> --help
    ```

## Cheat Sheet

Download the [Git Cheat Sheet](Git-Cheat-Sheet.pdf) for a quick reference to the most commonly used Git commands.

## Create Snapshots

- **Create a new directory**

    ```bash
    mkdir <directory-name> && cd <directory-name>
    ```

    Replace `<directory-name>` with the name of the directory you want to create.

- **Initialize a Git repository**

    ```bash
    git init
    ```

    This command creates a new subdirectory named `.git` that contains all of your necessary repository files.

### Add Files to the Staging Area

- **Add files to the staging area**

    ```bash
    git add <file-name>
    ```

- **Add all files to the staging area**

    ```bash
    git add .
    ```

### Commit Changes

- **Commit changes**

    ```bash
    git commit -m "<commit-message>"
    ```

- **Commit changes with a message**

    ```bash
    git commit
    ```

    This command will open your default editor for you to enter a commit message.

- **Commit changes with a message and skip the staging area**

    ```bash
    git commit -a -m "<commit-message>"
    ```

- **Commit changes with a message and skip the staging area**

    ```bash
    git commit -a
    ```

    This command will open your default editor for you to enter a commit message.

### Remove Files from the Staging Area

- **View the status of the working directory and staging area**

    ```bash
    git status
    ```

- **View the status of the working directory and staging area in short format**

    ```bash
    git status -s
    ```

- **View files in the staging area**

    ```bash
    git ls-files
    ```

- **Remove files from the staging area**

    ```bash
    git reset <file-name>
    ```

- **Remove all files from the staging area**

    ```bash
    git reset
    ```

## Automated Configuration Using `git-config.sh`

You can also use the [git-config.sh](https://github.com/muritalatolanrewaju/KnowledgeBase-Tech/blob/main/docs/Git-Guides/git-config.sh) script to automatically configure Git. This script will prompt you for your name, email, preferred editor, and detect your operating system, and then set your Git configuration accordingly.

You can run the script with the following command:

```bash
bash git-config.sh
```

## Review and Edit Configuration

- **View all configurations**

    ```bash
    git config --list
    ```

- **Manually edit the Git configuration**

    ```bash
    git config --global --edit
    ```
