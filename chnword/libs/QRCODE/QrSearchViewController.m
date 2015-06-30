//
//  QrSearchViewController.m
//  qrcode
//
//  Created by Caland on 14-10-16.
//  Copyright (c) 2014年 Caland. All rights reserved.
//

#import "QrSearchViewController.h"
#import "QRUtil.h"


@interface QrSearchViewController ()

//Device
@property (nonatomic, retain) AVCaptureDevice *device;
@property (nonatomic, retain) AVCaptureDeviceInput *input;
@property (nonatomic, retain) AVCaptureMetadataOutput *output;
@property (nonatomic, retain) AVCaptureSession *session;
@property (nonatomic, retain) AVCaptureVideoPreviewLayer *preview;
@property (nonatomic, retain) UIImageView *line;



@property (nonatomic, retain) UIView *maskView;

@end

@implementation QrSearchViewController



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (id) init
{
    if (self = [super init]) {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.captureType = AVCaptureDevicePositionBack;
    
}

- (void) viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    if (self.session) {
        [self.session startRunning];
    }else {
        if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
            self.device = [self cameraWithPosition:self.captureType];
            
            NSAssert(self.device!=nil, @"QRSearchViewController:Device shouldn't be nil.");
            
            self.input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
            
            NSAssert(self.input != nil, @"QRSearchViewController:Input shouldn't be nil.");
            
            self.output = [[AVCaptureMetadataOutput alloc] init];
            [self.output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
            self.output.rectOfInterest = CGRectMake(0.1, 0.1, 0.8, 0.8);//设置取值的范围，就是扫描的范围。
            
            self.session = [[AVCaptureSession alloc] init];
            
            if ([self.session canAddInput:self.input]) {
                [self.session addInput:self.input];
            }
            
            if ([self.session canAddOutput:self.output]) {
                [self.session addOutput:self.output];
            }
            
            
            self.output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode];
            
            
            self.preview = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
            
            _preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
            _preview.frame = self.view.frame;
            
            [self.view.layer insertSublayer:self.preview atIndex:0];
            
            [self.session startRunning];
        }
    }
    
}
- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.session stopRunning];
}

#pragma mark -Property Method
- (AVCaptureDevicePosition) captureType
{
    if (!_captureType) {
        _captureType = AVCaptureDevicePositionBack;
    }
    return _captureType;
}


#pragma mark - Private Method

/**
 *  得到指定的Device
 */
- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition)position
{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for ( AVCaptureDevice *device in devices )
        if ( device.position == position )
            return device;
    return nil;
}



#pragma mark
#pragma mark - AVCaptureMetadataOutputObjectsDelegate
- (void) captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    NSString *strValue = nil;
    if (metadataObjects.count > 0) {
        AVMetadataMachineReadableCodeObject *metaDataObject = [metadataObjects objectAtIndex:0];
        strValue = metaDataObject.stringValue;
    }
    if(strValue && ![@"" isEqualToString:strValue]){
        if ([self verifyQrCode:strValue]) {
            [self.session stopRunning];
            [self successedWithString:strValue];
        }
    }
}
//子类应该重写的方法
/**
 *  成功扫到文件的方法。
 */
- (void) successedWithString:(NSString *) str
{
    
}

/**
 *  @abstract 验证
 */
- (BOOL) verifyQrCode:(NSString *) code
{
    return YES;
}

/**
 *  闪烁的调用方法。
 *  @param view 在那个view上进行闪烁
 *  @param color 闪烁的颜色
 *  @param duration 闪烁的时间
 */
- (void) flashOnView:(UIView *) view withColor:(UIColor *) color duration:(NSTimeInterval) time
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath : @"opacity" ]; // 必须写 opacity 才行。
    animation.fromValue = [NSNumber numberWithFloat : 1.0f ];
    animation.toValue = [NSNumber numberWithFloat : 0.0f ]; // 这是透明度。
    animation.autoreverses = YES ;
    animation.duration = time;
    animation.repeatCount = 5;
    animation.removedOnCompletion = NO ;
    animation.fillMode = kCAFillModeForwards ;
    animation.delegate = self;
    
    animation.timingFunction =[CAMediaTimingFunction functionWithName : kCAMediaTimingFunctionEaseIn ];
    view.layer.backgroundColor = color.CGColor;
    [view.layer addAnimation:animation forKey:nil];
    
    self.maskView = view;
}
/**
 *  @abstract 关闭扫描
 */
- (void) stopSession
{
    [self.session stopRunning];
    [self.preview removeFromSuperlayer];
}
/**
 *  @abstract 重新开启扫描
 */
- (void) reStartSession
{
    [self.session startRunning];
}

/**
 *  @abstract 更换摄像头
 *
 */
- (void) switchCaptureDevice:(AVCaptureDevicePosition) type
{
    [self.session stopRunning];
    [self.session removeInput:self.input];
    self.input = nil;
    self.device = nil;
    
    self.captureType = type;
    
    self.device = [self cameraWithPosition:self.captureType];
    
    NSAssert(self.device!=nil, @"QRSearchViewController:Device shouldn't be nil.");
    
    self.input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    if ([self.session canAddInput:self.input]) {
        [self.session addInput:self.input];
    }
    [self.session startRunning];
}

/**
 *  @abstract 动画完成
 *
 */
- (void) afterAnimation
{
    [self.maskView removeFromSuperview];
    self.maskView = nil;
}


- (void)animationDidStart:(CAAnimation *)anim
{
    NSLog(@"the animation start!");
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    NSLog(@"the animation stop!");
    if (flag) {
        [self afterAnimation];
    }
}



#pragma mark
#pragma mark - UIInterfaceOrigation

- (BOOL) shouldAutorotate{
    return NO;
}




@end
