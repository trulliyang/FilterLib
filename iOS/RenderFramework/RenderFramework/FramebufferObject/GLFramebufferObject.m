//
//  GLFramebufferObject.m
//  RenderFramework
//
//  Created by yang.SHI on 2017/8/10.
//  Copyright © 2017年 appMagics. All rights reserved.
//

#import "GLFramebufferObject.h"

@interface GLFramebufferObject() {
    @public
    GLuint fboID;
    GLuint fboTextureID;
}
@end

@implementation GLFramebufferObject

- (instancetype)init
{
    if (self = [super init])
    {
        fboID = 0;
        fboTextureID = 0;
        [self createFramebuffer];
    }
    return self;
}

- (GLuint)createFramebuffer
{
    fboTextureID = createTexture2D(GL_RGBA, 720, 1280, NULL);
    
    glGenFramebuffers(1, &fboID);
    glBindFramebuffer(GL_FRAMEBUFFER, fboID);
    glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, fboTextureID, 0);
    if (glCheckFramebufferStatus(GL_FRAMEBUFFER) != GL_FRAMEBUFFER_COMPLETE) {
        NSLog(@"GenFramebuffer failed");
        return 0;
    }
    return fboID;
}

- (void)destroyFramebuffer
{
    if (fboID > 0) {
        glDeleteFramebuffers(1, &fboID);
    }
    if (fboTextureID > 0) {
        glDeleteTextures(1, &fboTextureID);
    }
}

- (GLuint)getFBOID
{
    return fboID;
}

- (GLuint)getFBOTextureID
{
    return fboTextureID;
}
@end
