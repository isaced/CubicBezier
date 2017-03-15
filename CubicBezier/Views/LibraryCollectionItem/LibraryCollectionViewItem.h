//
//  LibraryCollectionViewItem.h
//  CubicBezier
//
//  Created by feeling on 2017/3/15.
//
//

#import <Cocoa/Cocoa.h>

@interface LibraryCollectionViewItem : NSCollectionViewItem

@property (weak) IBOutlet NSImageView *bezierImageView;
@property (weak) IBOutlet NSTextField *nameTextField;

@end
