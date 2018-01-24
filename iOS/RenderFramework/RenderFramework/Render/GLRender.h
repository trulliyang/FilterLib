//
//  GLRender.h
//  RenderFramework
//
//  Created by yang.SHI on 2017/8/3.
//  Copyright © 2017年 appMagics. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLTexture.h"
#import "GLUtil.h"
#import "GLFramebufferObject.h"

@interface GLRender : NSObject

- (void)setTrackerData:(FPOINT *)points pointNum:(int)ptNumber faceNum:(int)faceNumber Width:(int)width Height:(int)height;
- (void)setTextureRGBA:(GLTextureRGBA *)texture;
- (void)setTextureId:(GLuint)texId;
- (GLTextureRGBA *)getTexture;
- (GLuint)getTextureId;
- (GLuint)getFBOId;
- (GLuint)getFBOTextureId;
- (void)prepareRender;
- (void)afterRender;
- (void)setupProgramVertex:(NSString *)v Fragment:(NSString *)f;
@end
