#include <jni.h>
#include <string>
#include "RenderFramework/Render/GLRenderSys.h"
#include "Tracker/Tracker.h"

extern "C"
JNIEXPORT void JNICALL
Java_appmagics_filterlib_MainActivity_nativeInitRenderFramework(JNIEnv *env, jclass type) {
    GLRenderSys::getInstance()->init();
}

extern "C"
JNIEXPORT void JNICALL
Java_appmagics_filterlib_MainActivity_nativeSetData(JNIEnv *env, jclass type, jobject buffer, jint len) {
    void *t_buf_point = env->GetDirectBufferAddress(buffer);
    Tracker::getInstance()->setData((unsigned char *)t_buf_point, len);
    GLRenderSys::getInstance()->setData((unsigned char *)t_buf_point, len);
    GLRenderSys::getInstance()->update();
    GLRenderSys::getInstance()->render();
}

extern "C"
JNIEXPORT void JNICALL
Java_appmagics_filterlib_GLRenderSys_nativeInitRenderFramework(JNIEnv *env, jclass type) {
    GLRenderSys::getInstance()->init();
}

extern "C"
JNIEXPORT void JNICALL
Java_appmagics_filterlib_GLRenderSys_nativeSetData(JNIEnv *env, jclass type, jobject buffer, jint len) {
    void *t_buf_point = env->GetDirectBufferAddress(buffer);
    Tracker::getInstance()->setData((unsigned char *)t_buf_point, len);
    GLRenderSys::getInstance()->setData((unsigned char *)t_buf_point, len);
    GLRenderSys::getInstance()->update();
    GLRenderSys::getInstance()->render();
}



