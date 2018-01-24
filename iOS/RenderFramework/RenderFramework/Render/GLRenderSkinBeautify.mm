//
//  GLRenderSkinBeautify.m
//  RenderFramework
//
//  Created by yang.SHI on 2017/8/9.
//  Copyright © 2017年 shiyang. All rights reserved.
//

#import "GLRenderSkinBeautify.h"
@interface GLRenderSkinBeautify() {
@public
    GLuint programID;
    GLuint textureID;
    GLuint vtxBufID;
    GLuint texBufID;
    GLuint idxBufID;
    
    GLint   width;
    GLint   height;
    GLfloat smooth;
    GLfloat redAvg;
    GLfloat greenAvg;
    GLfloat blueAvg;
    GLfloat colorR0[200];
    GLfloat colorR1[56];
    GLfloat colorG0[200];
    GLfloat colorG1[56];
    GLfloat colorB0[200];
    GLfloat colorB1[56];
    
    enum curveColor{
        CURVE_RED,
        CURVE_GREEN,
        CURVE_BLUE
    };
    
    GLFramebufferObject *fbo;
    GLuint fboID;
    
#define MIN_GAIN            4
#define MAX_GAIN            15
#define MIN2(a, b)          ((a > b) ? b : a)
#define MAX2(a, b)          ((a > b) ? a : b)
#define CLIP3(x, min, max)  ((x > min) ? (x < max ? x : max) : min)
}
@end

@implementation GLRenderSkinBeautify

