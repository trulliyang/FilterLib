//
//  GLTexture.h
//  RenderFramework
//
//  Created by yang.SHI on 2017/8/3.
//  Copyright © 2017年 appMagics. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GLTexture : NSObject
@property (assign, nonatomic) int width;
@property (assign, nonatomic) int height;
@end

@interface GLTextureRGBA : GLTexture
@property (nonatomic, assign) uint8_t *RGBA;
@end

@interface GLTextureYUV : GLTexture
@property (nonatomic, assign) uint8_t *Y;
@property (nonatomic, assign) uint8_t *UV;
@end
