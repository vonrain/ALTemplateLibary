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

#define kColorItemWidth (MainWidth-kProductItemShopNameWidth-kActiveViewWidth - 2*kPaddingWidth -2)
@interface ProductItemCell ()

@property (nonatomic, strong) UIView *detialView;
@property (nonatomic, strong) UIView *shopNameView;
@property (nonatomic, strong) UIView *colorView;
@property (nonatomic, strong) UIView *activityView;
@property (nonatomic, strong) UILabel *shopName;
@property (nonatomic, strong) UIButton *topBtn;

@property (nonatomic, strong) NSArray *itemsArr;

//@property (nonatomic, strong) YYLabel *colorPriceLabel;
@property (nonatomic, strong) NSMutableArray *modelsArray;
@property (nonatomic, strong) UIView *leftLine;
@property (nonatomic, strong) UIView *rightLine;
@property (nonatomic, strong) NSArray *activeArr;
@property (nonatomic, strong) NSDictionary *brandItemDic;

@property (nonatomic, assign) long lowestPrice;
@property (nonatomic, assign) NSRange lowestPriceRange;
@property (nonatomic, assign) BOOL isLowestPrice;
@property (nonatomic, assign) BOOL isLowPriceFirstPlace;
@property (nonatomic, assign) BOOL isLayoutLowPrice;

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
    
    [self.activityView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.colorView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.shopNameView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.detialView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    [self.contentView addSubview:self.detialView];
    [self.detialView addSubview:self.shopNameView];
    [self.detialView addSubview:self.colorView];
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
    
    [self.colorView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.leftLine.mas_right).offset(spacing);
            make.top.bottom.mas_equalTo(self.detialView);
            make.width.mas_equalTo(kColorItemWidth);
    }];
    
    // 单独处理下颜色标签
    [self layoutColorLabelView];
    
    [self.activityView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.mas_equalTo(self.detialView);
        make.width.mas_equalTo(kActiveViewWidth);
    }];
    
    [self.shopName mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.shopNameView);
    }];
    
    [self.topBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(15, 15));
        make.top.right.mas_equalTo(self.shopNameView);
    }];
    
    // 活动标签布局
    [self layoutActiveView];
}



- (void)layoutColorLabelView {
    
    
    // 制式颜色标签表
    CGFloat modelPadding = 0;
    for (int i = 0; i < self.modelsArray.count; i++) {
        YYLabel *colorPriceLabel = [self createColorPriceLabel];
        [self.colorView addSubview:colorPriceLabel];
        
        NSDictionary *item = self.modelsArray[i];
        NSMutableAttributedString * attributedText = [self modelString:item];
        CGFloat colorItemHeight = [self getMessageHeight:[attributedText string] andLabel:colorPriceLabel];
        colorPriceLabel.attributedText = attributedText;
        
        [colorPriceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.colorView).offset(modelPadding);
            make.centerX.mas_equalTo(self.colorView);
            make.height.mas_equalTo(colorItemHeight);
            make.width.mas_equalTo(kColorItemWidth -10);
        }];
        modelPadding += colorItemHeight;
        
        if (self.isLowPriceFirstPlace && !self.isLayoutLowPrice) {
            NSRange ra = self.lowestPriceRange;
            CGRect rect = [self boundingRectForCharacterRange:ra AttributedString:attributedText];
            UILabel *lowPrice = [self createLowPriceLabel];
            [colorPriceLabel addSubview:lowPrice];
            
            [lowPrice mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(7, 6));
                make.top.mas_equalTo(colorPriceLabel).offset(rect.origin.y);
                make.left.mas_equalTo(colorPriceLabel).offset(rect.origin.x+rect.size.width);
            }];
            
            self.isLayoutLowPrice = YES;
            MyLog(@"goodPrice Rect is %@", NSStringFromCGRect(rect));
            
        }
    }
    
}

- (void)layoutActiveView {
    
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
    //    [self.detialView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
}

-(void)remarkLayoutPageView {
    
    
}

