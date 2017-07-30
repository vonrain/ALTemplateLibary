//
//  ColorSortingView.m
//  ALTemplateLibary
//
//  Created by allen on 7/24/17.
//  Copyright © 2017 allen. All rights reserved.
//

#import "ColorSortingView.h"
#import "ColorSortingBtn.h"

#define kShopNameLabelWidth 60
@interface ColorSortingView ()

@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UIView   *detialView;
@property (nonatomic, strong) UILabel   *shopName;
@property (nonatomic, strong) UILabel   *shopActive;
@property (nonatomic, strong) NSArray   *colorArrary;
@end

@implementation ColorSortingView

-(instancetype)init{
    if (self=[super init]) {
        //        self.frame=CGRectMake(0, 0, MainWidth, 44);
    }
    return self;
}

-(void)dealloc{
}

- (void)layoutPageView {
    
    [self addSubview:self.title];
    [self addSubview:self.detialView];
    [self.detialView addSubview:self.shopName];
    [self.detialView addSubview:self.shopActive];
    self.backgroundColor = [UIColor whiteColor];
    
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(self);
        make.height.mas_equalTo(30);
    }];
    
    [self.detialView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.title.mas_bottom);
        make.left.right.bottom.mas_equalTo(self);
    }];
    
    [self.shopName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.height.mas_equalTo(self.detialView);
        make.width.mas_equalTo(kShopNameLabelWidth);
    }];
    
    [self.shopActive mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.height.mas_equalTo(self.detialView);
        make.width.mas_equalTo(kShopNameLabelWidth);
    }];
    
    int btnWidth = (self.frame.size.width - kShopNameLabelWidth*2)/self.colorArrary.count;
    CGFloat pointX = 1;
    for (int i = 0; i < self.colorArrary.count; i++) {
        ColorSortingBtn *btn = [[ColorSortingBtn alloc] init];
        btn.backgroundColor = [UIColor orangeColor];
//        btn.titleLabel.font = [UIFont systemFontOfSize:9];
        
 
        [self.detialView addSubview:btn];
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(self.detialView);
            make.left.mas_equalTo(self.shopName.mas_right).offset(pointX);
            make.width.mas_equalTo(btnWidth);
        }];
        
        pointX +=btnWidth;
        btn.colorLabel.text = self.colorArrary[i];
        
        [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 1000 + i;
    }
}


- (void)generateData:(id)data{
    
    NSDictionary *bandInfo = (NSDictionary *)data;
    
    self.colorArrary = bandInfo[@"colorArray"];
    self.title.text = bandInfo[@"bandTitle"];
    
    [self layoutPageView];
}

#pragma Event Response

-(void)clickBtn:(UIButton *)sender {
    long index = sender.tag - 1000;
    MyLog(@"%@",self.colorArrary[index]);
}
#pragma mark - Setter && Getter

- (UILabel *)title {
	if (_title == nil) {
        _title = [[UILabel alloc] init];
        _title.backgroundColor = [UIColor whiteColor];
        _title.textAlignment = NSTextAlignmentCenter;
	}
	return _title;
}
- (UIView *)detialView {
	if (_detialView == nil) {
        _detialView = [[UIView alloc] init];
        _detialView.backgroundColor = [UIColor whiteColor];
	}
	return _detialView;
}
- (UILabel *)shopName {
	if (_shopName == nil) {
        _shopName = [[UILabel alloc] init];
        _shopName.backgroundColor = [UIColor orangeColor];
        _shopName.text = @"店铺名称";
        _shopName.textAlignment = NSTextAlignmentCenter;
        _shopName.font = [UIFont systemFontOfSize:9];
        _shopName.textColor = [UIColor whiteColor];
	}
	return _shopName;
}
- (UILabel *)shopActive {
	if (_shopActive == nil) {
        _shopActive = [[UILabel alloc] init];
        _shopActive.backgroundColor = [UIColor orangeColor];
        _shopActive.text = @"促销优惠";
        _shopActive.textAlignment = NSTextAlignmentCenter;
        _shopActive.font = [UIFont systemFontOfSize:9];
        _shopActive.textColor = [UIColor whiteColor];
	}
	return _shopActive;
}
- (NSArray *)colorArrary {
	if (_colorArrary == nil) {
        _colorArrary = [[NSArray alloc] init];
	}
	return _colorArrary;
}
@end