//
//  ViewController.m
//  CC_VideoToolBoxLearning_1
//
//  Created by CC老师 on 2017/6/26.
//  Copyright © 2017年 Miss CC. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <VideoToolbox/VideoToolbox.h>


@interface ViewController ()<AVCaptureVideoDataOutputSampleBufferDelegate>

@property(nonatomic,strong)UILabel *cLabel;
@property(nonatomic,strong)AVCaptureSession *cCapturesession;@property(nonatomic,strong)AVCaptureDeviceInput *cCaptureDeviceInput;
@property(nonatomic,strong)AVCaptureVideoDataOutput *cCaptureDataOutput;
@property(nonatomic,strong)AVCaptureVideoPreviewLayer *cPreviewLayer;

@end

@implementation ViewController
{
    int  frameID;
    dispatch_queue_t cCaptureQueue;
    dispatch_queue_t cEncodeQueue;
    VTCompressionSessionRef cEncodeingSession;
    CMFormatDescriptionRef format;
    NSFileHandle *fileHandele;
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //基础UI实现
    _cLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 20, 200, 100)];
    _cLabel.text = @"cc课堂之H.264硬编码";
    _cLabel.textColor = [UIColor redColor];
    [self.view addSubview:_cLabel];
    
    UIButton *cButton = [[UIButton alloc]initWithFrame:CGRectMake(200, 20, 100, 100)];
    [cButton setTitle:@"play" forState:UIControlStateNormal];
    [cButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cButton setBackgroundColor:[UIColor orangeColor]];
    [cButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cButton];
    

    
}


-(void)buttonClick:(UIButton *)button
{
    
    if (!_cCapturesession || !_cCapturesession.isRunning ) {
        
        [button setTitle:@"Stop" forState:UIControlStateNormal];
        [self startCapture];
        
        
    }else
    {
        [button setTitle:@"Play" forState:UIControlStateNormal];
        [self stopCapture];
    }
    
}

//开始捕捉
- (void)startCapture
{
    self.cCapturesession = [[AVCaptureSession alloc]init];
    
    self.cCapturesession.sessionPreset = AVCaptureSessionPreset640x480;
    
    cCaptureQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    cEncodeQueue  = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    AVCaptureDevice *inputCamera = nil;
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices) {

        if ([device position] == AVCaptureDevicePositionBack) {
            
            inputCamera = device;
        }
    }
    
    self.cCaptureDeviceInput = [[AVCaptureDeviceInput alloc]initWithDevice:inputCamera error:nil];
    
    if ([self.cCapturesession canAddInput:self.cCaptureDeviceInput]) {
        
        [self.cCapturesession addInput:self.cCaptureDeviceInput];
        
        
    }
    
    self.cCaptureDataOutput = [[AVCaptureVideoDataOutput alloc]init];

    [self.cCaptureDataOutput setAlwaysDiscardsLateVideoFrames:NO];
    
    [self.cCaptureDataOutput setVideoSettings:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:kCVPixelFormatType_420YpCbCr8BiPlanarFullRange] forKey:(id)kCVPixelBufferPixelFormatTypeKey]];
    
    [self.cCaptureDataOutput setSampleBufferDelegate:self queue:cCaptureQueue];
    
    if ([self.cCapturesession canAddOutput:self.cCaptureDataOutput]) {
        
        [self.cCapturesession addOutput:self.cCaptureDataOutput];
    }
    
    AVCaptureConnection *connection = [self.cCaptureDataOutput connectionWithMediaType:AVMediaTypeVideo];
    
    [connection setVideoOrientation:AVCaptureVideoOrientationPortrait];
    
    self.cPreviewLayer = [[AVCaptureVideoPreviewLayer alloc]initWithSession:self.cCapturesession];

    [self.cPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspect];
    
    [self.cPreviewLayer setFrame:self.view.bounds];
    
    [self.view.layer addSublayer:self.cPreviewLayer];
    
    NSString *filePath = [NSHomeDirectory()stringByAppendingPathComponent:@"/Documents/cc_video.h264"];

    [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
    
    BOOL createFile = [[NSFileManager defaultManager] createFileAtPath:filePath contents:nil attributes:nil];
    if (!createFile) {
        
        NSLog(@"create file failed");
    }else
    {
        NSLog(@"create file success");

    }
    
    NSLog(@"filePaht = %@",filePath);
    fileHandele = [NSFileHandle fileHandleForWritingAtPath:filePath];
    
    
    //初始化videoToolbBox
    [self initVideoToolBox];
    
    //开始捕捉
    [self.cCapturesession startRunning];
    
    
    
    
}


//停止捕捉
- (void)stopCapture
{
    
    [self.cCapturesession stopRunning];
    
    [self.cPreviewLayer removeFromSuperlayer];
    
    [self endVideoToolBox];
    
    [fileHandele closeFile];
    
    fileHandele = NULL;
    
}

#pragma mark - AVCaptureVideoDataOutputSampleBufferDelegate
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
{
    dispatch_sync(cEncodeQueue, ^{
        [self encode:sampleBuffer];
    });
    
}



//初始化videoToolBox
-(void)initVideoToolBox
{

}


//编码
- (void) encode:(CMSampleBufferRef )sampleBuffer
{
    
}


//编码完成回调
void didCompressH264(void *outputCallbackRefCon, void *sourceFrameRefCon, OSStatus status, VTEncodeInfoFlags infoFlags, CMSampleBufferRef sampleBuffer)
{
    
    
}

- (void)gotSpsPps:(NSData*)sps pps:(NSData*)pps
{
    
    
}


- (void)gotEncodedData:(NSData*)data isKeyFrame:(BOOL)isKeyFrame
{
    
}

//结束VideoToolBox
-(void)endVideoToolBox
{
    VTCompressionSessionCompleteFrames(cEncodeingSession, kCMTimeInvalid);
    VTCompressionSessionInvalidate(cEncodeingSession);
    CFRelease(cEncodeingSession);
    cEncodeingSession = NULL;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
