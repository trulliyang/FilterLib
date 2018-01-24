//
// Created by SHI.yang on 2017/9/6.
//

#ifndef FILTERLIB_LOGBASE_H
#define FILTERLIB_LOGBASE_H

#define __USING_ANDROID__

#ifdef __USING_ANDROID__

#include <android/log.h>
#define  _LOG_TAG  "RenderFramework"
#define  _LOG_DEBUG(...)  __android_log_print(ANDROID_LOG_DEBUG, _LOG_TAG, __VA_ARGS__)
#define  _LOG_INFO(...)  __android_log_print(ANDROID_LOG_INFO, _LOG_TAG, __VA_ARGS__)
#define  _LOG_ERROR(...)  __android_log_print(ANDROID_LOG_ERROR, _LOG_TAG, __VA_ARGS__)

#elif   defined(__USING_APPLE__)

#define  _LOG_INFO(...)   printf(__VA_ARGS__);
#define  _LOG_ERROR(...)  printf(__VA_ARGS__);
#define  _LOG_DEBUG(...)  printf(__VA_ARGS__);

#endif

#endif //FILTERLIB_LOGBASE_H
