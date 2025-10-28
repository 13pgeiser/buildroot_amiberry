################################################################################
#
# amiberry
#
################################################################################

AMIBERRY_VERSION = 5.9.0
AMIBERRY_SOURCE = v$(AMIBERRY_VERSION).tar.gz
AMIBERRY_SITE = https://github.com/BlitterStudio/amiberry-lite/archive/refs/tags
AMIBERRY_SITE_METHOD = wget
AMIBERRY_DEPENDENCIES = sdl2 sdl2_image sdl2_ttf libmpeg2 mpg123 flac libserialport zstd portmidi libenet
AMIBERRY_LICENSE = GPL-3.0
AMIBERRY_LICENSE_FILES = COPYING
AMIBERRY_PLATFORM=rpi4-64-sdl2
AMIBERRY_INSTALL_STAGING = NO
AMIBERRY_INSTALL_TARGET = YES
AMIBERRY_SUPPORTS_IN_SOURCE_BUILD = NO
AMIBERRY_CONF_OPTS = -DLIBENET_LIBRARIES=$(STAGING_DIR)/usr/lib/static/libenet.a

define AMIBERRY_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/home/amiga
	mkdir -p $(TARGET_DIR)/home/amiga/kickstarts && \
		cp $(@D)/whdboot/save-data/Kickstarts/*.RTB $(TARGET_DIR)/home/amiga/kickstarts/
	cp -R $(@D)/data $(TARGET_DIR)/home/amiga
	cp -R $(@D)/roms/*.bin $(TARGET_DIR)/home/amiga/kickstarts/
	cp -R $(@D)/whdboot $(TARGET_DIR)/home/amiga
endef

$(eval $(cmake-package))
