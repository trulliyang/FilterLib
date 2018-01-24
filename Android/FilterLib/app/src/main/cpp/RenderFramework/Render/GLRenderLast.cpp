//
// Created by SHI.yang on 2017/9/6.
//

#include "GLRenderLast.h"
#include "../Utils/ShaderUtils.h"
#include "../FrameBufferObject/GLFrameBufferObject.h"
#include "../Utils/TextureUtils.h"
#include "../Texture/GLTextureData.h"

GLRenderLast::GLRenderLast()
{

}

GLRenderLast::~GLRenderLast()
{

}

void GLRenderLast::init()
{
    _initMember();
    _initMesh();
//    _initTexture();
//    _initFrameBufferObject();
}

void GLRenderLast::loadShader(const char *_vsPath, const char *_fsPath)
{
    m_programeId = ShaderUtils::createGLProgramFromFile(_vsPath, _fsPath);
    _LOG_ERROR("shiyang cpp shader programe id = %u", m_programeId);
}

void GLRenderLast::setImageData(unsigned char *_data, int _w, int _h, int _len, int _type) {
    if (nullptr == m_texData) {
        m_texData = new GLTextureData();
    }

    if (0 == _type) { //NV12
        m_texData->init(_type, _w, _h, _data, _data + _w*_h);
    } else if (1 == _type) { //NV21
        m_texData->init(_type, _w, _h, _data, _data + _w*_h);
    } else if (2 == _type) { //RGBA
        m_texData->init(_type, _w, _h, _data);
    }
}

void GLRenderLast::setData(unsigned char *_data, int _len)
{

}

void GLRenderLast::update()
{

}

void GLRenderLast::render()
{
    _LOG_ERROR("shiyang cpp GLRenderLast::render");

    glUseProgram(m_programeId);

    glViewport(0, 0, 720, 1280);
    glClearColor(1.0, 0.0, 1.0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT);

    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, m_texture0Id);

    glUniform1i(glGetUniformLocation(m_programeId, "u_image0"), 0);

//    glUniform1i(glGetUniformLocation(m_programeId, "u_isRGBA"), 0);
//    glUniform1f(glGetUniformLocation(m_programeId, "u_rotationDegree"), 0.0);

    glEnable(GL_BLEND);
    glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_ALPHA);

    glBindBuffer(GL_ARRAY_BUFFER, m_vtxBufId);
    GLint t_locationPosition = glGetAttribLocation(m_programeId, "a_position");
    glEnableVertexAttribArray((GLuint) t_locationPosition);
    glVertexAttribPointer((GLuint) t_locationPosition, 2, GL_FLOAT, GL_FALSE, 0, NULL);

    glBindBuffer(GL_ARRAY_BUFFER, m_texBufId);
    int t_locationTexCoord =  glGetAttribLocation(m_programeId, "a_texcoord");
    glEnableVertexAttribArray((GLuint) t_locationTexCoord);
    glVertexAttribPointer((GLuint) t_locationTexCoord, 2, GL_FLOAT, GL_FALSE, 0, NULL);

    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, m_idxBufId);
    glDrawElements(GL_TRIANGLES, 6, GL_UNSIGNED_SHORT, 0);

    glBindBuffer(GL_ARRAY_BUFFER, 0);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0);

    glDisableVertexAttribArray((GLuint) t_locationPosition);
    glDisableVertexAttribArray((GLuint) t_locationTexCoord);

    glDisable(GL_BLEND);
    glUseProgram(0);
}

void GLRenderLast::setTextureId(unsigned int _texId)
{
    m_texture0Id = _texId;
}

void GLRenderLast::_initMember()
{
    m_programeId = 0;
    m_texture0Id = 0;
    m_vtxBufId = 0;
    m_texBufId = 0;
    m_idxBufId = 0;
    m_fbo = nullptr;
    m_texData = nullptr;
}

void GLRenderLast::_initMesh()
{
    GLfloat t_v[8] = {-1,1,  1,1,  -1,-1,  1,-1};
    glGenBuffers(1, &m_vtxBufId);
    glBindBuffer(GL_ARRAY_BUFFER, m_vtxBufId);
    glBufferData(GL_ARRAY_BUFFER, sizeof(t_v), t_v, GL_STATIC_DRAW);
    glBindBuffer(GL_ARRAY_BUFFER, 0);

    GLfloat t_t[8] = {0,1,  1,1,  0,0,  1,0};
    glGenBuffers(1, &m_texBufId);
    glBindBuffer(GL_ARRAY_BUFFER, m_texBufId);
    glBufferData(GL_ARRAY_BUFFER, sizeof(t_t), t_t, GL_STATIC_DRAW);
    glBindBuffer(GL_ARRAY_BUFFER, 0);

    GLushort t_i[6] = {0,1,2, 1,2,3};
    glGenBuffers(1, &m_idxBufId);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, m_idxBufId);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(t_i), t_i, GL_STATIC_DRAW);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0);
}

void GLRenderLast::_initTexture()
{
    m_texture0Id = TextureUtils::createTexture2D(GL_RGBA, 720, 1280, nullptr);
}

void GLRenderLast::_initFrameBufferObject()
{
    m_fbo = new GLFrameBufferObject();
    m_fbo->createFrameBufferObject();
}