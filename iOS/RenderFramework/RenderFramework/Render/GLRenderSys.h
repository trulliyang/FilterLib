//
//  GLRenderSys.h
//  RenderFramework
//
//  Created by yang.SHI on 2017/8/9.
//  Copyright © 2017年 appMagics. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLRenderBackground.h"
#import "GLRenderBackgroundYUV.h"
#import "GLRenderFaceMorph.h"
#import "GLRenderFaceUBeautify.h"
#import "GLRenderSkinSmooth.h"
#import "GLRenderSkinColorAdjusting.h"
#import "GLRenderLast.h"

@interface GLRenderSys : NSObject

typedef enum INPUTOUTPUTTYPE{
    RGBA_DATA = 0,
    YUVNV12_DATA,
    RGBA_TEXTURE_ID,
    YUVNV12_TEXTURE_ID
}INOUTTYPE;

- (void)setSizeWidth:(int)w Height:(int)h;
- (void)setInputType:(INOUTTYPE)type;
- (void)setOutputType:(INOUTTYPE)type;
- (void)initRenderer;
- (void)setContext;
- (EAGLContext *)getContext;
- (void)setTrackerType:(int)type Data:(FPOINT *)points pointNum:(int)ptNumber faceNum:(int)faceNumber Width:(int)width Height:(int)height;
- (void)setTextureRGBA:(GLTextureRGBA *)texture;
- (void)setTextureYUV:(GLTextureYUV *)texture;
- (void)setTextureId:(GLuint)texId;
- (GLTextureRGBA *)getTexture;
- (GLuint)getTextureId;
- (GLTextureRGBA *)getOutputTexture;
- (GLuint)getOutputTextureId;
- (void)setFBOId:(GLuint)fboid;
- (void)enableFaceMorph:(bool)enable;
- (void)enableFaceUBeautify:(bool)enable;
- (void)enableSkinSmooth:(bool)enable;
- (void)enableColorAdjusting:(bool)enable;
- (void)prepareRender;
- (void)afterRender;
- (void)setupProgramBackgroundVertex:(NSString *)vertex Fragment:(NSString *)fragment;
- (void)setupProgramBackgroundYUVVertex:(NSString *)vertex Fragment:(NSString *)fragment;
- (void)setupProgramFaceMorphVertex:(NSString *)vertex Fragment:(NSString *)fragment;
- (void)setupProgramFaceUBeautifyVertex:(NSString *)vertex Fragment:(NSString *)fragment;
- (void)setupProgramSkinSmoothVertex:(NSString *)vertex Fragment:(NSString *)fragment;
- (void)setupProgramSkinColorAdjustingVertex:(NSString *)vertex Fragment:(NSString *)fragment;
- (void)setupProgramLastVertex:(NSString *)vertex Fragment:(NSString *)fragment;
@end
