//
//  ViewController.m
//  FilterLib
//
//  Created by yang.SHI on 2017/7/28.
//  Copyright © 2017年 appMagics. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "OpenGLESView.h"
#import <mach/mach.h>

//#define FILTERLIB_PROFILING
//#define TRACKING

@interface ViewController () <AVCaptureVideoDataOutputSampleBufferDelegate>{
    Tracker *tracker;
    OpenGLESView *glView;
    UIButton *btn3;
    UIButton *btn4;
    UIButton *btn5;
    

#ifdef FILTERLIB_PROFILING
    float cpu_usage_sum;
    int cpu_usage_count;
    float cpu_usage_max;
    
    float ram_usage_sum;
    int ram_usage_count;
    float ram_usage_max;
    
    float function_usage_sum[4];
    int function_usage_count[4];
    float function_usage_max[4];
#endif
    
}

@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureDeviceInput *videoInput;
@property (nonatomic, strong) AVCaptureVideoDataOutput *videoOutput;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
#ifdef FILTERLIB_PROFILING
    cpu_usage_sum = 0.0f;
    cpu_usage_count = 0;
    cpu_usage_max = 0.0f;
    
    ram_usage_sum = 0.0f;
    ram_usage_count = 0;
    ram_usage_max = 0.0f;
    
    function_usage_sum[0] = 0.0f;
    function_usage_count[0] = 0;
    function_usage_max[0] = 0.0f;
    
    function_usage_sum[1] = 0.0f;
    function_usage_count[1] = 0;
    function_usage_max[1] = 0.0f;
    
    function_usage_sum[2] = 0.0f;
    function_usage_count[2] = 0;
    function_usage_max[2] = 0.0f;
    
    function_usage_sum[3] = 0.0f;
    function_usage_count[3] = 0;
    function_usage_max[3] = 0.0f;
#endif

#ifdef TRACKING
    tracker = [[Tracker alloc] init];
