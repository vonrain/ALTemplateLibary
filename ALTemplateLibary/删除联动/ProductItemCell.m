//
//  ProductItemCell.m
//  ALTemplateLibary
//
//  Created by allen on 7/11/17.
//  Copyright © 2017 allen. All rights reserved.
//

#import "ProductItemCell.h"

@interface ProductItemCell ()

@property (nonatomic, strong) UIView *detialView;
@property (nonatomic, strong) UIView *productsView;
@property (nonatomic, strong) UIView *shopNameView;
@property (nonatomic, strong) UIView *activityView;

@property (nonatomic, strong) UILabel *shopName;
@property (nonatomic, strong) UIButton *topBtn;

@property (nonatomic, strong) NSArray *itemsArr;

@end

@implementation ProductItemCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
//        [self layoutPageView];
    }
    return self;
}

- (void)layoutPageView {
    
    [self.detialView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    [self.contentView addSubview:self.detialView];
    [self.detialView addSubview:self.shopNameView];
    [self.detialView addSubview:self.productsView];
    [self.detialView addSubview:self.activityView];
    
    [self.shopNameView addSubview:self.shopName];
    [self.shopNameView addSubview:self.topBtn];
    
    [self.detialView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentView);
    }];
    
    [self.shopNameView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(self.detialView);
        make.bottom.mas_equalTo(self.productsView);
        make.width.mas_equalTo(kProductItemShopNameWidth);
    }];
    
    [self.productsView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.detialView);
        make.left.mas_equalTo(self.shopNameView.mas_right).offset(1);
        make.right.mas_equalTo(self.activityView.mas_left).offset(-1);
        make.bottom.mas_equalTo(self.detialView);
    }];
    
    [self.activityView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.right.mas_equalTo(self.detialView);
        make.bottom.mas_equalTo(self.productsView);
        make.width.mas_equalTo(60);
    }];
    
    [self.shopName mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(60, 40));
        make.center.mas_equalTo(self.shopNameView);
    }];
    
    [self.topBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(15, 15));
        make.top.right.mas_equalTo(self.shopNameView);
    }];
}

- (void)layoutDetialView {
    
//    [self.detialView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
}

-(void)remarkLayoutPageView {
    
    
}

- (void)generateData:(id)data {
    
//    self.itemsArr = (NSArray*)data;
    self.shopName.text = (NSString *)data;
    [self layoutPageView];
}


-(void)addTarget:(id)target action:(SEL)action {
    //    [self.rightButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - Event
- (void)toTop:(UIButton*)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(toTop:)]) {
        [self.delegate toTop:self];
    }
}

#pragma mark - Getter && Setter
- (UIView *)detialView {
    if (_detialView == nil) {
        _detialView = [[UIView alloc] init];
        _detialView.layer.borderColor=[UIColor grayColor].CGColor;
        _detialView.layer.borderWidth=0.5;
    }
    return _detialView;
}


- (UIView *)productsView {
	if (_productsView == nil) {
        _productsView = [[UIView alloc] init];
        _productsView.backgroundColor = [UIColor yellowColor];
	}
	return _productsView;
}
- (UIView *)shopNameView {
	if (_shopNameView == nil) {
        _shopNameView = [[UIView alloc] init];
        _shopNameView.backgroundColor = [UIColor grayColor];
	}
	return _shopNameView;
}
- (UIView *)activityView {
	if (_activityView == nil) {
        _activityView = [[UIView alloc] init];
        
        _activityView.backgroundColor = [UIColor orangeColor];
	}
	return _activityView;
}
- (UILabel *)shopName {
	if (_shopName == nil) {
        _shopName = [[UILabel alloc] init];
        _shopName.backgroundColor = [UIColor redColor];
        _shopName.text = @"广西联通";
        _shopName.font = [UIFont systemFontOfSize:11];
	}
	return _shopName;
}
- (UIButton *)topBtn {
	if (_topBtn == nil) {
        _topBtn = [[UIButton alloc] init];
        _topBtn.backgroundColor = [UIColor orangeColor];
        [_topBtn addTarget:self action:@selector(toTop:) forControlEvents:UIControlEventTouchUpInside];
	}
	return _topBtn;
}

@end