# Variables with smart defaults
VERSION ?= 10.2.4

all: help

.PHONY: clean build
build: ## pulls specified gemfire dependency jars and builds a zip build/dist/gemfire-dependencies-<version>.zip
ifdef REPO_USER
	@if [ -z "$(REPO_PASS)" ]; then \
		echo "❌ Error: REPO_PASS is required if REPO_USER is provided."; \
		echo "Usage: make build REPO_USER=your_user REPO_PASS=your_password [VERSION=10.2.4]"; \
		exit 1; \
	fi
	@echo "📥 Running non-interactive build for GemFire version $(VERSION)..."
	@export GEMFIRE_ARTIFACTORY_USERNAME="$(REPO_USER)" && \
	 export GEMFIRE_ARTIFACTORY_PASSWORD="$(REPO_PASS)" && \
	 ./gradlew clean zipM2Dependencies -PgemfireVersion="$(VERSION)"
	@echo "🎉 Complete! Your package is ready at: build/dist/gemfire-dependencys-$(VERSION).zip"
else
	@echo "🚀 Launching interactive builder..."
	@chmod +x bundle-interactive.sh
	@./bundle-interactive.sh
endif

.PHONY: clean
clean: ## Cleans up the build and dist directories
	@echo "🧼 Cleaning Gradle build directories..."
	@./gradlew clean

# Based on http://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
help: ## Print help for each make target
	@grep -hE '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {gsub(/\\n/, "\n" sprintf("%26s", " "));printf "\033[36m%-25s\033[0m %s\n\n", $$1, $$2}'
