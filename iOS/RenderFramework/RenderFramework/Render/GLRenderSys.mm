//
//  GLRenderSys.m
//  RenderFramework
//
//  Created by yang.SHI on 2017/8/9.
//  Copyright © 2017年 appMagics. All rights reserved.
//

#import "GLRenderSys.h"

@interface GLRenderSys(){
    @public
    EAGLContext *m_context;
    GLuint m_textureId;
    GLuint m_textureYId;
    GLuint m_textureUVId;
    GLuint m_fboID;
    GLTextureRGBA *m_rgbaTexture;
    GLTextureYUV *m_yuvTexture;
    GLRenderBackground *m_renderBackground;
    GLRenderBackgroundYUV *m_renderBackgroundYUV;
    GLRenderFaceMorph *m_renderFaceMorph;
    GLRenderFaceUBeautify *m_renderFaceUBeautify;
    GLRenderSkinSmooth *m_renderSkinSmooth;
    GLRenderSkinColorAdjusting *m_renderSkinColorAjdusting;
    GLRenderLast *m_renderLast;
    int m_width;
    int m_height;
    bool m_enableFaceMorph;
    bool m_enableFaceUBeautify;
    bool m_enableSkinSmooth;
    bool m_enableSkinColorAdjusting;
    INOUTTYPE m_inputType;
    INOUTTYPE m_outputType;
}
@end

////////////////GLRenderSys//////////////////////////
@implementation GLRenderSys

- (instancetype)init
{
    if (self = [super init]) {
        [self setContext];
        m_inputType = YUVNV12_DATA;
        m_outputType = RGBA_DATA;
    }
    return self;
}

- (void)setInputType:(INOUTTYPE)type{
    m_inputType = type;
}

- (void)setOutputType:(INOUTTYPE)type{
    m_outputType = type;

}

- (void)setSizeWidth:(int)w Height:(int)h
{
    m_width = w;
    m_height = h;
}

- (void)initRenderer
{
    m_textureId = createTexture2D(GL_RGBA, m_width, m_height, NULL);
    
    m_textureYId = createTexture2D(GL_LUMINANCE, m_width, m_height, NULL);
    m_textureUVId = createTexture2D(GL_LUMINANCE_ALPHA, m_width/2, m_height/2, NULL);
    
    m_renderBackground = [[GLRenderBackground alloc] init];
    m_renderBackgroundYUV = [[GLRenderBackgroundYUV alloc] init];
    m_renderFaceMorph = [[GLRenderFaceMorph alloc] init];
    m_renderFaceUBeautify = [[GLRenderFaceUBeautify alloc] init];
    m_renderSkinSmooth = [[GLRenderSkinSmooth alloc] init];
    m_renderSkinColorAjdusting = [[GLRenderSkinColorAdjusting alloc] init];
    m_renderLast = [[GLRenderLast alloc] init];
    
    m_enableFaceMorph = false;
    m_enableFaceUBeautify = false;
    m_enableSkinSmooth = false;
    m_enableSkinColorAdjusting = false;
}

- (void)setContext
{
    NSLog(@"RenderFramework do setContext");

    m_context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    if (!m_context) {
        NSLog(@"RenderFramework do setContext Failed to initialize OpenGLES 2.0 context");
        exit(1);
    }
    
    if (![EAGLContext setCurrentContext:m_context]) {
        NSLog(@"RenderFramework do setContext Failed to set current OpenGL context");
        exit(1);
    }
}

- (EAGLContext *)getContext
{
    return m_context;
}

- (void)setupGLProgram
{
    
}

- (void)setupProgramBackgroundVertex:(NSString *)v Fragment:(NSString *)f;
{
    NSLog(@"RenderFramework do setupProgramBackground");
    [m_renderBackground setupProgramVertex:v Fragment:f];
}

- (void)setupProgramBackgroundYUVVertex:(NSString *)v Fragment:(NSString *)f;
{
    NSLog(@"RenderFramework do setupProgramBackgroundYUV");
    [m_renderBackgroundYUV setupProgramVertex:v Fragment:f];
}

- (void)setupProgramFaceMorphVertex:(NSString *)v Fragment:(NSString *)f;
{
    NSLog(@"RenderFramework do setupProgramFaceMorph");
    [m_renderFaceMorph setupProgramVertex:v Fragment:f];
}

- (void)setupProgramFaceUBeautifyVertex:(NSString *)v Fragment:(NSString *)f;
{
    NSLog(@"RenderFramework do setupProgramFaceUBeautify");
    [m_renderFaceUBeautify setupProgramVertex:v Fragment:f];
}

- (void)setupProgramSkinSmoothVertex:(NSString *)v Fragment:(NSString *)f;
{
    NSLog(@"RenderFramework do setupProgramSkinSmooth");
    [m_renderSkinSmooth setupProgramVertex:v Fragment:f];
}

- (void)setupProgramSkinColorAdjustingVertex:(NSString *)v Fragment:(NSString *)f;
{
    NSLog(@"RenderFramework do setupProgramSkinColorAdjusting");
    [m_renderSkinColorAjdusting setupProgramVertex:v Fragment:f];
}

- (void)setupProgramLastVertex:(NSString *)v Fragment:(NSString *)f;
{
    NSLog(@"RenderFramework do setupProgramLast");
    [m_renderLast setupProgramVertex:v Fragment:f];
}

