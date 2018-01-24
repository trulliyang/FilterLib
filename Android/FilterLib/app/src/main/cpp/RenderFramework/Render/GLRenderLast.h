//
// Created by SHI.yang on 2017/9/6.
//

#ifndef FILTERLIB_GLRENDERLAST_H
#define FILTERLIB_GLRENDERLAST_H

#include "GLRender.h"

class GLTextureData;
class GLRenderLast: public GLRender{
public:
    GLRenderLast();
    virtual ~GLRenderLast();
    virtual void init();
    void loadShader(const char *_vsPath="/storage/emulated/0/FilterLib/shader/YUVNV21toRGBA_vs.glsl",
                    const char *_fsPath="/storage/emulated/0/FilterLib/shader/YUVNV21toRGBA_fs.glsl");
    virtual void setImageData(unsigned char * _data, int w, int h, int len, int type);
    virtual void setData(unsigned char *_data, int _len);
    virtual void update();
    virtual void render();
    virtual void setTextureId(unsigned int _texId);
protected:
    void _initMember();
    void _initMesh();
    void _initTexture();
    void _initFrameBufferObject();
    GLTextureData *m_texData;
};

#endif //FILTERLIB_GLRENDERLAST_H
