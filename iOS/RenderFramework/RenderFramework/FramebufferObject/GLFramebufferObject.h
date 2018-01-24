//
//  GLFramebufferObject.h
//  RenderFramework
//
//  Created by yang.SHI on 2017/8/10.
//  Copyright © 2017年 appMagics. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GLUtil.h"

@interface GLFramebufferObject : NSObject
- (GLuint)createFramebuffer;
- (void)destroyFramebuffer;
- (GLuint)getFBOID;
- (GLuint)getFBOTextureID;
@end

