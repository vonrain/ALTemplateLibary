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
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = NO;
        self.layer.shadowOpacity = 0.15f;
        self.layer.shadowRadius = 5.0f;
        
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
        make.right.centerY.mas_equalTo(self.contentView).offset(-1);
    }];
}


-(void)generateData:(id)data {
    
    self.title.text = ((NSMutableDictionary *)data)[kParityListVCProductName];
    
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
        _title.font = [UIFont systemFontOfSize:9];
        _title.textAlignment = NSTextAlignmentCenter;
	}
	return _title;
}
- (UIButton *)closeBtn {
	if (_closeBtn == nil) {
        _closeBtn = [[UIButton alloc] init];
//        _closeBtn.backgroundColor = [UIColor redColor];
        [_closeBtn setImage:[UIImage imageNamed:@"关闭"] forState:UIControlStateNormal];
        [_closeBtn setImageEdgeInsets:UIEdgeInsetsMake(8, 0, 6, 4)];
        [_closeBtn addTarget:self action:@selector(delCell:) forControlEvents:UIControlEventTouchUpInside];
	}
	return _closeBtn;
}
@end
