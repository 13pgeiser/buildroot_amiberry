################################################################################
#
# amiberry
#
################################################################################

AMIBERRY_VERSION = 5.6.1
AMIBERRY_SOURCE = v$(AMIBERRY_VERSION).tar.gz
AMIBERRY_SITE = https://github.com/BlitterStudio/amiberry/archive/refs/tags
AMIBERRY_SITE_METHOD = wget
AMIBERRY_DEPENDENCIES = sdl2 sdl2_image sdl2_ttf libmpeg2 mpg123 flac libserialport
AMIBERRY_LICENSE = GPL-3.0
AMIBERRY_LICENSE_FILES = COPYING
AMIBERRY_PLATFORM=rpi4-64-sdl2

define AMIBERRY_BUILD_CMDS
	$(MAKE) CXX="$(TARGET_CXX)" \
		CC="$(TARGET_CC)" \
		LD="$(TARGET_LD)" \
		AS="$(TARGET_AS)" \
		STRIP="$(TARGET_STRIP)" \
		-C $(@D) \
		-f Makefile \
		PLATFORM="$(AMIBERRY_PLATFORM)" \
		SDL_CONFIG="$(STAGING_DIR)/usr/bin/sdl2-config" \
		USE_LD=""
endef

define AMIBERRY_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/home/amiga
	$(INSTALL) -D -m 0755 $(@D)/amiberry $(TARGET_DIR)/home/amiga/amiberry
	cp -R $(@D)/data $(TARGET_DIR)/home/amiga
	cp -R $(@D)/kickstarts $(TARGET_DIR)/home/amiga
	cp -R $(@D)/whdboot $(TARGET_DIR)/home/amiga
	rm $(TARGET_DIR)/home/amiga/whdboot/save-data/Savegames/foo.txt
	rm $(TARGET_DIR)/home/amiga/whdboot/save-data/Kickstarts/foo.txt
	rm $(TARGET_DIR)/home/amiga/whdboot/save-data/Debugs/foo.txt
	rm $(TARGET_DIR)/home/amiga/whdboot/save-data/Autoboots/foo.txt
	# Copy RTB files
	mkdir -p $(TARGET_DIR)/home/amiga/kickstarts && \
		cp $(@D)/whdboot/save-data/Kickstarts/*.RTB $(TARGET_DIR)/home/amiga/kickstarts/
endef

$(eval $(generic-package))
