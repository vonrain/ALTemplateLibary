//
//  ColorSortingBtn.m
//  ALTemplateLibary
//
//  Created by allen on 7/24/17.
//  Copyright © 2017 allen. All rights reserved.
//

#import "ColorSortingBtn.h"

@interface ColorSortingBtn ()

@property (nonatomic, strong) UIImageView *arrorImage;
@end

@implementation ColorSortingBtn
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self layoutPageView];
    }
    return self;
}

- (void)layoutPageView {
    [self addSubview: self.colorLabel];
    [self addSubview: self.arrorImage];
    
    [self.colorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.mas_equalTo(self);
        make.right.mas_equalTo(self.arrorImage);
    }];
    
    [self.arrorImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).offset(1);
        make.bottom.mas_equalTo(self).offset(-1);
        make.right.mas_equalTo(self);
        make.width.mas_equalTo(8);
    }];
    
}


- (UILabel *)colorLabel {
	if (_colorLabel == nil) {
        _colorLabel = [[UILabel alloc] init];
        _colorLabel.font = [UIFont systemFontOfSize:9];
        _colorLabel.textColor = [UIColor whiteColor];
        _colorLabel.textAlignment = NSTextAlignmentCenter;
	}
	return _colorLabel;
}

- (UIImageView *)arrorImage {
	if (_arrorImage == nil) {
        _arrorImage = [[UIImageView alloc] init];
        _arrorImage.image = [UIImage imageNamed:@"排序三角"];
	}
	return _arrorImage;
}
@end