- (instancetype)init
{
    if (self = [super init])
    {
        programID = 0;
        textureID = 0;
        vtxBufID = 0;
        texBufID = 0;
        idxBufID = 0;
        width = 1280;
        height = 720;
        smooth = 3.0f;
        redAvg = 0.0f;
        greenAvg = 0.0f;
        blueAvg = 0.0f;
        memset(colorR0, 0, sizeof(colorR0));
        memset(colorR1, 0, sizeof(colorR1));
        memset(colorG0, 0, sizeof(colorG0));
        memset(colorG1, 0, sizeof(colorG1));
        memset(colorB0, 0, sizeof(colorB0));
        memset(colorB1, 0, sizeof(colorB1));
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
    [self updateColorCurveRed:190 Green:145 Blue:125];
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

- (void)updateColorCurveRed:(int)red Green:(int)green Blue:(int)blue
{
    if (red != redAvg) {
        redAvg = red;
        [self getCurveColor:CURVE_RED avgBrightness:redAvg];
    }
    if (green != greenAvg) {
        greenAvg = green;
        [self getCurveColor:CURVE_GREEN avgBrightness:greenAvg];
    }
    if (blue != blueAvg) {
        blueAvg = blue;
        [self getCurveColor:CURVE_BLUE avgBrightness:blueAvg];
    }
    
}

- (void)getCurveColor:(curveColor)_curveColor avgBrightness:(int)average_brightness
{
    float m_gainAdjust = 1.0;
    //    if (CURVE_RED == _curveColor) {
    //        MA_LOG_ERROR("aaa shiyang red");
    //    } else if (CURVE_GREEN == _curveColor) {
    //        MA_LOG_ERROR("aaa shiyang green");
    //    } else if (CURVE_BLUE == _curveColor) {
    //        MA_LOG_ERROR("aaa shiyang blue");
    //    }
    int x1 = (int) (average_brightness * 0.3f);
    int x2 = (int) (average_brightness + (255 - average_brightness) * 0.5f);
    
    //    MA_LOG_ERROR("aaa shiyang x1=%d,x2=%d", x1, x2);
    
    int gain1 = (int) (x1 * 2.5);
    gain1 = MAX2(gain1, MIN_GAIN);
    
    int gain2 = (int) (gain1 * (1.1f + (255 - average_brightness) / 255.0f));
    gain2 = MIN2(gain2, MAX_GAIN);
    
    float a, b, c, target_curve[256];
    
    a = 4.0f * gain1 / (x1 * x1);
    b = 1.0f - a * x1;
    
    for(int i=0; i<x1; i++) {
        target_curve[i] = CLIP3((int)(a * i * i + b * i), 0, 255);
        target_curve[i] = ((1.0f-m_gainAdjust)*(float)i + m_gainAdjust*target_curve[i])/255.0f;
    }
    
    float dis = (x2 - x1) * 0.5f;
    a = gain2 / (dis * dis - gain2 * gain2);
    b = 1.0f - a * (x1 +x2);
    c = a * x1 * x2;
    target_curve[x1] = x1/255.0f;
    
    for(int i=x1 + 1; i<x2; i++) {
        int result = (int) ((sqrtf(b * b - 4.0f * a * (c - i)) - b) / (2.0f * a) + 0.5f);
        target_curve[i] = (float)CLIP3(result, 0, 255);
        target_curve[i] = ((1.0f-m_gainAdjust)*(float)i + m_gainAdjust*target_curve[i])/255.0f;
    }
    
    for(int i = x2; i<256; i++) {
        target_curve[i] = (float)i/255.0f;
    }
    
    
    //    for(int i = 0; i<256; i++) {
    //        MA_LOG_ERROR("aaa shiyang %d char is :%f", i, target_curve[i]*255.0);
    //    }
    
    if (CURVE_RED == _curveColor) {
        memcpy(colorR0, &target_curve[0], sizeof(float)*200);
        memcpy(colorR1, &target_curve[200], sizeof(float)*56);
        //        for(int i = 0; i<200; i++) {
        //            float dt = m_curveR0[i]*255.0f - target_curve[i]*255.0f;
        //            MA_LOG_ERROR("aaa shiyang %d char is :%f R0, tar :%f, dt :%f", i, m_curveR0[i]*255.0, target_curve[i]*255.0, dt);
        //        }
        //        for(int i = 0; i<56; i++) {
        //            float dt = m_curveR1[i]*255.0f - target_curve[i+200]*255.0f;
        //            MA_LOG_ERROR("aaa shiyang %d char is :%f R1, tar :%f, dt :%f", i+200, m_curveR1[i]*255.0, target_curve[i+200]*255.0, dt);
        //        }
    } else if (CURVE_GREEN == _curveColor) {
        memcpy(colorG0, &target_curve[0], sizeof(float)*200);
        memcpy(colorG1, &target_curve[200], sizeof(float)*56);
        //        for(int i = 0; i<200; i++) {
        //            float dt = m_curveG0[i]*255.0f - target_curve[i]*255.0f;
        //            MA_LOG_ERROR("aaa shiyang %d char is :%f G0, tar :%f, dt :%f", i, m_curveG0[i]*255.0, target_curve[i]*255.0, dt);
        //        }
        //        for(int i = 0; i<56; i++) {
        //            float dt = m_curveG1[i]*255.0f - target_curve[i+200]*255.0f;
        //            MA_LOG_ERROR("aaa shiyang %d char is :%f G1, tar :%f, dt :%f", i+200, m_curveG1[i]*255.0, target_curve[i+200]*255.0, dt);
        //        }
    } else if (CURVE_BLUE == _curveColor) {
        memcpy(colorB0, &target_curve[0], sizeof(float)*200);
        memcpy(colorB1, &target_curve[200], sizeof(float)*56);
        //        for(int i = 0; i<200; i++) {
        //            float dt = m_curveB0[i]*255.0f - target_curve[i]*255.0f;
        //            MA_LOG_ERROR("aaa shiyang %d char is :%f B0, tar :%f, dt :%f", i, m_curveB0[i]*255.0, target_curve[i]*255.0, dt);
        //        }
        //        for(int i = 0; i<56; i++) {
        //            float dt = m_curveB1[i]*255.0f - target_curve[i+200]*255.0f;
        //            MA_LOG_ERROR("aaa shiyang %d char is :%f B1, tar :%f, dt :%f", i+200, m_curveB1[i]*255.0, target_curve[i+200]*255.0, dt);
        //        }
    }
    
    return;
}



- (void)updateUniform
{
    glUniform1f(glGetUniformLocation(programID, "mvSmoothSize"), smooth);
    glUniform1i(glGetUniformLocation(programID, "width"), width);
    glUniform1i(glGetUniformLocation(programID, "height"), height);
    glUniform1fv(glGetUniformLocation(programID, "curveR0"), 200, colorR0);
    glUniform1fv(glGetUniformLocation(programID, "curveR1"), 56, colorR1);
    glUniform1fv(glGetUniformLocation(programID, "curveG0"), 200, colorG0);
    glUniform1fv(glGetUniformLocation(programID, "curveG1"), 56, colorG1);
    glUniform1fv(glGetUniformLocation(programID, "curveB0"), 200, colorB0);
    glUniform1fv(glGetUniformLocation(programID, "curveB1"), 56, colorB1);
}

- (void)prepareRender
{
    if (0 == textureID)
    {
        NSLog(@"GLRenderSkinBeautify do prepareRender no texture to render");
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
    NSLog(@"GLRenderSkinBeautify do setupProgram shader id = %d", programID);
//    glUseProgram(programID);
    
}

@end
