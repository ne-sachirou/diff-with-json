.PHONY: help build fix test
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .' $(MAKEFILE_LIST) | sort | awk -F ':.*?## ' '{printf "%s\t\t\t%s\n",$$1,$$2}'

build: ## Build a release binary
	crystal deps
	crystal build --release bin/diff-with-json.cr -o bin/diff-with-json
	crystal eval 'require "ecr/macros";io=IO::Memory.new;ECR.embed "src/README.md.ecr", io;File.open("README.md","w"){|f|f.print io.to_s}'

fix: ## Fix lint automatically
	find src spec -type f -name '*.cr' | xargs -L1 -P4 crystal tool format

test: ## Test
	find src spec -type f -name '*.cr' | xargs -L1 -P4 crystal tool format --check
	crystal spec
	crystal build bin/diff-with-json.cr -o bin/diff-with-json
