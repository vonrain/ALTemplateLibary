//
//  ProductItemCell.h
//  ALTemplateLibary
//
//  Created by allen on 7/11/17.
//  Copyright © 2017 allen. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ProductItemCellDelegate <NSObject>

-(void)toTop:(UITableViewCell*)cell;

@end

@interface ProductItemCell : UITableViewCell

@property (nonatomic, weak) id<ProductItemCellDelegate> delegate;

- (void)generateData:(id)data;
@end
