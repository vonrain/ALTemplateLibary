//
//  BrandPriceListCell.h
//  ALTemplateLibary
//
//  Created by allen on 7/17/17.
//  Copyright © 2017 allen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BrandPriceListCell : UITableViewCell

- (void)generateData:(id)data;

+ (CGFloat)cellHeightAtIndexWithMaxItemCount:(NSInteger)count;
@end
