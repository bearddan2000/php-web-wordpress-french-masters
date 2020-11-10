# php-web-wordpress-french-masters

## Description
A wordpress inspired website, featuring modern french painters Renoir and Matisse.

## Tech stack
- bash
- wordpress
- mariadb

## Docker stack
- docker-compose
- mariadb:latest
- wordpress:latest

## To run
`sudo ./install.sh -u`
http://localhost

### Admin panel
user: admin
password: admin

### To create a device node
This will be the mount point for the volume.
`sudo mknod -m +rw <location> b 10 229`

### To copy device node to a folder
`sudo cp -av <device_node> <folder>`

## To stop
`sudo ./install.sh -d`

## To see help
`sudo ./install.sh -h`

## Credits
- https://github.com/mikesale/quickwp
