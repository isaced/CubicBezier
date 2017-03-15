//
//  BezierThumbnailsPainter.m
//  CubicBezier
//
//  Created by feeling on 2017/3/15.
//
//

#import "BezierThumbnailsPainter.h"

@implementation BezierThumbnailsPainter

+ (NSImage *)drawWithSize:(CGSize)size point1:(CGPoint)point1 point2:(CGPoint)point2 {
    NSImage* img = [[NSImage alloc] initWithSize:size];
    
    CGAffineTransform scaleTransform = CGAffineTransformMakeScale(size.width, size.height);
    point1 = CGPointApplyAffineTransform(point1, scaleTransform);
    point2 = CGPointApplyAffineTransform(point2, scaleTransform);
    
    NSColor *controlLineColor = [[NSColor whiteColor] colorWithAlphaComponent:0.6];
    NSColor *bezierLineColor = [[NSColor whiteColor] colorWithAlphaComponent:0.9];
    
    CGSize roundSize = CGSizeMake(size.width * 0.07, size.width * 0.07);
    
    [img lockFocus];
    
    // Line1
    NSBezierPath *line1 = [NSBezierPath bezierPath];
    line1.lineWidth = 1.0;
    [line1 moveToPoint:NSMakePoint(0, 0)];
    [line1 lineToPoint:point1];
    [controlLineColor set];
    [line1 stroke];
    
    // Round1
    NSBezierPath *round1 = [NSBezierPath bezierPathWithRoundedRect:NSMakeRect(point1.x - roundSize.width / 2.0,
                                                                              point1.y - roundSize.height / 2.0,
                                                                              roundSize.width,
                                                                              roundSize.height)
                                                           xRadius:roundSize.width / 2 yRadius: roundSize.height / 2];
    [round1 fill];
    [round1 stroke];
    
    // Line2
    NSBezierPath *line2 = [NSBezierPath bezierPath];
    line2.lineWidth = 1.0;
    [line2 moveToPoint:NSMakePoint(size.width, size.height)];
    [line2 lineToPoint:point2];
    [controlLineColor set];
    [line2 stroke];
    
    
    // Round1
    NSBezierPath *round2 = [NSBezierPath bezierPathWithRoundedRect:NSMakeRect(point2.x - roundSize.width / 2.0,
                                                                              point2.y - roundSize.height / 2.0,
                                                                              roundSize.width,
                                                                              roundSize.height)
                                                           xRadius:roundSize.width / 2 yRadius: roundSize.height / 2];
    [round2 fill];
    [round2 stroke];
    
    // 动态曲线
    NSBezierPath *bezierPath = [NSBezierPath bezierPath];
    bezierPath.lineWidth = 3.0;
    [bezierPath moveToPoint:CGPointMake(0, 0)];
    [bezierPath curveToPoint:NSMakePoint(size.width, size.height) controlPoint1:point1 controlPoint2:point2];
    [bezierLineColor set];
    [bezierPath stroke];
    
    [img unlockFocus];
    
    return img;
}

@end
