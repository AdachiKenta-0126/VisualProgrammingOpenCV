//
//  OpenCvMatToImage.m
//  VisualProgrammingOpenCV
//
//  Created by k18004kk on 2020/08/14.
//  Copyright © 2020 AIT. All rights reserved.
//

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdocumentation"
#import <opencv2/opencv.hpp>
#import <opencv2/imgproc.hpp>
#pragma clang diagnostic pop

#import <Cocoa/Cocoa.h>
#import "OpenCvMatToImage.h"


/// Converts an NSImage to Mat.
static void NSImageToMat(NSImage *image, cv::Mat &mat) {
    
    // Create a pixel buffer.
    NSBitmapImageRep *bitmapImageRep = [NSBitmapImageRep imageRepWithData:image.TIFFRepresentation];
    NSInteger width = bitmapImageRep.pixelsWide;
    NSInteger height = bitmapImageRep.pixelsHigh;
    CGImageRef imageRef = bitmapImageRep.CGImage;
    cv::Mat mat8uc4 = cv::Mat((int)height, (int)width, CV_8UC4);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef contextRef = CGBitmapContextCreate(mat8uc4.data, mat8uc4.cols, mat8uc4.rows, 8, mat8uc4.step, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrderDefault);
    CGContextDrawImage(contextRef, CGRectMake(0, 0, width, height), imageRef);
    CGContextRelease(contextRef);
    CGColorSpaceRelease(colorSpace);
    
    // Draw all pixels to the buffer.
    cv::Mat mat8uc3 = cv::Mat((int)width, (int)height, CV_8UC3);
    cv::cvtColor(mat8uc4, mat8uc3, cv::COLOR_RGBA2BGR);
    
    mat = mat8uc3;
}

/// Converts a Mat to NSImage.
static NSImage *MatToNSImage(cv::Mat &mat) {
    
    // Create a pixel buffer.
    assert(mat.elemSize() == 1 || mat.elemSize() == 3);
    cv::Mat matrgb;
    if (mat.elemSize() == 1) {
        cv::cvtColor(mat, matrgb, cv::COLOR_GRAY2RGB);
    } else if (mat.elemSize() == 3) {
        cv::cvtColor(mat, matrgb, cv::COLOR_BGR2RGB);
    }
    
    // Change a image format.
    NSData *data = [NSData dataWithBytes:matrgb.data length:(matrgb.elemSize() * matrgb.total())];
    CGColorSpaceRef colorSpace;
    if (matrgb.elemSize() == 1) {
        colorSpace = CGColorSpaceCreateDeviceGray();
    } else {
        colorSpace = CGColorSpaceCreateDeviceRGB();
    }
    CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)data);
    CGImageRef imageRef = CGImageCreate(matrgb.cols, matrgb.rows, 8, 8 * matrgb.elemSize(), matrgb.step.p[0], colorSpace, kCGImageAlphaNone|kCGBitmapByteOrderDefault, provider, NULL, false, kCGRenderingIntentDefault);
    NSBitmapImageRep *bitmapImageRep = [[NSBitmapImageRep alloc] initWithCGImage:imageRef];
    NSImage *image = [NSImage new];
    [image addRepresentation:bitmapImageRep];
    CGImageRelease(imageRef);
    CGDataProviderRelease(provider);
    CGColorSpaceRelease(colorSpace);
    
    return image;
}

///// Get color at pixel
//static cv::Vec3b GetColorFromMat(cv::Mat mat, cv::Vec3i c) {
//    // circle center
//    cv::Point center = cv::Point(c[0], c[1]);
//    // get pixel
//    cv::Vec3b &color = mat.at<cv::Vec3b>(center.y+10,center.x+10);
//    return color;
//}

@implementation OpenCVWrapper

+ grayInputImage:(NSImage *)image myArgument2:(NSString *)code{
    
    cv::Mat src;
    NSImageToMat(image, src);
    cv::Mat dst;
    
    if([code isEqualToString:@"RGB"]){
        return MatToNSImage(src);
    }else if([code isEqualToString:@"RGB2GRAY"]){
        cv::cvtColor(src, dst, cv::COLOR_BGR2GRAY);
        //GRAY2BGR
    }else{
        cv::cvtColor(src, dst, cv::COLOR_RGB2HSV);
    }

    
    //madadayo
//    cv::Mat twocolor;
//    cv::threshold(gray,twocolor, 100, 255,cv::THRESH_BINARY);
    
    //kokodeyo
//    cv::Mat sobel;
//
//    cv::Sobel(gray, tmp_image, CV_8U, 0, 1, 3);
//    cv::convertScaleAbs(tmp_image, sobel);
   
    return MatToNSImage(dst);
}

+ twoColorImage:(NSImage *)image myArgument2:(NSNumber *)Th{
    
    cv::Mat src;
    cv::Mat dst;
    double TH = [Th doubleValue];
    NSImageToMat(image, src);
    cv::threshold(src,dst,TH,255,cv::THRESH_BINARY);
    
    return MatToNSImage(dst);
}

+ dilate:(NSImage *)image myArgument2:(NSNumber *)count{
    
    cv::Mat src;
    cv::Mat dst;
    cv::Mat kernel = cv::getStructuringElement(cv::MORPH_RECT, cv::Size(3, 3));
    int Count = [count doubleValue];
    NSImageToMat(image, src);
    cv::dilate(src, dst, kernel,cv::Point(-1,-1),Count);
    
    return MatToNSImage(dst);
}
+ erode:(NSImage *)image myArgument2:(NSNumber *)count{
    
    cv::Mat src;
    cv::Mat dst;
    cv::Mat kernel = cv::getStructuringElement(cv::MORPH_RECT, cv::Size(3, 3));
    int Count = [count doubleValue];
    NSImageToMat(image, src);
    cv::erode(src, dst, kernel,cv::Point(-1,-1),Count);
    
    return MatToNSImage(dst);
}

+ sobel:(NSImage *)image myArgument2:(NSNumber *)count{
    
    cv::Mat src;
    cv::Mat dst;
    NSImageToMat(image, src);
    cv::Mat sobel;
    int Count = [count doubleValue];
    cv::Sobel(src, dst, CV_8U, 0, 1, Count);
    return MatToNSImage(dst);
}


@end
