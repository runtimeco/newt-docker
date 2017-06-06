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
	mkdir -p _scratch
	docker run --rm -v $(PWD)/_scratch:/go/bin -e "GOPATH=/go" golang:$(GO_VERSION) bash -c "git clone -b mynewt_1_0_0_tag https://github.com/apache/incubator-mynewt-newt.git /go/src/mynewt.apache.org/newt && go install mynewt.apache.org/newt/newt && go install mynewt.apache.org/newt/newtmgr && chown $(shell id  -u):$(shell id -g) /go/bin/*"

newt: newt-binary
	$(eval NEWT_VERSION := $(shell docker run --rm -v $(PWD)/_scratch:/_scratch -w /_scratch golang:$(GO_VERSION) ./newt version | cut -d: -f2))
	docker build -t newt:$(NEWT_VERSION)-$(TOOLCHAIN_VERSION) -f Dockerfile .
	docker tag newt:$(NEWT_VERSION)-$(TOOLCHAIN_VERSION) newt:latest