#endif
    GLRenderSys *rendersys = [[GLRenderSys alloc] init];
    [rendersys setInputType:YUVNV12_DATA];
    [rendersys setOutputType:RGBA_DATA];
    
    CGRect rect = CGRectMake(0, 0, 720, 1280);
    
    glView = [[OpenGLESView alloc] initWithFrame:rect];
    [glView setSizeWidth:720 Height:1280];
    [glView setRender:rendersys];
    [glView setupContext];
    [glView initRenderer];
    
    self.view = glView;
    NSLog(@"ready to setup shader");
    
    NSString *vertFile = [[NSBundle mainBundle] pathForResource:@"vert.glsl" ofType:nil];
    NSString *fragFile = [[NSBundle mainBundle] pathForResource:@"frag_yuv.glsl" ofType:nil];
    [rendersys setupProgramBackgroundYUVVertex:vertFile Fragment:fragFile];
    
    NSString *vertFileFaceMorph = [[NSBundle mainBundle] pathForResource:@"vert.glsl" ofType:nil];
    NSString *fragFileFaceMorph = [[NSBundle mainBundle] pathForResource:@"frag_rgb.glsl" ofType:nil];
    [rendersys setupProgramFaceMorphVertex:vertFileFaceMorph Fragment:fragFileFaceMorph];
    
    NSString *vertFileSkinSmooth = [[NSBundle mainBundle] pathForResource:@"vert.glsl" ofType:nil];
    NSString *fragFileSkinSmooth = [[NSBundle mainBundle] pathForResource:@"frag_skinSmooth.glsl" ofType:nil];
    [rendersys setupProgramSkinSmoothVertex:vertFileSkinSmooth Fragment:fragFileSkinSmooth];
    
    
    NSString *vertFileFaceUBeautify = [[NSBundle mainBundle] pathForResource:@"vert_faceBeautify.glsl" ofType:nil];
    NSString *fragFileFaceUBeautify = [[NSBundle mainBundle] pathForResource:@"frag_faceBeautify.glsl" ofType:nil];
    
    [rendersys setupProgramFaceUBeautifyVertex:vertFileFaceUBeautify Fragment:fragFileFaceUBeautify];
    
    NSString *vertFileSkinColorAdjusting = [[NSBundle mainBundle] pathForResource:@"vert.glsl" ofType:nil];
    NSString *fragFileSkinColorAdjusting = [[NSBundle mainBundle] pathForResource:@"frag_skinColorAdjusting.glsl" ofType:nil];
    [rendersys setupProgramSkinColorAdjustingVertex:vertFileSkinColorAdjusting Fragment:fragFileSkinColorAdjusting];
    
    NSString *vertFileLast = [[NSBundle mainBundle] pathForResource:@"vert.glsl" ofType:nil];
    NSString *fragFileLast = [[NSBundle mainBundle] pathForResource:@"frag_rgb.glsl" ofType:nil];
    [rendersys setupProgramLastVertex:vertFileLast Fragment:fragFileLast];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 60, 120, 30)];
    [btn addTarget:self action:@selector(startBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"开始" forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor greenColor]];
    [self.view addSubview:btn];
    
    UIButton *btn2 = [[UIButton alloc] initWithFrame:CGRectMake(200, 60, 120, 30)];
    [btn2 addTarget:self action:@selector(stopBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [btn2 setTitle:@"结束" forState:UIControlStateNormal];
    [btn2 setBackgroundColor:[UIColor greenColor]];
    [self.view addSubview:btn2];
    
//    btn3 = [[UIButton alloc] initWithFrame:CGRectMake(0, 160, 120, 30)];
//    [btn3 addTarget:self action:@selector(enableFaceMorphBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    [btn3 setTitle:@"开启瘦脸" forState:UIControlStateNormal];
//    [btn3 setBackgroundColor:[UIColor greenColor]];
//    [self.view addSubview:btn3];
//    
//    btn4 = [[UIButton alloc] initWithFrame:CGRectMake(0, 260, 120, 30)];
//    [btn4 addTarget:self action:@selector(enableSkinSmoothBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    [btn4 setTitle:@"开启磨皮" forState:UIControlStateNormal];
//    [btn4 setBackgroundColor:[UIColor greenColor]];
//    [self.view addSubview:btn4];
//    
//    btn5 = [[UIButton alloc] initWithFrame:CGRectMake(0, 360, 120, 30)];
//    [btn5 addTarget:self action:@selector(enableColorAdjustingBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    [btn5 setTitle:@"开启肤色调整" forState:UIControlStateNormal];
//    [btn5 setBackgroundColor:[UIColor greenColor]];
//    [self.view addSubview:btn5];
    
    [self setupSession];
}

- (void)setupSession
{
    _captureSession = [[AVCaptureSession alloc] init];
    [_captureSession beginConfiguration];
    
    // 设置换面尺寸
//    [_captureSession setSessionPreset:AVCaptureSessionPresetiFrame1280x720];
        [_captureSession setSessionPreset:AVCaptureSessionPreset1280x720];
    
    // 设置输入设备
    AVCaptureDevice *inputCamera = nil;
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices)
    {
        if ([device position] == AVCaptureDevicePositionFront)
        {
            inputCamera = device;
        }
    }
    
    if (!inputCamera) {
        return;
    }
    
    NSError *error = nil;
    _videoInput = [[AVCaptureDeviceInput alloc] initWithDevice:inputCamera error:&error];
    if ([_captureSession canAddInput:_videoInput])
    {
        [_captureSession addInput:_videoInput];
    }
    
    // 设置输出数据
    _videoOutput = [[AVCaptureVideoDataOutput alloc] init];
    [_videoOutput setAlwaysDiscardsLateVideoFrames:YES];
    
    [_videoOutput setVideoSettings:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange] forKey:(id)kCVPixelBufferPixelFormatTypeKey]];
    [_videoOutput setSampleBufferDelegate:self queue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];

    if ([_captureSession canAddOutput:_videoOutput]) {
        [_captureSession addOutput:_videoOutput];
    }
    
    AVCaptureConnection *captureConnection = [_videoOutput connectionWithMediaType:AVMediaTypeVideo];
    if ([captureConnection isVideoMinFrameDurationSupported]) {
        
        captureConnection.videoMinFrameDuration = CMTimeMake(1, 60);
        
    }
    
    
    
    if ([captureConnection isVideoOrientationSupported])
    {
//        AVCaptureVideoOrientation orientation = AVCaptureVideoOrientationPortrait;
        AVCaptureVideoOrientation orientation = AVCaptureVideoOrientationPortraitUpsideDown;
        [captureConnection setVideoOrientation:orientation];
        [captureConnection setVideoMirrored:NO];
    }
    
    [_captureSession commitConfiguration];
}

