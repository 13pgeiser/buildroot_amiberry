################################################################################
#
# LIBENET
#
################################################################################

LIBENET_VERSION = 1.3.18
LIBENET_SOURCE = v$(LIBENET_VERSION).tar.gz
LIBENET_SITE = https://github.com/lsalzman/enet/archive/refs/tags
LIBENET_LICENSE = MIT
LIBENET_LICENSE_FILES = LICENSE
LIBENET_INSTALL_STAGING = YES
LIBENET_INSTALL_TARGET = NO

$(eval $(cmake-package))

