//
//  BrandPriceListCell.h
//  ALTemplateLibary
//
//  Created by allen on 7/17/17.
//  Copyright © 2017 allen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BrandPriceListCell;
@protocol BrandPriceListCellDelegate <NSObject>

-(void)refrashHeight:(BrandPriceListCell *)cell;
@end

@interface BrandPriceListCell : UITableViewCell

@property (nonatomic, weak) id<BrandPriceListCellDelegate> delegate;
- (void)generateData:(id)data;

- (CGFloat)caculationDataForHeight:(id)data;
+ (CGFloat)cellHeightAtIndexWithMaxItemCount:(NSInteger)count;
@end
