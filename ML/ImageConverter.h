//
//  ImageConverter.h
//  ML
//
//  Created by Hale on 2017/6/9.
//  Copyright © 2017年 Hale. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface ImageConverter : NSObject
+ (CVPixelBufferRef)pixelBufferFromImage:(CGImageRef)image;
+ (CVPixelBufferRef)modifyImage:(CMSampleBufferRef) sampleBuffer;
@end
