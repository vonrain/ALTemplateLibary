//
//  ProductTVCell.h
//  ALTemplateLibary
//
//  Created by allen on 7/10/17.
//  Copyright © 2017 allen. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ProductCellDelegate <NSObject>

- (void)didDelete:(UITableViewCell *)cell;

@optional
- (void)resetLongPressGesture;

@end


@interface ProductTVCell : UITableViewCell

@property (nonatomic, weak) id<ProductCellDelegate> delegate;

- (void)generateData:(id)data;

- (void)showMask;

- (void)hiddenMask;
@end
