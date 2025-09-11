PWD := $(shell pwd)
SYSTEM := $(shell uname -s)-amd64
#VERSION := $(shell cat VERSION)
BRANCH := $(shell git name-rev --name-only HEAD)
COMMIT := $(shell git rev-parse --short HEAD)
PROJECT ?= GithubActionTest
PKGNAME := $(PROJECT)-linux-amd64
# -ldflags作用：设置Go应用程序的版本信息；-X作用：设置包中的变量值
#OPTS := -ldflags "-X main.version=$(VERSION)-$(BRANCH)-$(COMMIT)"

default: clean bin tar

.PHONY: clean
clean:
	@rm -rf _output
	@mkdir _output

.PHONY: bin
bin: mkpkg mkdbuild

.PHONY: mkpkg
mkpkg:
	@test -e _output/$(PKGNAME) || { mkdir -p _output; }
	@echo "building $(PKGNAME)"

.PHONY: mkdbuild
mkdbuild:
	@echo "building $(PKGNAME)"
	@CGO_ENABLED=0 GOOS=linux go build $(OPTS) -trimpath -o _output/$(PKGNAME)/bin/$(PROJECT) ./
	@echo "successful binary to _output/$(PKGNAME)/bin/$(PROJECT)"

.PHONY: tar
tar:
	@cd _output && tar --no-same-owner -zcf $(PKGNAME).tar.gz $(PKGNAME)
	@echo "successful tarball to _output/$(PKGNAME).tar.gz"