# newt-docker
Docker provides a quick and easy way to get up and running with Apache Mynewt.
The newt command line tool and the entire build toolchain is available in a
single docker image.  The only requirement for building an Apache Mynewt based
application and loading it on a supported device is a docker installation
that's configure to support USB2.

See the documentation at [https://mynewt.apache.org/](https://mynewt.apache.org/os/get_started/docker/)

## Building the Image
To build the newt docker image:

```
make toolchain-image
make newt
```

The newt image is a small layer with the newt binary on top of a much larger
image containing all the build tools. `make toolchain-image` creates the base
toolchain image.  `make newt` compiles the newt binary in a golang build
container and then creates the newt image.

