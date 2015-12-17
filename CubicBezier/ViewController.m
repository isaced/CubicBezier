//
//  ViewController.m
//  CubicBezier
//
//  Created by isaced on 15/2/28.
//
//

#import "ViewController.h"
#import <QuartzCore/CoreAnimation.h>

@interface ViewController()

@property (strong) RoundButton *roundButton1;
@property (strong) RoundButton *roundButton2;

// 标识两个圆点的松开状态
@property (assign) BOOL roundButton1Up;
@property (assign) BOOL roundButton2Up;

@property (assign) CGPoint bezierPoint1;
@property (assign) CGPoint bezierPoint2;

@property (strong) CALayer *previewLayer1;
@property (strong) CALayer *previewLayer2;

@property (assign) CGFloat previewLayerXPosition;

@end

@implementation ViewController

// 坐标转换

- (CGPoint)boardPoint:(CGPoint)p{
    return CGPointMake(self.bezierBoardView.frame.origin.x + p.x * 200.0,
                       self.bezierBoardView.frame.origin.y + p.y * 200.0);
}

/**
 *  把鼠标拖动的锚点坐标转换成贝塞尔曲线所用的坐标点（以 bezierBoardView 正方形区域 0 ~ 1 范围）
 */
- (CGPoint)bezierPoint:(CGPoint)p{
    CGPoint point = [self.view convertPoint:p toView:self.bezierBoardView];
    
//    point.x -= RoundButtonDiameter / 2.0;
//    point.y -= RoundButtonDiameter / 2.0;
    
    point.x /= self.bezierBoardView.frame.size.width;
    point.y /= self.bezierBoardView.frame.size.height;
    return point;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.bezierPoint1 = CGPointMake(0.2, 0.7);
    self.bezierPoint2 = CGPointMake(0.7, 0.2);
    
    NSColor *color1 = [NSColor colorWithRed:244 / 255.0 green:0 blue:221 / 255.0 alpha:1];
    NSColor *color2 = [NSColor colorWithRed:35/255.0 green:154/255.0 blue:175/255.0 alpha:1];
    
    RoundButton *leftZero = [[RoundButton alloc] initWithFrame:NSMakeRect(self.bezierBoardView.frame.origin.x - RoundButtonDiameter / 2.0, self.bezierBoardView.frame.origin.y - RoundButtonDiameter / 2.0, RoundButtonDiameter, RoundButtonDiameter)];
    RoundButton *rightZero = [[RoundButton alloc] initWithFrame:NSMakeRect(self.bezierBoardView.frame.origin.x - RoundButtonDiameter / 2.0 + self.bezierBoardView.frame.size.width, self.bezierBoardView.frame.origin.y - RoundButtonDiameter / 2.0 + self.bezierBoardView.frame.size.height, RoundButtonDiameter, RoundButtonDiameter)];
    leftZero.showBorder = YES;
    rightZero.showBorder = YES;
    [self.view addSubview:leftZero];
    [self.view addSubview:rightZero];
    
    // 动态点
    CGPoint point1 = [self boardPoint:self.bezierPoint1];
    self.roundButton1 = [[RoundButton alloc] initWithFrame:NSMakeRect(point1.x + self.bezierBoardView.frame.origin.x - RoundButtonDiameter / 2.0, point1.y + self.bezierBoardView.frame.origin.y - RoundButtonDiameter / 2.0, RoundButtonDiameter, RoundButtonDiameter)];
    self.roundButton1.backgroundColor = color1;
    [self.view addSubview:self.roundButton1];
    
    
    CGPoint point2 = [self boardPoint:self.bezierPoint2];
    self.roundButton2 = [[RoundButton alloc] initWithFrame:NSMakeRect(point2.x + self.bezierBoardView.frame.origin.x - RoundButtonDiameter / 2.0, point2.y + self.bezierBoardView.frame.origin.y - RoundButtonDiameter / 2.0, RoundButtonDiameter, RoundButtonDiameter)];
    self.roundButton2.backgroundColor = color2;
    [self.view addSubview:self.roundButton2];
    
    self.bezierBoardView.point1 = point1;
    self.bezierBoardView.point2 = point2;
    
    self.bezierTextField.stringValue = @"0.2,0.7,0.7,0.2";
    
    // Animation Layer
    
    CGRect previewLayerRect = CGRectMake(50, 0, 50, 50);
    
    self.previewLayer1 = [CALayer layer];
    self.previewLayer1.frame = previewLayerRect;
    self.previewLayer1.backgroundColor = color1.CGColor;
    self.previewLayer1.cornerRadius = 6.0;
    [self.bezierPreview1.layer addSublayer:self.previewLayer1];
    
    self.previewLayer2 = [CALayer layer];
    self.previewLayer2.frame = previewLayerRect;
    self.previewLayer2.backgroundColor = color2.CGColor;
    self.previewLayer2.cornerRadius = 6.0;
    [self.bezierPreview2.layer addSublayer:self.previewLayer2];
    
    self.previewLayerXPosition = 50.0;
    
    [self goAnimation:nil];
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

-(void)mouseDown:(NSEvent *)theEvent{
    if (NSPointInRect(theEvent.locationInWindow, self.roundButton1.frame)) {
        self.roundButton1Up = YES;
    }else if(NSPointInRect(theEvent.locationInWindow, self.roundButton2.frame)){
        self.roundButton2Up = YES;
    }
    NSLog(@"mouseDown:%@",NSStringFromPoint(theEvent.locationInWindow));
}

-(void)mouseDragged:(NSEvent *)theEvent{
    
    // 贝塞尔曲线点
    CGPoint bezierPoint = [self bezierPoint:theEvent.locationInWindow];

    // 计算出 圆点 Center
    CGPoint roundButtonCenter = CGPointMake(theEvent.locationInWindow.x - RoundButtonDiameter / 2.0, theEvent.locationInWindow.y - RoundButtonDiameter / 2.0);
    CGPoint roundButtonCenterForBoard = [self.view convertPoint:theEvent.locationInWindow toView:self.bezierBoardView];
    
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
    CGRect newFrame = CGRectMake(roundButtonCenter.x,
                                  roundButtonCenter.y,
                                  RoundButtonDiameter,
                                  RoundButtonDiameter);
    if (self.roundButton1Up) {
        self.roundButton1.frame = newFrame;
        self.bezierBoardView.point1 = roundButtonCenterForBoard;
        self.bezierPoint1 = bezierPoint;
    }else if (self.roundButton2Up){
        self.roundButton2.frame = newFrame;
        self.bezierBoardView.point2 = roundButtonCenterForBoard;
        self.bezierPoint2 = bezierPoint;
    }
    
    self.bezierTextField.stringValue = [NSString stringWithFormat:@"%.2f,%.2f,%.2f,%.2f",self.bezierPoint1.x,self.bezierPoint1.y,self.bezierPoint2.x,self.bezierPoint2.y];
    
    [self.view setNeedsDisplay:YES];
    
    NSLog(@"mouseDragged:%@",NSStringFromPoint(bezierPoint));
}

-(void)mouseUp:(NSEvent *)theEvent{
    self.roundButton1Up = NO;
    self.roundButton2Up = NO;
    NSLog(@"mouseUp");
}

- (IBAction)goAnimation:(id)sender{

    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position.x"];
    animation.toValue = @(self.previewLayerXPosition);
    animation.duration = 1.0;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    [self.previewLayer1 addAnimation:animation forKey:nil];
    
    CABasicAnimation *animation2 = [CABasicAnimation animationWithKeyPath:@"position.x"];
    animation2.toValue = @(self.previewLayerXPosition);
    animation2.duration = 1.0;
    animation2.timingFunction = [CAMediaTimingFunction functionWithControlPoints:self.bezierPoint2.x :self.bezierPoint2.y :self.bezierPoint2.x :self.bezierPoint2.y];
    animation2.fillMode = kCAFillModeForwards;
    animation2.removedOnCompletion = NO;
    [self.previewLayer2 addAnimation:animation2 forKey:nil];
    
    // 折返位置
    if (self.previewLayerXPosition == 50.0) {
        self.previewLayerXPosition = 190.0;
    }else{
        self.previewLayerXPosition = 50.0;
    }
}

@end
