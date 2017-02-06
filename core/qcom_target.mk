
include build/core/qcom_utils.mk

# Set device-specific HALs into project pathmap
define set-device-specific-path
$(if $(USE_DEVICE_SPECIFIC_$(1)), \
    $(if $(DEVICE_SPECIFIC_$(1)_PATH), \
        $(eval path := $(DEVICE_SPECIFIC_$(1)_PATH)), \
        $(eval path := $(TARGET_DEVICE_DIR)/$(2))), \
    $(eval path := $(3))) \
$(call project-set-path,qcom-$(2),$(strip $(path)))
endef

define wlan-set-path-variant
$(call project-set-path-variant,wlan,TARGET_WLAN_VARIANT,hardware/qcom/$(1))
endef

# Target-specific configuration
ifeq ($(BOARD_USES_QCOM_HARDWARE),true)
	BR_FAMILY := msm8909 msm8916
    qcom_flags := -DQCOM_HARDWARE
    ifeq ($(TARGET_USES_QCOM_BSP),true)
        qcom_flags += -DQCOM_BSP
        qcom_flags += -DQTI_BSP
    endif

    TARGET_GLOBAL_CFLAGS += $(qcom_flags)
    TARGET_GLOBAL_CPPFLAGS += $(qcom_flags)
    CLANG_TARGET_GLOBAL_CFLAGS += $(qcom_flags)
    CLANG_TARGET_GLOBAL_CPPFLAGS += $(qcom_flags)

    # Multiarch needs these too..
    2ND_TARGET_GLOBAL_CFLAGS += $(qcom_flags)
    2ND_TARGET_GLOBAL_CPPFLAGS += $(qcom_flags)
    2ND_CLANG_TARGET_GLOBAL_CFLAGS += $(qcom_flags)
    2ND_CLANG_TARGET_GLOBAL_CPPFLAGS += $(qcom_flags)

    TARGET_COMPILE_WITH_MSM_KERNEL := true

    ifeq ($(call is-board-platform-in-list, $(BR_FAMILY)),true)
        MSM_VIDC_TARGET_LIST := $(BR_FAMILY)
        QCOM_HARDWARE_VARIANT := msm8916
    else
        MSM_VIDC_TARGET_LIST := $(TARGET_BOARD_PLATFORM)
        QCOM_HARDWARE_VARIANT := $(TARGET_BOARD_PLATFORM)
	endif

$(call project-set-path,qcom-audio,hardware/qcom/audio-caf/$(QCOM_HARDWARE_VARIANT))
$(call project-set-path,qcom-display,hardware/qcom/display-caf-$(QCOM_HARDWARE_VARIANT))
$(call project-set-path,qcom-media,hardware/qcom/media-caf-$(QCOM_HARDWARE_VARIANT))
$(call set-device-specific-path,CAMERA,camera,hardware/qcom/camera)
$(call wlan-set-path-variant,wlan-caf)

else
$(call wlan-set-path-variant,wlan)

endif
