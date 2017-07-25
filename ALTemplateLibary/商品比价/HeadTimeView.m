//
//  HeadTimeView.m
//  ALTemplateLibary
//
//  Created by allen on 7/23/17.
//  Copyright © 2017 allen. All rights reserved.
//

#import "HeadTimeView.h"

@interface HeadTimeView ()

@property (nonatomic, strong) UILabel *timeNameLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIView *leftBottomLine;
@end

@implementation HeadTimeView

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
    [self addSubview:self.leftBottomLine];
    self.backgroundColor = [UIColor whiteColor];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(10);
        make.top.mas_equalTo(self);
        make.height.mas_equalTo(15);
        make.width.mas_equalTo(MainWidth/2);
    }];
    
    [self.leftBottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.timeLabel.mas_bottom);
        make.left.mas_equalTo(self.timeLabel);
        make.right.mas_equalTo(self.timeLabel.mas_right);
        make.height.mas_equalTo(1);
        
    }];
    
    [self.timeNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.timeLabel);
        make.left.mas_equalTo(self.timeLabel);
        make.top.mas_equalTo(self.leftBottomLine.mas_bottom);
    }];
}

- (void)generateData:(id)data{
    
    NSDictionary *dic = (NSDictionary *)data;
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
        _timeLabel.textColor = [UIColor lightGrayColor];
    }
    return _timeLabel;
}

- (UIView *)leftBottomLine {
    if (_leftBottomLine == nil) {
        _leftBottomLine = [[UIView alloc] init];
        _leftBottomLine.backgroundColor = [UIColor redColor];
    }
    return _leftBottomLine;
}

@end