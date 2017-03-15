//
//  ViewController.m
//  CubicBezier
//
//  Created by isaced on 15/2/28.
//
//

#import "ViewController.h"
#import <QuartzCore/CoreAnimation.h>
#import "BezierThumbnailsPainter.h"

@interface ViewController()

@property (strong) RoundButton *roundButton1;
@property (strong) RoundButton *roundButton2;

// 标识两个圆点的松开状态
@property (assign) BOOL roundButton1Down;
@property (assign) BOOL roundButton2Down;
@property (assign) BOOL blankTouchDown;

@property (assign) CGPoint bezierDataPoint1;
@property (assign) CGPoint bezierDataPoint2;

@property (assign) CGPoint originalBezierDataPoint1;
@property (assign) CGPoint originalBezierDataPoint2;

@property (strong) CALayer *previewLayer1;
@property (strong) CALayer *previewLayer2;

@property (assign) CGFloat previewLayerXPosition;

@property (strong) NSTrackingArea *trackingArea;

@end

@implementation ViewController

#pragma mark -

/// 比较两点间距离
- (float)distanceBetween:(CGPoint)p1 and:(CGPoint)p2{
    return sqrt(pow(p2.x-p1.x,2)+pow(p2.y-p1.y,2));
}

/// 坐标转换：转换成相对画板的坐标
- (CGPoint)boardPoint:(CGPoint)p{
    return CGPointMake(self.bezierBoardView.frame.origin.x + p.x * 200.0,
                       self.bezierBoardView.frame.origin.y + p.y * 200.0);
}

/**
 *  把鼠标拖动的锚点坐标转换成贝塞尔曲线所用的坐标点（以 bezierBoardView 正方形区域 0 ~ 1 范围）
 */