- (void)generateData:(id)data {
    
    
    NSDictionary *dic = (NSDictionary*)data;
    self.brandItemDic = dic;
    self.shopName.text = dic[@"shopName"];
    
//    self.productsModelLabel.text = [NSString stringWithFormat:@"%@/%@/%@",dic[@"modelName"],dic[@"systemStandard"],dic[@"memory"]];
    
    self.modelsArray = dic[@"modelInfoList"];
    self.activeArr = dic[@"activityList"];
    
    // 获取最低价位置
    self.lowestPrice = [self whoIslowestPrice];
    
    self.isLowestPrice = NO;
    self.isLowPriceFirstPlace = NO;
    self.isLayoutLowPrice = NO;
    
    [self layoutPageView];
    
}

-(long) whoIslowestPrice {
     long lowest = 900000000;
    for (int i = 0; i < self.modelsArray.count; i++) {
        
        NSDictionary *modelDic = self.modelsArray[i];
        
        NSMutableString *str = [NSMutableString new];
        [str appendFormat:@"%@ %@ ",modelDic[@"systemStandard"],modelDic[@"memory"]];
        NSArray *colorsArrary = modelDic[@"skuInfoList"];
        
        for (int i = 0; i < colorsArrary.count; i++) {
            NSDictionary *item = colorsArrary[i];
            long current = [[item[@"gdsPrice"] stringValue] intValue];
            lowest = lowest < current ? lowest : current;
        }
        
    }
    
    MyLog(@"lowest :%ld",lowest);
    return lowest;
}

-(void)addTarget:(id)target action:(SEL)action {
    //    [self.rightButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - EventResponse
- (void)toTop:(UIButton*)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(toTop:)]) {
        [self.delegate toTop:self];
    }
}

#pragma mark - Customer Method

- (CGRect)boundingRectForCharacterRange:(NSRange)range AttributedString:(NSAttributedString *)attributedString
{
    NSTextStorage *textStorage = [[NSTextStorage alloc] initWithAttributedString:attributedString];
    NSLayoutManager *layoutManager = [[NSLayoutManager alloc] init];
    [textStorage addLayoutManager:layoutManager];
//    NSTextContainer *textContainer = [[NSTextContainer alloc] initWithSize:[self bounds].size];
    NSTextContainer *textContainer = [[NSTextContainer alloc] initWithSize:CGSizeMake(kColorItemWidth-10, CGFLOAT_MAX)];
    
    textContainer.lineFragmentPadding = 0;
    [layoutManager addTextContainer:textContainer];
    
    NSRange glyphRange;
    
    // Convert the range for glyphs.
    [layoutManager characterRangeForGlyphRange:range actualGlyphRange:&glyphRange];
    
    return [layoutManager boundingRectForGlyphRange:glyphRange inTextContainer:textContainer];
}

- (NSMutableAttributedString *)modelString:(NSDictionary *)modelDic {

    NSMutableString *str = [NSMutableString new];
    [str appendFormat:@"%@ %@ ",modelDic[@"systemStandard"],modelDic[@"memory"]];
    NSArray *colorsArrary = modelDic[@"skuInfoList"];
    
    return [self highLightedPrice:colorsArrary modelName:str];
}

