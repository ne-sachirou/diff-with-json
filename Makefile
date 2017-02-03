.PHONY: help build build_app fix test
default: build
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .' $(MAKEFILE_LIST) | sort | awk -F ':.*?## ' '{printf "%s\t\t\t%s\n",$$1,$$2}'

build: ## Build a release binary
	$(MAKE) build_linux
	$(MAKE) build_darwin
	crystal eval 'require "ecr/macros";io=IO::Memory.new;ECR.embed "src/README.md.ecr",io;File.open("README.md","w"){|f|f.print io.to_s}'

build_darwin:
	crystal deps --production
	bash -eux build.darwin-x86_64.sh
	cp bin/diff-with-json bin/diff-with-json-darwin-x86_64
	sandbox-exec -f test.darwin-x86_64.sb bin/diff-with-json --help

build_linux:
	docker build -f Dockerfile.build.linux-x86_64 -t diff-with-json.build.linux-x86_64 .
	docker run -v $(shell pwd):/data diff-with-json.build.linux-x86_64 make build_linux_app
	mv bin/diff-with-json bin/diff-with-json-linux-x86_64
	docker build -f Dockerfile.test.linux-x86_64 -t diff-with-json.test.linux-x86_64 .
	docker run diff-with-json.test.linux-x86_64 diff-with-json --help

build_linux_app:
	crystal deps --production
	crystal build --release -o bin/diff-with-json --link-flags '-static' bin/diff-with-json.cr

clean: ## Clean
	rm -f bin/diff-with-json bin/diff-with-json.o bin/diff-with-json-darwin-x86_64 bin/diff-with-json-linux-x86_64

fix: ## Fix lint automatically
	find bin src spec -type f -name '*.cr' -exec crystal tool format {} \;

test: ## Test
	shellcheck -e SC2046,SC2148 Makefile
	find . -name '*.sh' -exec shellcheck {} \;
	find bin src spec -type f -name '*.cr' -exec crystal tool format --check {} \;
	crystal deps
	crystal spec
