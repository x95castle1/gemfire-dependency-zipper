# Variables with smart defaults
VERSION ?= 10.2.4

.PHONY: all build clean help

# Default target when you just type 'make'
all: build

build:
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

clean:
	@echo "🧼 Cleaning Gradle build directories..."
	@./gradlew clean

help:
	@echo "GemFire Dependency Bundler Makefile"
	@echo "------------------------------------"
	@echo "make                     - Launches the interactive setup script"
	@echo "make clean               - Cleans up the build and dist directories"
	@echo "make build REPO_USER=x REPO_PASS=y [VERSION=z] - Bypasses prompts entirely"