- (NSMutableAttributedString *)highLightedPrice:(NSArray *)arr modelName:(NSString *)modelName{
    
    // 颜色价格
    NSMutableString *str = [NSMutableString new];
    [str appendString:modelName];
    [str appendString:@"( "];
//    for (NSDictionary *item in arr) {
    for (int i = 0; i < arr.count; i++) {
        NSDictionary *item = arr[i];
        [str appendFormat:@"%@ %@ ",item[@"skuColor"],item[@"gdsPrice"]];
       
        if (i != arr.count -1) {
            [str appendString:@" | "];
        }
    }
    [str appendString:@" )"];
    
    NSString *orgStr = [str copy];
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:orgStr];
    text.yy_color = [ALHelper createColorByHex:@"#505050"];
    [text yy_setFont:[UIFont systemFontOfSize:9] range:text.yy_rangeOfAll];
    
    UIColor *priceColor = [ALHelper createColorByHex:@"#FE9900"];
    __weak __typeof(&*self)weakSelf = self;
    //    for (NSDictionary *model in arr) {
    for (int j = 0; j < arr.count; j++) {
        
        NSDictionary *model = arr[j];
        NSMutableArray *rangeArr = [NSMutableArray new];
        NSString *tee = [[text string] copy];
        NSString *gdsPrice = [model[@"gdsPrice"] stringValue];
        
        if ([gdsPrice intValue] == self.lowestPrice && !self.isLowPriceFirstPlace) {
            self.isLowestPrice = YES;
        }
        
        [[tee rangesOfString:gdsPrice options:0 serachRange:NSMakeRange(0, tee.length)]
         enumerateObjectsUsingBlock:^(NSValue *obj, NSUInteger idx, BOOL * _Nonnull stop) {
             NSRange ra = [obj rangeValue];
             //             MyLog(@"my range is %@", NSStringFromRange(ra));
             [rangeArr addObject:NSStringFromRange(ra)];
             if(self.isLowestPrice){
                 weakSelf.lowestPriceRange = [obj rangeValue];
                 weakSelf.isLowPriceFirstPlace  = YES;
                 weakSelf.isLowestPrice = NO;
             }
         }] ;
        
        
        MyLog(@"rangeArr is %@", rangeArr);
        
        for (int k = 0; k < rangeArr.count; k++) {
            
            NSRange linkRange = NSRangeFromString(rangeArr[k]);
            [text yy_setTextHighlightRange:linkRange
                                     color:priceColor
                           backgroundColor:[UIColor colorWithWhite:0.000 alpha:0.220]
                                 tapAction:^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect){
                                     NSString *title = [text.string substringWithRange:range];
                                     MyLog(@"\n text.string :%@",text.string);
                                     MyLog(@"\n title :%@",title);
                                     MyLog(@"my Rect is %@", NSStringFromCGRect(rect));
                                     
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
                                         NSString *gdsPrice = [model[@"gdsPrice"] stringValue];
                                         if ([gdsPrice isEqualToString:title]) {
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
                                         
                                         MyLog(@"\n title :%@",model[@"skuColor"]);
                                         NSDictionary *info = @{@"type":@"color",
                                                                @"param":model
                                                                };
                                         [[NSNotificationCenter defaultCenter] postNotificationName:kParityListClickItemNotification object:weakSelf userInfo:info];
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

-(CGFloat)getMessageHeight:(NSString *)mess andLabel:(YYLabel *)lb
{
    NSMutableAttributedString *introText = [[NSMutableAttributedString alloc] initWithString:mess];
    introText.yy_font = [UIFont systemFontOfSize:9];
    introText.yy_lineSpacing = 2;
    lb.attributedText = introText;
    CGSize introSize = CGSizeMake(kColorItemWidth-10, CGFLOAT_MAX);
    YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:introSize text:introText];
    lb.textLayout = layout;
    CGFloat introHeight = layout.textBoundingSize.height;
    return introHeight;
}

#pragma mark - Customer Method
- (YYLabel *)createColorPriceLabel {
    YYLabel *colorPriceLabel = [[YYLabel alloc] init];
    colorPriceLabel.backgroundColor = [UIColor whiteColor];
    colorPriceLabel.numberOfLines = 0;
    colorPriceLabel.preferredMaxLayoutWidth = kColorItemWidth -10;
    colorPriceLabel.textAlignment = NSTextAlignmentCenter;
    colorPriceLabel.lineBreakMode = NSLineBreakByWordWrapping;
    colorPriceLabel.font = [UIFont systemFontOfSize:9];
    return colorPriceLabel;
}

- (UILabel *)createLowPriceLabel {
    UILabel *lowPriceLabel = [[UILabel alloc] init];
    lowPriceLabel.backgroundColor = [UIColor redColor];
    lowPriceLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:5];
    lowPriceLabel.textColor = [UIColor whiteColor];
    lowPriceLabel.textAlignment = NSTextAlignmentCenter;
    lowPriceLabel.text = @"低";
    return lowPriceLabel;
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

- (UIView *)colorView {
	if (_colorView == nil) {
        _colorView = [[UIView alloc] init];
        _colorView.backgroundColor = [UIColor whiteColor];
	}
	return _colorView;
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
