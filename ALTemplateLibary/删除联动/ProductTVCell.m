//
//  ProductTVCell.m
//  ALTemplateLibary
//
//  Created by allen on 7/10/17.
//  Copyright © 2017 allen. All rights reserved.
//

#import "ProductTVCell.h"

@interface ProductTVCell ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UIView *detialView;
@property (nonatomic, strong) UITableView *productTableView;
@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIButton *deleteBtn;
@end

@implementation ProductTVCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self layoutPageView];
    }
    return self;
}

- (void)layoutPageView {
    
    [self.contentView addSubview:self.detialView];
    [self.contentView addSubview:self.maskView];
    [self.detialView addSubview:self.productTableView];
    
    [self.detialView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentView);
    }];
    
    [self.productTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentView);
    }];
}

- (void)layoutDetialView {
    
    [self.detialView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
}

-(void)remarkLayoutPageView {
    
   
}

- (void)generateData:(id)data {
    
    NSDictionary *dic = (NSDictionary *)data;
    [self layoutDetialView];
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

#pragma mark - UITableViewDataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CustomerCellIdentifier";
    
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate Methods

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}

-(void)addTarget:(id)target action:(SEL)action {
    //    [self.rightButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

- (UIView *)detialView {
	if (_detialView == nil) {
        _detialView = [[UIView alloc] init];
        _detialView.backgroundColor=[UIColor blueColor];
        _detialView.layer.borderColor=[UIColor grayColor].CGColor;
        _detialView.layer.borderWidth=0.5;
        _detialView.layer.cornerRadius=10;
	}
	return _detialView;
}

- (UITableView *)productTableView {
	if (_productTableView == nil) {
        _productTableView = [[UITableView alloc] init];
        _productTableView.delegate = self;
        _productTableView.dataSource = self;
        _productTableView.scrollEnabled = NO;
	}
	return _productTableView;
}

- (UIView *)maskView {
    if (_maskView == nil) {
        _maskView = [[UIView alloc] init];
        _maskView.layer.borderColor=[UIColor grayColor].CGColor;
        _maskView.layer.borderWidth=0.5;
        _maskView.layer.cornerRadius=10;
        
        _maskView.backgroundColor = [UIColor blackColor];
        _maskView.alpha = .5f;
        UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(event:)];
        [_maskView addGestureRecognizer:tapGesture];
        
        UIButton *clearBtn= [[UIButton alloc] initWithFrame:CGRectMake(40,60 , 40, 40)];
        [clearBtn addTarget:self action:@selector(delCell:) forControlEvents:UIControlEventTouchUpInside];
        clearBtn.backgroundColor = [UIColor blueColor];
        [_maskView addSubview:clearBtn];
        _maskView.hidden = YES;
        
    }
    return _maskView;
}

@end
