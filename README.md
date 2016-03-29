# newt-docker
Docker provides a quick and easy way to get up and running with Mynewt.  The
newt command line tool and the entire build toolchain is available in a single
docker container.  The only requirement for building a Mynewt based application
and loading it on a supported device is a docker installation that's configure
to support USB2.

## Install Docker
Install docker for your platform. [Mac OS X](https://docs.docker.com/mac/) / [Windows](https://docs.docker.com/windows/) / [Linux](https://docs.docker.com/linux/)

## USB2 support for Mac or Windows

### Install VirtualBox extension pack
Docker uses a VirtualBox Linux VM to run containers.  A free VirtualBox
extension pack is required to enable USB2 support.  Download the [VirtualBox
5.0.16 Oracle VM VirtualBox Extension
Pack](http://download.virtualbox.org/virtualbox/5.0.16/Oracle_VM_VirtualBox_Extension_Pack-5.0.16-105871.vbox-extpack)
and double click to install.

### Enable USB2 and select your device
Select the "default" VM created by docker-machine and enable USB2.  Add your
device to the USB Device Filters to make the device visible in the docker
container.

*NOTE:* We've found that restart is required after installing the extension
pack and enabling USB2 for the first time.

## Use the newt wrapper script
Use the newt wrapper script to invoke newt.

```
#!/bin/bash

docker run -ti --rm --device=/dev/bus/usb --privileged -v $(pwd):/workspace -w /workspace newt:0.8.0-b2 /newt $@
```

This will allow you to run newt as if it was natively installed.  You can now
follow the normal tutorials using the newt wrapper script.




