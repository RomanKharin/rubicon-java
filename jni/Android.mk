LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

LOCAL_MODULE := rubicon

LOCAL_CFLAGS += -I$(LOCAL_PATH)/../../python3.4-install/include/python3.4m -finline-functions -O2

LOCAL_SRC_FILES := rubicon.c
LOCAL_LDLIBS := -llog -lpython3.4m
#LOCAL_SHARED_LIBRARIES := python3.4m

LOCAL_LDFLAGS += -L$(LOCAL_PATH)/../../python3.4-install/lib -Xlinker -export-dynamic -Wl,-O1 -Wl,-Bsymbolic-functions

include $(BUILD_SHARED_LIBRARY)
