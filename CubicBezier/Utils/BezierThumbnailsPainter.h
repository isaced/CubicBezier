//
//  BezierThumbnailsPainter.h
//  CubicBezier
//
//  Created by feeling on 2017/3/15.
//
//

#import <Cocoa/Cocoa.h>

@interface BezierThumbnailsPainter : NSObject


/**
 draw bezier preview thumbnails to a image

 @param size image size
 @param point1 first control point
 @param point2 secend control point
 @return image for thumbnails
 */
+ (NSImage *)drawWithSize:(CGSize)size point1:(CGPoint)point1 point2:(CGPoint)point2;

@end
