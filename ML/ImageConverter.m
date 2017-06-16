//
//  ImageConverter.m
//  ML
//
//  Created by Hale on 2017/6/9.
//  Copyright © 2017年 Hale. All rights reserved.
//

#import "ImageConverter.h"

@implementation ImageConverter
+ (CVPixelBufferRef)pixelBufferFromImage:(CGImageRef)image {
    CGSize frameSize = CGSizeMake(CGImageGetWidth(image), CGImageGetHeight(image)); // Not sure why this is even necessary, using CGImageGetWidth/Height in status/context seems to work fine too
    
    CVPixelBufferRef pixelBuffer = NULL;
    CVReturn status = CVPixelBufferCreate(kCFAllocatorDefault, frameSize.width, frameSize.height, kCVPixelFormatType_32BGRA, nil, &pixelBuffer);
    if (status != kCVReturnSuccess) {
        return NULL;
    }
    
    CVPixelBufferLockBaseAddress(pixelBuffer, 0);
    void *data = CVPixelBufferGetBaseAddress(pixelBuffer);
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(data, frameSize.width, frameSize.height, 8, CVPixelBufferGetBytesPerRow(pixelBuffer), rgbColorSpace, (CGBitmapInfo) kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    CGContextDrawImage(context, CGRectMake(0, 0, CGImageGetWidth(image), CGImageGetHeight(image)), image);
    
    CGColorSpaceRelease(rgbColorSpace);
    CGContextRelease(context);
    CVPixelBufferUnlockBaseAddress(pixelBuffer, 0);
    
    return pixelBuffer;
}

+ (CVPixelBufferRef)modifyImage:(CMSampleBufferRef) sampleBuffer {
    @synchronized (self) {
        CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
        // Lock the image buffer
        CVPixelBufferLockBaseAddress(imageBuffer,0);
        
        // Get information about the image
        uint8_t *baseAddress = (uint8_t *)CVPixelBufferGetBaseAddress(imageBuffer);
        size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
        size_t width = CVPixelBufferGetWidth(imageBuffer);
        size_t height = CVPixelBufferGetHeight(imageBuffer);
        
        CVPixelBufferRef pxbuffer;
        NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                                 [NSNumber numberWithBool:YES], kCVPixelBufferCGImageCompatibilityKey,
                                 [NSNumber numberWithBool:YES], kCVPixelBufferCGBitmapContextCompatibilityKey,
                                 [NSNumber numberWithInt:720], kCVPixelBufferWidthKey,
                                 [NSNumber numberWithInt:1280], kCVPixelBufferHeightKey,
                                 nil];
        NSInteger tempWidth = (NSInteger) (224);
        NSInteger tempHeight = (NSInteger) (224);
        
        NSInteger baseAddressStart = 100 + 100 * bytesPerRow;
        CVReturn status = CVPixelBufferCreateWithBytes(kCFAllocatorDefault, tempWidth, tempHeight, kCVPixelFormatType_32BGRA, &baseAddress[baseAddressStart], bytesPerRow, nil, NULL, (__bridge CFDictionaryRef)options, &pxbuffer);
        
        if (status != 0) {
            NSLog(@"%d", status);
            return NULL;
        }
        
        CVPixelBufferUnlockBaseAddress(imageBuffer,0);
        
        return pxbuffer;
    }
}
@end
