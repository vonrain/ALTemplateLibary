//
//  BrandPriceListCell.m
//  ALTemplateLibary
//
//  Created by allen on 7/17/17.
//  Copyright © 2017 allen. All rights reserved.
//

#import "BrandPriceListCell.h"
#import "ProductItemCell.h"
#import "BrandItemCell.h"
#import "UITableView+FDTemplateLayoutCell.h"

@interface BrandPriceListCell ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UIView *detialView;
@property (nonatomic, strong) UITableView *productTableView;
@property (nonatomic, strong) UIButton *headViewBtn;
@property (nonatomic, strong) UIButton *footViewBtn;
@property (nonatomic, strong) NSMutableArray *itemsArrary;
@property (nonatomic, strong) NSString *productName;
@end

@implementation BrandPriceListCell

static NSString *CellIdentifier = @"BrandItemCellIdentifier";

+ (CGFloat)cellHeightAtIndexWithMaxItemCount:(NSInteger)count {
    
    
    return 200.f;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [ALHelper createColorByHex:@"#F2F3F7"];
        [self.productTableView registerClass:[BrandItemCell class] forCellReuseIdentifier:CellIdentifier];
    }
    return self;
}

- (void)layoutPageView {
    
    [self.contentView addSubview:self.detialView];
    [self.detialView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.detialView addSubview:self.productTableView];
    
    UIEdgeInsets padding = UIEdgeInsetsMake(0, 10, 10, 10);
    [self.detialView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentView).insets(padding);
    }];
    
    [self.productTableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.detialView);
    }];
}

- (void)generateData:(id)data {
    
    NSMutableDictionary *dic = (NSMutableDictionary *)data;
    
    [self layoutPageView];
//    self.itemsArrary = dic[kParityListVCShopName];
    self.itemsArrary = dic[@"modelResult"];
    [self.headViewBtn setTitle:dic[@"brandName"] forState:UIControlStateNormal];
    [self.productTableView reloadData];
    
}

- (CGFloat)caculationDataForHeight:(id)data {
    
    NSMutableDictionary *dic = (NSMutableDictionary *)data;
    NSArray *itemsArrary = dic[@"modelResult"];
    
    int totalCount = 0;
    for (int i = 0 ; i < itemsArrary.count; i++) {
        
        NSDictionary *itemDic = itemsArrary[i];
        NSArray *skuArr = itemDic[@"skuInfoList"];
        NSArray *activeArr= itemDic[@"activityList"];
       
        int count = skuArr.count > activeArr.count ? skuArr.count:activeArr.count;
        totalCount += count;
    }
    
    return totalCount *40 ;
}



#pragma mark - Event
- (void)moreProducts:(UIButton *)sender {
    
    NSDictionary *dic = [ALHelper getJsonDataJsonname:@"cg0091_te.json"];
    NSArray *arr = dic[@"modelResult"];
    [self.itemsArrary addObjectsFromArray:arr];
    [self.productTableView reloadData];
    
    if ([self.delegate respondsToSelector:@selector(refrashHeight:)]) {
        [self.delegate refrashHeight:self];
    }
}

#pragma mark - UITableViewDataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.itemsArrary.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    static NSString *CellIdentifier = @"BrandItemCellIdentifier";
    
    BrandItemCell *cell = (BrandItemCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell)
    {
        cell = [[BrandItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        cell.contentView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    [cell generateData:self.itemsArrary[indexPath.row]];
    return cell;
}

#pragma mark - UITableViewDelegate Methods

//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static BrandItemCell *offscreenCell;
//    if (!offscreenCell) {
//        offscreenCell = [[BrandItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//    }
//    // configure offscreenCell ...
//    [offscreenCell generateData:self.itemsArrary[indexPath.row]];
//    [offscreenCell.contentView setNeedsLayout];
//    [offscreenCell.contentView layoutIfNeeded];
//    CGFloat height = [offscreenCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
//    CGFloat activeHeight = [offscreenCell activeHeight];
//    height = height > activeHeight ? height: activeHeight;
//    return height + 1;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    NSMutableArray *totalHeight = [NSMutableArray new];
    
    return 40;
}


#pragma mark - setter && getter
- (UIView *)detialView {
	if (_detialView == nil) {
        _detialView = [[UIView alloc] init];
        _detialView.backgroundColor = [UIColor clearColor];
	}
	return _detialView;
}
- (UITableView *)productTableView {
	if (_productTableView == nil) {
        _productTableView = [[UITableView alloc] init];
        _productTableView.backgroundColor = [UIColor clearColor];
        _productTableView.delegate = self;
        _productTableView.dataSource = self;
        _productTableView.scrollEnabled = NO;
        _productTableView.tableHeaderView = self.headViewBtn;
        _productTableView.tableFooterView = self.footViewBtn;
        _productTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	}
	return _productTableView;
}
- (UIButton *)headViewBtn {
	if (_headViewBtn == nil) {
        _headViewBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, MainWidth-20, 30)];
        _headViewBtn.backgroundColor = [UIColor orangeColor];
        _headViewBtn.titleLabel.textColor = [UIColor whiteColor];
        _headViewBtn.layer.cornerRadius = 3;
        _headViewBtn.layer.masksToBounds = YES;
	}
	return _headViewBtn;
}
- (UIButton *)footViewBtn {
	if (_footViewBtn == nil) {
        _footViewBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, MainWidth-20, 30)];
        _footViewBtn.backgroundColor = [UIColor whiteColor];
        _footViewBtn.titleLabel.font = [UIFont systemFontOfSize:11];
        [_footViewBtn setTitle:@"更多" forState:UIControlStateNormal];
        [_footViewBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [_footViewBtn addTarget:self action:@selector(moreProducts:) forControlEvents:UIControlEventTouchUpInside];
	}
	return _footViewBtn;
}

- (NSMutableArray *)itemsArrary {
	if (_itemsArrary == nil) {
        _itemsArrary = [[NSMutableArray alloc] init];
	}
	return _itemsArrary;
}

@end
