# **Install Semaphore Ansible Web UI on RHEL Based OS**

In this guide, we will install Semaphore Ansible Web UI on AlmaLinux 8. Semaphore is an open source web-based solution that makes Ansible easy to use for IT teams of all kinds. It gives you a Web interface from where you can launch and manage Ansible Tasks.

## **What You Will Need**

- MySQL >= 5.6.4/MariaDB >= 5.3
- ansible
- git >= 2.x

We will start the installation by ensuring these dependencies are installed on your AlmaLinux 8 server. So follow steps in the next sections to ensure all is set.

Before any installation we recommend you perform an update on the OS layer:
```bash
sudo yum -y update
```

A reboot is also essential once the upgrade is made:

```bash
sudo reboot -f
```

## **Step 1: Install MariaDB Database Server**

Semaphore requires a database server to store its data. In this guide, we will use MariaDB as our database server. So go ahead and install MariaDB on your AlmaLinux 8 server by running the following command:

```bash
curl -LsS -O https://downloads.mariadb.com/MariaDB/mariadb_repo_setup
sudo bash mariadb_repo_setup
sudo yum install MariaDB-server MariaDB-client MariaDB-backup
```

Start and enable mariadb database service:

```bash
sudo systemctl enable --now mariadb
```

Secure database server after installation:

```bash
sudo mariadb-secure-installation

# Switch to unix_socket authentication [Y/n] n
# Change the root password? [Y/n] y
# Remove anonymous users? [Y/n] y
# Disallow root login remotely? [Y/n] y
# Remove test database and access to it? [Y/n] y
# Reload privilege tables now? [Y/n] y
```

## **Step 2: Install `git 2.x` on Almalinux 8**

Semaphore requires git version 2.x to be installed on your system. So go ahead and install git 2.x on your AlmaLinux 8 server by running the following command:

```bash
sudo yum install git
```
Confirm the installation by checking the version of git installed:

```bash
git --version
```

## **Step 3: Install Ansible on AlmaLinux 8**

Semaphore requires Ansible to be installed on your system. So go ahead and install Ansible on your AlmaLinux 8 server by running the following command:

```bash
sudo yum -y install epel-release
sudo yum -y install ansible
```

Check the version of Ansible installed:

```bash
 ansible --version
```

## **Step 4: Install Semaphore Ansible Web UI on AlmaLinux 8**

Semaphore Ansible Web UI is available as a package on Semaphore's GitHub repository. So go ahead and clone the repository on your AlmaLinux 8 server by running the following command:

```bash
sudo yum -y install wget curl
VER=$(curl -s https://api.github.com/repos/ansible-semaphore/semaphore/releases/latest|grep tag_name | cut -d '"' -f 4|sed 's/v//g')
wget https://github.com/ansible-semaphore/semaphore/releases/download/v${VER}/semaphore_${VER}_linux_amd64.rpm
```

Install the `.rpm` package:

```bash
sudo rpm -Uvh semaphore_${VER}_linux_amd64.rpm
```

Check semaphore binary path:

```bash
which semaphore
```

## **Step 5: Configure Semaphore Ansible Web UI**

Run the following command to create a configuration file for Semaphore:

```bash
sudo semaphore setup
```

You will be prompted to enter the following information:

```bash
Hello! You will now be guided through a setup to:

1. Set up configuration for a MySQL/MariaDB database
2. Set up a path for your playbooks (auto-created)
3. Run database Migrations
4. Set up initial semaphore user & password

What database to use:
   1 - MySQL
   2 - BoltDB
   3 - PostgreSQL
 (default 1): 1
   DB Hostname (default 127.0.0.1:3306): <ENTER>
   DB User (default root): root
   DB Password: <db_root_Password>  
   DB Name (default semaphore): semaphore
   Playbook path (default /tmp/semaphore): /opt/semaphore
   Web root URL (optional, example http://localhost:8010/):  http://localhost:8010/
   Enable email alerts (y/n, default n): n
   Enable telegram alerts (y/n, default n): n
   Enable LDAP authentication (y/n, default n): n 
```

Set username

```bash
Username: admin
Email: admin@example.com
WARN[0268] sql: no rows in result set                    level=Warn
 Your name: Admin User
 Password: StrongUserPassword 
 You are all setup Admin User!
 Re-launch this program pointing to the configuration file
 ./semaphore -config /config.json

To run as daemon:
 nohup ./semaphore -config /config.json &
You can login with computingforgeeks@example.com or computingforgeeks
```

You can set other configuration values on the file `/config.json`.

## **Step 6: Configure systemd unit for Semaphore**

Let’s now configure Semaphore Ansible UI to be managed by systemd.

Create Semaphore configurations directory:

```bash
sudo mkdir /etc/semaphore
```

Create systemd service unit file.

```bash
sudo vi /etc/systemd/system/semaphore.service
```

Add the following content:

```bash
[Unit]
Description=Semaphore Ansible UI
Documentation=https://github.com/ansible-semaphore/semaphore
Wants=network-online.target
After=network-online.target

[Service]
Type=simple
ExecReload=/bin/kill -HUP $MAINPID
ExecStart=/usr/bin/semaphore server --config /etc/semaphore/config.json
SyslogIdentifier=semaphore
Restart=always

[Install]
WantedBy=multi-user.target
```

Copy your configuration file to created directory, `/etc/semaphore`:

```bash
sudo ln -s /config.json /etc/semaphore/config.json
```

Stop running instances of Semaphore.

```bash
sudo pkill semaphore
```

Confirm:

```bash
ps aux | grep semaphore
```

Reload systemd and start semaphore service.

```bash
sudo systemctl daemon-reload
sudo systemctl restart semaphore
```

Check status:

```bash
sudo systemctl status semaphore
```

Set Service to start at boot.

```bash
sudo systemctl enable semaphore
```

Port 3000 should now be Open.

```bash
sudo ss -tunelp | grep 3000
```

## **Step 7: Setup Nginx Proxy (Optional)**

If you want to access Semaphore Ansible Web UI from a remote system, you can configure Nginx as a reverse proxy for Semaphore. 

- [Configure Nginx Proxy for Semaphore Ansible Web UI](/configure-nginx-proxy-for-semaphore-ansible-web-ui.md)

## **Step 8: Access Semaphore Ansible Web UI**

On your web browser, open semaphore Server IP on port 3000 or server name.

    http://192.168.98.200:3000/




