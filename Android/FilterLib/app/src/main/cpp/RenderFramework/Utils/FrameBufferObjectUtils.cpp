//
// Created by SHI.yang on 2017/9/6.
//

#include "FrameBufferObjectUtils.h"

GLuint FrameBufferObjectUtils::createFrameBufferObject(GLuint _texId)
{
    GLuint fboId;
    glGenFramebuffers(1, &fboId);
    glBindFramebuffer(GL_FRAMEBUFFER, fboId);
    glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, _texId, 0);
    if (glCheckFramebufferStatus(GL_FRAMEBUFFER) != GL_FRAMEBUFFER_COMPLETE) {
//        NSLog(@"GenFramebuffer failed");
        return 0;
    }
    glBindFramebuffer(GL_FRAMEBUFFER, 0);
    return fboId;

}