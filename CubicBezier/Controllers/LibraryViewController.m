//
//  LibraryViewController.m
//  CubicBezier
//
//  Created by feeling on 2017/3/15.
//
//

#import "LibraryViewController.h"
#import "LibraryCollectionViewItem.h"
#import "ControlPoint.h"

@interface LibraryViewController () <NSCollectionViewDataSource, NSCollectionViewDelegateFlowLayout>

@property (strong) NSArray<ControlPoint *> *controlPointList;

@end

@implementation LibraryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    
    self.controlPointList = @[[ControlPoint ease],[ControlPoint linear],[ControlPoint easeIn],[ControlPoint easeOut],[ControlPoint easeInOut]];
    
    self.collectionView.wantsLayer = YES;
    self.collectionView.backgroundColors = @[[NSColor clearColor]];
}

#pragma mark <NSCollectionViewDataSource>

-(NSInteger)numberOfSectionsInCollectionView:(NSCollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(NSCollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.controlPointList.count;
}

-(NSCollectionViewItem *)collectionView:(NSCollectionView *)collectionView itemForRepresentedObjectAtIndexPath:(NSIndexPath *)indexPath {
    LibraryCollectionViewItem *item = [collectionView makeItemWithIdentifier:@"LibraryCollectionViewItem" forIndexPath:indexPath];
    
    ControlPoint *controlPoint = self.controlPointList[indexPath.item];
    
    item.bezierImageView.image = [controlPoint thumbnailsImage];
    item.nameTextField.stringValue = controlPoint.name;
    
    return item;
}

-(NSSize)collectionView:(NSCollectionView *)collectionView layout:(NSCollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return NSMakeSize(76, 75);
}

@end


