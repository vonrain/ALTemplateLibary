//
//  MoreProductVC.m
//  ALTemplateLibary
//
//  Created by allen on 7/10/17.
//  Copyright © 2017 allen. All rights reserved.
//

#import "MoreProductVC.h"
#import "MoreProductCollectionCell.h"

@interface MoreProductVC ()<UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,MoreProductCollectionCellDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIButton *addBtn;
@property (nonatomic, strong) UILabel  *addNameLabel;

@property (nonatomic, strong) NSMutableArray *collectionCellItemArrary;

@end

@implementation MoreProductVC

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self layoutPageView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteAction:) name:kDeleteMoreProductNotification object:nil];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)layoutPageView {
    
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.addBtn];
    [self.view addSubview:self.addNameLabel];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.mas_equalTo(self.view);
        make.right.mas_equalTo(self.addBtn.mas_left);
    }];
    
    [self.addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.right.mas_equalTo(self.view);
        make.centerY.mas_equalTo(self.view).offset(-20);
    }];
    
    [self.addNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 15));
        make.top.mas_equalTo(self.addBtn.mas_bottom);
        make.centerX.mas_equalTo(self.addBtn);
    }];
}

-(void)generateData:(id)data {
    NSMutableArray *itemArrary =(NSMutableArray*)data ;
    self.collectionCellItemArrary = [itemArrary mutableCopy];
}

#pragma mark - Helper methods
#pragma mark - Notification
- (void)deleteAction:(NSNotification *)notification {
    NSLog(@"seg2 to seg1 :%@",notification.object);
    NSLog(@"info is %@", notification.userInfo);
    id item = notification.userInfo[@"title"];
    [self.collectionCellItemArrary removeObject:item];
    [self.collectionView reloadData];
    
    
//    [seg2DeSelectedArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        BOOL isContain = [self.dataArray containsObject:obj];
//        if (isContain == YES) {
//            return ;
//        } else {
//            [self.dataArray addObjectsFromArray:seg2DeSelectedArray];
//            [self.collectionView reloadData];
//        }
//    }];
}


#pragma mark - click events
-(void)addClick:(id)sender{
    
    NSDictionary *itemDic = [ALHelper getJsonDataJsonname:@"cg0092_te.json"];
    NSMutableArray *itemArrary = itemDic[@"brandResult"];
    
    [self.collectionCellItemArrary addObjectsFromArray:[itemArrary mutableCopy]];
    [self.collectionView reloadData];
    
    NSDictionary *info = @{@"title":[itemArrary mutableCopy]};
    [[NSNotificationCenter defaultCenter] postNotificationName:kAddProductNotification object:self userInfo:info];
}

#pragma mark - CustomerDelegate
#pragma mark - MoreProductCollectionCellDelegate
- (void)didDelete:(UICollectionViewCell *)cell {
    
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    NSString *item = [self.collectionCellItemArrary[indexPath.row] copy];
    NSDictionary *info = @{@"title":item};
    [[NSNotificationCenter defaultCenter] postNotificationName:kDeleteProductNotification object:self userInfo:info];
    [self.collectionCellItemArrary removeObjectAtIndex:indexPath.row];
    [self.collectionView reloadData];
    
}

#pragma mark - UICollectionViewDataSource Methods

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.collectionCellItemArrary.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MoreProductCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionViewCellId" forIndexPath:indexPath];
    
    cell.delegate = self;
    [cell generateData:self.collectionCellItemArrary[indexPath.row]];
//    cell.backgroundColor= [UIColor yellowColor];
    
    return cell;
}
#pragma mark - setter and getter


- (UICollectionView *)collectionView {
	if (_collectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(80, 20);
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        //设置滚动方向的间距
        layout.minimumLineSpacing = 4;
        //设置上方的反方向
        layout.minimumInteritemSpacing = 5;
        //设置collectionView整体的上下左右之间的间距
        layout.sectionInset = UIEdgeInsetsMake(3, 5, 2, 5);
        
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, MainWidth,MainHeight ) collectionViewLayout:layout];
        _collectionView.backgroundColor = [ALHelper createColorByHex:@"#F2F3F7"];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.scrollEnabled = YES;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        
        [_collectionView registerClass:[MoreProductCollectionCell class] forCellWithReuseIdentifier:@"CollectionViewCellId"];
	}
	return _collectionView;
}
- (UIButton *)addBtn {
	if (_addBtn == nil) {
        _addBtn = [[UIButton alloc] init];
//        _addBtn.backgroundColor = [UIColor orangeColor];
        [_addBtn setBackgroundImage:[UIImage imageNamed:@"添加"] forState:UIControlStateNormal];
        [_addBtn addTarget:self action:@selector(addClick:) forControlEvents:UIControlEventTouchUpInside];
	}
	return _addBtn;
}


- (UILabel *)addNameLabel {
	if (_addNameLabel == nil) {
        _addNameLabel = [[UILabel alloc] init];
        _addNameLabel.textColor = [UIColor orangeColor];
        _addNameLabel.textAlignment = NSTextAlignmentCenter;
        _addNameLabel.font = [UIFont systemFontOfSize:9];
        _addNameLabel.text = @"更多机型";
	}
	return _addNameLabel;
}

@end
