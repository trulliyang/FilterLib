//
// Created by SHI.yang on 2017/9/6.
//

#ifndef FILTERLIB_GLFRAMEBUFFEROBJECT_H
#define FILTERLIB_GLFRAMEBUFFEROBJECT_H

#include "../Base/GLBase.h"
#include "../Base/LogBase.h"
#include "../Utils/TextureUtils.h"
#include "../Utils/FrameBufferObjectUtils.h"

class GLFrameBufferObject{
public:
    GLFrameBufferObject();
    ~GLFrameBufferObject();
    void createFrameBufferObject(int width=720, int height=1280);
    GLuint getFboId();
    GLuint getTexId();
private:
    void _init();
    GLuint m_fboId;
    GLuint m_fboTexId;
};

#endif //FILTERLIB_GLFRAMEBUFFEROBJECT_H
