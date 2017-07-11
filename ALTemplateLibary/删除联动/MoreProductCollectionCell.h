//
//  MoreProductCollectionCell.h
//  ALTemplateLibary
//
//  Created by allen on 7/10/17.
//  Copyright © 2017 allen. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MoreProductCollectionCellDelegate <NSObject>

- (void)didDelete:(UICollectionViewCell *)cell;

@end

@interface MoreProductCollectionCell : UICollectionViewCell

@property (nonatomic, weak) id<MoreProductCollectionCellDelegate> delegate;

-(void)generateData:(id)data;

@end
