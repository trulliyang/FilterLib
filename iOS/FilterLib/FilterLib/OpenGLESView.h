//
//  OpenGLESView.h
//  FilterLib
//
//  Created by yang.SHI on 2017/7/28.
//  Copyright © 2017年 appMagics. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tracker.h"
#import <RenderFramework/GLRenderSys.h>

@interface OpenGLESView : UIView
@property (nonatomic, strong) GLRenderSys *rendersys;
- (void)initRenderer;
- (void)setupContext;
- (void)setNeedDraw;
- (void)setSizeWidth:(int)w Height:(int)h;
- (void)setTrackerType:(int)type Data:(MPOINT *)points pointNum:(int)ptNumber faceNum:(int)faceNumber Width:(int)width Height:(int)height;
- (void)setRender:(GLRenderSys *)render;
- (void)setTextureRGBA:(GLTextureRGBA *)texture;
- (void)setTextureYUV:(GLTextureYUV *)texture;
- (void)setTextureId:(GLuint)texId;
- (GLuint)getTextureId;
- (GLTextureRGBA *)getTextureImg;
- (void)enableFaceMorph:(bool)enable;
- (void)enableFaceUBeautify:(bool)enable;
- (void)enableSkinSmooth:(bool)enable;
- (void)enableColorAdjusting:(bool)enable;
@end
