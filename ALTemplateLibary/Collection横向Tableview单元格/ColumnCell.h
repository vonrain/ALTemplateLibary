//
//  ColumnCell.h
//  AFTabledCollectionView
//
//  Created by allen on 6/27/17.
//  Copyright © 2017 Ash Furrow. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ColumnCellDelegate <NSObject>

- (void)scrollViewDidColumnCellScroll:(UIScrollView*)scrollView;

- (void)didDelete:(UICollectionViewCell *)cell;

@optional
- (void)resetLongPressGesture;

@end

@interface ColumnCell : UICollectionViewCell

@property (nonatomic, weak) id<ColumnCellDelegate> delegate;

-(void)generateData:(id)data;

- (void)showMask;

- (void)hiddenMask;
@end
