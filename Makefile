
VERSION := latest

all: build

build:
	@echo "+++ Building docker image +++"
	docker build --build-arg VERSION=$(VERSION) -t kalemena/android-builder:$(VERSION) .
