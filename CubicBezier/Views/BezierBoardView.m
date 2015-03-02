//
//  BezierBoardView.m
//  CubicBezier
//
//  Created by isaced on 15/2/28.
//
//

#import "BezierBoardView.h"

@implementation BezierBoardView

-(instancetype)initWithCoder:(NSCoder *)coder{
    if ([super initWithCoder:coder]) {
        // init
    }
    return self;
}

-(void)drawRect:(NSRect)dirtyRect{
    
    CGFloat viewWidth = dirtyRect.size.width;
    CGFloat viewHeight = dirtyRect.size.height;
    
    // 边框
    [[NSColor grayColor] set];
    NSBezierPath *borderPath = [NSBezierPath bezierPathWithRect:dirtyRect];
    borderPath.lineWidth = 1.0;
    [borderPath stroke];
    
    // 灰色底线
    [[NSColor lightGrayColor] set];
    NSBezierPath *backgroundPath = [NSBezierPath bezierPath];
    backgroundPath.lineWidth = 5.0;
    [backgroundPath moveToPoint:CGPointMake(0, 0)];
    [backgroundPath curveToPoint:NSMakePoint(viewWidth, viewHeight) controlPoint1:NSMakePoint(0, 0) controlPoint2:NSMakePoint(0, 0)];
    [backgroundPath stroke];
    
    // Line1
    NSBezierPath *line1 = [NSBezierPath bezierPath];
    line1.lineWidth = 1.5;
    [line1 moveToPoint:NSMakePoint(0, 0)];
    [line1 lineToPoint:self.point1];
    [[NSColor grayColor] set];
    [line1 stroke];
    
    // Line2
    NSBezierPath *line2 = [NSBezierPath bezierPath];
    line2.lineWidth = 1.5;
    [line2 moveToPoint:NSMakePoint(viewWidth, viewHeight)];
    [line2 lineToPoint:self.point2];
    [[NSColor grayColor] set];
    [line2 stroke];
    
    // 动态曲线
    [[NSColor blackColor] set];
    NSBezierPath *bezierPath = [NSBezierPath bezierPath];
    bezierPath.lineWidth = 3.0;
    [bezierPath moveToPoint:CGPointMake(0, 0)];
    [bezierPath curveToPoint:NSMakePoint(viewWidth, viewHeight) controlPoint1:self.point1 controlPoint2:self.point2];
    [bezierPath stroke];
}

- (BOOL) wantsDefaultClipping { return NO; } // thanks stackoverflow.com

@end
