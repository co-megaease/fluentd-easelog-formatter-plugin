.PHONY: build  test

MKFILE_PATH := $(abspath $(lastword $(MAKEFILE_LIST)))
MKFILE_DIR := $(dir $(MKFILE_PATH))
IMAGE_BUILD_DIR := ${MKFILE_DIR}fluentd-kubernetes-daemonset

all: build


test:
	rake test


build: test
	@cp ${MKFILE_DIR}lib/fluent/plugin/*.rb ${IMAGE_BUILD_DIR}/plugins/
	cd ${IMAGE_BUILD_DIR} &&  make src DOCKERFILE=v1.14/debian-kafka2 VERSION=v1.14.0-debian-kafka2
	cd ${IMAGE_BUILD_DIR} && make image DOCKERFILE=v1.14/debian-kafka2 VERSION=v1.14.0-debian-kafka2






