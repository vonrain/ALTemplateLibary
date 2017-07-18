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

@interface ShopPricListVC ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UISearchDisplayDelegate>

@property (nonatomic, strong) UITableView *tableView;
/**数据源*/
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *searchResultArray;
@property (nonatomic, strong) UISearchDisplayController *displayer;
@property (nonatomic, strong) HeadTipsView *headTipsView;

@end

@implementation ShopPricListVC

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
    
    self.title = @"店铺比价单";
    
    [self generateData:nil];
    
    [self.tableView registerClass:[BrandPriceListCell class] forCellReuseIdentifier:@"mainCell"];
    [self layoutPageView];
    [self.headTipsView generateData:nil];
    
}

- (void)layoutPageView {
    [self.view addSubview:self.headTipsView];
    [self.view addSubview:self.tableView];
    [self setupSearchBar];
    
    [self.headTipsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(MainWidth, 36));
        make.top.left.right.mas_equalTo(self.view);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.headTipsView.mas_bottom);
        make.left.bottom.right.mas_equalTo(self.view);
    }];
    
}
- (void)setupSearchBar{
    /**配置Search相关控件*/
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    self.tableView.tableHeaderView = searchBar;
    
    self.displayer = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
    /**searchBar的delegate看需求进行配置*/
    searchBar.delegate = self;
    
    /**以下都比较重要，建议都设置好代理*/
    self.displayer.searchResultsDataSource = self;
    self.displayer.searchResultsDelegate = self;
    self.displayer.delegate = self;
}

-(void)generateData:(id)data {
    self.dataArray = [self getDataArray];
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
        cell.textLabel.text = [NSString stringWithFormat:@"%@",self.searchResultArray[indexPath.row]];
    }
    else{
        cell.textLabel.text = [NSString stringWithFormat:@"%@",self.dataArray[indexPath.row]];
        
        [cell generateData:nil];
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
    return  YES;
}

/**UISearchDisplayController的代理实现*/

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    
    /**通过谓词修饰的方式来查找包含我们搜索关键字的数据*/
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"self contains[cd] %@",searchString];
    self.searchResultArray = [self.dataArray filteredArrayUsingPredicate:resultPredicate];
    return  YES;
}

#pragma mark - getter && setter


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


