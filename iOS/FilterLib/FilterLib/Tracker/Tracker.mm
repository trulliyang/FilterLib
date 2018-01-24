//
//  Tracker.m
//  FilterLib
//
//  Created by yang.SHI on 2017/7/28.
//  Copyright © 2017年 appMagics. All rights reserved.
//

#import "Tracker.h"

@implementation Tracker{
    MHandle m_trackerHandle;
}
- (id)init {
    self = [super init];
    if (self) {
        
        [self initTracker];
        
    }
    return self;
}

- (void)initTracker{
    
    m_trackerHandle = ASL_CreateEngine();
    NSBundle *mainBundle=[NSBundle mainBundle];
    NSString *path = [mainBundle pathForResource:@"track_data" ofType:@"dat"];
    MRESULT hRet = ASL_Initialize(m_trackerHandle,
                                  [path UTF8String],
                                  ASL_MAX_FACE_NUM,
                                  MNull,MNull);
    if(hRet == MOK)
    {
        ASL_SetProcessModel(m_trackerHandle,ASL_PROCESS_MODEL_FACEOUTLINE |ASL_PROCESS_MODEL_FACEBEAUTY);//|ASL_PROCESS_MODEL_FACEBEAUTY
        //        ASL_SetProcessModel(m_hEngine,ASL_PROCESS_MODEL_FACEOUTLINE);
        ASL_SetFaceSkinSoftenLevel(m_trackerHandle,100);
        ASL_SetFaceBrightLevel(m_trackerHandle,100);
    }
    
}

- (int)processSampleBuffer:(LPYUVFrame)yuvData Points:(MPOINT *)points{
    FMPixelFormat format = yuvData->inputFormat;
    int videoWidth = yuvData->width;
    int videoHeight = yuvData->height;
    MInt32 nFaceCountInOut = ASL_MAX_FACE_NUM;
    MRECT rcFaceRectOut[ASL_MAX_FACE_NUM];
    MFloat faceOrientOut[ASL_MAX_FACE_NUM * 3];
    
    ASVLOFFSCREEN OffScreenIn = {0};
    if (format == FMPixelFormatYUV420V) {
        UInt8 *yBuffer = yuvData->plane[0];
        UInt8 *uvBuffer = yuvData->plane[1];
        OffScreenIn.u32PixelArrayFormat = ASVL_PAF_NV12;
        OffScreenIn.i32Width = videoWidth;
        OffScreenIn.i32Height = videoHeight;
        OffScreenIn.pi32Pitch[0] = OffScreenIn.i32Width;
        OffScreenIn.pi32Pitch[1] = OffScreenIn.i32Width;
        OffScreenIn.ppu8Plane[0] = yBuffer;
        OffScreenIn.ppu8Plane[1] = uvBuffer;
    } else if (format == FMPixelFormatBGRA) {
        UInt8 *yBuffer = yuvData->plane[0];
        OffScreenIn.u32PixelArrayFormat = ASVL_PAF_RGB32_B8G8R8A8;
        OffScreenIn.i32Width = videoWidth;
        OffScreenIn.i32Height = videoHeight;
        OffScreenIn.pi32Pitch[0] = OffScreenIn.i32Width*4;
        OffScreenIn.ppu8Plane[0] = yBuffer;
    }
    
    MRESULT hr = ASL_Process(m_trackerHandle,
                             &OffScreenIn,
                             &OffScreenIn,
                             &nFaceCountInOut,
                             points,
                             rcFaceRectOut,
                             faceOrientOut
                             );
    
    int ret = 0;
    if(hr == MOK)
    {
        ret = nFaceCountInOut;
    } else {
        printf("error, tracking has problem\n");
    }
    return ret;
}
@end
