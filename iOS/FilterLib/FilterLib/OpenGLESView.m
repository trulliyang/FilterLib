//
//  OpenGLESView.m
//  FilterLib
//
//  Created by yang.SHI on 2017/7/28.
//  Copyright © 2017年 appMagics. All rights reserved.
//

#import "OpenGLESView.h"
#import <OpenGLES/ES2/gl.h>

@interface OpenGLESView ()
{
    CAEAGLLayer     *_eaglLayer;
    EAGLContext     *_context;
    GLuint          _colorRenderBuffer;
    GLuint          _frameBuffer;

    GLRenderSys        *_rendersys;
    
    GLTextureRGBA   *_textureRGBA;
    GLuint          _textureId;
    int             _width;
    int             _height;
}
@end

@implementation OpenGLESView

+ (Class)layerClass
{
    // 只有 [CAEAGLLayer class] 类型的 layer 才支持在其上描绘 OpenGL 内容。
    return [CAEAGLLayer class];
}

- (void)dealloc
{
    
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupLayer];
        NSLog(@"w=%f, h=%f", frame.size.width, frame.size.height);
//        [self setupContext];
    }
    return self;
}

- (void)layoutSubviews
{
    NSLog(@"layoutSubviews");
    
    [EAGLContext setCurrentContext:_context];
    
    [self destoryRenderAndFrameBuffer];
    
    [self setupFrameAndRenderBuffer];
}


#pragma mark - Setup
- (void)setupLayer
{
    _eaglLayer = (CAEAGLLayer*) self.layer;
    
    // CALayer 默认是透明的，必须将它设为不透明才能让其可见
    _eaglLayer.opaque = YES;
    
    // 设置描绘属性，在这里设置不维持渲染内容以及颜色格式为 RGBA8
    _eaglLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:
                                     [NSNumber numberWithBool:NO], kEAGLDrawablePropertyRetainedBacking, kEAGLColorFormatRGBA8, kEAGLDrawablePropertyColorFormat, nil];
}

- (void)initRenderer
{
    [_rendersys setSizeWidth:_width Height:_height];
    [_rendersys initRenderer];
}

- (void)setupContext
{
    NSLog(@"setupContext");
    _context = [_rendersys getContext];
    if (!_context) {
        NSLog(@"OpenGLESView setupContext failed, context = nil");
    }
    
//    // 设置OpenGLES的版本为2.0 当然还可以选择1.0和最新的3.0的版本，以后我们会讲到2.0与3.0的差异，目前为了兼容性选择2.0的版本
//    _context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
//    if (!_context) {
//        NSLog(@"Failed to initialize OpenGLES 2.0 context");
//        exit(1);
//    }
//    
//    // 将当前上下文设置为我们创建的上下文
//    if (![EAGLContext setCurrentContext:_context]) {
//        NSLog(@"Failed to set current OpenGL context");
//        exit(1);
//    }
}

- (void)setSizeWidth:(int)w Height:(int)h
{
    _width = w;
    _height = h;
}

- (void)setupFrameAndRenderBuffer
{
    glGenRenderbuffers(1, &_colorRenderBuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, _colorRenderBuffer);
    // 为 color renderbuffer 分配存储空间
    [_context renderbufferStorage:GL_RENDERBUFFER fromDrawable:_eaglLayer];
    
    glGenFramebuffers(1, &_frameBuffer);
    // 设置为当前 framebuffer
    glBindFramebuffer(GL_FRAMEBUFFER, _frameBuffer);
    // 将 _colorRenderBuffer 装配到 GL_COLOR_ATTACHMENT0 这个装配点上
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, _colorRenderBuffer);
}

#pragma mark - Clean
- (void)destoryRenderAndFrameBuffer
{
    glDeleteFramebuffers(1, &_frameBuffer);
    _frameBuffer = 0;
    glDeleteRenderbuffers(1, &_colorRenderBuffer);
    _colorRenderBuffer = 0;
}

#pragma mark - Render
- (void)draw
{
    glClearColor(0.0, 0.0, 1.0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT);
    
//    glViewport(0, 0, self.frame.size.width, self.frame.size.height);
//    NSLog(@"frame w=%f,h=%f", self.frame.size.width, self.frame.size.height);
    
    // 绘制
    [_rendersys prepareRender];
    
//    NSLog(@"_frameBuffer=%d",_frameBuffer);
    
//    glBindFramebuffer(GL_FRAMEBUFFER, _frameBuffer);
    //将指定 renderbuffer 呈现在屏幕上，在这里我们指定的是前面已经绑定为当前 renderbuffer 的那个，在 renderbuffer 可以被呈现之前，必须调用renderbufferStorage:fromDrawable: 为之分配存储空间。
    [_context presentRenderbuffer:GL_RENDERBUFFER];
    
    [_rendersys afterRender];
}

#pragma mark - PublicMethod
- (void)setRender:(GLRenderSys *)render
{
    _rendersys = render;
}

- (void)setTextureRGBA:(GLTextureRGBA *)texture
{
    [_rendersys setTextureRGBA:texture];
}

- (void)setTextureYUV:(GLTextureYUV *)texture
{
    [_rendersys setTextureYUV:texture];
}

- (void)setTextureId:(GLuint)texId
{
    [_rendersys setTextureId:texId];
}

- (void)setNeedDraw
{
    [_rendersys setFBOId:_frameBuffer];
    [self draw];
}

- (void)setTrackerType:(int)type Data:(MPOINT *)points pointNum:(int)ptNumber faceNum:(int)faceNumber Width:(int)width Height:(int)height;
{
    [_rendersys setTrackerType:type Data:(FPOINT *)points pointNum:ptNumber faceNum:faceNumber Width:width Height:height];
}

- (GLuint)getTextureId
{
    _textureId = [_rendersys getOutputTextureId];
    return _textureId;
}

- (GLTextureRGBA *)getTextureImg
{
    _textureRGBA = [_rendersys getOutputTexture];
    return _textureRGBA;
}

- (void)enableFaceMorph:(bool)enable {
    [_rendersys enableFaceMorph:enable];
}

- (void)enableFaceUBeautify:(bool)enable {
    [_rendersys enableFaceUBeautify:enable];
}

- (void)enableSkinSmooth:(bool)enable {
    [_rendersys enableSkinSmooth:enable];
}

- (void)enableColorAdjusting:(bool)enable {
    [_rendersys enableColorAdjusting:enable];
}

@end
