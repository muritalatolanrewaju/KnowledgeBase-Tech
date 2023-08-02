# Git Configuration Guide

This guide provides methods to configure Git globally: manual configuration via terminal commands and an automated approach using a script.

## Manual Configuration

Follow these steps to manually configure Git:

1. **Set your username**
    ```bash
    git config --global user.name "Your Name"
    ```
    Replace `"Your Name"` with your actual name.

2. **Set your email**
    ```bash
    git config --global user.email "Your Email"
    ```
    Replace `"Your Email"` with your actual email.

3. **Select default editor**

    - For VS Code:
        ```bash
        git config --global core.editor "code --wait"
        ```
    - For Vim:
        ```bash
        git config --global core.editor "vim -w"
        ```

4. **Configure line endings**

    - On Windows:
        ```bash
        git config --global core.autocrlf true
        ```
    - On Linux/macOS:
        ```bash
        git config --global core.autocrlf input
        ```

5. **Set the credential helper**
    ```bash
    git config --global credential.helper store
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
