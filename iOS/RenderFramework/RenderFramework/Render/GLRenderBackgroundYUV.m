//
//  GLRenderBackgroundYUV.m
//  RenderFramework
//
//  Created by yang.SHI on 2017/8/28.
//  Copyright © 2017年 shiyang. All rights reserved.
//

#import "GLRenderBackgroundYUV.h"
@interface GLRenderBackgroundYUV() {
    @public
    GLuint programID;
    
    GLuint textureYID;
    GLuint textureUVID;
    
    GLuint vtxBufID;
    GLuint texBufID;
    GLuint idxBufID;
    
    GLFramebufferObject *fbo;
}
@end

@implementation GLRenderBackgroundYUV

- (instancetype)init
{
    if (self = [super init])
    {
        programID = 0;
        textureYID = 0;
        textureUVID = 0;
        vtxBufID = 0;
        texBufID = 0;
        idxBufID = 0;
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
    
//    NSLog(@"GLRenderBackground vtxBufID=%d", vtxBufID);
//    NSLog(@"GLRenderBackground texBufID=%d", texBufID);
//    NSLog(@"GLRenderBackground idxBufID=%d", idxBufID);
}

- (void)initFramebuffer
{
    fbo = [[GLFramebufferObject alloc] init];
    NSLog(@"fbo id = %d, fbo texture id = %d", [fbo getFBOID], [fbo getFBOTextureID]);
}

- (void)setTrackerData:(FPOINT *)points pointNum:(int)ptNumber faceNum:(int)faceNumber Width:(int)width Height:(int)height
{
}

- (void)setTextureRGBA:(GLTextureRGBA *)texture
{
}

- (void)setTextureYUV:(GLTextureYUV *)texture
{
}

- (void)setTextureIdYid:(GLuint)texYId UVid:(GLuint)texUVId
{
    textureYID = texYId;
    textureUVID = texUVId;
}

- (GLTextureRGBA *)getTexture
{
    return nil;
}

- (GLuint)getTextureId
{
    return 0;//textureID;
}

- (GLuint)getFBOId
{
    return [fbo getFBOID];
}

- (GLuint)getFBOTextureId
{
    return [fbo getFBOTextureID];
}

- (void)prepareRender
{
    if (0 == textureYID) {
        NSLog(@"GLRenderBackgroundYUV do prepareRender no Y texture to render");
        return;
    }
    if (0 == textureUVID) {
        NSLog(@"GLRenderBackgroundYUV do prepareRender no UV texture to render");
        return;
    }
    
    glUseProgram(programID);

    GLuint fbid = [fbo getFBOID];
    glBindFramebuffer(GL_FRAMEBUFFER, fbid);
    glViewport(0, 0, 720, 1280);
    glClearColor(1.0f, 1.0f, 1.0f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT | GL_STENCIL_BUFFER_BIT);
    
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, textureYID);
    glUniform1i(glGetUniformLocation(programID, "image0"), 0);
    
    glActiveTexture(GL_TEXTURE1);
    glBindTexture(GL_TEXTURE_2D, textureUVID);
    glUniform1i(glGetUniformLocation(programID, "image1"), 1);
    
    glUniform1f(glGetUniformLocation(programID, "rotationDegree"), 0.0);
    
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
    NSLog(@"GLRenderBackgroundYUV do setupProgram shader id = %d", programID);
//    glUseProgram(programID);
    
}

@end
