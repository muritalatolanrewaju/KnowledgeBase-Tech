# **Setup Semaphore Ansible GUI to Run Playbooks**

Semaphore Ansible GUI is a web interface that allows you to manage Ansible playbooks, inventories, and schedule jobs to run periodically or at a specific time. It is a free and open-source tool written in Go and Vue.js. It is a self-hosted application that can be installed on your local system or server.

## Create a new directory for Ansible:

```bash
mkdir -p ansible/roles && cd ansible/roles
```

## Make Ansible Semaphore `user` an administrator using a playbook:

```bash
ansible-galaxy init create_admin_user
```

## Create a role in the roles directory:

```bash
vi create_admin_user/tasks/main.yml
```

Add the following content, save and exit:

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

## Create a list of users to be added to the system:

```bash
vi create_admin_user/vars/main.yml
```

Add the following content, save and exit:

```bash
admin:
  - name: 'vagrant'
    comment: 'Ultimate User'
    uid: '1000'
```
Change to the semaphore user (For example, vagrant is the user):

```bash
sudo su - vagrant
```
## Generate SSH key pair:

```bash
ssh-keygen -t rsa -b 4096
```

Create a new directory for SSH keys in the ansible directory:

```bash
mkdir -p create_admin_user/files/pub_keys/
```

Copy the public key to the `files/pub_keys` directory:

```bash
sudo cp /home/vagrant/.ssh/id_rsa.pub /home/vagrant/ansible/roles/create_admin_user/files/pub_keys/vagrant.pub
```

## Create playbooks directory:

```bash
mkdir -p /home/vagrant/ansible/playbooks/users
```

Create a new playbook to run the role:

```bash
vi /home/vagrant/ansible/playbooks/users/create_admin_user.yml
```

## Create Ansible configuration file:

```bash
vi /home/vagrant/ansible/ansible.cfg
```

Add the following content, save and exit:

```bash
[defaults]
roles_path=roles
host_key_checking=False
private_key_file=~/.ssh/id_rsa
```
## Install `sshpass`:

```bash
sudo yum -y install sshpass
```

## Create an inventory directory:

```bash
mkdir -p /home/vagrant/ansible/inventory/test
```

Create a new inventory file:

```bash
vi /home/vagrant/ansible/inventory/test/hosts
```

Add the following content, save and exit:

```bash
[webservers]
192.168.98.111
192.168.98.112

[loadbalancers]
192.168.98.221

[database]
192.168.98.231
```

## Run the playbook:

```bash
ansible-playbook -i inventory/test/hosts playbooks/users/create_admin_user.yml -bkK
```

## Git/GitHub Setup

Add the ssh public keys of all the hosts to GitHub as they will pull the playbooks from GitHub.:


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
git config --local core.sshCommand "/usr/bin/ssh -i ~/.ssh/vagrant"
```

Add the files to the staging area:

```bash
git add .
```

Commit the changes:

```bash
git commit -m "Initial commit"
```

Add the remote repository:

```bash
git remote add origin git@github.com:muritalatolanrewaju/ansible.git
git branch -M main
git push -u origin main
```

Ensure the ssh key is accessible.






