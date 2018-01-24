//
//  GLRenderBackground.h
//  RenderFramework
//
//  Created by yang.SHI on 2017/8/8.
//  Copyright © 2017年 appMagics. All rights reserved.
//

#import "GLRender.h"

@interface GLRenderBackground : GLRender
@property (nonatomic, assign) GLuint dataType;


@property(nonatomic, assign, readonly) GLuint y;
@property(nonatomic, assign, readonly) GLuint u;
@property(nonatomic, assign, readonly) GLuint v;

- (void)setTrackerData:(FPOINT *)points pointNum:(int)ptNumber faceNum:(int)faceNumber Width:(int)width Height:(int)height;
- (void)setTextureRGBA:(GLTextureRGBA *)texture;
- (void)setTextureYUV:(GLTextureYUV *)texture;
- (void)setTextureId:(GLuint)texId;
- (GLTextureRGBA *)getTexture;
- (GLuint)getTextureId;
- (GLuint)getFBOId;
- (GLuint)getFBOTextureId;
- (void)prepareRender;
- (void)afterRender;
- (void)setupProgramVertex:(NSString *)v Fragment:(NSString *)f;

@end

