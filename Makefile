.PHONY: help build build_darwin build_linux build_linux_app clean fix install test uninstall
default: build
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .' $(MAKEFILE_LIST) | sort | awk -F ':.*?## ' '{printf "%s\t\t\t%s\n",$$1,$$2}'

build: ## Build a release binary
	$(MAKE) build_linux
ifeq ($(shell uname -s),Darwin)
	$(MAKE) build_darwin
endif
	crystal eval 'require "ecr/macros";io=IO::Memory.new;ECR.embed "src/README.md.ecr",io;File.open("README.md","w"){|f|f.print io.to_s}'

build_darwin:
	crystal deps --production
	crystal build.darwin-x86_64.cr
	otool -L bin/diff-with-json-darwin-x86_64
	sandbox-exec -f test.darwin-x86_64.sb bin/diff-with-json-darwin-x86_64 --help

build_linux:
	docker build -f Dockerfile.build.linux-x86_64 -t diff-with-json.build.linux-x86_64 .
	docker run --rm -v $(shell pwd):/data diff-with-json.build.linux-x86_64 make build_linux_app
	docker build -f Dockerfile.test.linux-x86_64 -t diff-with-json.test.linux-x86_64 .
	docker run --rm diff-with-json.test.linux-x86_64 diff-with-json --help

build_linux_app:
	crystal deps --production
	crystal build --release -o bin/diff-with-json-linux-x86_64 --link-flags '-static' bin/diff-with-json.cr

clean: ## Clean
	rm -f bin/diff-with-json-darwin-x86_64.o bin/diff-with-json-darwin-x86_64 bin/diff-with-json-linux-x86_64

fix: ## Fix lint automatically
	find bin src spec -type f -name '*.cr' -exec crystal tool format {} \;

install: ## cp the binary to PATH
ifeq ($(shell uname -s),Linux)
	cp bin/diff-with-json-linux-x86_64 /usr/local/bin/diff-with-json
endif
ifeq ($(shell uname -s),Darwin)
	cp bin/diff-with-json-darwin-x86_64 /usr/local/bin/diff-with-json
endif

test: ## Test
	find . -name '*.sh' -exec shellcheck -s sh {} \;
	find bin src spec -type f -name '*.cr' -exec crystal tool format --check {} \;
	crystal spec

uninstall: ## rm the installed binary
	rm -f /usr/local/bin/diff-with-json
