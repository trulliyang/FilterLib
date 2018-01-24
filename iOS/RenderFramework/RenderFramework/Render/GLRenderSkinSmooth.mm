//
//  GLRenderSkinSmooth.m
//  RenderFramework
//
//  Created by yang.SHI on 2017/8/15.
//  Copyright © 2017年 shiyang. All rights reserved.
//

#import "GLRenderSkinSmooth.h"
@interface GLRenderSkinSmooth() {
@public
    GLuint programID;
    GLuint textureID;
    GLuint vtxBufID;
    GLuint texBufID;
    GLuint idxBufID;
    
    GLint   m_width;
    GLint   m_height;
    GLfloat m_smooth;
    
    GLFramebufferObject *fbo;
    GLuint fboID;
}
@end

@implementation GLRenderSkinSmooth

- (instancetype)init
{
    if (self = [super init])
    {
        programID = 0;
        textureID = 0;
        vtxBufID = 0;
        texBufID = 0;
        idxBufID = 0;
        m_width = 720;
        m_height = 1280;
        m_smooth = 3.0f;
        [self initMesh];
        [self initFramebuffer];
    }
    return self;
}

- (void)initMesh
{
    float v[8] = {-1,1,  1,1,  -1,-1,  1,-1};
    glGenBuffers(1, &vtxBufID);
    glBindBuffer(GL_ARRAY_BUFFER, vtxBufID);
    glBufferData(GL_ARRAY_BUFFER, sizeof(v), v, GL_STATIC_DRAW);
    glBindBuffer(GL_ARRAY_BUFFER, 0);
    
    float t[8] = {0,1,  1,1,  0,0,  1,0};
    glGenBuffers(1, &texBufID);
    glBindBuffer(GL_ARRAY_BUFFER, texBufID);
    glBufferData(GL_ARRAY_BUFFER, sizeof(t), t, GL_STATIC_DRAW);
    glBindBuffer(GL_ARRAY_BUFFER, 0);
    
    unsigned short i[6] = {0,1,2, 1,2,3};
    glGenBuffers(1, &idxBufID);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, idxBufID);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(i), i, GL_STATIC_DRAW);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0);
}

- (void)initFramebuffer
{
    fbo = [[GLFramebufferObject alloc] init];
    NSLog(@"fbo id = %d, fbo texture id = %d", [fbo getFBOID], [fbo getFBOTextureID]);
}

- (void)setTrackerData:(FPOINT *)points pointNum:(int)ptNumber faceNum:(int)faceNumber Width:(int)width Height:(int)height
{
    [super setTrackerData:points pointNum:ptNumber faceNum:faceNumber Width:width Height:height];
}

- (void)setTextureRGBA:(GLTextureRGBA *)texture
{
}

- (void)setTextureId:(GLuint)texId
{
    textureID = texId;
}

- (GLTextureRGBA *)getTexture
{
    return nil;
}

- (GLuint)getTextureId
{
    return textureID;
}

- (void)setFBOId:(GLuint)fboid
{
    fboID = fboid;
}

- (GLuint)getFBOId
{
    return [fbo getFBOID];
}

- (GLuint)getFBOTextureId
{
    return [fbo getFBOTextureID];
}

- (void)updateUniform
{
    glUniform1f(glGetUniformLocation(programID, "mvSmoothSize"), m_smooth);
    glUniform1i(glGetUniformLocation(programID, "width"), m_width);
    glUniform1i(glGetUniformLocation(programID, "height"), m_height);
}

- (void)prepareRender
{
    if (0 == textureID)
    {
        NSLog(@"GLRenderSkinSmooth do prepareRender no texture to render");
        return;
    }
    
    bool notLast = true;
    GLuint fbid = [fbo getFBOID];
    
    glUseProgram(programID);
    
    if (notLast) {
        glBindFramebuffer(GL_FRAMEBUFFER, fbid);
    } else {
        glBindFramebuffer(GL_FRAMEBUFFER, fboID);
        glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, 1);
    }
    
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, textureID);
    glUniform1i(glGetUniformLocation(programID, "image0"), 0);
    
    glUniform1i(glGetUniformLocation(programID, "isRGBA"), 1);
    glUniform1f(glGetUniformLocation(programID, "rotationDegree"), 0.0);
    [self updateUniform];
    
    //绘图
    glEnable(GL_BLEND);
    glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_ALPHA);
    
    //顶点流
    glBindBuffer(GL_ARRAY_BUFFER, vtxBufID);
    glEnableVertexAttribArray(glGetAttribLocation(programID, "position"));
    glVertexAttribPointer(glGetAttribLocation(programID, "position"), 2, GL_FLOAT, GL_FALSE, 0, NULL);
    
    //纹理坐标流
    glBindBuffer(GL_ARRAY_BUFFER, texBufID);
    glEnableVertexAttribArray(glGetAttribLocation(programID, "texcoord"));
    glVertexAttribPointer(glGetAttribLocation(programID, "texcoord"), 2, GL_FLOAT,GL_FALSE, 0, NULL);
    
    //索引方式绘制
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, idxBufID);
    glDrawElements(GL_TRIANGLES, 6, GL_UNSIGNED_SHORT, 0);
    
    glBindBuffer(GL_ARRAY_BUFFER, 0);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0);
    
    glDisableVertexAttribArray(glGetAttribLocation(programID, "position"));
    glDisableVertexAttribArray(glGetAttribLocation(programID, "texcoord"));
    
    glUseProgram(0);
    
    glDisable(GL_BLEND);
    
}

- (void)afterRender
{
}

- (void)setupProgramVertex:(NSString *)v Fragment:(NSString *)f
{
    programID = createGLProgramFromFile(v.UTF8String, f.UTF8String);
    NSLog(@"GLRenderSkinSmooth do setupProgram shader id = %d", programID);
//    glUseProgram(programID);
    
}

@end
