# SPDX-License-Identifier: 0BSD
################################################################################
# CPL
################################################################################
MAKEFILE_PATH := makefiles
include $(MAKEFILE_PATH)/config.mk
PROJECT := cpl
PROJECT_TYPE := header
################################################################################
# TARGETS
################################################################################
# Default targets
include $(MAKEFILE_PATH)/targets.mk

.PHONY: gen
gen::
	python3 ./tool/gen_pp/gen_pp.py