// 视频格式为：kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange或kCVPixelFormatType_420YpCbCr8BiPlanarFullRange
- (void)processVideoSampleBufferToYUV:(CMSampleBufferRef)sampleBuffer
{
    //CFAbsoluteTime startTime = CFAbsoluteTimeGetCurrent();
    CVImageBufferRef pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    
    //表示开始操作数据
    CVPixelBufferLockBaseAddress(pixelBuffer, 0);
    
    int pixelWidth = (int) CVPixelBufferGetWidth(pixelBuffer);
    int pixelHeight = (int) CVPixelBufferGetHeight(pixelBuffer);
    
    GLTextureYUV *yuv = [[GLTextureYUV alloc] init];
    yuv.width = pixelWidth;
    yuv.height = pixelHeight;
    
//    size_t count = CVPixelBufferGetPlaneCount(pixelBuffer);
    //获取CVImageBufferRef中的y数据
    
    uint8_t *y_frame = CVPixelBufferGetBaseAddressOfPlane(pixelBuffer, 0);
    size_t y_size = pixelWidth * pixelHeight;
    yuv.Y = malloc(y_size);
    memcpy(yuv.Y, y_frame, y_size);

    // UV数据
    uint8_t *uv_frame = CVPixelBufferGetBaseAddressOfPlane(pixelBuffer, 1);
    size_t uv_size = y_size/2;
    yuv.UV = malloc(uv_size);
    memcpy(yuv.UV, uv_frame, uv_size);
    
#ifdef TRACKING
    int ptNumber = ASL_GetFaceOutlinePointCount();
    MPOINT *points = malloc(ASL_MAX_FACE_NUM * ptNumber*2);
    int faceNumber = 0;
    GASYUVFrame yuvFrame;
    yuvFrame.plane[0] = y_frame;
    yuvFrame.plane[1] = uv_frame;
    yuvFrame.inputFormat = FMPixelFormatYUV420V;
    yuvFrame.outputFormat = FMPixelFormatYUV420V;
    yuvFrame.width = pixelWidth;
    yuvFrame.height = pixelHeight;
#ifdef FILTERLIB_PROFILING
    NSDate* tmpStartData2 = [NSDate date];
    //You code here...
#endif
    faceNumber = [tracker processSampleBuffer:&yuvFrame Points:points];
#ifdef FILTERLIB_PROFILING
    double deltaTime2 = [[NSDate date] timeIntervalSinceDate:tmpStartData2];
    if (function_usage_max[2] < deltaTime2) {
        function_usage_max[2] = deltaTime2;
    }
    function_usage_sum[2] += deltaTime2;
    function_usage_count[2]++;
    if (function_usage_count[2] == 1000) {
        NSLog(@"FilterLib function processSampleBuffer usage avg=%fms, max=%fms",
                1000.0f*function_usage_sum[2]/(float)function_usage_count[2],
                1000.0f*function_usage_max[2]);
        function_usage_sum[2] = 0.0f;
        function_usage_count[2] = 0;
        function_usage_max[2] = 0.0f;
    }
#endif
#endif

    dispatch_async(dispatch_get_main_queue(), ^{
#ifdef FILTERLIB_PROFILING
        NSDate* tmpStartData3 = [NSDate date];
        //You code here...
#endif
        [glView setTextureYUV:(GLTextureYUV *)yuv];
        [glView setNeedDraw];
#ifdef TRACKING
        [glView setTrackerType:TRACKER_ARCSOFT Data:points pointNum:ptNumber faceNum:faceNumber Width:pixelWidth Height:pixelHeight];
        if (points != nil) {
            free(points);
        }
#endif
#ifdef FILTERLIB_PROFILING
        double deltaTime3 = [[NSDate date] timeIntervalSinceDate:tmpStartData3];
        if (function_usage_max[3] < deltaTime3) {
            function_usage_max[3] = deltaTime3;
        }
        function_usage_sum[3] += deltaTime3;
        function_usage_count[3]++;
        if (function_usage_count[3] == 1000) {
            NSLog(@"FilterLib function render usage avg=%fms, max=%fms",
                  1000.0f*function_usage_sum[3]/(float)function_usage_count[3],
                  1000.0f*function_usage_max[3]);
            function_usage_sum[3] = 0.0f;
            function_usage_count[3] = 0;
            function_usage_max[3] = 0.0f;
        }
#endif
    });
    // Unlock
    CVPixelBufferUnlockBaseAddress(pixelBuffer, 0);
}

