//
// Created by SHI.yang on 2017/9/6.
//

#include "GLTextureData.h"

GLTextureData::GLTextureData()
{

}

GLTextureData::~GLTextureData()
{

}

void GLTextureData::init(int _type, int _w, int _h, GLubyte *_p0, GLubyte *_p1, GLubyte *_p2, GLubyte *_p3)
{
    m_type = _type;
    m_width = _w;
    m_height = _h;
    m_pData0 = _p0;
    m_pData1 = _p1;
    m_pData2 = _p2;
    m_pData3 = _p3;
}

int GLTextureData::getType()
{
    return m_type;
}

int GLTextureData::getWidth()
{
    return m_width;
}

int GLTextureData::getHeight()
{
    return m_height;
}

void GLTextureData::destroy()
{
    if (nullptr != m_pData0) {
        delete m_pData0;
        m_pData0 = nullptr;
    }

    if (nullptr != m_pData1) {
        delete m_pData1;
        m_pData1 = nullptr;
    }

    if (nullptr != m_pData2) {
        delete m_pData2;
        m_pData2 = nullptr;
    }

    if (nullptr != m_pData3) {
        delete m_pData3;
        m_pData3 = nullptr;
    }
}