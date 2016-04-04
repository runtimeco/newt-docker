TOOLCHAIN_VERSION:=1.0.0

all:
	@echo "make newt"

clean:
	rm -rf _scratch

newt-binary: clean
	mkdir _scratch
	docker run --rm -v $(PWD)/_scratch:/go golang:1.6 go get mynewt.apache.org/newt/...

newt: newt-binary
	$(eval NEWT_VERSION := $(shell docker run --rm -v $(PWD)/_scratch:/_scratch -w /_scratch golang:1.6 bin/newt version | cut -d: -f2))
	docker build -t newt:$(NEWT_VERSION) -f Dockerfile .
	docker tag newt:$(NEWT_VERSION) newt:latest
