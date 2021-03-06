//
//  TableViewColumnCell.m
//  AFTabledCollectionView
//
//  Created by allen on 6/30/17.
//  Copyright © 2017 Ash Furrow. All rights reserved.
//

#import "TableViewColumnCell.h"
#define cellWidth 100

@interface TableViewColumnCell () <UITableViewDelegate, UITableViewDataSource,UIScrollViewDelegate>
@property (nonatomic, strong) UITableView *cellTableView;
@property (nonatomic, strong) NSArray *itemArray;
@property (nonatomic, strong) UIButton *addBtn;
@property (nonatomic, strong) UIButton *deleteBtn;
@property (nonatomic, strong) UIView *maskView;
@end

@implementation TableViewColumnCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.contentView.transform = CGAffineTransformMakeRotation(M_PI / 2);
        self.frame = CGRectMake(0, 0, cellWidth, MainHeight-64);
        
        [self layoutPageView];
    }
    return self;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier frame:(CGRect)rect
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.contentView.transform = CGAffineTransformMakeRotation(M_PI / 2);
        self.frame = rect;
        
        [self layoutPageView];
    }
    return self;
}



- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self layoutPageView];
    }
    return self;
}

+(CGFloat)cellHeigh {
    return cellWidth;
}

-(void)layoutPageView {
    [self.contentView addSubview:self.cellTableView];
    [self.contentView addSubview:self.addBtn];
    [self.contentView addSubview:self.maskView];
}


-(void)generateData:(id)data {
    
    [self hiddenMask];
    self.itemArray = (NSArray *)data;
    [self.cellTableView reloadData];
}

- (void)delCell:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(didDelete:)]){
        [self.delegate didDelete:self];
        [self scrollViewDidScroll:self.cellTableView];
    }
}

#pragma mark - UITableViewDelegate UITableViewDataSource


#pragma mark - UITableViewDataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.itemArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = [self.itemArray[indexPath.row] stringValue];
//    cell.backgroundColor = self.itemArray[indexPath.row];
    return cell;
}


- (void)scrollViewDidScroll:(UIScrollView*)scrollView
{
    if ([scrollView isKindOfClass:[UITableView class]]) {
        
        if (scrollView.contentOffset.x != 0) {
            scrollView.contentOffset = CGPointMake(0, scrollView.contentOffset.y);
            return;
        }
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(scrollViewDidColumnCellScroll:)]) {
            [self.delegate scrollViewDidColumnCellScroll:scrollView];
        }
    }
}


#pragma mark - UITableViewDelegate Methods

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 66;
}

#pragma mark -

-(void)showMask{
    self.maskView.hidden = NO;
    //    [self.contentView addSubview:self.maskView];
}

-(void)hiddenMask{
    //    [self.maskView removeFromSuperview];
    self.maskView.hidden = YES;
}

#pragma mark - Event
- (void)event:(UITapGestureRecognizer *)gesture
{
    [self hiddenMask];
    if ([self.delegate respondsToSelector:@selector(resetLongPressGesture)]){
        [self.delegate resetLongPressGesture];
    }
}

#pragma mark - getter && setter
- (UITableView *)cellTableView {
    if (_cellTableView == nil) {
        _cellTableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 0, cellWidth -20, self.bounds.size.height)];
//        _cellTableView = [[UITableView alloc] init];
//        _cellTableView.frame = CGRectMake(0, 0, 60, self.bounds.size.width );
        NSLog(@"width = %f, height = %f",self.bounds.size.width,self.bounds.size.height);
        _cellTableView.backgroundColor = [UIColor yellowColor];
        
        _cellTableView.delegate = self;
        _cellTableView.dataSource = self;
        //        [_cellTableView setUserInteractionEnabled:NO];
    }
    return _cellTableView;
}


- (NSArray *)itemArray {
    if (_itemArray == nil) {
        _itemArray = [[NSArray alloc] init];
    }
    return _itemArray;
}



- (UIButton *)deleteBtn {
    if (_deleteBtn == nil) {
        _deleteBtn = [[UIButton alloc] initWithFrame:CGRectMake(60, 0, 20, 20)];
        _deleteBtn.titleLabel.text = @"-";
        _deleteBtn.backgroundColor = [UIColor grayColor];
        [_deleteBtn addTarget:self action:@selector(delCell:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _deleteBtn;
}


- (UIView *)maskView {
    if (_maskView == nil) {
        //        _maskView = [[UIView alloc] initWithFrame:self.frame];
        _maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
        _maskView.backgroundColor = [UIColor blackColor];
        _maskView.alpha = .5f;
        UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(event:)];
        [_maskView addGestureRecognizer:tapGesture];
        
        UIButton *clearBtn= [[UIButton alloc] initWithFrame:CGRectMake(40,100 , 40, 40)];
        [clearBtn addTarget:self action:@selector(delCell:) forControlEvents:UIControlEventTouchUpInside];
        clearBtn.backgroundColor = [UIColor blueColor];
        [_maskView addSubview:clearBtn];
        _maskView.hidden = YES;
        
    }
    return _maskView;
}

@end
