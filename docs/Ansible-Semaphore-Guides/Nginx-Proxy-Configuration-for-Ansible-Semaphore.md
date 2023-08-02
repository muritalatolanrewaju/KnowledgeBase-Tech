# **Nginx Proxy Configuration for Ansible Semaphore**

## **1: Ansible Semaphore Installation**

Follow the guide for [Ansible Semaphore Installation on RHEL-Based OS](Ansible-Semaphore-Installation-on-RHEL-Based-OS.md)

## **2: Nginx Installation**

Install Nginx on your Semaphore server or another instance to act as a proxy server. On RHEL based OS:

```bash
sudo yum -y install epel-release
sudo yum -y install vim nginx
```
- Once the service is installed, start it and set to be started at system boot.

```bash
sudo systemctl start nginx
sudo systemctl enable nginx
```
- Verify that Nginx is running:

```bash
sudo systemctl status nginx
```
## **3: Self-Signed SSL Certificate Generation**

For testing, create a self-signed SSL certificate:

- Create a new directory for SSL certificate:

```bash
sudo mkdir /etc/nginx/ssl
```

- Change to the directory:

```bash
cd /etc/nginx/ssl
```
- Create a new file to define the SSL certificate configuration:

```bash
sudo vi ssl-info.txt
```

- Add the following configuration to the ssl-info.txt file:

```bash
[req]
default_bits       = 2048
prompt      = no
default_keyfile    = localhost.key
distinguished_name = dn
req_extensions     = req_ext
x509_extensions    = v3_ca

[ dn ]
C = US
ST = NY
L = New York
O = localhost
OU = Development
CN = localhost

[req_ext]
subjectAltName = @alt_names

[v3_ca]
subjectAltName = @alt_names

[alt_names]
DNS.1   = localhost
DNS.2   = 127.0.0.1
```

- Generate the SSL certificate:

```bash
sudo openssl req -x509 -nodes -days 3652 -newkey rsa:2048 -keyout localhost.key -out localhost.crt -config ssl-info.txt
```

## **4: Nginx Proxy Configuration for Semaphore**

Create a new Nginx configuration file for Semaphore:

```bash
sudo vi /etc/nginx/conf.d/semaphore.conf
```

- Add the following configuration to the file:

```bash
upstream semaphore {
    server 127.0.0.1:3000;
    }

server {
  listen 443 ssl http2;
  server_name  _;

  # add Strict-Transport-Security to prevent man in the middle attacks
  add_header Strict-Transport-Security "max-age=31536000" always;

  # SSL
  ssl_certificate /etc/nginx/ssl/localhost.crt;
  ssl_certificate_key /etc/nginx/ssl/localhost.key;

  # Recommendations from
  # https://raymii.org/s/tutorials/Strong...
  ssl_protocols TLSv1.1 TLSv1.2;
  ssl_ciphers 'EECDH+AESGCM:EDH+AESGCM:AES256+EECDH:AES256+EDH';
  ssl_prefer_server_ciphers on;
  ssl_session_cache shared:SSL:10m;

  # required to avoid HTTP 411: see Issue # 1486
  # (https://github.com/docker/docker/issu...)
  chunked_transfer_encoding on;

  location / {
    proxy_pass http://127.0.0.1:3000/;
    proxy_set_header Host $http_host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;

    proxy_set_header X-Forwarded-Proto $scheme;

    proxy_buffering off;
    proxy_request_buffering off;
  }

  location /api/ws {
    proxy_pass http://127.0.0.1:3000/api/ws;
    proxy_http_version 1.1;
    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection "upgrade";
    proxy_set_header Origin "";
  }
}
```

Remove the default Nginx configuration file:

```bash
sudo rm /etc/nginx/conf.d/default.conf
```

Validate file syntax after the change:

```bash
sudo nginx -t
```

Activate firewalld:

```bash
sudo systemctl enable firewalld
sudo systemctl start firewalld
```

Open port 443 on firewalld and reload the firewall configuration:

```bash
sudo firewall-cmd --permanent --add-port=443/tcp
sudo systemctl restart firewalld
```

Modify SELinux policy to allow Apache HTTP server to make network connections:

```bash
sudo setsebool -P httpd_can_network_connect 1
```

Restart Nginx:

```bash
sudo systemctl restart nginx
```

Access Semaphore console via Nginx proxy server at `https://your-server-ip>/`.
