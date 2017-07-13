//
//  ProductHeadView.m
//  ALTemplateLibary
//
//  Created by allen on 7/12/17.
//  Copyright © 2017 allen. All rights reserved.
//

#import "ProductHeadView.h"

@interface ProductHeadView ()

@property (nonatomic, strong) UILabel *productNameLabel;
@property (nonatomic, strong) UILabel *leftLabel;
@property (nonatomic, strong) UILabel *rightLabel;

@end

@implementation ProductHeadView
- (instancetype)init {
    self = [super init];
    if (self) {
        [self layoutPageView];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self layoutPageView];
    }
    return self;
}

-(void)generateData:(id)data{
    
    self.productNameLabel.text = (NSString *)data;
}

- (void)layoutPageView{
    [self addSubview:self.productNameLabel];
    [self addSubview:self.leftLabel];
    [self addSubview:self.rightLabel];
    
    [self.productNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.mas_equalTo(self);
        make.bottom.mas_equalTo(self.leftLabel.mas_top);
    }];
    
    [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.mas_equalTo(self);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(kProductItemShopNameWidth);
    }];
    
    [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.mas_equalTo(self);
        make.top.mas_equalTo(self.leftLabel);
        make.left.mas_equalTo(self.leftLabel.mas_right).offset(1).priority(900);
    }];
    
}

#pragma mark - Getter && Setter

- (UILabel *)productNameLabel {
	if (_productNameLabel == nil) {
        _productNameLabel = [[UILabel alloc] init];
        _productNameLabel.text = @"华为P10";
        _productNameLabel.backgroundColor = [UIColor whiteColor];
        _productNameLabel.textAlignment = NSTextAlignmentCenter;
	}
	return _productNameLabel;
}
- (UILabel *)leftLabel {
	if (_leftLabel == nil) {
        _leftLabel = [[UILabel alloc] init];
        _leftLabel.text = @"店铺";
        _leftLabel.textColor = [UIColor whiteColor];
        _leftLabel.textAlignment = NSTextAlignmentCenter;
        _leftLabel.backgroundColor = [UIColor orangeColor];
	}
	return _leftLabel;
}

- (UILabel *)rightLabel {
	if (_rightLabel == nil) {
        _rightLabel = [[UILabel alloc] init];
        _rightLabel.backgroundColor = [UIColor orangeColor];
	}
	return _rightLabel;
}
@end
