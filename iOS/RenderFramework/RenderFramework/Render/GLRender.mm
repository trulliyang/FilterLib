//
//  GLRender.m
//  RenderFramework
//
//  Created by yang.SHI on 2017/8/3.
//  Copyright © 2017年 appMagics. All rights reserved.
//

#import "GLRender.h"

@interface GLRender(){
}
@end

////////////////GLRender//////////////////////////
@implementation GLRender

- (void)setupGLProgram
{
    
}

- (void)setupProgramVertex:(NSString *)v Fragment:(NSString *)f;
{
}

- (void)setupVBO
{
}

- (void)setTrackerData:(FPOINT *)points pointNum:(int)ptNumber faceNum:(int)faceNumber Width:(int)width Height:(int)height
{
}

- (void)setTextureRGBA:(GLTextureRGBA *)texture
{
}

- (GLTextureRGBA *)getTexture
{
    return nil;
}

- (void)setTextureId:(GLuint)texId
{
}

- (GLuint)getTextureId
{
    return 0;
}

- (GLuint)getFBOId
{
    return 0;
}

- (GLuint)getFBOTextureId
{
    return 0;
}

- (void)prepareRender
{
}

- (void)afterRender
{
}
@end
