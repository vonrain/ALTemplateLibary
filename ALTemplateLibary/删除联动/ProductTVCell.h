//
//  ProductTVCell.h
//  ALTemplateLibary
//
//  Created by allen on 7/10/17.
//  Copyright © 2017 allen. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ProductTVCell;
@protocol ProductCellDelegate <NSObject>

- (void)didDelete:(UITableViewCell *)cell;
@optional
- (void)resetLongPressGesture;

-(void)refrashHeight:(ProductTVCell *)cell;

@end


@interface ProductTVCell : UITableViewCell

@property (nonatomic, weak) id<ProductCellDelegate> delegate;

- (void)generateData:(id)data;

- (void)showMask;

- (void)hiddenMask;
@end