// 视频格式为：kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange或kCVPixelFormatType_420YpCbCr8BiPlanarFullRange
//- (void)processVideoSampleBufferToRGB1:(CMSampleBufferRef)sampleBuffer
//{
//    //CFAbsoluteTime startTime = CFAbsoluteTimeGetCurrent();
//    CVImageBufferRef pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
//    //size_t count = CVPixelBufferGetPlaneCount(pixelBuffer);
//    //printf("%zud\n", count);
//    
//    //表示开始操作数据
//    CVPixelBufferLockBaseAddress(pixelBuffer, 0);
//    
//    int pixelWidth = (int) CVPixelBufferGetWidth(pixelBuffer);
//    int pixelHeight = (int) CVPixelBufferGetHeight(pixelBuffer);
//    
////    NSLog(@"pixel buffer w=%d, h=%d", pixelWidth, pixelHeight);
//    
//    GLTextureRGBA *rgb = [[GLTextureRGBA alloc] init];
//    rgb.width = pixelWidth;
//    rgb.height = pixelHeight;
//    
//    // Y数据
//    //size_t y_size = pixelWidth * pixelHeight;
//    uint8_t *y_frame = CVPixelBufferGetBaseAddressOfPlane(pixelBuffer, 0);
//    
//    // UV数据
//    uint8_t *uv_frame = CVPixelBufferGetBaseAddressOfPlane(pixelBuffer, 1);
//    //size_t uv_size = y_size/2;
//    
//    // ARGB = BGRA 大小端问题 转换出来的数据是BGRA
//    uint8_t *bgra = malloc(pixelHeight * pixelWidth * 4);
//#ifdef FILTERLIB_PROFILING
//    NSDate* tmpStartData1 = [NSDate date];
//    //You code here...
//#endif
//    NV12ToARGB(y_frame, pixelWidth, uv_frame, pixelWidth, bgra, pixelWidth * 4, pixelWidth, pixelHeight);
//#ifdef FILTERLIB_PROFILING
//    double deltaTime1 = [[NSDate date] timeIntervalSinceDate:tmpStartData1];
//    if (function_usage_max[1] < deltaTime1) {
//        function_usage_max[1] = deltaTime1;
//    }
//    function_usage_sum[1] += deltaTime1;
//    function_usage_count[1]++;
//    if (function_usage_count[1] == 1000) {
//        NSLog(@"FilterLib function NV12ToARGB usage avg=%fms, max=%fms",
//              1000.0f*function_usage_sum[1]/(float)function_usage_count[1],
//              1000.0f*function_usage_max[1]);
//        function_usage_sum[1] = 0.0f;
//        function_usage_count[1] = 0;
//        function_usage_max[1] = 0.0f;
//    }
//#endif
//    rgb.RGBA = bgra;
//    
//    // Unlock
//    CVPixelBufferUnlockBaseAddress(pixelBuffer, 0);
//    
//    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
//    int ptNumber = ASL_GetFaceOutlinePointCount();
//    MPOINT *points = malloc(ASL_MAX_FACE_NUM * ptNumber*2);
//    int faceNumber = 0;
//    GASYUVFrame yuvFrame;
//    if(CVPixelBufferLockBaseAddress(imageBuffer, 0) == kCVReturnSuccess)
//    {
//        FMPixelFormat format = FMPixelFormatYUV420V;
//        if (format == FMPixelFormatYUV420V) {
//            UInt8 *bufferPtr = (UInt8 *)CVPixelBufferGetBaseAddressOfPlane(imageBuffer,0);
//            UInt8 *bufferPtr1 = (UInt8 *)CVPixelBufferGetBaseAddressOfPlane(imageBuffer,1);
//            yuvFrame.plane[0] = bufferPtr;
//            yuvFrame.plane[1] = bufferPtr1;
//        } else if (format == FMPixelFormatBGRA || format == FMPixelFormatRGBA) {
//            UInt8 *bufferPtr = (UInt8 *)CVPixelBufferGetBaseAddress(imageBuffer);
//            yuvFrame.plane[0] = bufferPtr;
//        }
//        size_t width = CVPixelBufferGetWidth(imageBuffer);
//        size_t height = CVPixelBufferGetHeight(imageBuffer);
//        yuvFrame.inputFormat = format;
//        yuvFrame.outputFormat = FMPixelFormatYUV420V;
//        yuvFrame.width = (int32_t)width;
//        yuvFrame.height = (int32_t)height;
//#ifdef FILTERLIB_PROFILING
//        NSDate* tmpStartData2 = [NSDate date];
//        //You code here...
//#endif
////        faceNumber = [tracker processSampleBuffer:&yuvFrame Points:points];
//#ifdef FILTERLIB_PROFILING
//        double deltaTime2 = [[NSDate date] timeIntervalSinceDate:tmpStartData2];
//        if (function_usage_max[2] < deltaTime2) {
//            function_usage_max[2] = deltaTime2;
//        }
//        function_usage_sum[2] += deltaTime2;
//        function_usage_count[2]++;
//        if (function_usage_count[2] == 1000) {
//            NSLog(@"FilterLib function processSampleBuffer usage avg=%fms, max=%fms",
//                  1000.0f*function_usage_sum[2]/(float)function_usage_count[2],
//                  1000.0f*function_usage_max[2]);
//            function_usage_sum[2] = 0.0f;
//            function_usage_count[2] = 0;
//            function_usage_max[2] = 0.0f;
//        }
//#endif
////        NSLog(@"faceNumber=%d", faceNumber);
//    }
//    CVPixelBufferUnlockBaseAddress(imageBuffer, 0);
//    
//    
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [glView setTextureRGBA:rgb];
//        
//        if (false) {
//            GLTextureRGBA *test_rgb = [[GLTextureRGBA alloc] init];
//            test_rgb.width = pixelWidth;
//            test_rgb.height = pixelHeight;
//            test_rgb.RGBA = malloc(pixelWidth * pixelHeight * 4);
//            memset(test_rgb.RGBA, 128, pixelHeight * pixelWidth * 4);
//            memset(test_rgb.RGBA, 255, pixelHeight * pixelWidth * 4 / 2);
//            memset(test_rgb.RGBA, 191, pixelHeight * pixelWidth * 4 / 4);
//            [glView setTextureRGBA:test_rgb];
//            
//            GLTextureRGBA *get_rgb = [glView getTextureImg];
//            printf("get_rgb (0,0) rgba %d,%d,%d,%d\n",
//                   get_rgb.RGBA[0], get_rgb.RGBA[1],
//                   get_rgb.RGBA[2], get_rgb.RGBA[3]);
//            printf("get_rgb (0,320) rgba %d,%d,%d,%d\n",
//                   get_rgb.RGBA[720*320*4+0], get_rgb.RGBA[720*320*4+1],
//                   get_rgb.RGBA[720*320*4+2], get_rgb.RGBA[720*320*4+3]);
//            printf("get_rgb (0,640) rgba %d,%d,%d,%d\n",
//                   get_rgb.RGBA[720*640*4+0], get_rgb.RGBA[720*640*4+1],
//                   get_rgb.RGBA[720*640*4+2], get_rgb.RGBA[720*640*4+3]);
//            
//            if (false) {
//                [glView setTextureId:2];
//                GLuint tid = [glView getTextureId];
//                NSLog(@"tid=%d", tid);
//            }
//        }
//#ifdef FILTERLIB_PROFILING
//        NSDate* tmpStartData3 = [NSDate date];
//        //You code here...
//#endif
//        
//        [glView setTrackerType:TRACKER_ARCSOFT Data:points pointNum:ptNumber faceNum:faceNumber Width:pixelWidth Height:pixelHeight];
//#ifdef FILTERLIB_PROFILING
//        double deltaTime3 = [[NSDate date] timeIntervalSinceDate:tmpStartData3];
//        if (function_usage_max[3] < deltaTime3) {
//            function_usage_max[3] = deltaTime3;
//        }
//        function_usage_sum[3] += deltaTime3;
//        function_usage_count[3]++;
//        if (function_usage_count[3] == 1000) {
//            NSLog(@"FilterLib function setTrackerData usage avg=%fms, max=%fms",
//                  1000.0f*function_usage_sum[3]/(float)function_usage_count[3],
//                  1000.0f*function_usage_max[3]);
//            function_usage_sum[3] = 0.0f;
//            function_usage_count[3] = 0;
//            function_usage_max[3] = 0.0f;
//        }
//#endif
//        
////        glView.frame = CGRectMake(0, 0, 720, 1280);
////        float ms = [UIScreen mainScreen].scale;
////        float mw = [UIScreen mainScreen].bounds.size.width;
////        float mh = [UIScreen mainScreen].bounds.size.height;
////        NSLog(@"mainScreen w=%f,h=%f,s=%f", mw, mh, ms);
//        
//        [glView setNeedDraw];
//        
//        if (points != nil) {
//            free(points);
//        }
//        
//    });
//}

