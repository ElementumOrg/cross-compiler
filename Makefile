# Name of the project.
PROJECT = elementumorg
IMAGE = cross-compiler

# Set binaries and platform specific variables.
DOCKER = docker

# Platforms on which we want to build the project.
PLATFORMS = \
	android-arm \
	android-arm64 \
	android-x64 \
	android-x86 \
	darwin-x64 \
	darwin-x86 \
	linux-armv6 \
	linux-armv7 \
	linux-arm64 \
	linux-x64 \
	linux-x86 \
	windows-x64 \
	windows-x86

.PHONY: $(PLATFORMS)

all:
	for i in $(PLATFORMS); do \
		$(MAKE) $$i; \
	done

base:
	$(DOCKER) build -t $(PROJECT)/$(IMAGE):base .

$(PLATFORMS): base
	$(DOCKER) build -t $(PROJECT)/$(IMAGE):$@ -f docker/$@.Dockerfile docker

push:
	docker push $(PROJECT)/cross-compiler:$(PLATFORM)

push-all:
	for i in $(PLATFORMS); do \
		PLATFORM=$$i $(MAKE) push; \
	done

pull:
	docker pull $(PROJECT)/cross-compiler:$(PLATFORM)

pull-all:
	for i in $(PLATFORMS); do \
		PLATFORM=$$i $(MAKE) pull; \
	done