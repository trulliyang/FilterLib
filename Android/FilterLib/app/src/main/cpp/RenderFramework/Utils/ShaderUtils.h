//
// Created by SHI.yang on 2017/9/6.
//

#ifndef FILTERLIB_SHADERUTILS_H
#define FILTERLIB_SHADERUTILS_H

#include "../Base/GLBase.h"
#include "../Base/LogBase.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

class ShaderUtils{
public:
    static long getFileContent(char *buffer, long len, const char *filePath);
    static GLuint createGLShader(const char *shaderText, GLenum shaderType);
    static GLuint createGLProgram(const char *vertext, const char *frag);
    static GLuint createGLProgramFromFile(const char *vertextPath, const char *fragPath);
};

#endif //FILTERLIB_SHADERUTILS_H
