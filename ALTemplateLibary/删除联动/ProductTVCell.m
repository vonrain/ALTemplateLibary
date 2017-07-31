//
//  ProductTVCell.m
//  ALTemplateLibary
//
//  Created by allen on 7/10/17.
//  Copyright © 2017 allen. All rights reserved.
//

#import "ProductTVCell.h"
#import "ProductItemCell.h"
#import "ProductHeadView.h"

@interface ProductTVCell ()<UITableViewDelegate,UITableViewDataSource,ProductItemCellDelegate>
@property (nonatomic, strong) UIView *detialView;
@property (nonatomic, strong) UITableView *productTableView;
@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) ProductHeadView *headView;
@property (nonatomic, strong) UIButton *footViewBtn;
@property (nonatomic, strong) UIButton *moreBtn;
@property (nonatomic, strong) UIButton *deleteBtn;
@property (nonatomic, strong) NSMutableArray *itemsArrary;
@property (nonatomic, strong) NSString *productName;
@end

@implementation ProductTVCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
//        [self layoutPageView];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [ALHelper createColorByHex:@"#F2F3F7"];
    }
    return self;
}

- (void)layoutPageView {
    
    [self.contentView addSubview:self.detialView];
    [self.contentView addSubview:self.maskView];
    
    [self.detialView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.detialView addSubview:self.productTableView];
    
//    UIEdgeInsets padding = UIEdgeInsetsMake(0, 10, 10, 10);
    UIEdgeInsets padding = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.detialView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentView).insets(padding);
    }];
    
    [self.productTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.detialView);
    }];
}

- (void)layoutDetialView {
    
//    [self.detialView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
}

-(void)remarkLayoutPageView {
    
   
}

- (void)generateData:(id)data {
    
    NSMutableDictionary *dic = (NSMutableDictionary *)data;
    
    self.productName = dic[kParityListVCProductName];
    self.itemsArrary = dic[kParityListVCShopName];
    
    [self.headView generateData:self.productName];
    
    [self.productTableView reloadData];
    [self layoutPageView];
}

#pragma mark -
-(void)showMask{
    self.maskView.hidden = NO;
    _maskView.frame = self.detialView.frame;
    //    [self.contentView addSubview:self.maskView];
}

-(void)hiddenMask{
    //    [self.maskView removeFromSuperview];
    self.maskView.hidden = YES;
}

- (void)delCell:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(didDelete:)]){
        [self.delegate didDelete:self];
    }
}

#pragma mark - Event
- (void)event:(UITapGestureRecognizer *)gesture
{
    [self hiddenMask];
    if ([self.delegate respondsToSelector:@selector(resetLongPressGesture)]){
        [self.delegate resetLongPressGesture];
    }
}

#pragma mark - Event
- (void)moreProducts:(UIButton *)sender {
    
    NSDictionary *itemDic = [ALHelper getJsonDataJsonname:@"cg0092_te.json"];
    NSMutableArray *itemArrary = itemDic[@"shopResult"];
    [self.itemsArrary addObjectsFromArray:itemArrary];
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
    static NSString *CellIdentifier = @"CustomerCellIdentifier";
    
    ProductItemCell *cell = (ProductItemCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell)
    {
        cell = [[ProductItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.delegate = self;
    }
    
    [cell generateData:self.itemsArrary[indexPath.row]];
    return cell;
}

#pragma mark - UITableViewDelegate Methods

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

-(void)addTarget:(id)target action:(SEL)action {
    //    [self.rightButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}
#pragma mark - ProductItemCellDelegate

-(void)toTop:(UITableViewCell*)cell {
    
    NSIndexPath *indexPath = [self.productTableView indexPathForCell:cell];
    id item = self.itemsArrary[indexPath.row];
    [self.itemsArrary removeObjectAtIndex:indexPath.row];
    [self.itemsArrary insertObject:item atIndex:0];
    
    [self.productTableView reloadData];
}

#pragma mark - Getter && Setter
- (UIView *)detialView {
	if (_detialView == nil) {
        _detialView = [[UIView alloc] init];
        _detialView.backgroundColor=[UIColor clearColor];
//        _detialView.layer.borderColor=[UIColor grayColor].CGColor;
//        _detialView.layer.borderWidth=0.5;
//        _detialView.layer.cornerRadius=10;
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
        _productTableView.tableHeaderView = self.headView;
        _productTableView.tableFooterView = self.footViewBtn;
        _productTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _productTableView;
}


- (UIView *)maskView {
    if (_maskView == nil) {
        _maskView = [[UIView alloc] init];
        _maskView.layer.borderColor=[UIColor grayColor].CGColor;
//        _maskView.layer.borderWidth=0.5;
//        _maskView.layer.cornerRadius=10;
        
        _maskView.backgroundColor = [UIColor blackColor];
        _maskView.alpha = .5f;
        UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(event:)];
        [_maskView addGestureRecognizer:tapGesture];
        
        UIButton *clearBtn= [[UIButton alloc] init];
        [_maskView addSubview:clearBtn];
        [clearBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(60, 20));
            make.center.mas_equalTo(self.maskView);
        }];
        [clearBtn setTitle:@"不再展示" forState:UIControlStateNormal];
        clearBtn.titleLabel.font = [UIFont systemFontOfSize:11];
        clearBtn.layer.borderColor=[UIColor whiteColor].CGColor;
        clearBtn.layer.borderWidth=1;
        clearBtn.layer.cornerRadius=5;
        
        [clearBtn addTarget:self action:@selector(delCell:) forControlEvents:UIControlEventTouchUpInside];
        _maskView.hidden = YES;
        
    }
    return _maskView;
}


- (NSMutableArray *)itemsArrary {
	if (_itemsArrary == nil) {
        _itemsArrary = [[NSMutableArray alloc] init];
	}
	return _itemsArrary;
}


- (ProductHeadView *)headView {
	if (_headView == nil) {
        _headView = [[ProductHeadView alloc] initWithFrame:CGRectMake(0, 0, MainWidth-20, 44)];
	}
	return _headView;
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

- (UIButton *)moreBtn {
	if (_moreBtn == nil) {
        _moreBtn = [[UIButton alloc] init];
	}
	return _moreBtn;
}
@end
