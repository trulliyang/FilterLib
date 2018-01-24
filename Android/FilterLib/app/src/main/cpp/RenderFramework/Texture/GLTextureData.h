//
// Created by SHI.yang on 2017/9/6.
//

#ifndef FILTERLIB_GLTEXTURE_H
#define FILTERLIB_GLTEXTURE_H

#include "../Base/GLBase.h"
#include "../Base/LogBase.h"

class GLTextureData{
public:
    GLTextureData();
    ~GLTextureData();
    void init(int _type=1, int _w=720, int _h=1280,
              GLubyte *_p0=nullptr, GLubyte *_p1=nullptr,
              GLubyte *_p2=nullptr, GLubyte *_p3=nullptr);
    int getType();
    int getWidth();
    int getHeight();
    void destroy();
private:
    int m_type;
    int m_width;
    int m_height;
    GLubyte *m_pData0;
    GLubyte *m_pData1;
    GLubyte *m_pData2;
    GLubyte *m_pData3;
};

#endif //FILTERLIB_GLTEXTURE_H
