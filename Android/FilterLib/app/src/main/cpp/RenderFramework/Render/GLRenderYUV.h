//
// Created by shiyang1 on 2018/1/23.
//

#ifndef FILTERLIB_GLRENDERYUV_H
#define FILTERLIB_GLRENDERYUV_H


#include "GLRender.h"

class GLTextureData;
class GLRenderYUV : public GLRender{
public:
    GLRenderYUV();
    virtual ~GLRenderYUV();
    virtual void init();
    void loadShader(const char *_vsPath="/storage/emulated/0/FilterLib/shader/YUVNV21toRGBA_vs.glsl",
                    const char *_fsPath="/storage/emulated/0/FilterLib/shader/YUVNV21toRGBA_fs.glsl");
    virtual void setImageData(unsigned char * _data, int w, int h, int len, int type);
    virtual void setData(unsigned char *_data, int _len);
    virtual void update();
    virtual void render();
    virtual unsigned int getFboTexId();
protected:
    void _initMember();
    void _initMesh();
    void _initTexture();
    void _initFrameBufferObject();
    void _readYUVMovie();
    GLTextureData *m_texData;
    unsigned char *m_buf;
};


#endif //FILTERLIB_GLRENDERYUV_H
