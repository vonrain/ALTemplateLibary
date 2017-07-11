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

@property (nonatomic, strong) NSMutableArray *collectionCellItemArrary;

@end

@implementation MoreProductVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self layoutPageView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)layoutPageView {
    
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.addBtn];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.mas_equalTo(self.view);
        make.right.mas_equalTo(self.addBtn.mas_left);
    }];
    
    [self.addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.right.centerY.mas_equalTo(self.view);
    }];
}

-(void)generateData:(id)data {
    
    NSMutableArray *collectionCellArrary = [NSMutableArray new];
    for (int i =1 ; i < 15; i++) {
        NSString *item = [NSString stringWithFormat:@"华为p%d",i];
        [collectionCellArrary addObject:item];
    }
    
    self.collectionCellItemArrary = [collectionCellArrary mutableCopy];
}


#pragma mark - Helper methods

#pragma mark - click events
-(void)addClick:(id)sender{
    
    static int i = 3;
    NSString *item = [NSString stringWithFormat:@"iPhone %d",i++];
    [self.collectionCellItemArrary addObject:item];
    [self.collectionView reloadData];
}

#pragma mark - CustomerDelegate
#pragma mark - MoreProductCollectionCellDelegate
- (void)didDelete:(UICollectionViewCell *)cell {
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
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
    cell.backgroundColor= [UIColor yellowColor];
    
    return cell;
}
#pragma mark - setter and getter


- (UICollectionView *)collectionView {
	if (_collectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(80, 20);
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        //设置滚动方向的间距
        layout.minimumLineSpacing = 10;
        //设置上方的反方向
        layout.minimumInteritemSpacing = 5;
        //设置collectionView整体的上下左右之间的间距
        layout.sectionInset = UIEdgeInsetsMake(3, 5, 2, 5);
        
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, MainWidth,MainHeight ) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor greenColor];
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
        _addBtn.backgroundColor = [UIColor orangeColor];
        [_addBtn addTarget:self action:@selector(addClick:) forControlEvents:UIControlEventTouchUpInside];
	}
	return _addBtn;
}

@end
