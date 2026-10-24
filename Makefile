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
	linux-armv6 \
	linux-armv7 \
	linux-armv7_softfp \
	linux-arm64 \
	linux-x64 \
	linux-x86 \
	windows-x64 \
	windows-x86 \
	darwin-x64
# TODO: darwin-arm64 still uses the old MacOS SDK, Golang >= 1.26 needs MacOS 13 SDK
# 	darwin-arm64

.PHONY: $(PLATFORMS)

all:
	for i in $(PLATFORMS); do \
		$(MAKE) $$i; \
	done

base:
	$(DOCKER) build -t $(PROJECT)/$(IMAGE):base -f debian.Dockerfile .

musl:
	$(DOCKER) build -t $(PROJECT)/$(IMAGE):musl -f musl.Dockerfile .

$(PLATFORMS): base
	$(DOCKER) build -t $(PROJECT)/$(IMAGE):$@ -f docker/$@.Dockerfile docker

push:
	docker push $(PROJECT)/$(IMAGE):$(PLATFORM)

push-all:
	for i in $(PLATFORMS); do \
		PLATFORM=$$i $(MAKE) push; \
	done

pull:
	docker pull $(PROJECT)/$(IMAGE):$(PLATFORM)

pull-all:
	for i in $(PLATFORMS); do \
		PLATFORM=$$i $(MAKE) pull; \
	done