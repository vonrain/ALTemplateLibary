//
//  HeadTipsView.m
//  ALTemplateLibary
//
//  Created by allen on 7/17/17.
//  Copyright © 2017 allen. All rights reserved.
//

#import "HeadTipsView.h"

@interface HeadTipsView ()

@property (nonatomic, strong) UILabel *timeNameLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *shopNameLabel;
@property (nonatomic, strong) UILabel *shopLabel;
@property (nonatomic, strong) UIView *leftBottomLine;
@property (nonatomic, strong) UIView *rightBottomLine;
@end

@implementation HeadTipsView

-(instancetype)init{
    if (self=[super init]) {
//        self.frame=CGRectMake(0, 0, MainWidth, 44);
        [self layoutPageView];
    }
    return self;
}

-(void)dealloc{
}

- (void)layoutPageView {

    [self addSubview:self.timeNameLabel];
    [self addSubview:self.timeLabel];
    [self addSubview:self.shopNameLabel];
    [self addSubview:self.shopLabel];
    [self addSubview:self.leftBottomLine];
    [self addSubview:self.rightBottomLine];
    
    int labelWidth = 50;
    [self.timeNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(labelWidth, 22));
        make.left.mas_equalTo(self).offset(10);
        make.top.mas_equalTo(self);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.timeNameLabel.mas_right);
        make.top.height.mas_equalTo(self.timeNameLabel);
        make.width.mas_equalTo(MainWidth/2 - labelWidth);
    }];
    
    [self.shopNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(labelWidth, 22));
        make.left.mas_equalTo(self.timeLabel.mas_right);
        make.top.mas_equalTo(self);
    }];
    
    [self.shopLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.shopNameLabel.mas_right);
        make.top.height.mas_equalTo(self.timeNameLabel);
        make.right.mas_equalTo(self);
    }];
    
    [self.leftBottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.timeNameLabel.mas_bottom).offset(3);
        make.left.mas_equalTo(self.timeNameLabel);
        make.right.mas_equalTo(self.timeLabel.mas_right).offset(-3);
        make.height.mas_equalTo(1);
        
    }];
    
    [self.rightBottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.height.mas_equalTo(self.leftBottomLine);
        make.left.mas_equalTo(self.shopNameLabel).offset(3);
        make.right.mas_equalTo(self).offset(-6);
    }];
    
}

- (void)generateData:(id)data{
    
    NSDictionary *dic = (NSDictionary *)data;
    self.shopLabel.text = @"联通华盛旗舰店";//dic[@"shop"];
    self.timeLabel.text = @"2017-03-11 11：54";//dic[@"time"];
}

- (UILabel *)timeNameLabel {
	if (_timeNameLabel == nil) {
        _timeNameLabel = [[UILabel alloc] init];
        _timeNameLabel.text = @"更新时间：";
        _timeNameLabel.textAlignment = NSTextAlignmentLeft;
        _timeNameLabel.font = [UIFont systemFontOfSize:9];
        
	}
	return _timeNameLabel;
}
- (UILabel *)timeLabel {
	if (_timeLabel == nil) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = [UIFont systemFontOfSize:9];
        _timeLabel.textAlignment = NSTextAlignmentLeft;
	}
	return _timeLabel;
}
- (UILabel *)shopNameLabel {
	if (_shopNameLabel == nil) {
        _shopNameLabel = [[UILabel alloc] init];
        _shopNameLabel.text = @"来源店铺：";
        _shopNameLabel.font = [UIFont systemFontOfSize:9];
        _shopNameLabel.textAlignment = NSTextAlignmentLeft;
	}
	return _shopNameLabel;
}
- (UILabel *)shopLabel {
	if (_shopLabel == nil) {
        _shopLabel = [[UILabel alloc] init];
        _shopLabel.font = [UIFont systemFontOfSize:9];
        _shopLabel.textAlignment = NSTextAlignmentLeft;
	}
	return _shopLabel;
}


- (UIView *)leftBottomLine {
	if (_leftBottomLine == nil) {
        _leftBottomLine = [[UIView alloc] init];
        _leftBottomLine.backgroundColor = [UIColor redColor];
	}
	return _leftBottomLine;
}
- (UIView *)rightBottomLine {
	if (_rightBottomLine == nil) {
        _rightBottomLine = [[UIView alloc] init];
        _rightBottomLine.backgroundColor = [UIColor redColor];
	}
	return _rightBottomLine;
}
@end
