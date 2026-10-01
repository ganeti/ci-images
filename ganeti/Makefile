DEB_RELEASES := bookworm trixie testing focal jammy noble resolute
LEAP_RELEASES := 15.6 16.0

GEN_DIR  := generated_dockerfiles

DEB_DOCKERFILES := $(patsubst %,$(GEN_DIR)/Dockerfile.%,$(DEB_RELEASES))
LEAP_DOCKERFILES := $(patsubst %,$(GEN_DIR)/Dockerfile.leap%,$(LEAP_RELEASES))

.PHONY: all clean

all: $(DEB_DOCKERFILES) $(LEAP_DOCKERFILES)

$(DEB_DOCKERFILES): $(GEN_DIR)/Dockerfile.%: Dockerfile-Debian-template.sh
	@mkdir -p $(GEN_DIR)
	@echo "generating $@ (Debian Release: $*)..."
	@RELEASE="$*" bash Dockerfile-Debian-template.sh > $@

$(LEAP_DOCKERFILES): $(GEN_DIR)/Dockerfile.leap%: Dockerfile-LEAP-template.sh
	@mkdir -p $(GEN_DIR)
	@echo "generating $@ (LEAP Release: $*)..."
	@RELEASE="$*" bash Dockerfile-LEAP-template.sh > $@

clean:
	rm -rf $(GEN_DIR)

