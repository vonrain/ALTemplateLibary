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
#import "DragVC.h"
#import "LongPressChangeVC.h"

NSString *const kParityListVCProductName = @"brandName";
NSString *const kParityListVCShopName = @"shopResult";
NSString *const kParityListVCItemCount = @"kParityListVCItemCount";

@interface ParityListVC ()

@property (nonatomic, strong) MoreProductVC *moreProductVC;
@property (nonatomic, strong) ProductsListVC *productsListVC;

@end

@implementation ParityListVC

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.modalPresentationCapturesStatusBarAppearance = NO;
   [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jumpAction:) name:kParityListClickItemNotification object:nil];
    self.view.backgroundColor = [ALHelper createColorByHex:@"#F2F3F7"];
    [self layoutPageView];
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)layoutPageView {
    
//    self.view.backgroundColor = [UIColor grayColor];
    [self.view addSubview:self.moreProductVC.view];
    [self.view addSubview:self.productsListVC.view];
    
    [self.moreProductVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.productsListVC.view.mas_top);
        make.height.mas_equalTo(80);
    }];
    
    [self.productsListVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(5);
        make.right.mas_equalTo(self.view).offset(-5);
        make.top.mas_equalTo(self.moreProductVC.view.mas_bottom);
        make.bottom.mas_equalTo(self.view);
    }];
}


-(void)generateData:(id)data {
    
//    NSMutableArray *itemArrary = [NSMutableArray new];
//    for (int i = 0; i < 8; i++) {
//        NSString *item = [NSString stringWithFormat:@"华为p%d",i];
//        NSMutableArray *shopItems = [NSMutableArray new];
//        int j = 0;
//        for (j = 0; j<i+1; j++) {
//            NSString *shop = [NSString stringWithFormat:@"迈腾通讯%d",j];
//            [shopItems addObject:shop];
//        }
//        
//        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
//                             item,kParityListVCProductName,
//                             shopItems,kParityListVCShopName,
//                             @(j),kParityListVCItemCount,
//                             nil];
//        
//        [itemArrary addObject:dic];
//    }
    
    NSDictionary *itemDic = [ALHelper getJsonDataJsonname:@"cg0092_te.json"];
    NSMutableArray *itemArrary = itemDic[@"brandResult"];
    
    [self.productsListVC generateData:itemArrary];
    [self.moreProductVC generateData:itemArrary];
 
}


#pragma mark - Notification
- (void)jumpAction:(NSNotification *)notification {
    //    NSLog(@"seg2 to seg1 :%@",notification.object);
    //    NSLog(@"info is %@", notification.userInfo);
    NSString *type = notification.userInfo[@"type"];
    NSDictionary *paramDic = notification.userInfo[@"param"];
    
    if ([type isEqualToString:@"active"]) {
        MyLog(@"jump to %@",paramDic);
        DragVC *dragVC = [[DragVC alloc] init];
        [self.navigationController pushViewController:dragVC animated:YES];
    }
    else if ([type isEqualToString:@"model"]){
        
        MyLog(@"jump to %@",paramDic);
        LongPressChangeVC *longPressChangVC = [[LongPressChangeVC alloc] init];
        [longPressChangVC generateData:nil];
        longPressChangVC.title = @"长按删除及移动";
        [self.navigationController pushViewController:longPressChangVC animated:YES];
    }
    else if ([type isEqualToString:@"color"]){
        
        MyLog(@"jump to %@",paramDic);
        LongPressChangeVC *longPressChangVC = [[LongPressChangeVC alloc] init];
        [longPressChangVC generateData:nil];
        longPressChangVC.title = @"长按删除及移动";
        [self.navigationController pushViewController:longPressChangVC animated:YES];
    }
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