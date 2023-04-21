//
//  OpenCvMatToImage.h
//  VisualProgrammingOpenCV
//
//  Created by k18004kk on 2020/08/14.
//  Copyright © 2020 AIT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface OpenCVWrapper : NSObject

+ grayInputImage:(NSImage *)image myArgument:(NSString *)code;
+ twoColorImage:(NSImage *)image myArgument:(NSNumber *)Th;
+ dilate:(NSImage *)image myArgument:(NSNumber *)count;
+ erode:(NSImage *)image myArgument:(NSNumber *)count;
+ sobel:(NSImage *)image myArgument:(NSNumber *)count;

@end

NS_ASSUME_NONNULL_END