#pragma mark - Action
- (IBAction)startBtnClick:(UIButton *)sender
{
    if (![_captureSession isRunning]) {
        [_captureSession startRunning];
    }
}

- (IBAction)stopBtnClick:(UIButton *)sender
{
    if ([_captureSession isRunning]) {
        [_captureSession stopRunning];
    }
}

- (IBAction)enableFaceMorphBtnClick:(UIButton *)sender
{
    if ([_captureSession isRunning]) {
        [glView enableFaceMorph:true];
        [btn3 setBackgroundColor:[UIColor redColor]];

    }
}

- (IBAction)enableSkinSmoothBtnClick:(UIButton *)sender
{
    if ([_captureSession isRunning]) {
        [glView enableSkinSmooth:true];
        [btn4 setBackgroundColor:[UIColor redColor]];
    }
}

- (IBAction)enableColorAdjustingBtnClick:(UIButton *)sender
{
    if ([_captureSession isRunning]) {
        [glView enableColorAdjusting:true];
        [btn5 setBackgroundColor:[UIColor redColor]];
    }
}

#pragma mark - <AVCaptureVideoDataOutputSampleBufferDelegate>
- (void)captureOutput:(AVCaptureOutput *)captureOutput
        didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer
        fromConnection:(AVCaptureConnection *)connection
{
#ifdef FILTERLIB_PROFILING
    NSDate* tmpStartData0 = [NSDate date];
#endif
    if (self.captureSession.isRunning && captureOutput == _videoOutput) {
        [self processVideoSampleBufferToYUV:sampleBuffer];
    }
#ifdef FILTERLIB_PROFILING
    double deltaTime0 = [[NSDate date] timeIntervalSinceDate:tmpStartData0];
    if (function_usage_max[0] < deltaTime0) {
        function_usage_max[0] = deltaTime0;
    }
    function_usage_sum[0] += deltaTime0;
    function_usage_count[0]++;
    if (function_usage_count[0] == 1000) {
        NSLog(@"FilterLib function captureOutput usage avg=%fms, max=%fms",
              1000.0f*function_usage_sum[0]/(float)function_usage_count[0],
              1000.0f*function_usage_max[0]);
        function_usage_sum[0] = 0.0f;
        function_usage_count[0] = 0;
        function_usage_max[0] = 0.0f;
    }
#endif
    
#ifdef FILTERLIB_PROFILING
    [self do_cpu_profiling];
    
    [self do_ram_profiling];
#endif
}

