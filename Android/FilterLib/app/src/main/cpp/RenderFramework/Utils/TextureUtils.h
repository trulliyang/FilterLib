//
// Created by SHI.yang on 2017/9/6.
//

#ifndef FILTERLIB_TEXTUREUTILS_H
#define FILTERLIB_TEXTUREUTILS_H


//#include "../Base/GLBase.h"
//#include "../Base/LogBase.h"


#include <GLES3/gl3.h>

class TextureUtils{
public:
    static GLuint createTexture2D(GLenum format, int width, int height, void *data);
};

#endif //FILTERLIB_TEXTUREUTILS_H