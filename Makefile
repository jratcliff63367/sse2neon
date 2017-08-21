# Detect environment, tools, compilers
DEBUG   :=
ARCH    := $(shell uname -m)
NATIVE  := $(shell which g++)
A32GCC  := $(shell which arm-linux-gnueabihf-g++)
A64GCC  := $(shell which aarch64-linux-gnu-g++)
CLANG   := $(shell which clang)
A32QEMU := $(shell which qemu-arm-static)
A64QEMU := $(shell which qemu-aarch64-static)

# "gcc" or "clang", set your own CXX to ignore
DEFCXX := gcc
ifeq ($(DEFCXX),gcc)
else ifeq ($(DEFCXX),clang)
else
$(error "Default target: gcc or clang, not $(DEFCXX)")
endif

# "arm" or "aarch64"
TARGETARCH := arm
ifeq ($(TARGETARCH),arm)
else ifeq ($(TARGETARCH),aarch64)
else
$(error "Target arch: arm or aarch64, not $(TARGETARCH)")
endif

# No option set, pick defaults
ifndef $(CXX)
### Same arch
ifeq ($(ARCH), $(TARGETARCH))
RUN := ""
ifeq ($(DEFCXX),gcc)
CXX := $(NATIVE)
else
CXX := $(CLANG)
endif
### Cross-compile
else
# ARM
ifeq ($(TARGETARCH),arm)
RUN := $(A32QEMU)
ifeq ($(DEFCXX),gcc)
CXX := $(A32GCC) -mfpu=neon
else
CXX := $(CLANG) -target armv7a-linux-gnueabihf -mfpu=neon
endif
# AARCH64
else
RUN := $(A64QEMU)
ifeq ($(DEFCXX),gcc)
CXX := $(A64GCC)
else
CXX := $(CLANG) -target aarch64-linux-gnu
endif
endif # ARM/AARCH64
endif # SAME ARCH
endif # ndef CXX

test: sse2neon
	$(RUN) ./$<

sse2neon: main.o SSE2NEONBinding.o SSE2NEONTEST.o
	$(CXX) $^ -static -o $@

%.o: %.cpp
ifneq ($(DEBUG),)
	$(CXX) -S -O2 $<
endif
	$(CXX) -c -O2 $<

clean:
	rm -f *.o *.s sse2neon
