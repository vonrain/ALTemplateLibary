//
//  ProductItemCell.m
//  ALTemplateLibary
//
//  Created by allen on 7/11/17.
//  Copyright © 2017 allen. All rights reserved.
//

#import "ProductItemCell.h"
#import "YYText.h"
#import "NSString+Range.h"

@interface ProductItemCell ()

@property (nonatomic, strong) UIView *detialView;
@property (nonatomic, strong) UIView *shopNameView;
@property (nonatomic, strong) UIView *activityView;
@property (nonatomic, strong) UILabel *shopName;
@property (nonatomic, strong) UIButton *topBtn;

@property (nonatomic, strong) NSArray *itemsArr;

@property (nonatomic, strong) YYLabel *colorPriceLabel;
@property (nonatomic, strong) UIView *leftLine;
@property (nonatomic, strong) UIView *rightLine;
@property (nonatomic, strong) NSArray *activeArr;
@property (nonatomic, strong) NSDictionary *brandItemDic;

@end

@implementation ProductItemCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
//        [self layoutPageView];
        self.contentView.backgroundColor = [ALHelper createColorByHex:@"#F2F3F7"];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)layoutPageView {
    
    [self.shopNameView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.detialView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    [self.contentView addSubview:self.detialView];
    [self.detialView addSubview:self.shopNameView];
    [self.detialView addSubview:self.colorPriceLabel];
    [self.detialView addSubview:self.activityView];
    [self.detialView addSubview:self.leftLine];
    [self.detialView addSubview:self.rightLine];
    
    [self.shopNameView addSubview:self.shopName];
    [self.shopNameView addSubview:self.topBtn];
    
    UIEdgeInsets padding = UIEdgeInsetsMake(1, 0, 1, 0);
    CGFloat spacing = 0;
    [self.detialView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentView).insets(padding);
    }];
    
    [self.shopNameView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(self.detialView);
        make.bottom.mas_equalTo(self.detialView);
        make.width.mas_equalTo(kProductItemShopNameWidth);
    }];
    
    [self.leftLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(1);
        make.top.mas_equalTo(self.shopNameView).offset(4);
        make.bottom.mas_equalTo(self.shopNameView).offset(-4);
        make.left.mas_equalTo(self.shopNameView.mas_right);
    }];
    
    
    [self.colorPriceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.leftLine.mas_right).offset(spacing);
        make.top.mas_equalTo(self.detialView);
        make.bottom.mas_equalTo(self.detialView);
        make.width.mas_equalTo(MainWidth-kProductItemShopNameWidth-kActiveViewWidth - 2*kPaddingWidth -2);
        
    }];
    
    [self.activityView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.mas_equalTo(self.detialView);
        make.width.mas_equalTo(kActiveViewWidth);
    }];
    
    [self.shopName mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.mas_equalTo(self.shopNameView);
        make.right.mas_equalTo(self.topBtn.mas_left);
    }];
    
    [self.topBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(15, 15));
        make.top.right.mas_equalTo(self.shopNameView);
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

- (void)layoutDetialView {
    
//    [self.detialView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
}

-(void)remarkLayoutPageView {
    
    
}

