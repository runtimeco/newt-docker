TOOLCHAIN_VERSION:=3
GO_VERSION:=1.8.3

all:
	@echo "make toolchain-image"
	@echo "make newt"

clean:
	@rm -rf _scratch

toolchain-image:
	docker build -t toolchain:$(TOOLCHAIN_VERSION) -f Dockerfile.toolchain .
	docker tag toolchain:$(TOOLCHAIN_VERSION) toolchain:latest

newt-binary: clean
	docker run --rm -v $(PWD)/_scratch:/go golang:$(GO_VERSION) bash -c "git clone -b mynewt_1_0_0_b1_tag https://github.com/apache/incubator-mynewt-newt.git /go/src/mynewt.apache.org/newt && go get -v mynewt.apache.org/newt/..."
	docker run --rm -v $(PWD)/_scratch:/go golang:$(GO_VERSION) bash -c "chmod a+rx /go/bin/newt*"

newt: newt-binary
	$(eval NEWT_VERSION := $(shell docker run --rm -v $(PWD)/_scratch:/_scratch -w /_scratch golang:$(GO_VERSION) bin/newt version | cut -d: -f2))
	docker build -t newt:$(NEWT_VERSION)-$(TOOLCHAIN_VERSION) -f Dockerfile .
	docker tag newt:$(NEWT_VERSION)-$(TOOLCHAIN_VERSION) newt:latest
