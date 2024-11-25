################################################################################
#
# PortMidi
#
################################################################################

PORTMIDI_VERSION = 2.0.4
PORTMIDI_SOURCE = v$(PORTMIDI_VERSION).tar.gz
PORTMIDI_SITE = https://github.com/PortMidi/portmidi/archive/refs/tags
PORTMIDI_LICENSE = BSD-like
PORTMIDI_LICENSE_FILES = license.txt
PORTMIDI_INSTALL_STAGING = YES
PORTMIDI_INSTALL_TARGET = YES

$(eval $(cmake-package))

