//
//  RoundButton.m
//  CubicBezier
//
//  Created by isaced on 15/2/28.
//
//

#import "RoundButton.h"

@implementation RoundButton

-(instancetype)init{
    if ([super init]) {
        [self initUI];
    }
    return self;
}

-(instancetype)initWithFrame:(NSRect)frameRect{
    if ([super initWithFrame:frameRect]) {
        [self initUI];
    }
    return self;
}

-(void)initUI{
    self.wantsLayer = YES;
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = RoundButtonDiameter / 2.0;
    self.layer.borderWidth = 1.0;
    self.layer.borderColor = [NSColor lightGrayColor].CGColor;
    
    self.backgroundColor = [NSColor whiteColor];
}

-(void)drawRect:(NSRect)dirtyRect{
    [self.backgroundColor setFill];
    NSRectFill(dirtyRect);
}

- (BOOL) wantsDefaultClipping { return NO; } // thanks stackoverflow.com

@end
