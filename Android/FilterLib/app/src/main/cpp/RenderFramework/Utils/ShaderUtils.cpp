//
// Created by SHI.yang on 2017/9/6.
//

#include "ShaderUtils.h"

long ShaderUtils::getFileContent(char *buffer, long len, const char *filePath)
{
    FILE *file = fopen(filePath, "rb");
    if (file == NULL) {
        _LOG_ERROR("ShaderUtils cannot find file %s", filePath);
        return -1;
    } else {
        _LOG_ERROR("ShaderUtils has found file %s", filePath);
    }

    fseek(file, 0, SEEK_END);
    long size = ftell(file);
    rewind(file);

    if (len < size) {
        _LOG_ERROR("ShaderUtils file size(%ld) is large than the size(%ld) you give\n", size, len);
        return -1;
    }

    fread(buffer, 1, size, file);
    buffer[size] = '\0';

    fclose(file);

    return size;
}

GLuint ShaderUtils::createGLShader(const char *shaderText, GLenum shaderType)
{
    GLuint shader = glCreateShader(shaderType);
    glShaderSource(shader, 1, &shaderText, nullptr);
    glCompileShader(shader);

    int compiled = 0;
    glGetShaderiv(shader, GL_COMPILE_STATUS, &compiled);
    if (!compiled) {
        _LOG_ERROR("ShaderUtils compile == 0 failed\n");
        GLint infoLen = 0;
        glGetShaderiv(shader, GL_INFO_LOG_LENGTH, &infoLen);
        _LOG_ERROR("ShaderUtils compile info lens = %d\n", infoLen);
        if (infoLen > 1) {
            char *infoLog = (char *)malloc(sizeof(char) * infoLen);
            if (infoLog) {
                glGetShaderInfoLog (shader, infoLen, nullptr, infoLog);
                _LOG_ERROR("ShaderUtils Error compiling shader: %s\n", infoLog);
                free(infoLog);
            }
        }
        glDeleteShader(shader);
        return 0;
    }

    return shader;
}

GLuint ShaderUtils::createGLProgram(const char *vertex, const char *fragment)
{
    GLuint program = glCreateProgram();
    if (0 == program) {
        _LOG_ERROR("ShaderUtils glCreateProgram = %u failed", program);
        return 0;
    }

    GLuint vertShader = createGLShader(vertex, GL_VERTEX_SHADER);
    GLuint fragShader = createGLShader(fragment, GL_FRAGMENT_SHADER);

    _LOG_ERROR("ShaderUtils vs = %u", vertShader);
    _LOG_ERROR("ShaderUtils fs = %u", fragShader);

    if (vertShader == 0 || fragShader == 0) {
        return 0;
    }

    glAttachShader(program, vertShader);
    glAttachShader(program, fragShader);

    glLinkProgram(program);
    GLint success;
    glGetProgramiv(program, GL_LINK_STATUS, &success);
    if (!success) {
        GLint infoLen;
        glGetProgramiv(program, GL_INFO_LOG_LENGTH, &infoLen);
        if (infoLen > 1) {
            GLchar *infoText = (GLchar *)malloc(sizeof(GLchar) * infoLen + 1);
            if (infoText) {
                memset(infoText, 0x00, sizeof(GLchar)*infoLen + 1);
                glGetProgramInfoLog(program, infoLen, NULL, infoText);
                _LOG_ERROR("ShaderUtils infoText %s\n", infoText);
                free(infoText);
            }
        }
        glDeleteShader(vertShader);
        glDeleteShader(fragShader);
        glDeleteProgram(program);
        return 0;
    }

    glDetachShader(program, vertShader);
    glDetachShader(program, fragShader);
    glDeleteShader(vertShader);
    glDeleteShader(fragShader);

    return program;
}

GLuint ShaderUtils::createGLProgramFromFile(const char *vertexPath, const char *fragmentPath)
{
    char vBuffer[2048] = {0};
    char fBuffer[2048*3] = {0};

    _LOG_ERROR("ShaderUtils vs path = %s\n", vertexPath);
    _LOG_ERROR("ShaderUtils fs path = %s\n", fragmentPath);

    if (getFileContent(vBuffer, sizeof(vBuffer), vertexPath) <= 0) {
        _LOG_ERROR("ShaderUtils createGLProgramFromFile vertex failed\n");
        return 0;
    } else {
        _LOG_ERROR("ShaderUtils createGLProgramFromFile vertex sucsseed\n");
    }

    if (getFileContent(fBuffer, sizeof(fBuffer), fragmentPath) <= 0) {
        _LOG_ERROR("ShaderUtils createGLProgramFromFile fragment failed\n");
        return 0;
    } else {
        _LOG_ERROR("ShaderUtils createGLProgramFromFile fragment sucsseed\n");
    }

    return createGLProgram(vBuffer, fBuffer);
}