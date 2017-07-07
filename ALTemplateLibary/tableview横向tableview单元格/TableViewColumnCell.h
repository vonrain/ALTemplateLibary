//
//  TableViewColumnCell.h
//  AFTabledCollectionView
//
//  Created by allen on 6/30/17.
//  Copyright © 2017 Ash Furrow. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TableColumnCellDelegate <NSObject>

- (void)scrollViewDidColumnCellScroll:(UIScrollView*)scrollView;

- (void)didDelete:(UITableViewCell *)cell;

- (void)resetLongPressGesture;

@end

@interface TableViewColumnCell : UITableViewCell

@property (nonatomic, weak) id<TableColumnCellDelegate> delegate;

+(CGFloat)cellHeigh;

-(void)generateData:(id)data;

- (void)showMask;

- (void)hiddenMask;

@end