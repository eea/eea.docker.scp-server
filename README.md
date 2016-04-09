# SCP server

Restricted SSH server which allows SCP / SFTP access only. This image is meant to be used together with the httpd:2.4 image

The purpose of this image is to make a constellation of a website with a way to update the content using SCP or SFTP.

Running
-------

It is easiest if you use docker-compose. Then you can specify the authorized SSH keys in a block declaration:

docker-compose.yml file:
```
scpserver:
  image: eeacms/scp-server
  ports:
  - <PORT>:22
  environment:
    AUTHORIZED_KEYS: |
      ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAIEA4FhFro3H....vg0hrC3s0= My First CERT
      ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAteQ38qb7....uC839w== Second authorized key 
    DATADIR: /usr/local/apache2/htdocs
  volumes_from:
  - htdocs

httpd:
  image: httpd
  ports:
  - 80:80
  volumes_from:
  - htdocs

htdocs:
  image: tianon/true
  volumes:
  - <DATADIR>:/usr/local/apache2/htdocs
```

When started you can upload data into the container (e.g. via scp) as the `www` user:

    scp -P <PORT> <FILE> www@<DOCKER-HOST>:

