//
//  GLRenderLast.h
//  RenderFramework
//
//  Created by yang.SHI on 2017/8/11.
//  Copyright © 2017年 appMagics. All rights reserved.
//

#import "GLRender.h"

@interface GLRenderLast : GLRender

- (void)setTrackerData:(FPOINT *)points pointNum:(int)ptNumber faceNum:(int)faceNumber Width:(int)width Height:(int)height;
- (void)setTextureRGBA:(GLTextureRGBA *)texture;
- (void)setTextureId:(GLuint)texId;
- (GLTextureRGBA *)getTexture;
- (GLuint)getTextureId;
- (void)setFBOId:(GLuint)fboid;
//- (GLuint)getFBOId;
//- (GLuint)getFBOTextureId;
- (void)prepareRender;
- (void)afterRender;
- (void)setupProgramVertex:(NSString *)v Fragment:(NSString *)f;

@end

