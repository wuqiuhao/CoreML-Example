//
//  ImageConverter.m
//  ML
//
//  Created by Hale on 2017/6/9.
//  Copyright © 2017年 Hale. All rights reserved.
//

#import "ImageConverter.h"

@implementation ImageConverter
+ (CVPixelBufferRef)modifyImage:(CMSampleBufferRef) sampleBuffer  size:(CGSize)size{
    @synchronized (self) {
        CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
        // Lock the image buffer
        CVPixelBufferLockBaseAddress(imageBuffer,0);
        
        // Get information about the image
        uint8_t *baseAddress = (uint8_t *)CVPixelBufferGetBaseAddress(imageBuffer);
        size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
        size_t height = CVPixelBufferGetHeight(imageBuffer);
        size_t width = CVPixelBufferGetWidth(imageBuffer);
        
        CVPixelBufferRef pxbuffer;
        NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                                 [NSNumber numberWithBool:YES], kCVPixelBufferCGImageCompatibilityKey,
                                 [NSNumber numberWithBool:YES], kCVPixelBufferCGBitmapContextCompatibilityKey,
                                 nil];
        NSInteger baseAddressStart = bytesPerRow * (height-size.height) / 2 + (width - size.width) / 2 * 4;
        CVReturn status = CVPixelBufferCreateWithBytes(kCFAllocatorDefault, size.width, size.height, kCVPixelFormatType_32BGRA, &baseAddress[baseAddressStart], bytesPerRow, nil, NULL, (__bridge CFDictionaryRef)options, &pxbuffer);
        
        if (status != 0) {
            NSLog(@"%d", status);
            return NULL;
        }
        
        CVPixelBufferUnlockBaseAddress(imageBuffer,0);
        
        return pxbuffer;
    }
}
@end
