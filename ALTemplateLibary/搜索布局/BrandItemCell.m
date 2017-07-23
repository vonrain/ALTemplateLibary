//
//  BrandItemCell.m
//  ALTemplateLibary
//
//  Created by allen on 7/17/17.
//  Copyright © 2017 allen. All rights reserved.
//

#import "BrandItemCell.h"
#import "YYText.h"
#import "NSString+Range.h"

@interface BrandItemCell ()

@property (nonatomic, strong) UIView *detialView;
@property (nonatomic, strong) UILabel *productsModelLabel;
@property (nonatomic, strong) UIButton *productsModelBtn;
@property (nonatomic, strong) YYLabel *colorPriceLabel;
//@property (nonatomic, strong) YYLabel  *titleTextLabel;
@property (nonatomic, strong) UIView *activityView;
@property (nonatomic, strong) UIView *leftLine;
@property (nonatomic, strong) UIView *rightLine;
@property (nonatomic, strong) NSArray *itemsArr;
@property (nonatomic, strong) NSArray *activeArr;
@property (nonatomic, strong) NSDictionary *brandItemDic;

@end

@implementation BrandItemCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [ALHelper createColorByHex:@"#F2F3F7"];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)layoutPageView {
    [self.activityView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.detialView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    [self.contentView addSubview:self.detialView];
    [self.detialView addSubview:self.productsModelLabel];
    [self.detialView addSubview:self.productsModelBtn];
    [self.detialView addSubview:self.colorPriceLabel];
    [self.detialView addSubview:self.activityView];
    [self.detialView addSubview:self.leftLine];
    [self.detialView addSubview:self.rightLine];
    
    UIEdgeInsets padding = UIEdgeInsetsMake(1, 0, 1, 0);
    CGFloat spacing = 5;
    [self.detialView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentView).insets(padding);
    }];
    
    [self.productsModelLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.detialView);
        make.left.mas_equalTo(self.detialView).offset(spacing);
        make.bottom.mas_equalTo(self.detialView);
        make.width.mas_equalTo(kProductsModelLabelWidth-spacing);
    }];
    
    [self.productsModelBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.productsModelLabel);
    }];
    
    [self.leftLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(2);
        make.top.mas_equalTo(self.productsModelLabel).offset(4);
        make.bottom.mas_equalTo(self.productsModelLabel).offset(-4);
        make.left.mas_equalTo(self.productsModelLabel.mas_right);
    }];
    
    [self.colorPriceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.leftLine.mas_right).offset(spacing);
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
        make.top.mas_equalTo(self.detialView);
        make.right.mas_equalTo(self.detialView).offset(-spacing);
        make.bottom.mas_equalTo(self.detialView);
        make.left.mas_equalTo(self.colorPriceLabel.mas_right).offset(spacing);
    }];
    
    CGFloat pointY = 2;
    for (int i = 0; i < self.activeArr.count; i++) {
        NSDictionary *activeItemDic = self.activeArr[i];
        UIButton *btn = [[UIButton alloc] init];
        btn.backgroundColor = [UIColor yellowColor];
        btn.titleLabel.font = [UIFont systemFontOfSize:9];
        [self.activityView addSubview:btn];
        
        [btn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.activityView).offset(2);
            make.right.mas_equalTo(self.activityView).offset(-2);
            make.height.mas_equalTo(18);
            make.top.mas_equalTo(self.activityView).offset(pointY);
        }];
        
        pointY += 20;
        [btn setTitle:activeItemDic[@"activityName"] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 1000 + i;
    }
    
}

- (void)generateData:(id)data {
    
    NSDictionary *dic = (NSDictionary*)data;
    self.brandItemDic = dic;
    
    self.productsModelLabel.text = [NSString stringWithFormat:@"%@/%@/%@",dic[@"modelName"],dic[@"systemStandard"],dic[@"memory"]];
    NSArray *arr = dic[@"skuInfoList"];
    
    // 颜色价格
    NSMutableString *str = [NSMutableString new];
    for (NSDictionary *item in arr) {
        [str appendFormat:@"%@ (%@)",item[@"skuColor"],item[@"gdsPrice"]];
    }
    
    NSString *colorPriceString = [str copy];
    
    self.colorPriceLabel.attributedText = [self titleOK:arr];
//    self.colorPriceLabel.text = colorPriceString;
    self.activeArr = dic[@"activityList"];
    [self layoutPageView];
    
}

- (NSMutableAttributedString *)titleOK:(NSArray *)arr {
    
    // 颜色价格
    NSMutableString *str = [NSMutableString new];
    for (NSDictionary *item in arr) {
        [str appendFormat:@"%@ %@ ",item[@"skuColor"],item[@"gdsPrice"]];
    }
    
    NSString *orgStr = [str copy];
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:orgStr];
    [text yy_setFont:[UIFont systemFontOfSize:9] range:text.yy_rangeOfAll];
    
    __weak __typeof(&*self)weakSelf = self;
