TOOLCHAIN_VERSION := 6
GO_VERSION := 1.10.4
MYNEWT_RELEASE := 1_4_1
JLINK_RELEASE := 634h
JLINK_BIN := JLink_Linux_V$(JLINK_RELEASE)_x86_64.deb
JLINK_URL := https://www.segger.com/downloads/jlink
JLINK_CHKS := $(JLINK_BIN).sha256

all:
	@echo "make toolchain-image"
	@echo "make newt"

clean:
	@rm -rf _scratch

$(JLINK_BIN):
	curl -X POST -d "accept_license_agreement=accepted" -o $(JLINK_BIN) $(JLINK_URL)/$(JLINK_BIN)
	shasum -c $(JLINK_CHKS)

toolchain-image: $(JLINK_BIN)
	docker build -t toolchain:$(TOOLCHAIN_VERSION) --build-arg JLINK_RELEASE=$(JLINK_RELEASE) -f Dockerfile.toolchain .
	docker tag toolchain:$(TOOLCHAIN_VERSION) toolchain:latest

newt-binary: clean
	mkdir -p _scratch
	docker run --rm -v $(PWD)/_scratch:/go/bin -e "GOPATH=/go" golang:$(GO_VERSION) bash -c "git clone -b mynewt_$(MYNEWT_RELEASE)_tag https://github.com/apache/mynewt-newt.git /go/src/mynewt.apache.org/newt && go install mynewt.apache.org/newt/newt && chown $(shell id  -u):$(shell id -g) /go/bin/*"
	docker run --rm -v $(PWD)/_scratch:/go/bin -e "GOPATH=/go" golang:$(GO_VERSION) bash -c "git clone -b mynewt_$(MYNEWT_RELEASE)_tag https://github.com/apache/mynewt-newtmgr.git /go/src/mynewt.apache.org/newtmgr && go install mynewt.apache.org/newtmgr/newtmgr && chown $(shell id  -u):$(shell id -g) /go/bin/*"

newt: newt-binary
	$(eval NEWT_VERSION := $(shell docker run --rm -v $(PWD)/_scratch:/_scratch -w /_scratch golang:$(GO_VERSION) ./newt version | cut -d: -f2))
	docker build -t newt:$(NEWT_VERSION)-$(TOOLCHAIN_VERSION) -f Dockerfile .
	docker tag newt:$(NEWT_VERSION)-$(TOOLCHAIN_VERSION) newt:latest
