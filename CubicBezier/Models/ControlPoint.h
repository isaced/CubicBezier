//
//  ControlPoint.h
//  CubicBezier
//
//  Created by feeling on 2017/3/15.
//
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

@interface ControlPoint : NSObject

@property (copy) NSString *name;
@property (assign) NSPoint point1;
@property (assign) NSPoint point2;

- (instancetype)initWithPoint1:(NSPoint)point1 point2:(NSPoint)point2;
- (instancetype)initWithPoints:(float)c1x :(float)c1y :(float)c2x :(float)c2y;

- (CAMediaTimingFunction *)timingFunction;


+ (instancetype)ease;
+ (instancetype)linear;
+ (instancetype)easeIn;
+ (instancetype)easeOut;
+ (instancetype)easeInOut;

- (NSImage *)thumbnailsImage;

@end