#ifdef FILTERLIB_PROFILING
- (void)do_cpu_profiling
{
    float usage = cpu_usage();
    if (cpu_usage_max < usage) {
        cpu_usage_max =usage;
    }
    cpu_usage_sum += usage;
    cpu_usage_count++;
    if (cpu_usage_count == 1000) {
        NSLog(@"FilterLib cpu usage avg=%f%%, max=%f%%", cpu_usage_sum/(float)cpu_usage_count, cpu_usage_max);
        cpu_usage_sum = 0.0f;
        cpu_usage_count = 0;
        cpu_usage_max = 0.0f;
    }
}

- (void)do_ram_profiling
{
    float usage = usedMemory2()/8388608.0f;//1MB=8*1024*1024bit
    if (ram_usage_max < usage) {
        ram_usage_max =usage;
    }
    ram_usage_sum += usage;
    ram_usage_count++;
    if (ram_usage_count == 1000) {
        NSLog(@"FilterLib ram usage avg=%fMB, max=%fMB",
              ram_usage_sum/(float)ram_usage_count, ram_usage_max);
        ram_usage_sum = 0.0f;
        ram_usage_count = 0;
        ram_usage_max = 0.0f;
    }
}


/**
 计算CPU使用率
 
 @return CPU使用率的浮点数
 */
