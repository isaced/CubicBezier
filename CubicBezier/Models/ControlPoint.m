//
//  ControlPoint.m
//  CubicBezier
//
//  Created by feeling on 2017/3/15.
//
//

#import "ControlPoint.h"
#import "BezierThumbnailsPainter.h"

@implementation ControlPoint

- (instancetype)initWithPoint1:(NSPoint)point1 point2:(NSPoint)point2 {
    if (self=[super init]) {
        self.point1 = point1;
        self.point2 = point2;
    }
    return self;
}

- (instancetype)initWithPoints:(float)c1x :(float)c1y :(float)c2x :(float)c2y {
    if (self=[super init]) {
        self.point1 = NSMakePoint(c1x, c1y);
        self.point2 = NSMakePoint(c2x, c2y);
    }
    return self;
}

- (CAMediaTimingFunction *)timingFunction {
    return [CAMediaTimingFunction functionWithControlPoints:self.point1.x :self.point1.y :self.point2.x :self.point2.y];
}

+ (instancetype)ease {
    ControlPoint *ease = [[ControlPoint alloc] initWithPoints:0.25 :0.1 :0.25 :1];
    ease.name = @"ease";
    return ease;
}

+ (instancetype)linear {
    ControlPoint *linear = [[ControlPoint alloc] initWithPoints:0 :0 :1 :1];
    linear.name = @"linear";
    return linear;
}

+ (instancetype)easeIn {
    ControlPoint *easeIn = [[ControlPoint alloc] initWithPoints:0.42 :0 :1 :1];
    easeIn.name = @"ease-in";
    return easeIn;
}

+ (instancetype)easeOut {
    ControlPoint *easeOut = [[ControlPoint alloc] initWithPoints:0 :0 :0.58 :1];
    easeOut.name = @"ease-out";
    return easeOut;
}

+ (instancetype)easeInOut {
    ControlPoint *easeInOut = [[ControlPoint alloc] initWithPoints:0.42 :0 :0.58 :1];
    easeInOut.name = @"ease-in-out";
    return easeInOut;
}

- (NSImage *)thumbnailsImage {
    return [BezierThumbnailsPainter drawWithSize:CGSizeMake(50, 50) point1:self.point1 point2:self.point2];
}

@end
