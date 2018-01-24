//
// Created by SHI.yang on 2017/9/1.
//

#include "GLRenderSys.h"
#include "GLRenderFirst.h"
#include "GLRenderLast.h"
#include "GLRenderYUV.h"
#include <string>
#include <malloc.h>

static GLRenderSys *m_pInst = nullptr;

bool m_hasInitialsed = false;

GLRenderSys *GLRenderSys::getInstance()
{
    if (nullptr == m_pInst) {
        m_pInst = new GLRenderSys();
    }
    return m_pInst;
}

void GLRenderSys::init(const char *shaderFilePath)
{
    if (m_hasInitialsed) {
        _LOG_ERROR("shiyang GLRenderSys::init has initialised return");
        return;
    }

    _LOG_ERROR("shiyang GLRenderSys::init do init");
    _LOG_ERROR("shiyang GLRenderSys::init do init shader file path = %s", shaderFilePath);

    std::string path = std::string(shaderFilePath);

//    std::string vs = path + std::string("/") + std::string("default_vs.glsl");
    std::string vs = path + std::string("/") + std::string("red_vs.glsl");
//    std::string fs = path + std::string("/") + std::string("YUVNV21toRGBA_fs.glsl");
    std::string fs = path + std::string("/") + std::string("red_fs.glsl");
    m_GLRenderFirst = new GLRenderFirst();
    m_GLRenderFirst->init();
    m_GLRenderFirst->loadShader(vs.c_str(), fs.c_str());

    vs = path + std::string("/") + std::string("YUVNV21toRGBA_vs.glsl");
    fs = path + std::string("/") + std::string("YUVNV21toRGBA_fs.glsl");
    m_GLRenderYUV = new GLRenderYUV();
    m_GLRenderYUV->init();
    m_GLRenderYUV->loadShader(vs.c_str(), fs.c_str());


    vs = path + std::string("/") + std::string("green_vs.glsl");
    fs = path + std::string("/") + std::string("green_fs.glsl");
    m_GLRenderLast = new GLRenderLast();
    m_GLRenderLast->init();
    m_GLRenderLast->loadShader(vs.c_str(), fs.c_str());

    m_hasInitialsed = true;
}

void GLRenderSys::setImageData(unsigned char *_data, int _w, int _h, int _len, int _type) {
    if (m_GLRenderFirst) {
        m_GLRenderFirst->setImageData(_data, _w, _h, _len, _type);
    }
}

void GLRenderSys::setData(unsigned char *_data, int _len)
{
    if (m_GLRenderFirst) {
        m_GLRenderFirst->setData(_data, _len);
    }
    if (m_GLRenderLast) {
        m_GLRenderLast->setData(_data, _len);
    }
}

void GLRenderSys::update()
{
    if (m_GLRenderFirst) {
        m_GLRenderFirst->update();
    }
    if (m_GLRenderYUV) {
        m_GLRenderYUV->update();
    }
    if (m_GLRenderLast) {
        m_GLRenderLast->update();
    }
}

//int a = 0;

void GLRenderSys::render()
{
//    if (a == 1) {
//        renderTestInit();
//        a = 0;
//    }
//    renderTest();
//    return;

    GLuint t_texId = 0;

    if (m_GLRenderFirst) {
//        m_GLRenderFirst->render();
    }

    if (m_GLRenderYUV) {
        m_GLRenderYUV->render();
        t_texId = m_GLRenderYUV->getFboTexId();
    }

    if (m_GLRenderLast) {
        m_GLRenderLast->setTextureId(t_texId);
//        m_GLRenderLast->render();
    }
}

GLuint GLRenderSys::LoadShader(GLenum type, const char *shaderSrc) {
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
//            LOGE("Error compiling shader:[%s]", infoLog);

            free(infoLog);
        }

        glDeleteShader(shader);
        return 0;
    }

    return shader;

}

void GLRenderSys::renderTestInit()
{
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
//            LOGE("Error linking program:[%s]", infoLog);

            free(infoLog);
        }

        glDeleteProgram(programObject);
        return;
    }

    // Store the program object
    g_programObject = programObject;

    glClearColor(1.0f, 1.0f, 1.0f, 0.0f);
}

void GLRenderSys::renderTest()
{
    GLfloat vVertices[] = {
             0.0f,  0.5f, 0.0f,
            -0.5f, -0.5f, 0.0f,
             0.5f, -0.5f, 0.0f
    };

    // Set the viewport
    glViewport(0, 0, 720, 1280);

    // Clear the color buffer
    glClear(GL_COLOR_BUFFER_BIT);

    // Use the program object
    glUseProgram(g_programObject);

    // Load the vertex data
    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 0, vVertices);
    glEnableVertexAttribArray(0);

    glDrawArrays(GL_TRIANGLES, 0, 3);
}