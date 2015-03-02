//
//  BezierPreviewView.m
//  CubicBezier
//
//  Created by isaced on 15/3/2.
//
//

#import "BezierPreviewView.h"

@implementation BezierPreviewView

-(instancetype)initWithCoder:(NSCoder *)coder{
    if ([super initWithCoder:coder]) {
        // init
        self.wantsLayer = YES;
        self.layer.cornerRadius = 6.0;
        
    }
    return self;
}

-(void)drawRect:(NSRect)dirtyRect{
    
//    CGFloat viewWidth = dirtyRect.size.width;
//    CGFloat viewHeight = dirtyRect.size.height;

    [self.backgroundColor setFill];
    NSRectFill(dirtyRect);
}

- (BOOL) wantsDefaultClipping { return NO; } // thanks stackoverflow.com

@end
