# **Deploying Playbooks Using Semaphore Ansible GUI**

Semaphore Ansible GUI is a self-hosted web interface for managing Ansible playbooks, inventories, and scheduling jobs. Written in Go and Vue.js, it can be installed either locally or on a server.

## **1: Prepare the Ansible Environment**

Create a new directory for Ansible:

```bash
mkdir -p ansible/roles && cd ansible/roles
```

Initialize a new Ansible role to create an administrator user:

```bash
ansible-galaxy init create_admin_user
```

Create a role in the roles directory:

```bash
vi /home/`whoami`/ansible/roles/create_admin_user/tasks/main.yml
```

- Add the following content to the file, then save and exit:

```bash
- name: Add the user with a specific uid and a primary group of "admin"
# User module creates a new user or updates an existing user
  ansible.builtin.user:
    name: "{{ item.name }}"
    comment: "{{ item.comment }}"
    uid: "{{ item.uid }}"
  loop: "{{ admin }}"

# Authorized_key module manages SSH authorized keys
- name: Setup authorized key
  ansible.posix.authorized_key:
    user: "{{ item.name }}"
    key: "{{ lookup('file', 'pub_keys/{{ item.name }}.pub') }}"
  loop: "{{ admin }}"

# Add the user to the sudoers file
- name: Update sudoers file and validate
  ansible.builtin.lineinfile:
    dest: /etc/sudoers
    insertafter: EOF
    line: "{{ item.name }} ALL=(ALL) NOPASSWD: ALL"
    regexp: "^{{ item.name }} .*"
    state: present
  loop: "{{ admin }}"
```

Create a list of users to be added to the system:

```bash
vi /home/`whoami`/ansible/roles/create_admin_user/vars/main.yml
```

- Add the following content for a user ``whoami``, save and exit:

```bash
admin:
  - name: '`whoami`'
    comment: 'Ultimate User'
    uid: '1000'
```
Switch to the Semaphore user (e.g., `user`):

```bash
sudo su - `whoami`
```
Generate a SSH key pair:

```bash
ssh-keygen -t rsa -b 4096
```

Create a new directory for the public keys:

```bash
mkdir -p /home/`whoami`/ansible/roles/create_admin_user/files/pub_keys/
```

- Copy the public key to the `files/pub_keys` directory:

```bash
sudo cp /home/`whoami`/.ssh/id_rsa.pub /home/`whoami`/ansible/roles/create_admin_user/files/pub_keys/`whoami`.pub
```

## **2: Set Up Playbooks and Inventory**

Create a directory for the playbooks:

```bash
mkdir -p /home/`whoami`/ansible/playbooks/users
```

Create a new playbook to run the role:

```bash
vi /home/`whoami`/ansible/playbooks/users/create_admin_user.yml
```

```bash
---
- hosts: all
  gather_facts: yes
  become: yes
  become_user: root
  tasks:
    - ansible.builtin.import_role:
        name: create_admin_user
```

Create Ansible configuration file:

```bash
vi /home/`whoami`/ansible/ansible.cfg
```

- Add the following content, save and exit:

```bash
[defaults]
roles_path=roles
host_key_checking=False
private_key_file=~/.ssh/id_rsa
```
Install `sshpass`:

```bash
sudo yum -y install sshpass
```

Create an inventory directory:

```bash
mkdir -p /home/`whoami`/ansible/inventory/test
```

Create a new inventory file:

```bash
vi /home/`whoami`/ansible/inventory/test/hosts
```

- Add the following content, save and exit:

```bash
[webservers]
192.168.98.111
192.168.98.112

[loadbalancers]
192.168.98.221

[database]
192.168.98.231
```

Run the playbook:

```bash
ansible-playbook -i inventory/test/hosts playbooks/users/create_admin_user.yml -bkK
```

## **3: Git/GitHub Setup**

Add the ssh public keys of all the hosts to GitHub as they will pull the playbooks from GitHub:

Set the default branch name to `main`:

```bash
git config --global init.defaultBranch main
```

Set the username and email address:

```bash
git config --global user.name "Your Name"
git config --global user.email "Your Email"
```

Set the SSH key:

```bash
git init
git config --local core.sshCommand "/usr/bin/ssh -i ~/.ssh/`whoami`"
```

Add the files to the staging area:

```bash
git add .
```

Commit the changes:

```bash
git commit -m "Initial commit"
```

Add the remote repository and push the changes:

```bash
git remote add origin git@github.com:muritalatolanrewaju/ansible.git
git branch -M main
git push -u origin main
```

Ensure the ssh key is accessible for future tasks.