- (void)generateData:(id)data {
    
    
    NSDictionary *dic = (NSDictionary*)data;
    self.brandItemDic = dic;
    self.shopName.text = dic[@"shopName"];
    
//    self.productsModelLabel.text = [NSString stringWithFormat:@"%@/%@/%@",dic[@"modelName"],dic[@"systemStandard"],dic[@"memory"]];
    NSArray *arr = dic[@"modelInfoList"];
    
    NSMutableString *str = [NSMutableString new];
    for (NSDictionary *item in arr) {
        [str appendFormat:@"%@ %@",item[@"systemStandard"],item[@"memory"]];
        NSArray *colorsArrary = item[@"skuInfoList"];
        for (NSDictionary *colorItme in colorsArrary){
            [str appendFormat:@"%@ (%@) ",colorItme[@"skuColor"],colorItme[@"gdsPrice"]];
        }
    }
    
    [str appendFormat:@"\n"];
    self.colorPriceLabel.attributedText = [self titleOK:arr];
    
    
    self.activeArr = dic[@"activityList"];
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

- (NSMutableAttributedString *)titleOK:(NSArray *)itemsArr {
    
    // 颜色价格
    NSMutableString *str = [NSMutableString new];
//    for (NSDictionary *item in itemsArr) {
    for (int i = 0; i < itemsArr.count; i++) {
        NSDictionary *item = itemsArr[i];
        // arr 是modelInfoList 型号列表
        [str appendFormat:@"%@ %@",item[@"systemStandard"],item[@"memory"]];
        NSArray *colorsArrary = item[@"skuInfoList"];
        for (NSDictionary *colorItme in colorsArrary){
            // colorsArray 是颜色列表 skuInfoList
            [str appendFormat:@"%@ (%@) ",colorItme[@"skuColor"],colorItme[@"gdsPrice"]];
        }
        
        [str appendFormat:@"\n"];
    }
    
    
    NSString *orgStr = [str copy];
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:orgStr];
    [text yy_setFont:[UIFont systemFontOfSize:9] range:text.yy_rangeOfAll];
    
    __weak __typeof(&*self)weakSelf = self;
    
    for (int n = 0; n < itemsArr.count; n++) {
            NSDictionary *item = itemsArr[n];
            
        NSArray *arr = item[@"skuInfoList"];
        
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
                                             MyLog(@"%@",model[@"gdsPrice"]);
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
                                             MyLog(@"%@",model[@"skuColor"]);
                                             NSDictionary *info = @{@"type":@"color",
                                                                    @"param":model
                                                                    };
                                             [[NSNotificationCenter defaultCenter] postNotificationName:kParityListClickItemNotification object:weakSelf userInfo:info];
                                         }
                                     }];
                
                
            }
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
    [[NSNotificationCenter defaultCenter] postNotificationName:kParityListClickItemNotification object:self userInfo:info];
}

- (void)clickModelBtn:(UIButton *)sender {
    NSDictionary *dic = self.brandItemDic;
    NSDictionary *info = @{@"type":@"model",
                           @"param":dic
                           };
    [[NSNotificationCenter defaultCenter] postNotificationName:kParityListClickItemNotification object:self userInfo:info];
}


- (CGFloat)activeHeight {
    
    return self.activeArr.count * 20;
}


#pragma mark - Getter && Setter
- (UIView *)detialView {
    if (_detialView == nil) {
        _detialView = [[UIView alloc] init];
//        _detialView.backgroundColor = [UIColor whiteColor];
        _detialView.backgroundColor = [ALHelper createColorByHex:@"#F2F3F7"] ;
    }
    return _detialView;
}

- (UIView *)shopNameView {
	if (_shopNameView == nil) {
        _shopNameView = [[UIView alloc] init];
        _shopNameView.backgroundColor = [UIColor whiteColor];
	}
	return _shopNameView;
}
- (UIView *)activityView {
	if (_activityView == nil) {
        _activityView = [[UIView alloc] init];
        _activityView.backgroundColor = [UIColor whiteColor];
	}
	return _activityView;
}
- (UILabel *)shopName {
	if (_shopName == nil) {
        _shopName = [[UILabel alloc] init];
//        _shopName.backgroundColor = [UIColor whiteColor];
        _shopName.textAlignment = NSTextAlignmentCenter;
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

- (YYLabel *)colorPriceLabel {
    if (_colorPriceLabel == nil) {
        _colorPriceLabel = [[YYLabel alloc] init];
        _colorPriceLabel.backgroundColor = [UIColor whiteColor];
        _colorPriceLabel.numberOfLines = 0;
        _colorPriceLabel.preferredMaxLayoutWidth = (MainWidth-kProductItemShopNameWidth-kActiveViewWidth - 2*kPaddingWidth -2);
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
