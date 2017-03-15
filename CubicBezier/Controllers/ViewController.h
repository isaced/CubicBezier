//
//  ViewController.h
//  CubicBezier
//
//  Created by isaced on 15/2/28.
//
//

#import <Cocoa/Cocoa.h>
#import "BezierBoardView.h"
#import "RoundButton.h"
#import "BezierPreviewView.h"

@interface ViewController : NSViewController

@property (strong) IBOutlet BezierBoardView *bezierBoardView;

@property (strong) IBOutlet NSTextField *bezierTextField;
@property (strong) IBOutlet BezierPreviewView *bezierPreview1;
@property (strong) IBOutlet BezierPreviewView *bezierPreview2;
@property (weak) IBOutlet NSSlider *speedSlider;

@property (weak) IBOutlet NSTextField *bezierBoardFooterTextField;
@property (weak) IBOutlet NSTextField *bezierBoardLeftTextField;
@property (weak) IBOutlet NSTextField *speedTextField;

- (IBAction)goAnimation:(id)sender;

@end

