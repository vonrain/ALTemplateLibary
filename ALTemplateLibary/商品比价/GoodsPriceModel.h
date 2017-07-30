//
//  GoodsPriceModel.h
//  ALTemplateLibary
//
//  Created by allen on 7/29/17.
//  Copyright © 2017 allen. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ActivityInfo,ColorInfo,Shopinfo,Skuprice, ShopGoodsPrice,ColorPrice;
@interface GoodsPriceModel : NSObject

@property (nonatomic, copy) NSString *memory;

@property (nonatomic, copy) NSString *spuType;

@property (nonatomic, copy) NSString *gdsId;

@property (nonatomic, copy) NSString *quotationUpdateTime;

@property (nonatomic, copy) NSString *systemStandard;

@property (nonatomic, copy) NSString *modelName;

@property (nonatomic, strong) NSArray<ColorInfo *> *colorList;

@property (nonatomic, strong) NSArray<Skuprice *> *skuPriceList;

@property (nonatomic, strong) NSArray<Shopinfo *> *shopInfoList;

@property (nonatomic, strong) NSArray<ActivityInfo *> *activityList;

@end
@interface ActivityInfo : NSObject

@property (nonatomic, copy) NSString *skuId;

@property (nonatomic, copy) NSString *gdsId;

@property (nonatomic, copy) NSString *shopId;

@property (nonatomic, copy) NSString *activityId;

@property (nonatomic, copy) NSString *activityName;

@property (nonatomic, copy) NSString *brandName;

@end

@interface ColorInfo : NSObject

@property (nonatomic, copy) NSString *skuId;

@property (nonatomic, copy) NSString *skuColor;

@end

@interface Shopinfo : NSObject

@property (nonatomic, copy) NSString *shopId;

@property (nonatomic, copy) NSString *shopName;

@end

@interface Skuprice : NSObject

@property (nonatomic, copy) NSString *shopId;

@property (nonatomic, copy) NSString *memory;

@property (nonatomic, assign) NSInteger gdsPrice;

@property (nonatomic, copy) NSString *gdsId;

@property (nonatomic, copy) NSString *spuType;

@property (nonatomic, copy) NSString *provinceCode;

@property (nonatomic, copy) NSString *skuId;

@property (nonatomic, copy) NSString *systemStandard;

@property (nonatomic, copy) NSString *modelName;

@property (nonatomic, assign) NSInteger guidePrice;

@end

// 单品价格列表
@interface ColorPrice : NSObject

@property (nonatomic, copy) NSString *skuId;

@property (nonatomic, copy) NSString *skuColor;

// 颜色价格
@property (nonatomic, strong) Skuprice *skuPrice;

@end


@interface ShopGoodsPrice : NSObject

@property (nonatomic, copy) NSString *shopId;

@property (nonatomic, copy) NSString *shopName;

@property (nonatomic, strong) NSArray<ColorPrice *> *colorPriceList;

@property (nonatomic, strong) NSArray<ActivityInfo *> *activityList;


+ (NSMutableArray *)transformGoodsPriceToShopGoodPrice:(GoodsPriceModel *)goodPriceModel;

+ (NSArray *)colorCategoryList:(GoodsPriceModel *)goodPriceModel;
@end

