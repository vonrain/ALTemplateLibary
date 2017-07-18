//
//  BrandItemCell.m
//  ALTemplateLibary
//
//  Created by allen on 7/17/17.
//  Copyright © 2017 allen. All rights reserved.
//

#import "BrandItemCell.h"

@interface BrandItemCell ()

@property (nonatomic, strong) UIView *detialView;
@property (nonatomic, strong) UILabel *productsModelLabel;
@property (nonatomic, strong) UILabel *colorPriceLabel;
@property (nonatomic, strong) UIView *activityView;
@property (nonatomic, strong) UIView *leftLine;
@property (nonatomic, strong) UIView *rightLine;
@property (nonatomic, strong) NSArray *itemsArr;

@end

@implementation BrandItemCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor lightGrayColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)layoutPageView {
    [self.detialView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    [self.contentView addSubview:self.detialView];
    [self.detialView addSubview:self.productsModelLabel];
    [self.detialView addSubview:self.colorPriceLabel];
    [self.detialView addSubview:self.activityView];
    [self.detialView addSubview:self.leftLine];
    [self.detialView addSubview:self.rightLine];
    
    UIEdgeInsets padding = UIEdgeInsetsMake(1, 0, 1, 0);
    [self.detialView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentView).insets(padding);
    }];
    
    [self.productsModelLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.detialView);
        make.left.mas_equalTo(self.detialView);
        make.bottom.mas_equalTo(self.detialView);
        make.width.mas_equalTo(kProductsModelLabelWidth);
    }];
    
    [self.leftLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(1);
        make.top.mas_equalTo(self.productsModelLabel).offset(4);
        make.bottom.mas_equalTo(self.productsModelLabel).offset(-4);
        make.left.mas_equalTo(self.productsModelLabel.mas_right);
    }];
    
    [self.colorPriceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.productsModelLabel.mas_right);
        make.top.mas_equalTo(self.detialView);
        make.bottom.mas_equalTo(self.detialView);
        make.width.mas_equalTo(MainWidth-2*kProductsModelLabelWidth-20);
        
    }];
    
    [self.rightLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.leftLine);
        make.top.bottom.mas_equalTo(self.leftLine);
        make.left.mas_equalTo(self.colorPriceLabel.mas_right);
    }];
    
    [self.activityView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.right.mas_equalTo(self.detialView);
        make.bottom.mas_equalTo(self.detialView);
        make.left.mas_equalTo(self.colorPriceLabel.mas_right);
    }];
    
}

- (void)generateData:(id)data {
    
    //    self.itemsArr = (NSArray*)data;
    self.productsModelLabel.text = (NSString *)data;
//    self.colorPriceLabel.text = @"杨发送到发送到服务百八十的发送到发送到发鞍山地区阿斯顿发送到发送到哈社交恐惧；了；";
    self.colorPriceLabel.text = @"哈社交恐惧；了；";
    [self layoutPageView];
    
}

#pragma mark - Getter && Setter
- (UIView *)detialView {
    if (_detialView == nil) {
        _detialView = [[UIView alloc] init];
        _detialView.backgroundColor = [UIColor whiteColor];
    }
    return _detialView;
}


- (UIView *)activityView {
    if (_activityView == nil) {
        _activityView = [[UIView alloc] init];
        _activityView.backgroundColor = [UIColor whiteColor];
    }
    return _activityView;
}

- (UILabel *)productsModelLabel {
	if (_productsModelLabel == nil) {
        _productsModelLabel = [[UILabel alloc] init];
        _productsModelLabel.backgroundColor = [UIColor whiteColor];
	}
	return _productsModelLabel;
}
- (UILabel *)colorPriceLabel {
	if (_colorPriceLabel == nil) {
        _colorPriceLabel = [[UILabel alloc] init];
        _colorPriceLabel.backgroundColor = [UIColor whiteColor];
        _colorPriceLabel.numberOfLines = 0;
        _colorPriceLabel.preferredMaxLayoutWidth = (MainWidth-2*kProductsModelLabelWidth-20);
        _colorPriceLabel.lineBreakMode = NSLineBreakByWordWrapping;
	}
	return _colorPriceLabel;
}


- (UIView *)leftLine {
	if (_leftLine == nil) {
        _leftLine = [[UIView alloc] init];
        _leftLine.backgroundColor = [UIColor lightGrayColor];
	}
	return _leftLine;
}
- (UIView *)rightLine {
	if (_rightLine == nil) {
        _rightLine = [[UIView alloc] init];
        _rightLine.backgroundColor = [UIColor lightGrayColor];
	}
	return _rightLine;
}
@end
