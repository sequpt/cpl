################################################################################
# PROJECT
#
# [R]: Single value variable can be redefined in other makefiles
# [+]: Values can be added to the variable in other makefiles
# [X]: Variable must not be redefined nor values be added to it
################################################################################
# Project name: must not contain spaces                                      [R]
PROJECT := untitled
# Project type: one of [header, program, shared, static]                     [R]
PROJECT_TYPE := program
# Incompatible API changes                                                   [R]
VERSION_MAJOR := 0
# Functionality in a backwards compatible manner added                       [R]
VERSION_MINOR := 1
# Backwards compatible bug fixes                                             [R]
VERSION_PATCH := 0
# Full version(default to 0.1.0)                                             [X]
VERSION = $(VERSION_MAJOR).$(VERSION_MINOR).$(VERSION_PATCH)
# Project description                                                        [R]
DESCRIPTION :=
# Build mode. Change it at runtime with 'make <target> BUILD_MODE=release'   [R]
BUILD_MODE ?= debug
################################################################################
# BASIC FOLDER AND PATH
################################################################################
# Output folder for analysis tools like valgrind or scan-build               [X]
ANALYSIS_FOLDER := analysis
# Installation folder for programs                                           [X]
BIN_FOLDER := bin
# Output folder for executables, *.a, *.so, etc                              [X]
BUILD_FOLDER := build
# Input/output folder for generated dependency files(*.d)                    [X]
DEP_FOLDER := dep
# Output folder for documentation generated by tools like doxygen            [X]
DOC_FOLDER := doc
# Input/output folder for third-parties sources, libraries, tools, etc       [X]
EXT_FOLDER := external
# Input/installation folder for header files(*.h)                            [X]
INC_FOLDER := include
# Input/installation folder for shared objects/archives(*.so/*.a)            [X]
LIB_FOLDER := lib
# Input/output folder for object files(*.o)                                  [X]
OBJ_FOLDER := obj
# Input folder for source files(*.c)                                         [X]
SRC_FOLDER := src
# Input/output folder for tests                                              [X]
TEST_FOLDER := test
# Paths to above folders                                                     [R]
ANALYSIS_PATH   = $(ANALYSIS_FOLDER)
BUILD_PATH      = $(BUILD_ROOT_PATH)/$(BUILD_MODE)
BUILD_ROOT_PATH = $(BUILD_FOLDER)
DEP_PATH        = $(BUILD_PATH)/$(DEP_FOLDER)
DOC_PATH        = $(DOC_FOLDER)
EXT_PATH        = $(EXT_FOLDER)
INC_PATH        = $(INC_FOLDER)
LIB_PATH        = $(LIB_FOLDER)
OBJ_PATH        = $(BUILD_PATH)/$(OBJ_FOLDER)
SRC_PATH        = $(SRC_FOLDER)
TEST_PATH       = $(TEST_FOLDER)
# Prefix for installation path                                               [X]
INSTALL_PREFIX := /usr/local
# Expected existing variables                                                [R]
DESTDIR    ?=
prefix      = $(DESTDIR)$(INSTALL_PREFIX)
exec_prefix = $(prefix)
bindir      = $(exec_prefix)/$(BIN_FOLDER)
includedir  = $(prefix)/$(INC_FOLDER)
libdir      = $(exec_prefix)/$(LIB_FOLDER)
################################################################################
# EXTERNAL
################################################################################
# Target to build tests                                                      [X]
# Expand to $(TEST_PATH)empty_target if $(TEST_PATH) points to an existing
# folder or to `empty_target` otherwise.
TEST_TARGET = $(wildcard $(TEST_PATH))empty_target
# List of directories containing header files(*.h)                           [+]
INC_DIRS = $(INC_PATH)
# List of directories containing source files(*.c)                           [+]
SRC_DIRS = $(shell find $(SRC_PATH)/ -type d)
# Paths in which to look for source files in rules like %.o: %.c             [X]
# Modify SRC_DIRS if other directories must be added to VPATH
VPATH = $(SRC_DIRS)
# List of source files(*.c)                                                  [+]
SRC_FILES = $(sort $(shell find $(SRC_DIRS) -name '*.c' -type f))
# Change .c extension to .o and remove directory-part(path/to/foo.c => foo.o)[X]
OBJ_FILES_PASS1 = $(notdir $(SRC_FILES:.c=.o))
# Prefix all files with $(OBJ_PATH)(foo.o => ./obj/debug/foo.o)              [+]
OBJ_FILES = $(OBJ_FILES_PASS1:%=$(OBJ_PATH)/%)
# Change .o extension to .d(foo.o => foo.d)                                  [X]
DEP_FILES_PASS1 = $(OBJ_FILES_PASS1:.o=.d)
# Prefix all files all with $(DEP_PATH)(foo.d => ./dep/foo.d)                [X]
DEP_FILES = $(DEP_FILES_PASS1:%=$(DEP_PATH)/%)
# Dependencies for %.o: %.c rule                                             [X]
OBJ_DEPS = $(DEP_PATH)/%.d | $(OBJ_PATH) $(DEP_PATH)
################################################################################
# EXTERNAL
################################################################################
# Input path for third-parties headers                                       [R]
EXT_INC_PATH = $(EXT_PATH)/$(INC_FOLDER)
# Input path for third-parties libraries                                     [R]
EXT_LIB_PATH = $(EXT_PATH)/$(LIB_FOLDER)
# List of directories containing third-parties libraries                     [+]
EXT_LIB_DIRS = $(shell find $(EXT_LIB_PATH)/ -type d)
# Output folder for third-parties                                            [X]
EXT_INSTALL_PREFIX := $(CURDIR)/$(EXT_PATH)
# Command to invoke submakes in external folder                              [X]
EXT_SUBMAKE = $(MAKE) -C $(EXT_PATH)
# List of directories containing *.h files                                   [+]
INC_DIRS += $(wildcard $(EXT_PATH))
INC_DIRS += $(wildcard $(EXT_INC_PATH))
################################################################################
# PROGRAM
################################################################################
# Name of the program to build                                               [R]
PROGRAM_NAME = $(PROJECT)
# Output path for the project program                                        [X]
PROGRAM_PATH = $(BUILD_PATH)/$(PROGRAM_NAME)
# Target to build main program                                               [X]
PROGRAM_TARGET = $(PROGRAM_PATH)
################################################################################
# LIBRARY COMMON
################################################################################
# 'foo' part in 'libfoo'                                                     [R]
LIB_NAME = $(PROJECT)
# Path where to install headers                                              [X]
HEADER_INSTALL_PATH = $(includedir)/$(LIB_NAME)
# Path where to install library                                              [X]
LIB_INSTALL_PATH = $(libdir)/$(LIB_NAME)
################################################################################
# SHARED LIBRARY
################################################################################
# libfoo.so                                                                  [X]
LIB_SHARED = lib$(LIB_NAME).so
# libfoo.so.1                                                                [X]
LIB_SHARED_X = $(LIB_SHARED).$(VERSION_MAJOR)
# libfoo.so.1.2.3                                                            [X]
LIB_SHARED_XYZ = $(LIB_SHARED).$(VERSION)
# Output path for libfoo.so                                                  [X]
LIB_SHARED_PATH = $(BUILD_PATH)/$(LIB_SHARED)
# Output path for libfoo.so.1                                                [X]
LIB_SHARED_X_PATH = $(BUILD_PATH)/$(LIB_SHARED_X)
# Output path for libfoo.so.1.2.3                                            [X]
LIB_SHARED_XYZ_PATH = $(BUILD_PATH)/$(LIB_SHARED_XYZ)
# Target to build the shared lib                                             [X]
LIB_SHARED_TARGET = $(LIB_SHARED_XYZ_PATH)
################################################################################
# STATIC LIBRARY
################################################################################
# libfoo.a                                                                   [X]
LIB_STATIC = lib$(LIB_NAME).a
# Output path for libfoo.a                                                   [X]
LIB_STATIC_PATH = $(BUILD_PATH)/$(LIB_STATIC)
# Target to build the static lib                                             [X]
LIB_STATIC_TARGET = $(LIB_STATIC_PATH)