- (void)setupProgramFilterVertex:(NSString *)v Fragment:(NSString *)f;
{
    NSLog(@"RenderFramework do setupProgramFilter");
}

- (void)setupVBO
{
}

- (void)setTrackerType:(int)type Data:(FPOINT *)points pointNum:(int)ptNumber faceNum:(int)faceNumber Width:(int)width Height:(int)height
{
    if (m_enableFaceMorph && m_renderFaceMorph) {
        [m_renderFaceMorph setTrackerData:points pointNum:ptNumber faceNum:faceNumber Width:width Height:height];
    }
    if (m_enableSkinColorAdjusting && m_renderSkinColorAjdusting) {
        [m_renderSkinColorAjdusting setTrackerData:points pointNum:ptNumber faceNum:faceNumber Width:width Height:height];
    }
}

- (void)setTextureRGBA:(GLTextureRGBA *)texture
{
    glPixelStorei(GL_UNPACK_ALIGNMENT, 1);
    m_rgbaTexture = (GLTextureRGBA *)texture;
    glBindTexture(GL_TEXTURE_2D, m_textureId);
    glTexSubImage2D(GL_TEXTURE_2D, 0, 0, 0, texture.width, texture.height,
                    GL_RGBA, GL_UNSIGNED_BYTE, m_rgbaTexture.RGBA);
}

- (void)setTextureYUV:(GLTextureYUV *)texture
{
    glPixelStorei(GL_UNPACK_ALIGNMENT, 1);
    m_yuvTexture = (GLTextureYUV *)texture;
    
    glBindTexture(GL_TEXTURE_2D, m_textureYId);
    glTexSubImage2D(GL_TEXTURE_2D, 0, 0, 0, m_yuvTexture.width, m_yuvTexture.height,
                    GL_LUMINANCE, GL_UNSIGNED_BYTE, m_yuvTexture.Y);
    glBindTexture(GL_TEXTURE_2D, 0);
    
    glBindTexture(GL_TEXTURE_2D, m_textureUVId);
    glTexSubImage2D(GL_TEXTURE_2D, 0, 0, 0, m_yuvTexture.width/2, m_yuvTexture.height/2,
                    GL_LUMINANCE_ALPHA, GL_UNSIGNED_BYTE, m_yuvTexture.UV);
    glBindTexture(GL_TEXTURE_2D, 0);
}

- (GLTextureRGBA *)getTexture
{
    return m_rgbaTexture;
}

- (GLTextureRGBA *)getOutputTexture
{
    GLuint texid = [m_renderLast getTextureId];
    GLTextureRGBA *texture = [[GLTextureRGBA alloc] init];
//    texture.RGBA = (uint8_t *)malloc(720*1280*4);
    texture.RGBA = new uint8_t[720*1280*4];
    glBindTexture(GL_TEXTURE_2D, texid);
    glReadPixels(0, 0, 720, 1280, GL_RGBA, GL_UNSIGNED_BYTE, texture.RGBA);
    return (GLTextureRGBA *)texture;
}

- (void)setTextureId:(GLuint)texId
{
    m_textureId = texId;
}

- (GLuint)getTextureId
{
    return m_textureId;
}

- (GLuint)getOutputTextureId
{
    return [m_renderLast getTextureId];
}

- (void)setFBOId:(GLuint)fboid
{
    m_fboID = fboid;
}

- (void)enableFaceMorph:(bool)enable {
    m_enableFaceMorph = enable;
}

- (void)enableSkinSmooth:(bool)enable {
    m_enableSkinSmooth = enable;
}

- (void)enableColorAdjusting:(bool)enable {
    m_enableSkinColorAdjusting = enable;
}

- (void)prepareRender
{
//    [m_renderBackground setTextureId:m_textureId];
//    [m_renderBackground prepareRender];
//    GLuint texid = [m_renderBackground getFBOTextureId];
    
    [m_renderBackgroundYUV setTextureIdYid:m_textureYId UVid:m_textureUVId];
    [m_renderBackgroundYUV prepareRender];
    GLuint texid = [m_renderBackgroundYUV getFBOTextureId];
    
    if (m_enableFaceMorph) {
        [m_renderFaceMorph setTextureId:texid];
        [m_renderFaceMorph prepareRender];
        texid = [m_renderFaceMorph getFBOTextureId];
    }
    
    if (m_enableFaceUBeautify) {
        [m_renderFaceUBeautify setTextureId:texid];
        [m_renderFaceUBeautify prepareRender];
        texid = [m_renderFaceUBeautify getFBOTextureId];
    }
    
    if (m_enableSkinSmooth) {
        [m_renderSkinSmooth setTextureId:texid];
        [m_renderSkinSmooth prepareRender];
        texid = [m_renderSkinSmooth getFBOTextureId];
    }
    
    if (m_enableSkinColorAdjusting) {
        [m_renderSkinColorAjdusting setTextureId:texid];
        [m_renderSkinColorAjdusting prepareRender];
        texid = [m_renderSkinColorAjdusting getFBOTextureId];
    }
    
    [m_renderLast setFBOId:m_fboID];
    [m_renderLast setTextureId:texid];
    [m_renderLast prepareRender];
}

- (void)afterRender
{
}
@end
