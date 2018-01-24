//
// Created by SHI.yang on 2017/9/1.
//

#ifndef FILTERLIB_GLRENDER_H
#define FILTERLIB_GLRENDER_H

#include "../Base/GLBase.h"
#include "../Base/LogBase.h"

class GLFrameBufferObject;
class GLRender{
public:
    GLRender();
    virtual ~GLRender();
    virtual void init();
    void loadShader(const char *_vsPath="/storage/emulated/0/FilterLib/shader/YUVNV21toRGBA_vs.glsl",
                    const char *_fsPath="/storage/emulated/0/FilterLib/shader/YUVNV21toRGBA_fs.glsl");
    virtual void setImageData(unsigned char * _data, int w, int h, int len, int type);
    virtual void setData(unsigned char *_data, int _len);
    virtual void update();
    virtual void render();

protected:
    void _initMember();
    void _initMesh();
    void _initFrameBufferObject();

    GLuint m_programeId;
    GLuint m_texture0Id;
    GLuint m_texture1Id;
    GLuint m_texture2Id;
    GLuint m_texture3Id;
    GLuint m_vtxBufId;
    GLuint m_texBufId;
    GLuint m_idxBufId;
    GLFrameBufferObject *m_fbo;
};

#endif //FILTERLIB_GLRENDER_H