- (CGPoint)bezierPoint:(CGPoint)p{
    CGPoint point = [self.view convertPoint:p toView:self.bezierBoardView];
    point.x /= self.bezierBoardView.frame.size.width;
    point.y /= self.bezierBoardView.frame.size.height;
    return point;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 画板左边的文本框旋转90度
    self.bezierBoardLeftTextField.frameRotation = 90;
    
    // 初始点
    self.bezierDataPoint1 = CGPointMake(0.17, 0.67);
    self.bezierDataPoint2 = CGPointMake(0.83, 0.67);
    
    self.originalBezierDataPoint1 = CGPointMake(0, 0);
    self.originalBezierDataPoint2 = CGPointMake(1, 1);
    
    // 控制点颜色
    NSColor *color1 = [NSColor colorWithRed:244 / 255.0 green:0 blue:221 / 255.0 alpha:1];
    NSColor *color2 = [NSColor colorWithRed:35/255.0 green:154/255.0 blue:175/255.0 alpha:1];
    
    // 顶点 （左下&右上）
    RoundButton *leftZero = [[RoundButton alloc] initWithFrame:NSMakeRect(self.bezierBoardView.frame.origin.x - RoundButtonDiameter / 2.0, self.bezierBoardView.frame.origin.y - RoundButtonDiameter / 2.0, RoundButtonDiameter, RoundButtonDiameter)];
    RoundButton *rightZero = [[RoundButton alloc] initWithFrame:NSMakeRect(self.bezierBoardView.frame.origin.x - RoundButtonDiameter / 2.0 + self.bezierBoardView.frame.size.width, self.bezierBoardView.frame.origin.y - RoundButtonDiameter / 2.0 + self.bezierBoardView.frame.size.height, RoundButtonDiameter, RoundButtonDiameter)];
    leftZero.showBorder = YES;
    rightZero.showBorder = YES;
    [self.view addSubview:leftZero];
    [self.view addSubview:rightZero];
    
    // 动态点
    CGPoint point1 = [self boardPoint:self.bezierDataPoint1];
    self.roundButton1 = [[RoundButton alloc] initWithFrame:NSMakeRect(point1.x + self.bezierBoardView.frame.origin.x - RoundButtonDiameter / 2.0, point1.y + self.bezierBoardView.frame.origin.y - RoundButtonDiameter / 2.0, RoundButtonDiameter, RoundButtonDiameter)];
    self.roundButton1.backgroundColor = color1;
    [self.view addSubview:self.roundButton1];
    
    CGPoint point2 = [self boardPoint:self.bezierDataPoint2];
    self.roundButton2 = [[RoundButton alloc] initWithFrame:NSMakeRect(point2.x + self.bezierBoardView.frame.origin.x - RoundButtonDiameter / 2.0, point2.y + self.bezierBoardView.frame.origin.y - RoundButtonDiameter / 2.0, RoundButtonDiameter, RoundButtonDiameter)];
    self.roundButton2.backgroundColor = color2;
    [self.view addSubview:self.roundButton2];
    
    self.bezierBoardView.point1 = point1;
    self.bezierBoardView.point2 = point2;
    
    self.bezierTextField.stringValue = @"0.17,0.67,0.83,0.67";
    
    // Animation Layer
    
    CGRect previewLayerRect = CGRectMake(0, 0, 50, 50);

    self.previewLayer1 = [CALayer layer];
    self.previewLayer1.frame = previewLayerRect;
    self.previewLayer1.backgroundColor = color1.CGColor;
    self.previewLayer1.cornerRadius = 6.0;
    self.previewLayer1.masksToBounds = YES;
    [self.bezierPreview1.layer addSublayer:self.previewLayer1];
    
    self.previewLayer2 = [CALayer layer];
    self.previewLayer2.frame = previewLayerRect;
    self.previewLayer2.backgroundColor = color2.CGColor;
    self.previewLayer2.cornerRadius = 6.0;
    self.previewLayer2.masksToBounds = YES;
    [self.bezierPreview2.layer addSublayer:self.previewLayer2];
    
    self.previewLayerXPosition = self.previewLayer1.bounds.size.width / 2.0;
    
    [self goAnimation:nil];
    
    // TrackingArea
    NSTrackingAreaOptions options = (NSTrackingActiveAlways | NSTrackingInVisibleRect | NSTrackingMouseEnteredAndExited | NSTrackingMouseMoved);
    self.trackingArea = [[NSTrackingArea alloc] initWithRect:[self.view bounds] options:options owner:self userInfo:nil];
    [self.view addTrackingArea:self.trackingArea];
    
    [self updateBezierThumbnailsAll:YES];
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

- (void) updateBezierThumbnailsAll:(BOOL)all {
    NSImage *bezierThumbnailsImage = [BezierThumbnailsPainter drawWithSize:self.previewLayer1.bounds.size point1:self.bezierDataPoint1 point2:self.bezierDataPoint2 inset:0.1];
    self.previewLayer1.contents = bezierThumbnailsImage;
    
    if (all) {
        NSImage *bezierThumbnailsImage2 = [BezierThumbnailsPainter drawWithSize:self.previewLayer1.bounds.size
                                                                         point1:self.originalBezierDataPoint1
                                                                         point2:self.originalBezierDataPoint2 inset:0.1];
        self.previewLayer2.contents = bezierThumbnailsImage2;
    }
}

-(void)mouseDown:(NSEvent *)theEvent{
    if (NSPointInRect(theEvent.locationInWindow, self.roundButton1.frame)) {
        // 如果点中第一个点
        self.roundButton1Down = YES;
    }else if(NSPointInRect(theEvent.locationInWindow, self.roundButton2.frame)){
        // 如果点中的第二个点
        self.roundButton2Down = YES;
    }else if(NSPointInRect(theEvent.locationInWindow, self.bezierBoardView.frame)){
        // 如果点的空白地方（画板内）
        self.blankTouchDown = YES;
    }
    NSLog(@"mouseDown:%@",NSStringFromPoint(theEvent.locationInWindow));
}

-(void)mouseDragged:(NSEvent *)theEvent{
    [self updateBezierBoard:theEvent];
    NSLog(@"mouseDragged");
}

-(void)mouseUp:(NSEvent *)theEvent{
    [self updateBezierBoard:theEvent];
    
    // 清除状态
    self.roundButton1Down = NO;
    self.roundButton2Down = NO;
    self.blankTouchDown = NO;
    
    NSLog(@"mouseUp");
}

-(void)mouseMoved:(NSEvent *)event {
    CGPoint bezierPoint = [self bezierPoint:event.locationInWindow];
    [self updateBezierBoardLabels:bezierPoint];
}

- (void)updateBezierBoard:(NSEvent *)theEvent {
    // 贝塞尔曲线点
    CGPoint bezierPoint = [self bezierPoint:theEvent.locationInWindow];
    
    // 计算出 圆点 Center
    CGPoint roundButtonCenter = CGPointMake(theEvent.locationInWindow.x - RoundButtonDiameter / 2.0, theEvent.locationInWindow.y - RoundButtonDiameter / 2.0);
    CGPoint roundButtonCenterForBoard = [self.view convertPoint:theEvent.locationInWindow toView:self.bezierBoardView];
    
    // 边界判断
    if (bezierPoint.x < 0) {
        bezierPoint.x = 0;
        roundButtonCenter.x = self.bezierBoardView.frame.origin.x - RoundButtonDiameter / 2.0;
        roundButtonCenterForBoard.x = 0;
    }
    if (bezierPoint.x > 1) {
        bezierPoint.x = 1;
        roundButtonCenter.x = self.bezierBoardView.frame.origin.x + self.bezierBoardView.frame.size.width - RoundButtonDiameter / 2.0;
        roundButtonCenterForBoard.x = self.bezierBoardView.frame.size.width;
    }
    
    // 给予新的位置和重绘点，记录贝塞尔曲线点
    CGRect newFrame = CGRectMake(roundButtonCenter.x, roundButtonCenter.y, RoundButtonDiameter, RoundButtonDiameter);
    if (self.roundButton1Down) {
        // 按住到第一个点的
        self.roundButton1.frame = newFrame;
        self.bezierBoardView.point1 = roundButtonCenterForBoard;
        self.bezierDataPoint1 = bezierPoint;
    }else if (self.roundButton2Down){
        // 按住到第二个点的
        self.roundButton2.frame = newFrame;
        self.bezierBoardView.point2 = roundButtonCenterForBoard;
        self.bezierDataPoint2 = bezierPoint;
    }else if(self.blankTouchDown) {
        // 没点到点上，查找最近的点
        double dist1 = [self distanceBetween:roundButtonCenter and:self.bezierBoardView.point1];
        double dist2 = [self distanceBetween:roundButtonCenter and:self.bezierBoardView.point2];
        if (dist1 < dist2) {
            self.roundButton1.frame = newFrame;
            self.bezierDataPoint1 = bezierPoint;
            self.bezierBoardView.point1 = roundButtonCenterForBoard;
            self.roundButton1Down = YES;
        }else{
            self.roundButton2.frame = newFrame;
            self.bezierDataPoint2 = bezierPoint;
            self.bezierBoardView.point2 = roundButtonCenterForBoard;
            self.roundButton2Down = YES;
        }
        self.blankTouchDown = NO;
    }
    
    self.bezierTextField.stringValue = [NSString stringWithFormat:@"%.2f,%.2f,%.2f,%.2f",self.bezierDataPoint1.x,self.bezierDataPoint1.y,self.bezierDataPoint2.x,self.bezierDataPoint2.y];
    
    [self.view setNeedsDisplay:YES];
    [self updateBezierThumbnailsAll:NO];
}

- (IBAction)goAnimation:(id)sender{

    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position.x"];
    animation.toValue = @(self.previewLayerXPosition);
    animation.duration = self.speedSlider.doubleValue;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.timingFunction = [CAMediaTimingFunction functionWithControlPoints:self.bezierDataPoint2.x :self.bezierDataPoint2.y :self.bezierDataPoint2.x :self.bezierDataPoint2.y];
    [self.previewLayer1 addAnimation:animation forKey:nil];
    
    CABasicAnimation *animation2 = [CABasicAnimation animationWithKeyPath:@"position.x"];
    animation2.toValue = @(self.previewLayerXPosition);
    animation2.duration = self.speedSlider.doubleValue;
    animation2.timingFunction = [CAMediaTimingFunction functionWithControlPoints:self.originalBezierDataPoint1.x :self.originalBezierDataPoint1.y :self.originalBezierDataPoint1.x :self.originalBezierDataPoint1.y];
    animation2.fillMode = kCAFillModeForwards;
    animation2.removedOnCompletion = NO;
    [self.previewLayer2 addAnimation:animation2 forKey:nil];
    
    // 折返位置
    if (self.previewLayerXPosition == self.previewLayer1.bounds.size.width / 2.0) {
        self.previewLayerXPosition = self.bezierPreview1.bounds.size.width - (self.previewLayer1.bounds.size.width / 2.0);
    }else{
        self.previewLayerXPosition = self.previewLayer1.bounds.size.width / 2.0;
    }
}

#pragma mark -

- (void)updateBezierBoardLabels:(CGPoint)bezierPoint {
    NSString *leftString = @"PROGRESSION";
    NSString *footerString = @"TIME";
    
    if (bezierPoint.x >= 0 && bezierPoint.x <= 1) {
        footerString = [NSString stringWithFormat:@"TIME (%.f%%)",bezierPoint.x * 100];
        leftString = [NSString stringWithFormat:@"PROGRESSION (%.f%%)",bezierPoint.y * 100];
    }
    
    self.bezierBoardFooterTextField.stringValue = footerString;
    self.bezierBoardLeftTextField.stringValue = leftString;
}

- (IBAction)speedSliderAction:(NSSlider *)sender {
    self.speedTextField.stringValue = [NSString stringWithFormat:@"%.1fs",sender.floatValue];
}

@end
