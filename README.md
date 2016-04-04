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
* The "default" VM created by docker-machine must first be stopped before you
  can enable USB2.  You can run the command `docker-machine stop default` or
  use the VirtualBox UI to stop the VM.
* Enable USB2 using the VirtualBox UI. Select the "default"
  VM->Settings->Ports->USB2 to enable USB2.   Add your device to the USB Device
  Filters to make the device visible in the docker container.  See the image below.

![VirtualBox USB Settings](https://github.com/runtimeinc/newt-docker/raw/master/docs/img/virtualbox_usb.jpg)

* Restart the "default" VM by running `docker-machine start default` or by
  using the VirtualBox UI.

*NOTE:* We've found that restart is required after installing the extension
pack and enabling USB2 for the first time.

## Use the newt wrapper script
Use the newt wrapper script to invoke newt.

```
#!/bin/bash

docker run -ti --rm --device=/dev/bus/usb --privileged -v $(pwd):/workspace -w /workspace mynewt/newt:latest /newt "$@"
```

This will allow you to run newt as if it was natively installed.  You can now
follow the normal tutorials using the newt wrapper script.




