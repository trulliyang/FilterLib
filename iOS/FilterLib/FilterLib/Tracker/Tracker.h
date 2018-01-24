//
//  Tracker.h
//  FilterLib
//
//  Created by yang.SHI on 2017/7/28.
//  Copyright © 2017年 appMagics. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "amcomdef.h"
#include "arcsoft_spotlight.h"

typedef enum
{
    TRACKER_ARCSOFT = 0,
    TRACKER_SENSETIME = 1,
    TRACKER_FACEPP = 1,
    TRACKER_SELF = 2
} TRACKERTYPE;

typedef enum
{
    FMPixelFormatRGBA = 0,              //kCVPixelFormatType_32RGBA
    FMPixelFormatBGRA,              //kCVPixelFormatType_32BGRA
    FMPixelFormatYUV420V                 // kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange
} FMPixelFormat;

typedef struct tagYUVFrame
{
    FMPixelFormat   inputFormat;
    
    FMPixelFormat   outputFormat;
    int32_t    width;
    
    int32_t    height;
    
    uint8_t*   plane[4];
    
    int32_t    stride[4];
    
} GASYUVFrame, *LPYUVFrame;

@interface Tracker : NSObject
- (int)processSampleBuffer:(LPYUVFrame)yuvData Points:(MPOINT *)points;
@end