float cpu_usage()
{
    kern_return_t kr;
    task_info_data_t tinfo;
    mach_msg_type_number_t task_info_count;
    
    task_info_count = TASK_INFO_MAX;
    kr = task_info(mach_task_self(), TASK_BASIC_INFO, (task_info_t)tinfo, &task_info_count);
    if (kr != KERN_SUCCESS) {
        return -1;
    }
    
    //    task_basic_info_t      basic_info;
    thread_array_t         thread_list;
    mach_msg_type_number_t thread_count;
    
    thread_info_data_t     thinfo;
    mach_msg_type_number_t thread_info_count;
    
    thread_basic_info_t basic_info_th;
    //    uint32_t stat_thread = 0; // Mach threads
    
    //    basic_info = (task_basic_info_t)tinfo;
    
    // get threads in the task
    kr = task_threads(mach_task_self(), &thread_list, &thread_count);
    if (kr != KERN_SUCCESS) {
        return -1;
    }
    //    if (thread_count > 0)
    //        stat_thread += thread_count;
    
    long tot_sec = 0;
    long tot_usec = 0;
    float tot_cpu = 0;
    int j;
    
    for (j = 0; j < (int)thread_count; j++)
    {
        thread_info_count = THREAD_INFO_MAX;
        kr = thread_info(thread_list[j], THREAD_BASIC_INFO,
                         (thread_info_t)thinfo, &thread_info_count);
        if (kr != KERN_SUCCESS) {
            return -1;
        }
        
        basic_info_th = (thread_basic_info_t)thinfo;
        
        if (!(basic_info_th->flags & TH_FLAGS_IDLE)) {
            tot_sec = tot_sec + basic_info_th->user_time.seconds + basic_info_th->system_time.seconds;
            tot_usec = tot_usec + basic_info_th->user_time.microseconds + basic_info_th->system_time.microseconds;
            tot_cpu = tot_cpu + basic_info_th->cpu_usage / (float)TH_USAGE_SCALE * 100.0;
        }
        
    } // for each thread
    
    kr = vm_deallocate(mach_task_self(), (vm_offset_t)thread_list, thread_count * sizeof(thread_t));
    assert(kr == KERN_SUCCESS);
    
    return tot_cpu;
}

/**
 计算当前APP内存占用大小
 
 @return 单位是bit,最后输出会转换成MB
 */
vm_size_t usedMemory2(void) {
    struct task_basic_info info;
    mach_msg_type_number_t size = sizeof(info);
    kern_return_t kerr = task_info(mach_task_self(), TASK_BASIC_INFO, (task_info_t)&info, &size);
    return (kerr == KERN_SUCCESS) ? info.resident_size : 0; // size in bytes
}
#endif
@end
