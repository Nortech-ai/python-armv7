# Adding a new package

To add a new package first find it in the pkgs.alpinelinux.org under the armv7 architecture. i.e. for nmap: https://pkgs.alpinelinux.org/package/edge/main/armv7/nmap


We are currently following alpine version 3.21.

Create a new folder under packages/nmap and fill in both the control file inside and the alpine-name file

packages/nmap/control/control
```
Package: nmap
Version: 7.95-r1
Architecture: armv7
Maintainer: info@nortech.ai
Description: Network exploration tool and security/port scanner
Priority: optional
Depends: musl nmap
```

Some of these fields shoulkd be copied from the pkgs.alpinelinux.org site

Open the mirror and find the correct package file. In this case
https://dl-cdn.alpinelinux.org/alpine/v3.21/main/armv7/nmap-7.95-r1.apk

Create a file `packages/nmap/alpine-name` with the name of the apk as it exists on the mirror. So `nmap-7.95-r1.apk`

Once that is done, run `build.sh` and you should have an ipk file with the new package.