################################################################################
#
# fmc
#
################################################################################

FMC_VERSION = lf-6.12.3-1.0.0
FMC_SITE = $(call github,nxp-qoriq,fmc,$(FMC_VERSION))
FMC_LICENSE = MIT
FMC_LICENSE_FILES = LICENSE
FMC_DEPENDENCIES = libxml2 tclap fmlib

FMC_MAKE_OPTS = \
	CC="$(TARGET_CC)" \
	CXX="$(TARGET_CXX)" \
	FMD_USPACE_HEADER_PATH="$(STAGING_DIR)/usr/include/fmd" \
	FMD_USPACE_LIB_PATH="$(STAGING_DIR)/usr/lib" \
	LIBXML2_HEADER_PATH="$(STAGING_DIR)/usr/include/libxml2" \
	TCLAP_HEADER_PATH="$(STAGING_DIR)/usr/include"

ifeq ($(BR2_powerpc64),y)
FMC_MAKE_OPTS += M64BIT=1
endif

# fmc's platform is the same as fmlib's.
FMC_PLATFORM = $(call qstrip,$(BR2_PACKAGE_FMLIB_PLATFORM))

define FMC_BUILD_CMDS
	$(SED) "s:LS1043:$(FMC_PLATFORM):g" $(@D)/source/Makefile
	# The linking step has dependency issues so using MAKE1
	$(TARGET_MAKE_ENV) $(MAKE1) $(FMC_MAKE_OPTS) -C $(@D)/source
endef

define FMC_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/source/fmc $(TARGET_DIR)/usr/sbin/fmc
	cp -dpfr $(@D)/etc/fmc $(TARGET_DIR)/etc/
endef

$(eval $(generic-package))
