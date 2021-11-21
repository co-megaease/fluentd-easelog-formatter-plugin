.PHONY: build  test

MKFILE_PATH := $(abspath $(lastword $(MAKEFILE_LIST)))
MKFILE_DIR := $(dir $(MKFILE_PATH))
IMAGE_BUILD_DIR := ${MKFILE_DIR}fluentd-kubernetes-daemonset

VERSION := v1.14
OS_VERSION :=debian
KAFKA_VERSION := kafka2
PLUGINS_DIR := "${IMAGE_BUILD_DIR}/docker-image/${VERSION}/${OS_VERSION}-${KAFKA_VERSION}/plugins"

all: build




test:
	rake test


build: test
	mkdir -p ${PLUGINS_DIR}
	@cp ${MKFILE_DIR}lib/fluent/plugin/*.rb ${PLUGINS_DIR}
	cd ${IMAGE_BUILD_DIR} &&  make src DOCKERFILE="${VERSION}/${OS_VERSION}-${KAFKA_VERSION}" VERSION="${VERSION}.0-${OS_VERSION}-${KAFKA_VERSION}"
	cd ${IMAGE_BUILD_DIR} && make image DOCKERFILE="${VERSION}/${OS_VERSION}-${KAFKA_VERSION}" VERSION="${VERSION}.0-${OS_VERSION}-${KAFKA_VERSION}"






