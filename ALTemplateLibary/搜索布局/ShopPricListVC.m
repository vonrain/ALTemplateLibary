//
//  ShopPricListVC.m
//  ALTemplateLibary
//
//  Created by allen on 7/17/17.
//  Copyright © 2017 allen. All rights reserved.
//

#import "ShopPricListVC.h"
#import "HeadTipsView.h"
#import "BrandPriceListCell.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "DragVC.h"
#import "LongPressChangeVC.h"

@interface ShopPricListVC ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UISearchDisplayDelegate>

@property (nonatomic, strong) UITableView *tableView;
/**数据源*/
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *searchResultArray;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UISearchDisplayController *displayer;
@property (nonatomic, strong) HeadTipsView *headTipsView;

@end

@implementation ShopPricListVC

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (NSMutableArray *)getDataArray
{
    /**模拟一组数据*/
    NSMutableArray *resultArray = [[NSMutableArray alloc] init];
    for (int i = 0; i< 20; i++) {
        NSString *dataString = [NSString stringWithFormat:@"%d",i];
        [resultArray addObject:dataString];
    }
    return resultArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.modalPresentationCapturesStatusBarAppearance = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jumpAction:) name:kShopPricListClickItemNotification object:nil];
    self.title = @"店铺比价单";
    
    [self generateData:nil];
    
    [self.tableView registerClass:[BrandPriceListCell class] forCellReuseIdentifier:@"mainCell"];
    [self layoutPageView];
    [self.headTipsView generateData:nil];
    
}

- (void)layoutPageView {
    [self.view addSubview:self.headTipsView];
    [self.view addSubview:self.tableView];
    self.tableView.tableHeaderView = self.searchBar;
    
    [self.headTipsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(MainWidth, 36));
        make.top.left.right.mas_equalTo(self.view);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.headTipsView.mas_bottom);
        make.left.bottom.right.mas_equalTo(self.view);
    }];
    
}

-(void)generateData:(id)data {
    
    NSDictionary *dic = [ALHelper getJsonDataJsonname:@"cg0091_te.json"];
    self.dataArray = dic[@"brandResult"];
    
//    self.dataArray = [self getDataArray];
}

#pragma mark - EventRespone
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
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    /**对TableView进行判断，如果是搜索结果展示视图，返回不同结果*/
    if (tableView == self.displayer.searchResultsTableView) {
        return self.searchResultArray.count;
    }
    else{
        return self.dataArray.count;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BrandPriceListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mainCell"];
    if (cell == nil) {
        cell = [[BrandPriceListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"mainCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    /**对TableView进行判断，如果是搜索结果展示视图，返回不同数据源*/
    if (tableView == self.displayer.searchResultsTableView) {
        [cell generateData:self.searchResultArray[indexPath.row]];
    }
    else{
        
        [cell generateData:self.dataArray[indexPath.row]];
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
        return 480;
//    PackageDetialModel *item = self.packageDetialModel.packageDetialArrary[indexPath.row];
//    return item.totalHeight + kCardPackageDetialCellPadding;
    
//    if (tableView == self.displayer.searchResultsTableView) {
//        return 200;
//    }
//    else{
//        static BrandPriceListCell *offscreenCell;
//        if (!offscreenCell) {
//            offscreenCell = [[BrandPriceListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"mainCell"];
//        }
//        // configure offscreenCell ...
//        [offscreenCell generateData:nil];
//        [offscreenCell.contentView setNeedsLayout];
//        [offscreenCell.contentView layoutIfNeeded];
//        CGFloat height = [offscreenCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
//        return height + 1;
//        
//    }
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    NSLog(@"begin");
    return YES;
}

-(BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    NSLog(@"end");
//    [self.displayer.searchResultsTableView reloadData];
    
    self.searchResultArray = self.dataArray;
    [self.displayer.searchResultsTableView reloadData];
    return  YES;
}

/**UISearchDisplayController的代理实现*/

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    
    /**通过谓词修饰的方式来查找包含我们搜索关键字的数据*/
//    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"self contains[cd] %@",searchString];
//    self.searchResultArray = [self.dataArray filteredArrayUsingPredicate:resultPredicate];
//    self.searchResultArray = self.dataArray;
    
    return  YES;
}

#pragma mark - getter && setter
- (UISearchBar *)searchBar {
	if (_searchBar == nil) {
        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
        _searchBar.delegate = self;
        _searchBar.backgroundImage = [[UIImage alloc] init];
//        _searchBar.barTintColor = [ALHelper createColorByHex:@"#F2F3F7"];
        
	}
	return _searchBar;
}

- (UISearchDisplayController *)displayer {
	if (_displayer == nil) {
        _displayer = [[UISearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
        
        _displayer.searchResultsDataSource = self;
        _displayer.searchResultsDelegate = self;
        _displayer.delegate = self;
        _displayer.searchResultsTableView.tableFooterView= [UIView new];//无数据时不显示cell
        
	}
	return _displayer;
}

- (HeadTipsView *)headTipsView {
	if (_headTipsView == nil) {
        _headTipsView = [[HeadTipsView alloc] init];
	}
	return _headTipsView;
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [ALHelper createColorByHex:@"#F2F3F7"];
    }
    return _tableView;
}
- (NSMutableArray *)dataArray {
	if (_dataArray == nil) {
        _dataArray = [[NSMutableArray alloc] init];
	}
	return _dataArray;
}
- (NSMutableArray *)searchResultArray {
	if (_searchResultArray == nil) {
        _searchResultArray = [[NSMutableArray alloc] init];
	}
	return _searchResultArray;
}

@end


