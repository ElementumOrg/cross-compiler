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
	darwin-x64 \
	darwin-arm64

# Build platforms in parallel (override with `make JOBS=1 all`); each build's output is printed when it finishes
JOBS ?= 4
MAKEFLAGS += -j$(JOBS) --output-sync=target

.PHONY: all base $(PLATFORMS)

all: $(PLATFORMS)

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