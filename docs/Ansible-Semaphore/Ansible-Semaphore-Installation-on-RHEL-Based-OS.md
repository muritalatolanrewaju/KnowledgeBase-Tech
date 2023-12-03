# **Ansible Semaphore Installation on RHEL-Based OS**

Semaphore is an open-source, web-based solution that simplifies the use of Ansible for IT teams. This guide demonstrates its installation on AlmaLinux 8.

## **Prerequisites**

Ensure the following are installed:

- MySQL >= 5.6.4/MariaDB >= 5.3
- ansible
- git >= 2.x

Update the OS before starting:

```bash
sudo yum -y update
```

A reboot is also essential once the upgrade is made:

```bash
sudo reboot -f
```

## **1. Install MariaDB Database Server**

Semaphore requires a database server. Install MariaDB on AlmaLinux 8:

```bash
curl -LsS -O https://downloads.mariadb.com/MariaDB/mariadb_repo_setup
sudo bash mariadb_repo_setup
sudo yum install MariaDB-server MariaDB-client MariaDB-backup
```

Start and enable mariadb database service:

```bash
sudo systemctl enable --now mariadb
```

Secure database server after installation and Answer the questions that follow:

```bash
sudo mariadb-secure-installation

# Switch to unix_socket authentication [Y/n] n
# Change the root password? [Y/n] y
# Remove anonymous users? [Y/n] y
# Disallow root login remotely? [Y/n] y
# Remove test database and access to it? [Y/n] y
# Reload privilege tables now? [Y/n] y
```

## **2: Install `git 2.x`**

Semaphore requires git version 2.x to be installed.Install git 2.x on your AlmaLinux 8 server:

```bash
sudo yum install git
```
Confirm the installation by checking the version of git installed:

```bash
git --version
```

## **3. Install Ansible**

```bash
sudo yum -y install epel-release
sudo yum -y install ansible
```

Check the version of Ansible installed:

```bash
 ansible --version
```

## **4. Install Semaphore Ansible Web UI**

Semaphore is available on Semaphore's GitHub repository. Clone the repository:

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

## **5. Configure Semaphore Ansible Web UI**

```bash
sudo semaphore setup
```

Answer the prompts that appear, and set other configuration values in `/config.json` file:

```
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
   Web root URL (optional, see https://github.com/ansible-semaphore/semaphore/wiki/Web-root-URL):  http://localhost:8010/
   Enable email alerts? (yes/no) (default no): n
   Enable telegram alerts? (yes/no) (default no): n
   Enable slack alerts? (yes/no) (default no): n
   Enable LDAP authentication? (yes/no) (default no): n
   Config output directory (default /home/username): <ENTER>
```

Set username:

```
Username: admin
Email: admin@example.com
WARN[0268] sql: no rows in result set                    level=Warn
 Your name: Admin User
 Password: StrongUserPassword 
 You are all setup Admin User!
 Re-launch this program pointing to the configuration file
 ./semaphore -config /config.json
```

You can set other configuration values on the file `/config.json`.

## **6. Configure `systemd` unit for Semaphore**

Semaphore Ansible UI can be managed by `systemd`. Setup the configurations directory and service unit file:

```bash
sudo mkdir /etc/semaphore
```

Create systemd service unit file:

```bash
sudo vi /etc/systemd/system/semaphore.service
```

Add the following content:

```
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
sudo ln -s /home/`whoami`/config.json /etc/semaphore/config.json
```

Stop running instances of Semaphore:

```bash
sudo pkill semaphore
```

Confirm:

```bash
ps aux | grep semaphore
```

Reload `systemd` and start semaphore service:

```bash
sudo systemctl daemon-reload
sudo systemctl restart semaphore
```

Check status:

```bash
sudo systemctl status semaphore
```

Troubleshoot errors:
```bash
sudo journalctl -u semaphore
```

Set Service to start at boot:

```bash
sudo systemctl enable semaphore
```

Port 3000 should now be Open:

```bash
sudo ss -tunelp | grep 3000
```

## **7. Setup Nginx Proxy (Optional)**

To remotely access Semaphore, configure Nginx as a reverse proxy: 

- [Nginx Proxy Configuration for Ansible Semaphore](Nginx-Proxy-Configuration-for-Ansible-Semaphore.md)

## **8. Access Semaphore Ansible Web UI**

Access Semaphore at http://`<your-server-ip>`:3000/ on your web browser.
