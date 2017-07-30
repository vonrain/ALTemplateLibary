//
//  GoodsPriceModel.m
//  ALTemplateLibary
//
//  Created by allen on 7/29/17.
//  Copyright © 2017 allen. All rights reserved.
//

#import "GoodsPriceModel.h"

@implementation GoodsPriceModel

+ (NSDictionary *)modelContainerPropertyGenericClass{
    return @{@"activityList" : [ActivityInfo class],
             @"colorList" : [ColorInfo class],
             @"shopInfoList" : [Shopinfo class],
             @"skuPriceList" : [Skuprice class]};
}

-(NSString *)description {
    return [self yy_modelDescription];
}

//- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
//    
//    NSArray *arr = [[dic objectForKey:@"shopInfoList"] isEqual:[NSNull null]]?nil:[dic objectForKey:@"shopInfoList"];
//    //    NSArray *arr = [dic objectForKey:@"ordCartDetailList"];
//    NSMutableArray *list = [NSMutableArray new];
//    
//    for (NSArray *models in arr) {
//        NSMutableArray *arr4Model = [[NSMutableArray alloc] init];
//        for (NSDictionary * dic in models) {
//            Shopinfo *model = [Shopinfo yy_modelWithJSON:dic];
//            [arr4Model addObject:model];
//        }
//        
//        [list addObject:arr4Model];
//    }
//    _shopInfoList = list;
//    
//    return YES;
//}
//
@end
@implementation ActivityInfo
-(NSString *)description {
    return [self yy_modelDescription];
}
@end


@implementation ColorInfo
-(NSString *)description {
    return [self yy_modelDescription];
}
@end


@implementation Shopinfo
-(NSString *)description {
    return [self yy_modelDescription];
}
@end


@implementation Skuprice
-(NSString *)description {
    return [self yy_modelDescription];
}
@end

@implementation ColorPrice
-(NSString *)description {
    return [self yy_modelDescription];
}
@end

@implementation ShopGoodsPrice
-(NSString *)description {
    return [self yy_modelDescription];
}


+ (NSMutableArray *)transformGoodsPriceToShopGoodPrice:(GoodsPriceModel *)goodPriceModel {
    
    NSMutableArray *shopPriceList = [[NSMutableArray alloc] init];
    for (int i = 0; i < goodPriceModel.shopInfoList.count; i++) {
        
        Shopinfo *shopinfo = goodPriceModel.shopInfoList[i];
        ShopGoodsPrice *shopPriceInfo = [ShopGoodsPrice new];
        shopPriceInfo.shopId = shopinfo.shopId;
        shopPriceInfo.shopName = shopinfo.shopName;
        
        // 过滤出相同shopId的skuprice
        NSMutableArray *colorPriceList = [NSMutableArray new];
        
        for (int j = 0; j < goodPriceModel.skuPriceList.count; j++) {
            Skuprice *skuPrice = goodPriceModel.skuPriceList[j];
            if ([skuPrice.shopId isEqualToString:shopPriceInfo.shopId]) {
                
                for (int k = 0; k < goodPriceModel.colorList.count; k++) {
                    
                    ColorInfo *colorInfo = goodPriceModel.colorList[k];
                    if ([skuPrice.skuId isEqualToString:colorInfo.skuId]) {
                        ColorPrice *colorPrice = [ColorPrice new];
                        colorPrice.skuId = colorInfo.skuId;
                        colorPrice.skuColor = colorInfo.skuColor;
                        colorPrice.skuPrice = skuPrice;
                        
                        [colorPriceList addObject:colorPrice];
                    }
                    
                }
                
            }
        }
        
        shopPriceInfo.colorPriceList = colorPriceList;
        
        // 过滤出相同shopId的activityList
        NSMutableArray *activityList = [NSMutableArray new];
        
        for (int j = 0; j < goodPriceModel.activityList.count; j++) {
            ActivityInfo *activeInfo = goodPriceModel.activityList[j];
            if ([activeInfo.shopId isEqualToString:shopPriceInfo.shopId]) {
                [activityList addObject:activeInfo];
            }
        }
        
        shopPriceInfo.activityList = activityList;
        
        [shopPriceList addObject:shopPriceInfo];
    }
    return shopPriceList;
}

+ (NSArray *)colorCategoryList:(GoodsPriceModel *)goodPriceModel {
    
    NSMutableArray *colorCategory = [NSMutableArray new];
    NSArray *colorList = goodPriceModel.colorList;
    
    for (int i = 0; i < colorList.count; i++) {
        ColorInfo *colorInfo = colorList[i];
        NSString *color = colorInfo.skuColor;
        
        if ([colorCategory containsObject:color] == NO){
            [colorCategory addObject:color];
        }
        
    }
    
    return [colorCategory copy];
}

@end





