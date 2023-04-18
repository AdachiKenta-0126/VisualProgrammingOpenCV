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

+ grayInputImage:(NSImage *)image myArgument2:(NSString *)code;
+ twoColorImage:(NSImage *)image myArgument2:(NSNumber *)Th;
+ dilate:(NSImage *)image myArgument2:(NSNumber *)count;
+ erode:(NSImage *)image myArgument2:(NSNumber *)count;
+ sobel:(NSImage *)image myArgument2:(NSNumber *)count;

@end

NS_ASSUME_NONNULL_END
