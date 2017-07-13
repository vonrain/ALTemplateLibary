//
//  ParityListVC.m
//  ALTemplateLibary
//
//  Created by allen on 7/7/17.
//  Copyright © 2017 allen. All rights reserved.
//

#import "ParityListVC.h"
#import "MoreProductVC.h"
#import "ProductsListVC.h"

NSString *const kParityListVCProductName = @"kParityListVCProductName";
NSString *const kParityListVCShopName = @"kParityListVCShopName";

@interface ParityListVC ()

@property (nonatomic, strong) MoreProductVC *moreProductVC;
@property (nonatomic, strong) ProductsListVC *productsListVC;

@end

@implementation ParityListVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.modalPresentationCapturesStatusBarAppearance = NO;
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self layoutPageView];
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)layoutPageView {
    
    self.view.backgroundColor = [UIColor grayColor];
    [self.view addSubview:self.moreProductVC.view];
    [self.view addSubview:self.productsListVC.view];
    
    [self.moreProductVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.productsListVC.view.mas_top);
        make.height.mas_equalTo(80);
    }];
    
    [self.productsListVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.moreProductVC.view.mas_bottom);
    }];
}


-(void)generateData:(id)data {
    
//    NSMutableArray *itemArrary = [NSMutableArray new];
//    for (int i = 0; i < 8; i++) {
//        NSString *item = [NSString stringWithFormat:@"华为p%d",i];
//        NSMutableArray *shopItems = [NSMutableArray new];
//        for (int j = 0; j<i+1; j++) {
//            NSString *shop = [NSString stringWithFormat:@"迈腾通讯%d",j];
//            [shopItems addObject:shop];
//        }
//        
//        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
//                             item,kParityListVCProductName,
//                             shopItems,kParityListVCShopName,
//                             nil];
//        
//        [itemArrary addObject:dic];
//    }
    
    NSMutableArray *itemArrary = [ALHelper getJsonDataJsonname:@"删除联动.json"];
    [self.productsListVC generateData:itemArrary];
    [self.moreProductVC generateData:itemArrary];
 
}


#pragma mark - Helper methods


#pragma mark - click events

#pragma mark - CustomerDelegate
#pragma mark - setter and getter


- (MoreProductVC *)moreProductVC {
    if (_moreProductVC == nil) {
        _moreProductVC = [[MoreProductVC alloc] init];
        [self addChildViewController:_moreProductVC];
    }
    return _moreProductVC;
}
- (ProductsListVC *)productsListVC {
    if (_productsListVC == nil) {
        _productsListVC = [[ProductsListVC alloc] init];
        [self addChildViewController:_productsListVC];
    }
    return _productsListVC;
}


@end