# Lab: Running Web Servers in a Docker Container

## 1. Running Web Servers in a Docker Container

- Running three nginx and one Apache web servers

```bash
docker container run -d -p 80:80 --name mysite1 nginx
docker container run -d -p 8080:80 --name mysite2 nginx
docker container run -d -p 8081:80 --name mysite3 nginx
docker container run -d -p 8082:80 --name mysite4 httpd
```

- Verify that the web servers, nginx, are running.

```bash
docker container ls
```

or

```bash
docker ps
```


![Untitled](assets/images/lab-running-a-webserver-in-a-docker-container/Untitled.png)

- Enter the `ipaddress:port` of the server into a web browser to confirm its status.

![Untitled](assets/images/lab-running-a-webserver-in-a-docker-container/Untitled%201.png)

![Untitled](assets/images/lab-running-a-webserver-in-a-docker-container/Untitled%202.png)

![Untitled](assets/images/lab-running-a-webserver-in-a-docker-container/Untitled%203.png)

![Untitled](assets/images/lab-running-a-webserver-in-a-docker-container/Untitled%204.png)

## 2. Stopping a container

- use docker container stop `CONTAINER_ID|CONTAINER_NAME.` For example, the container_id of a running nginx web server is `d75a67d879fc`, and the container_name is `mysite3`

```bash
docker container stop d75a67d879fc
```

- or use the command below to kill a container by name.

```bash
docker container stop mysite2
```

![Untitled](assets/images/lab-running-a-webserver-in-a-docker-container/Untitled.png)

- stopping multiple containers using the first three characters of the `container_id`

```bash
docker container stop d75 553 6be 568
```

## 3. Remove a Running Container and Docker Image from Local

Example: removing a container image, `nginx`, and `hello-world` with running container_names: `mysite1 mysite2 mysite3 mysite4 mysite5 sleepy_curran laughing_mirzakhani interesting_benz clever_kare wonderful_nash flamboyant_fermi magical_heyrovsky` requires force `-f` removing the running containers before the images can be removed.

![Untitled](assets/images/lab-running-a-webserver-in-a-docker-container/Untitled%205.png)

```bash
docker remove rm mysite1 mysite2 mysite3 mysite4 mysite5 sleepy_curran laughing_mirzakhani interesting_benz clever_kare wonderful_nash flamboyant_fermi magical_heyrovsky -f
docker image rm nginx httpd hello-world
```

## 4. Removing Dangling Docker Images

Docker images consist of multiple layers, and dangling images are layers with no relationship to tagged images. Delete dangling images, stopped containers, and networks not used by at least one container. Run the commands below:

```bash
docker system prune -y
```