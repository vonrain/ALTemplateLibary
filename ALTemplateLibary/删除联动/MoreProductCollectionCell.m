//
//  MoreProductCollectionCell.m
//  ALTemplateLibary
//
//  Created by allen on 7/10/17.
//  Copyright © 2017 allen. All rights reserved.
//

#import "MoreProductCollectionCell.h"

@interface MoreProductCollectionCell ()

@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UIButton *closeBtn;

@end

@implementation MoreProductCollectionCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self layoutPageView];
    }
    return self;
}


-(void)layoutPageView {
    [self.contentView addSubview:self.title];
    [self.contentView addSubview:self.closeBtn];
    
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.mas_equalTo(self.contentView);
        make.right.mas_equalTo(self.closeBtn.mas_left);
    }];
    
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(10, 20));
        make.right.centerY.mas_equalTo(self.contentView);
    }];
}


-(void)generateData:(id)data {
    
    self.title.text = (NSString *)data;
    
}

- (void)delCell:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(didDelete:)]){
        [self.delegate didDelete:self];
    }
}

#pragma mark - setter && getter

- (UILabel *)title {
	if (_title == nil) {
        _title = [[UILabel alloc] init];
        _title.text = @"华为p10";
	}
	return _title;
}
- (UIButton *)closeBtn {
	if (_closeBtn == nil) {
        _closeBtn = [[UIButton alloc] init];
        _closeBtn.backgroundColor = [UIColor redColor];
        _closeBtn.titleLabel.text = @"-";
        [_closeBtn addTarget:self action:@selector(delCell:) forControlEvents:UIControlEventTouchUpInside];
	}
	return _closeBtn;
}
@end
