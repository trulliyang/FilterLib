//
// Created by admin on 2017/9/13.
//

#include <jni.h>
#include "FLJNI.h"
#include "RenderFramework/Render/GLRenderSys.h"

extern "C"
JNIEXPORT void JNICALL
Java_sy_filterlib_FLJNI_nativeFLInit(JNIEnv *env, jobject self) {
    GLRenderSys::getInstance()->init();
//    int a = glCreateProgram();
//    _LOG_ERROR("shiyang nativeFLInit glCreateProgram = %u", glCreateProgram());
}

extern "C"
JNIEXPORT void JNICALL
Java_sy_filterlib_FLJNI_nativeFLRender(JNIEnv *env, jobject self, jint texid) {
    GLRenderSys::getInstance()->update();
    GLRenderSys::getInstance()->render();
}

extern "C"
JNIEXPORT void JNICALL
Java_sy_filterlib_FLJNI_nativeFLResize(JNIEnv *env, jobject self, jint width, jint height) {

}

extern "C"
JNIEXPORT void JNICALL
Java_sy_filterlib_FLJNI_nativeFLSetImageData(JNIEnv *env, jobject self, jobject data,
                                                    jint width, jint height, jint len, jint type) {
    unsigned char *t_imageDate = (unsigned char *)env->GetDirectBufferAddress(data);
    GLRenderSys::getInstance()->setImageData(t_imageDate, width, height, len, type);
}