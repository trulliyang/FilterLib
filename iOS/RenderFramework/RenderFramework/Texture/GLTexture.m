//
//  GLTexture.m
//  RenderFramework
//
//  Created by yang.SHI on 2017/8/3.
//  Copyright © 2017年 appMagics. All rights reserved.
//

#import "GLTexture.h"

@implementation GLTexture
@end

@implementation GLTextureRGBA
- (void)dealloc
{
    if (_RGBA) {
        free(_RGBA);
        _RGBA = NULL;
    }
}
@end

@implementation GLTextureYUV
- (void)dealloc
{
    if (_Y) {
        free(_Y);
        _Y = NULL;
    }
    
    if (_UV) {
        free(_UV);
        _UV = NULL;
    }
}
@end
