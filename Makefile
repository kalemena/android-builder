
VERSION := latest
PROJECT_PATH := $(pwd)

all: build

build:
	@echo "+++ Building docker image +++"
	docker pull ubuntu:18.04
	docker build --build-arg VERSION=$(VERSION) -t kalemena/android-builder:$(VERSION) .

build.project:
	@echo "+++ Building an Android project at $(PROJECT_PATH) +++"
	docker run --rm -v $(PROJECT_PATH):/home/app \
        kalemena/android-builder:$(VERSION) \
        /bin/bash -c "cd /home/app && ./gradlew clean assembleDebug"

