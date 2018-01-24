//
//  GLRenderBackgroundYUV.h
//  RenderFramework
//
//  Created by yang.SHI on 2017/8/28.
//  Copyright © 2017年 appMagics. All rights reserved.
//

#import "GLRender.h"

@interface GLRenderBackgroundYUV : GLRender

- (void)setTrackerData:(FPOINT *)points pointNum:(int)ptNumber faceNum:(int)faceNumber Width:(int)width Height:(int)height;
- (void)setTextureYUV:(GLTextureYUV *)texture;
- (void)setTextureIdYid:(GLuint)texYId UVid:(GLuint)texUVId;
- (GLuint)getTextureId;
- (GLuint)getFBOId;
- (GLuint)getFBOTextureId;
- (void)prepareRender;
- (void)afterRender;
- (void)setupProgramVertex:(NSString *)v Fragment:(NSString *)f;

@end

