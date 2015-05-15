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
        
    }
    return self;
}
@end
