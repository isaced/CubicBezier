//
//  LibraryCollectionViewItem.m
//  CubicBezier
//
//  Created by feeling on 2017/3/15.
//
//

#import "LibraryCollectionViewItem.h"

@interface LibraryCollectionViewItem ()

@end

@implementation LibraryCollectionViewItem

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    
    self.bezierImageView.wantsLayer = YES;
    self.bezierImageView.layer.backgroundColor = [NSColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1].CGColor;
    self.bezierImageView.layer.cornerRadius = 6.0;
    self.bezierImageView.layer.masksToBounds = YES;
}

@end
