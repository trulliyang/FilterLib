//
// Created by SHI.yang on 2017/9/1.
//

#ifndef FILTERLIB_GLRENDERSYS_H
#define FILTERLIB_GLRENDERSYS_H

#include "../Base/GLBase.h"
#include "../Base/LogBase.h"

class GLRenderFirst;
class GLRenderYUV;
class GLRenderLast;
class GLTextureData;
class GLRenderSys{
public:
    static GLRenderSys *getInstance();
    void init(const char *shaderFilePath = "/storage/emulated/0/FilterLib/Shader");
    void setImageData(unsigned char * _data, int w, int h, int len, int type);
    void setData(unsigned char *_data, int _len);
    void update();
    void render();
private:
    void renderTestInit();
    void renderTest();
    GLuint LoadShader(GLenum _type, const char * _shaderSrc);
    GLuint g_programObject;
    GLRenderFirst *m_GLRenderFirst;
    GLRenderYUV *m_GLRenderYUV;
    GLRenderLast *m_GLRenderLast;
};


#endif //FILTERLIB_GLRENDERSYS_H
