//
// Created by SHI.yang on 2017/9/1.
//

#include "GLRender.h"
#include "../Utils/ShaderUtils.h"
#include "../FrameBufferObject/GLFrameBufferObject.h"

GLRender::GLRender()
{

}

GLRender::~GLRender()
{

}

void GLRender::init()
{
    _initMember();
    _initMesh();
    _initFrameBufferObject();
}

void GLRender::loadShader(const char *_vsPath, const char *_fsPath)
{
    m_programeId = ShaderUtils::createGLProgramFromFile(_vsPath, _fsPath);
}

void GLRender::setImageData(unsigned char * _data, int w, int h, int len, int type)
{

}

void GLRender::setData(unsigned char *_data, int _len)
{

}

void GLRender::update()
{

}

void GLRender::render()
{
    glUseProgram(m_programeId);
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, m_texture0Id);
    glUniform1i(glGetUniformLocation(m_programeId, "u_image0"), 0);

//    glUniform1i(glGetUniformLocation(m_programeId, "u_isRGBA"), 0);
//    glUniform1f(glGetUniformLocation(m_programeId, "u_rotationDegree"), 0.0);

    glEnable(GL_BLEND);
    glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_ALPHA);

    glBindBuffer(GL_ARRAY_BUFFER, m_vtxBufId);
    GLuint t_locationPosition = (GLuint) glGetAttribLocation(m_programeId, "a_position");
    glEnableVertexAttribArray(t_locationPosition);
    glVertexAttribPointer(t_locationPosition, 2, GL_FLOAT, GL_FALSE, 0, NULL);

    glBindBuffer(GL_ARRAY_BUFFER, m_texBufId);
    GLuint t_locationTexCoord = (GLuint) glGetAttribLocation(m_programeId, "a_texcoord");
    glEnableVertexAttribArray(t_locationTexCoord);
    glVertexAttribPointer(t_locationTexCoord, 2, GL_FLOAT, GL_FALSE, 0, NULL);

    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, m_idxBufId);
    glDrawElements(GL_TRIANGLES, 6, GL_UNSIGNED_SHORT, 0);

    glBindBuffer(GL_ARRAY_BUFFER, 0);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0);

    glDisableVertexAttribArray(t_locationPosition);
    glDisableVertexAttribArray(t_locationTexCoord);

    glUseProgram(0);

    glDisable(GL_BLEND);
    glUseProgram(0);
}

void GLRender::_initMember()
{
    m_programeId = 0;
    m_texture0Id = 0;
    m_texture1Id = 0;
    m_texture2Id = 0;
    m_texture3Id = 0;
    m_vtxBufId = 0;
    m_texBufId = 0;
    m_idxBufId = 0;
    m_fbo = nullptr;
}

void GLRender::_initMesh()
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

void GLRender::_initFrameBufferObject()
{
    m_fbo = new GLFrameBufferObject();
    m_fbo->createFrameBufferObject();
}

