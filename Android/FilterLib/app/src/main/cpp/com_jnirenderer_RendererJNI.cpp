//
// Created by admin on 2017/9/12.
//


#include "com_jnirenderer_RendererJNI.h"
#include <stdlib.h>
#include <stdio.h>
#include <errno.h>
#include <GLES3/gl3.h>
#include <android/asset_manager_jni.h>
#include <android/log.h>


#define LOG_TAG "ndk-build"
#define LOGI(...) __android_log_print(ANDROID_LOG_INFO, LOG_TAG, __VA_ARGS__)
#define LOGE(...) __android_log_print(ANDROID_LOG_ERROR, LOG_TAG, __VA_ARGS__)

extern "C" {
GLint	g_programObject;
jint	g_width;
jint	g_height;

AAssetManager* g_pAssetManager = nullptr;

char *readShaderSrcFile(char *shaderFile, AAssetManager *pAssetManager) {
    AAsset *pAsset = nullptr;
    char *pBuffer = nullptr;
    off_t size = -1;
    int numByte = -1;

    if (nullptr == pAssetManager) {
        LOGE("pAssetManager is null!");
        return nullptr;
    }
    pAsset = AAssetManager_open(pAssetManager, shaderFile, AASSET_MODE_UNKNOWN);
    //LOGI("after AAssetManager_open");
    if (nullptr == pAsset) {
        LOGE(" AAssetManager_open failed");
        return nullptr;
    }
    size = AAsset_getLength(pAsset);
    LOGI("after AAssetManager_open");
    pBuffer = (char *) malloc(size + 1);
    pBuffer[size] = '\0';

    numByte = AAsset_read(pAsset, pBuffer, size);
    LOGI("%s : [%s]", shaderFile, pBuffer);
    AAsset_close(pAsset);

    return pBuffer;
}

GLuint LoadShader(GLenum type, const char *shaderSrc) {
    GLuint shader;
    GLint compiled;

    // Create the shader object
    shader = glCreateShader(type);

    if (shader == 0) {
        return 0;
    }

    // Load the shader source
    glShaderSource(shader, 1, &shaderSrc, nullptr);

    // Compile the shader
    glCompileShader(shader);

    // Check the compile status
    glGetShaderiv(shader, GL_COMPILE_STATUS, &compiled);

    if (!compiled) {
        GLint infoLen = 0;

        glGetShaderiv(shader, GL_INFO_LOG_LENGTH, &infoLen);

        if (infoLen > 1) {
            char *infoLog = (char *) malloc(sizeof(char) * infoLen);

            glGetShaderInfoLog(shader, infoLen, nullptr, infoLog);
            LOGE("Error compiling shader:[%s]", infoLog);

            free(infoLog);
        }

        glDeleteShader(shader);
        return 0;
    }

    return shader;

}

//*********************************************************************************
//

JNIEXPORT void JNICALL
Java_sy_filterlib_RendererJNI_readShaderFile(JNIEnv *env, jobject self, jobject assetManager) {
    if (assetManager != nullptr && env != nullptr) {
        LOGE("before AAssetManager_fromJava");
        g_pAssetManager = AAssetManager_fromJava(env, assetManager);
        LOGE("after AAssetManager_fromJava");
        if (nullptr == g_pAssetManager) {
            LOGE("AAssetManager_fromJava() return null !");
        }
    } else {
        LOGE("assetManager is null !");
    }
}

//*********************************************************************************
//

JNIEXPORT void JNICALL
Java_sy_filterlib_RendererJNI_glesInit(JNIEnv *pEnv, jobject obj) {
    char vShaderStr[] =
            "#version 300 es                          \n"
                    "layout(location = 0) in vec4 vPosition;  \n"
                    "void main()                              \n"
                    "{                                        \n"
                    "   gl_Position = vPosition;              \n"
                    "}                                        \n";

    char fShaderStr[] =
            "#version 300 es                              \n"
                    "precision mediump float;                     \n"
                    "out vec4 fragColor;                          \n"
                    "void main()                                  \n"
                    "{                                            \n"
                    "   fragColor = vec4 ( 1.0, 0.0, 0.0, 1.0 );  \n"
                    "}                                            \n";

//    if (nullptr == g_pAssetManager) { return; }
//    char *pVertexShader = readShaderSrcFile("shader/vs.glsl", g_pAssetManager);
//    char *pFragmentShader = readShaderSrcFile("shader/fs.glsl", g_pAssetManager);

    GLuint vertexShader;
    GLuint fragmentShader;
    GLuint programObject;
    GLint linked;

    // Load the vertex/fragment shaders
    vertexShader = LoadShader(GL_VERTEX_SHADER, vShaderStr);
    fragmentShader = LoadShader(GL_FRAGMENT_SHADER, fShaderStr);
//    vertexShader = LoadShader(GL_VERTEX_SHADER, pVertexShader);
//    fragmentShader = LoadShader(GL_FRAGMENT_SHADER, pFragmentShader);

    // Create the program object
    programObject = glCreateProgram();

    if (programObject == 0) {
        return;
    }

    glAttachShader(programObject, vertexShader);
    glAttachShader(programObject, fragmentShader);

    // Link the program
    glLinkProgram(programObject);

    // Check the link status
    glGetProgramiv(programObject, GL_LINK_STATUS, &linked);

    if (!linked) {
        GLint infoLen = 0;

        glGetProgramiv(programObject, GL_INFO_LOG_LENGTH, &infoLen);

        if (infoLen > 1) {
            char *infoLog = (char *) malloc(sizeof(char) * infoLen);

            glGetProgramInfoLog(programObject, infoLen, nullptr, infoLog);
            LOGE("Error linking program:[%s]", infoLog);

            free(infoLog);
        }

        glDeleteProgram(programObject);
        return;
    }

    // Store the program object
    g_programObject = programObject;

    glClearColor(1.0f, 1.0f, 1.0f, 0.0f);

}

//*********************************************************************************
//

JNIEXPORT void JNICALL
Java_sy_filterlib_RendererJNI_glesRender(JNIEnv *pEnv, jobject obj) {
    GLfloat vVertices[] = {0.0f, 0.5f, 0.0f,
                           -0.5f, -0.5f, 0.0f,
                           0.5f, -0.5f, 0.0f
    };

    // Set the viewport
    glViewport(0, 0, g_width, g_height);

    // Clear the color buffer
    glClear(GL_COLOR_BUFFER_BIT);

    // Use the program object
    glUseProgram(g_programObject);

    // Load the vertex data
    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 0, vVertices);
    glEnableVertexAttribArray(0);

    glDrawArrays(GL_TRIANGLES, 0, 3);
}

//*********************************************************************************
//

JNIEXPORT void JNICALL
Java_sy_filterlib_RendererJNI_glesResize(JNIEnv *pEnv, jobject obj, jint width, jint height) {
    g_width = width;
    g_height = height;
}

};