//    for (NSDictionary *model in arr) {
    for (int j = 0; j < arr.count; j++) {
    
        NSDictionary *model = arr[j];
        NSMutableArray *rangeArr = [NSMutableArray new];
        NSString *tee = [[text string] copy];
        [[tee rangesOfString:model[@"gdsPrice"] options:0 serachRange:NSMakeRange(0, tee.length)]
         enumerateObjectsUsingBlock:^(NSValue *obj, NSUInteger idx, BOOL * _Nonnull stop) {
             NSRange ra = [obj rangeValue];
//             MyLog(@"my range is %@", NSStringFromRange(ra));
             [rangeArr addObject:NSStringFromRange(ra)];
         }] ;
        
        
        MyLog(@"rangeArr is %@", rangeArr);
        
        for (int k = 0; k < rangeArr.count; k++) {
            
            NSRange linkRange = NSRangeFromString(rangeArr[k]);
            [text yy_setTextHighlightRange:linkRange
                                     color:[UIColor colorWithRed:0.093 green:0.492 blue:1.000 alpha:1.000]
                           backgroundColor:[UIColor colorWithWhite:0.000 alpha:0.220]
                                 tapAction:^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect){
                                     NSString *title = [text.string substringWithRange:range];
                                     MyLog(@"\n text.string :%@",text.string);
                                     MyLog(@"\n title :%@",title);
                                     
                                     BOOL isFound = NO;
                                     int i = 0;
                                     for (i = 0; i < rangeArr.count; i++) {
                                         if([rangeArr[i] isEqualToString:NSStringFromRange(range)]){
                                             break;
                                         }
                                     }
                                     
                                     int f = 0;
                                     for (f = 0 ; f < arr.count; f++) {
                                         NSDictionary *model = arr[f];
                                         if ([model[@"gdsPrice"] isEqualToString:title]) {
                                             if(i == 0){
                                                 isFound = YES;
                                                 break;
                                             }
                                             else{
                                                 i--;
                                             }
                                         }
                                     }
                                     if(isFound){
                                         NSDictionary *model = arr[f];
                                         NSDictionary *info = @{@"type":@"color",
                                                                @"param":model
                                                                };
                                         [[NSNotificationCenter defaultCenter] postNotificationName:kShopPricListClickItemNotification object:weakSelf userInfo:info];
                                     }
                                 }];
            
            
        }
    }
    
    return text;
}

#pragma mark - EventResponse
- (void)clickBtn:(UIButton *)sender {
    long index = sender.tag -1000;
    NSDictionary *dic = self.activeArr[index];
    NSDictionary *info = @{@"type":@"active",
                            @"param":dic
                            };
    [[NSNotificationCenter defaultCenter] postNotificationName:kShopPricListClickItemNotification object:self userInfo:info];
}

- (void)clickModelBtn:(UIButton *)sender {
    NSDictionary *dic = self.brandItemDic;
    NSDictionary *info = @{@"type":@"model",
                            @"param":dic
                            };
    [[NSNotificationCenter defaultCenter] postNotificationName:kShopPricListClickItemNotification object:self userInfo:info];
}


- (CGFloat)activeHeight {
    
    return self.activeArr.count * 20;
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
        _productsModelLabel.font = [UIFont systemFontOfSize:9];
	}
	return _productsModelLabel;
}


- (UIButton *)productsModelBtn {
	if (_productsModelBtn == nil) {
        _productsModelBtn = [[UIButton alloc] init];
//        _productsModelBtn.backgroundColor = [UIColor clearColor];
        [_productsModelBtn addTarget:self action:@selector(clickModelBtn:) forControlEvents:UIControlEventTouchUpInside];
	}
	return _productsModelBtn;
}
- (YYLabel *)colorPriceLabel {
	if (_colorPriceLabel == nil) {
        _colorPriceLabel = [[YYLabel alloc] init];
        _colorPriceLabel.backgroundColor = [UIColor whiteColor];
        _colorPriceLabel.numberOfLines = 0;
        _colorPriceLabel.preferredMaxLayoutWidth = (MainWidth-2*kProductsModelLabelWidth-20);
        _colorPriceLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _colorPriceLabel.font = [UIFont systemFontOfSize:9];
	}
	return _colorPriceLabel;
}


- (UIView *)leftLine {
	if (_leftLine == nil) {
        _leftLine = [[UIView alloc] init];
        _leftLine.backgroundColor = [ALHelper createColorByHex:@"#F2F3F7"];
	}
	return _leftLine;
}
- (UIView *)rightLine {
	if (_rightLine == nil) {
        _rightLine = [[UIView alloc] init];
        _rightLine.backgroundColor = [ALHelper createColorByHex:@"#F2F3F7"];
	}
	return _rightLine;
}
@end
