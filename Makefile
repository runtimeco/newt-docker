TOOLCHAIN_VERSION := 6
GO_VERSION := 1.14
MYNEWT_RELEASE := 1_8_0
NEWT_URL := https://github.com/apache/mynewt-newt.git
NEWT_SRC_DIR := /go/src/mynewt.apache.org/newt
NEWTMGR_URL := https://github.com/apache/mynewt-newtmgr.git
NEWTMGR_SRC_DIR := /go/src/mynewt.apache.org/newtmgr
JLINK_RELEASE := 648
JLINK_BIN := JLink_Linux_V$(JLINK_RELEASE)_x86_64.deb
JLINK_URL := https://www.segger.com/downloads/jlink
JLINK_CHKS := $(JLINK_BIN).sha256
OPENOCD_RELEASE := b3a4f771

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
	docker run --rm -v $(PWD)/_scratch:/go/bin -e "GOPATH=/go" golang:$(GO_VERSION) bash -c "git clone --depth=1 -b mynewt_$(MYNEWT_RELEASE)_tag $(NEWT_URL) $(NEWT_SRC_DIR) && cd $(NEWT_SRC_DIR) && ./build.sh && mv $(NEWT_SRC_DIR)/newt/newt /go/bin/newt && chown $(shell id  -u):$(shell id -g) /go/bin/*"
	docker run --rm -v $(PWD)/_scratch:/go/bin golang:$(GO_VERSION) bash -c "git clone --depth=1 -b mynewt_$(MYNEWT_RELEASE)_tag $(NEWTMGR_URL) $(NEWTMGR_SRC_DIR) && cd $(NEWTMGR_SRC_DIR)/newtmgr && go build && mv newtmgr /go/bin/newtmgr && chown $(shell id  -u):$(shell id -g) /go/bin/*"

newt: newt-binary
	$(eval NEWT_VERSION := $(shell docker run --rm -v $(PWD)/_scratch:/_scratch -w /_scratch golang:$(GO_VERSION) ./newt version | cut -d" " -f3))
	docker build -t newt:$(NEWT_VERSION)-$(TOOLCHAIN_VERSION) -f Dockerfile .
	docker tag newt:$(NEWT_VERSION)-$(TOOLCHAIN_VERSION) newt:latest
