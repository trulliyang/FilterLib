//
// Created by SHI.yang on 2017/9/6.
//

#include "GLFrameBufferObject.h"

GLFrameBufferObject::GLFrameBufferObject()
{
    _init();
}

GLFrameBufferObject::~GLFrameBufferObject()
{

}

GLuint GLFrameBufferObject::getFboId()
{
    return m_fboId;
}

GLuint GLFrameBufferObject::getTexId()
{
    return m_fboTexId;
}

void GLFrameBufferObject::createFrameBufferObject(int width, int height)
{
    m_fboTexId = TextureUtils::createTexture2D(GL_RGBA, width, height, nullptr);
    m_fboId = FrameBufferObjectUtils::createFrameBufferObject(m_fboTexId);
}

void GLFrameBufferObject::_init()
{
    m_fboId = 0;
    m_fboTexId = 0;
}