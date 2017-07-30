//
//  GoodsPriceCompareVC.m
//  ALTemplateLibary
//
//  Created by allen on 7/23/17.
//  Copyright © 2017 allen. All rights reserved.
//

#import "GoodsPriceCompareVC.h"
#import "GoodsPriceCompareCell.h"
#import "HeadTimeView.h"
#import "ColorSortingView.h"
#import "GoodsPriceModel.h"

static NSString *GoodsPriceCompareCellId = @"GoodsPriceCompareCellId";
@interface GoodsPriceCompareVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *colorArray;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) HeadTimeView *headTimeView;
@property (nonatomic, strong) ColorSortingView *colorSortingView;
@property (nonatomic, strong) UIButton *footViewBtn;
@property (nonatomic, strong) GoodsPriceModel *goodPriceModel;

@property (nonatomic, strong) NSMutableArray *shopPriceList;

@end

@implementation GoodsPriceCompareVC

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.modalPresentationCapturesStatusBarAppearance = NO;
    
    self.title = @"商品比价";
    self.view.backgroundColor = [ALHelper createColorByHex:@"#F2F3F7"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jumpAction:) name:kGoodPriceCompareClickItemNotification object:nil];
    
    [self generateData:nil];
    [self layoutPageView];
    
}

- (void)layoutPageView {
    [self.view addSubview:self.headTimeView];
    [self.view addSubview:self.tableView];
    
    [self.headTimeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(MainWidth, 30));
        make.top.left.right.mas_equalTo(self.view);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.headTimeView.mas_bottom).offset(2);
        make.left.mas_equalTo(self.view).offset(5);
        make.right.mas_equalTo(self.view).offset(-5);
        make.bottom.mas_equalTo(self.view);
    }];
    
}

-(void)generateData:(id)data {
    
    NSDictionary *dic = [ALHelper getJsonDataJsonname:@"cg0095_te.json"];
    
    self.goodPriceModel = [GoodsPriceModel yy_modelWithJSON:dic];
    self.shopPriceList = [ShopGoodsPrice transformGoodsPriceToShopGoodPrice:self.goodPriceModel];
    self.colorArray = [ShopGoodsPrice colorCategoryList:self.goodPriceModel];
    
    
    NSString *bandTitle = [NSString stringWithFormat:@"%@ %@/%@",
                           self.goodPriceModel.modelName,
                           self.goodPriceModel.systemStandard,
                           self.goodPriceModel.memory];
    NSDictionary *bandInfo = @{@"bandTitle":bandTitle,
                           @"colorArray":self.colorArray};
    [self.colorSortingView generateData:bandInfo];
    
    NSString *lastTime = self.goodPriceModel.quotationUpdateTime;
    [self.headTimeView generateData:lastTime];
    
}
#pragma mark - Event Response
- (void)moreProducts:(UIButton *)sender {
    
    NSDictionary *dic = [ALHelper getJsonDataJsonname:@"cg0095_te.json"];
    
    GoodsPriceModel *goodPriceModel = [GoodsPriceModel yy_modelWithJSON:dic];
    NSMutableArray *shopPriceList = [ShopGoodsPrice transformGoodsPriceToShopGoodPrice:goodPriceModel];
    
    [self.shopPriceList addObjectsFromArray:shopPriceList];
    [self.tableView reloadData];
}

#pragma mark - Notification
- (void)jumpAction:(NSNotification *)notification {
    NSString *type = notification.userInfo[@"type"];
    NSDictionary *paramDic = notification.userInfo[@"param"];
    
    if ([type isEqualToString:@"active"]) {
        MyLog(@"jump to %@",paramDic);
    }
    else if ([type isEqualToString:@"model"]){
        
        MyLog(@"jump to %@",paramDic);
    }
    else if ([type isEqualToString:@"color"]){
        
        MyLog(@"jump to %@",paramDic);
    }
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.shopPriceList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GoodsPriceCompareCell *cell = (GoodsPriceCompareCell *)[tableView dequeueReusableCellWithIdentifier:GoodsPriceCompareCellId];
    if (!cell)
    {
        cell = [[GoodsPriceCompareCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:GoodsPriceCompareCellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //        cell.contentView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    NSDictionary *dic = @{@"colorList":self.colorArray,
                          @"shopPrice":self.shopPriceList[indexPath.row]};
    [cell generateData:dic];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  44;
}

#pragma mark - Getter && Setter
- (HeadTimeView *)headTimeView {
    if (_headTimeView == nil) {
        _headTimeView = [[HeadTimeView alloc] init];
    }
    return _headTimeView;
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [ALHelper createColorByHex:@"#F2F3F7"];
        _tableView.tableHeaderView = self.colorSortingView;
        _tableView.tableFooterView = self.footViewBtn;
    }
    return _tableView;
}


- (ColorSortingView *)colorSortingView {
	if (_colorSortingView == nil) {
        _colorSortingView = [[ColorSortingView alloc] initWithFrame:CGRectMake(0, 0, MainWidth-10, 44)];
	}
	return _colorSortingView;
}

- (UIButton *)footViewBtn {
    if (_footViewBtn == nil) {
        _footViewBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, MainWidth-10, 30)];
        _footViewBtn.backgroundColor = [UIColor whiteColor];
        _footViewBtn.titleLabel.font = [UIFont systemFontOfSize:11];
        [_footViewBtn setTitle:@"更多" forState:UIControlStateNormal];
        [_footViewBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [_footViewBtn addTarget:self action:@selector(moreProducts:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _footViewBtn;
}

- (NSMutableArray *)dataArray {
    if (_dataArray == nil) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

@end
