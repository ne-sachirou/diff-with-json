.PHONY: help build build_app fix test
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .' $(MAKEFILE_LIST) | sort | awk -F ':.*?## ' '{printf "%s\t\t\t%s\n",$$1,$$2}'

build: ## Build a release binary
	docker build -f Dockerfile.build.linux-x86_64 -t diff-with-json.build.linux-x86_64 .
	docker run -v $(shell pwd):/data diff-with-json.build.linux-x86_64 make build_app
	mv bin/diff-with-json bin/diff-with-json-linux-x86_64
	make build_app
	cp bin/diff-with-json bin/diff-with-json-darwin-x86_64
	crystal eval 'require "ecr/macros";io=IO::Memory.new;ECR.embed "src/README.md.ecr",io;File.open("README.md","w"){|f|f.print io.to_s}'

build_app:
	crystal deps --production
	crystal build --release -o bin/diff-with-json bin/diff-with-json.cr

fix: ## Fix lint automatically
	find src spec -print0 -type f -name '*.cr' | xargs -L1 -P4 crystal tool format

test: ## Test
	shellcheck -e SC2046,SC2148 Makefile
	find src spec -print0 -type f -name '*.cr' | xargs -L1 -P4 crystal tool format --check
	crystal deps
	crystal spec
