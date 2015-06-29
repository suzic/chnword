//
//  GIFPLayer.m
//  chnword
//
//  Created by 苏智 on 15/6/21.
//  Copyright (c) 2015年 Suzic. All rights reserved.
//

#import "GIFPlayer.h"
#import <ImageIO/ImageIO.h>
#import <QuartzCore/CoreAnimation.h>

/**
 * @abstract C函数，解析给定的GIF返回关键帧、每帧持续时间、总播放时间、以及帧尺寸
 */
void getFrameInfo(CFURLRef url, NSMutableArray *frames, NSMutableArray *delayTimes, CGFloat *totalTime,CGFloat *gifWidth, CGFloat *gifHeight)
{
    CGImageSourceRef gifSource = CGImageSourceCreateWithURL(url, NULL);
    
    // get frame count
    size_t frameCount = CGImageSourceGetCount(gifSource);
    for (size_t i = 0; i < frameCount; ++i)
    {
        // get each frame
        CGImageRef frame = CGImageSourceCreateImageAtIndex(gifSource, i, NULL);
        [frames addObject:(__bridge id)frame];
        CGImageRelease(frame);
        
        // get gif info with each frame
        NSDictionary *dict = (NSDictionary*)CFBridgingRelease(CGImageSourceCopyPropertiesAtIndex(gifSource, i, NULL));
        NSLog(@"kCGImagePropertyGIFDictionary %@", [dict valueForKey:(NSString*)kCGImagePropertyGIFDictionary]);
        
        // get gif size
        if (gifWidth != NULL && gifHeight != NULL)
        {
            *gifWidth = [[dict valueForKey:(NSString*)kCGImagePropertyPixelWidth] floatValue];
            *gifHeight = [[dict valueForKey:(NSString*)kCGImagePropertyPixelHeight] floatValue];
        }
        
        // kCGImagePropertyGIFDictionary中kCGImagePropertyGIFDelayTime，kCGImagePropertyGIFUnclampedDelayTime值是一样的
        NSDictionary *gifDict = [dict valueForKey:(NSString*)kCGImagePropertyGIFDictionary];
        [delayTimes addObject:[gifDict valueForKey:(NSString*)kCGImagePropertyGIFDelayTime]];
        
        if (totalTime)
            *totalTime = *totalTime + [[gifDict valueForKey:(NSString*)kCGImagePropertyGIFDelayTime] floatValue];
    }
}

/**
 * @abstract C函数，解析给定的GIF返回关键帧、每帧持续时间、总播放时间、以及帧尺寸
 */
void getFrameInfoFromData(CFDataRef data, NSMutableArray *frames, NSMutableArray *delayTimes, CGFloat *totalTime,CGFloat *gifWidth, CGFloat *gifHeight)
{
//    CGImageSourceRef gifSource = CGImageSourceCreateWithURL(url, NULL);
    CGImageSourceRef gifSource = CGImageSourceCreateWithData(data, NULL);
    
    // get frame count
    size_t frameCount = CGImageSourceGetCount(gifSource);
    for (size_t i = 0; i < frameCount; ++i)
    {
        // get each frame
        CGImageRef frame = CGImageSourceCreateImageAtIndex(gifSource, i, NULL);
        [frames addObject:(__bridge id)frame];
        CGImageRelease(frame);
        
        // get gif info with each frame
        NSDictionary *dict = (NSDictionary*)CFBridgingRelease(CGImageSourceCopyPropertiesAtIndex(gifSource, i, NULL));
        NSLog(@"kCGImagePropertyGIFDictionary %@", [dict valueForKey:(NSString*)kCGImagePropertyGIFDictionary]);
        
        // get gif size
        if (gifWidth != NULL && gifHeight != NULL)
        {
            *gifWidth = [[dict valueForKey:(NSString*)kCGImagePropertyPixelWidth] floatValue];
            *gifHeight = [[dict valueForKey:(NSString*)kCGImagePropertyPixelHeight] floatValue];
        }
        
        // kCGImagePropertyGIFDictionary中kCGImagePropertyGIFDelayTime，kCGImagePropertyGIFUnclampedDelayTime值是一样的
        NSDictionary *gifDict = [dict valueForKey:(NSString*)kCGImagePropertyGIFDictionary];
        [delayTimes addObject:[gifDict valueForKey:(NSString*)kCGImagePropertyGIFDelayTime]];
        
        if (totalTime)
            *totalTime = *totalTime + [[gifDict valueForKey:(NSString*)kCGImagePropertyGIFDelayTime] floatValue];
    }
}

@interface GIFPlayer()
{
    NSMutableArray *_frames;
    NSMutableArray *_frameDelayTimes;
    
    CGFloat _totalTime;         // seconds
    CGFloat _width;
    CGFloat _height;
}

@property (strong, nonatomic) CAKeyframeAnimation *animation;

@end

@implementation GIFPlayer

- (id)initWithCenter:(CGPoint)center fileURL:(NSURL*)fileURL;
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        
        _frames = [[NSMutableArray alloc] init];
        _frameDelayTimes = [[NSMutableArray alloc] init];
        
        _width = 0;
        _height = 0;
        
        if (fileURL) {
            getFrameInfo((__bridge CFURLRef)fileURL, _frames, _frameDelayTimes, &_totalTime, &_width, &_height);
        }
        
        self.frame = CGRectMake(0, 0, _width, _height);
        self.center = center;
    }
    
    return self;
}

+ (NSArray*)framesInGif:(NSURL *)fileURL
{
    NSMutableArray *frames = [NSMutableArray arrayWithCapacity:3];
    NSMutableArray *delays = [NSMutableArray arrayWithCapacity:3];
    
    getFrameInfo((__bridge CFURLRef)fileURL, frames, delays, NULL, NULL, NULL);
    
    return frames;
}

+ (NSArray *) framesInImage:(UIImage *) image
{
    NSMutableArray *frames = [NSMutableArray arrayWithCapacity:3];
    NSMutableArray *delays = [NSMutableArray arrayWithCapacity:3];
    
//    getFrameInfo((__bridge CFURLRef)fileURL, frames, delays, NULL, NULL, NULL);
    getFrameInfoFromData((__bridge CFDataRef) UIImageJPEGRepresentation(image,1.0), frames, delays, NULL, NULL, NULL);
    
    
    return frames;
}

- (CAKeyframeAnimation *)animation
{
    if (_animation == nil)
    {
        _animation = [CAKeyframeAnimation animationWithKeyPath:@"contents"];
        
        NSMutableArray *times = [NSMutableArray arrayWithCapacity:3];
        CGFloat currentTime = 0;
        int count = (int)_frameDelayTimes.count;
        for (int i = 0; i < count; ++i)
        {
            [times addObject:[NSNumber numberWithFloat:(currentTime / _totalTime)]];
            currentTime += [[_frameDelayTimes objectAtIndex:i] floatValue];
        }
        [_animation setKeyTimes:times];
        
        NSMutableArray *images = [NSMutableArray arrayWithCapacity:3];
        for (int i = 0; i < count; ++i) {
            [images addObject:[_frames objectAtIndex:i]];
        }
        
        [_animation setValues:images];
        [_animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
        _animation.duration = _totalTime;
        _animation.repeatCount = 1;
    }
    return _animation;
}

- (void)startGif:(UIViewController *)delegateController
{
    self.animation.delegate = delegateController;
    [self.layer addAnimation:self.animation forKey:@"gifAnimation"];
}

- (void)stopGif
{
    [self.layer removeAllAnimations];
}

// remove contents when animation end
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    self.layer.contents = nil;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}

@end


