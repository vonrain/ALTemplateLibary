//
//  ProductsListVC.m
//  ALTemplateLibary
//
//  Created by allen on 7/10/17.
//  Copyright © 2017 allen. All rights reserved.
//

#import "ProductsListVC.h"
#import "ProductTVCell.h"

typedef NS_ENUM(NSUInteger, XWDragCellCollectionViewScrollDirection) {
    XWDragCellCollectionViewScrollDirectionNone = 0,
    XWDragCellCollectionViewScrollDirectionLeft,
    XWDragCellCollectionViewScrollDirectionRight,
    XWDragCellCollectionViewScrollDirectionUp,
    XWDragCellCollectionViewScrollDirectionDown
};

@interface ProductsListVC ()<UITableViewDelegate,UITableViewDataSource,ProductCellDelegate>

@property (nonatomic, strong) UITableView *productsTableView;
@property (nonatomic, strong) NSMutableArray *itemArrary;

@property (nonatomic) BOOL resetGesture;
/**删除手势*/
@property (nonatomic,strong) UILongPressGestureRecognizer *recognize;
/**移动手势*/
@property (nonatomic,strong) UILongPressGestureRecognizer *longGesture;

@property(nonatomic)         CGPoint                      currentContentOffset;                  // default CGPointZero

@property (nonatomic, strong) CADisplayLink *edgeTimer;
@property (nonatomic) BOOL isPanning;
@property (nonatomic, assign) XWDragCellCollectionViewScrollDirection scrollDirection;
@property (nonatomic, weak) UIView *tempMoveCell;

@end

@implementation ProductsListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor yellowColor];
    [self layoutPageView];
    [self addRecognize];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)layoutPageView {
    
    [self.view addSubview:self.productsTableView];
    
    [self.productsTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
}


-(void)generateData:(id)data {
    NSMutableArray *itemArrary = [NSMutableArray new];
    for (int i =1 ; i < 8; i++) {
        NSString *item = [NSString stringWithFormat:@"华为p%d",i];
        [itemArrary addObject:item];
    }
    
    self.itemArrary = itemArrary;
}
#pragma mark - UITableViewDataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.itemArrary.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ProductCellIdentifier";
    
    ProductTVCell *cell = (ProductTVCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell)
    {
        cell = [[ProductTVCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.delegate = self;
    
    return cell;
}

#pragma mark - UITableViewDelegate Methods

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}

#pragma mark - CustomerDelegate
- (void)didDelete:(UITableViewCell *)cell{
    NSIndexPath *indexPath = [self.productsTableView indexPathForCell:cell];
    [self.itemArrary removeObjectAtIndex:indexPath.row];
    
    self.resetGesture = YES;
    
    cell.maskView.hidden = YES;
    [self.productsTableView reloadData];
}

-(void)resetLongPressGesture {
    self.resetGesture = YES;
}


- (void)xwp_setScrollDirection{
    _scrollDirection = XWDragCellCollectionViewScrollDirectionNone;
    if (self.productsTableView.bounds.size.height + self.productsTableView.contentOffset.y - _tempMoveCell.center.y < _tempMoveCell.bounds.size.height / 2 && self.productsTableView.bounds.size.height + self.productsTableView.contentOffset.y < self.productsTableView.contentSize.height) {
        _scrollDirection = XWDragCellCollectionViewScrollDirectionDown;
    }
    if (_tempMoveCell.center.y - self.productsTableView.contentOffset.y < _tempMoveCell.bounds.size.height / 2 && self.productsTableView.contentOffset.y > 0) {
        _scrollDirection = XWDragCellCollectionViewScrollDirectionUp;
    }
    if (self.productsTableView.bounds.size.width + self.productsTableView.contentOffset.x - _tempMoveCell.center.x < _tempMoveCell.bounds.size.width / 2 && self.productsTableView.bounds.size.width + self.productsTableView.contentOffset.x < self.productsTableView.contentSize.width) {
        _scrollDirection = XWDragCellCollectionViewScrollDirectionRight;
    }
    
    if (_tempMoveCell.center.x - self.productsTableView.contentOffset.x < _tempMoveCell.bounds.size.width / 2 && self.productsTableView.contentOffset.x > 0) {
        _scrollDirection = XWDragCellCollectionViewScrollDirectionLeft;
    }
}

- (void)xwp_edgeScroll{
    [self xwp_setScrollDirection];
    switch (_scrollDirection) {
        case XWDragCellCollectionViewScrollDirectionLeft:{
            //这里的动画必须设为NO
            [self.productsTableView setContentOffset:CGPointMake(self.productsTableView.contentOffset.x - 4, self.productsTableView.contentOffset.y) animated:NO];
            _tempMoveCell.center = CGPointMake(_tempMoveCell.center.x - 4, _tempMoveCell.center.y);
        }
            break;
        case XWDragCellCollectionViewScrollDirectionRight:{
            [self.productsTableView setContentOffset:CGPointMake(self.productsTableView.contentOffset.x + 4, self.productsTableView.contentOffset.y) animated:NO];
            _tempMoveCell.center = CGPointMake(_tempMoveCell.center.x + 4, _tempMoveCell.center.y);
            
        }
            break;
        case XWDragCellCollectionViewScrollDirectionUp:{
            [self.productsTableView setContentOffset:CGPointMake(self.productsTableView.contentOffset.x, self.productsTableView.contentOffset.y - 4) animated:NO];
            _tempMoveCell.center = CGPointMake(_tempMoveCell.center.x, _tempMoveCell.center.y - 4);
        }
            break;
        case XWDragCellCollectionViewScrollDirectionDown:{
            [self.productsTableView setContentOffset:CGPointMake(self.productsTableView.contentOffset.x, self.productsTableView.contentOffset.y + 4) animated:NO];
            _tempMoveCell.center = CGPointMake(_tempMoveCell.center.x, _tempMoveCell.center.y + 4);
        }
            break;
        default:
            break;
    }
    
}


#pragma mark - 
- (void)longPress:(UILongPressGestureRecognizer *)longGesture {
    //判断手势状态
    switch (longGesture.state) {
        case UIGestureRecognizerStateBegan:{
            //判断手势落点位置是否在路径上
            NSIndexPath *indexPath = [self.productsTableView indexPathForRowAtPoint:[longGesture locationInView:self.productsTableView]];
            ProductTVCell *cell = (ProductTVCell*)[self.productsTableView cellForRowAtIndexPath:indexPath];
            [cell showMask];
            self.resetGesture = NO;
            NSLog(@"1");
        }
            break;
        case UIGestureRecognizerStateChanged:{
            NSLog(@"2");
            break;
        }
        case UIGestureRecognizerStateEnded:
            NSLog(@"3");
            break;
        default:
            NSLog(@"4");
            break;
    }
}

- (void)longPressGestureRecognized:(id)sender {
    
    UILongPressGestureRecognizer *longPress = (UILongPressGestureRecognizer *)sender;
    UIGestureRecognizerState state = longPress.state;
    
    CGPoint location = [longPress locationInView:self.productsTableView];
    NSIndexPath *indexPath = [self.productsTableView indexPathForRowAtPoint:location];
    
    static UIView       *snapshot = nil;        ///< A snapshot of the row user is moving.
    static NSIndexPath  *sourceIndexPath = nil; ///< Initial index path, where gesture begins.
    
    switch (state) {
        case UIGestureRecognizerStateBegan: {
            if (indexPath) {
                sourceIndexPath = indexPath;
                
                UITableViewCell *cell = [self.productsTableView cellForRowAtIndexPath:indexPath];
                
                // Take a snapshot of the selected row using helper method.
                snapshot = [self customSnapshoFromView:cell];
                
                // Add the snapshot as subview, centered at cell's center...
                __block CGPoint center = cell.center;
                snapshot.center = center;
                snapshot.alpha = 0.0;
                [self.productsTableView addSubview:snapshot];
                
                self.tempMoveCell = snapshot;
                //开启边缘滚动定时器
                [self xwp_setEdgeTimer];
                
                [UIView animateWithDuration:0.25 animations:^{
                    
                    // Offset for gesture location.
                    center.y = location.y;
                    snapshot.center = center;
                    //                    snapshot.transform = CGAffineTransformMakeScale(1.05, 1.05);
                    //                    snapshot.transform = CGAffineTransformMakeScale(.5f, .5f);
                    snapshot.alpha = 0.98;
                    cell.alpha = 0.0;
                    cell.hidden = YES;
                    
                }];
            }
            break;
        }
            
        case UIGestureRecognizerStateChanged: {
            CGPoint center = snapshot.center;
            center.y = location.y;
            snapshot.center = center;
            
            // Is destination valid and is it different from source?
            if (indexPath && ![indexPath isEqual:sourceIndexPath]) {
                
                // ... update data source.
                [self.itemArrary exchangeObjectAtIndex:indexPath.row withObjectAtIndex:sourceIndexPath.row];
                
                // ... move the rows.
                [self.productsTableView moveRowAtIndexPath:sourceIndexPath toIndexPath:indexPath];
                
                // ... and update source so it is in sync with UI changes.
                sourceIndexPath = indexPath;
            }
            break;
        }
            
        default: {
            // Clean up.
            //            UICollectionViewCell *cell = [self.productsTableView cellForItemAtIndexPath:sourceIndexPath];
            ProductTVCell *cell = (ProductTVCell*)[self.productsTableView cellForRowAtIndexPath:sourceIndexPath];
            cell.alpha = 0.0;
            _isPanning = NO;
            [self xwp_stopEdgeTimer];
            
            [UIView animateWithDuration:0.25 animations:^{
                
                snapshot.center = cell.center;
                snapshot.transform = CGAffineTransformIdentity;
                snapshot.alpha = 0.0;
                cell.alpha = 1.0;
                
            } completion:^(BOOL finished) {
                
                cell.hidden = NO;
                sourceIndexPath = nil;
                [snapshot removeFromSuperview];
                snapshot = nil;
                
                self.resetGesture = YES;
                [cell hiddenMask];
            }];
            
            break;
        }
    }
}

#pragma mark - Helper methods

/** @brief Returns a customized snapshot of a given view. */
- (UIView *)customSnapshoFromView:(UIView *)inputView {
    
    // Make an image from the input view.
    UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, 1.0f, 0);
    [inputView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // Create an image view.
    UIView *snapshot = [[UIImageView alloc] initWithImage:image];
    snapshot.layer.masksToBounds = NO;
    snapshot.layer.cornerRadius = 0.0;
    snapshot.layer.shadowOffset = CGSizeMake(-5.0, 0.0);
    snapshot.layer.shadowRadius = 5.0;
    snapshot.layer.shadowOpacity = 0.4;
    
    snapshot.frame = inputView.frame;
    
    return snapshot;
}


- (void)addLongGesture{
    //此处给其增加长按手势，用此手势触发cell移动效果
    if(!_longGesture){
        _longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGestureRecognized:)];
    }
    // 时间因素影响按钮点击事件的响应
    _longGesture.minimumPressDuration = 0.2;
    [self.productsTableView addGestureRecognizer:_longGesture];
}

- (void)addRecognize{
    //添加长按抖动手势
    if(!_recognize){
        _recognize = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    }
    //长按响应时间
    _recognize.minimumPressDuration = 1;
    [self.productsTableView addGestureRecognizer:_recognize];
}


- (void)setResetGesture:(BOOL) resetGesture {
    if (resetGesture) {
        [self.productsTableView removeGestureRecognizer:self.longGesture];
        [self addRecognize];
        
    } else {
        [self.productsTableView removeGestureRecognizer:self.recognize];
        [self addLongGesture];
    }
}


#pragma mark - timer methods

- (void)xwp_setEdgeTimer{
    if (!_edgeTimer ) {
        _edgeTimer = [CADisplayLink displayLinkWithTarget:self selector:@selector(xwp_edgeScroll)];
        [_edgeTimer addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    }
}

- (void)xwp_stopEdgeTimer{
    if (_edgeTimer) {
        [_edgeTimer invalidate];
        _edgeTimer = nil;
    }
}

#pragma mark - setter &&getter


- (UITableView *)productsTableView {
	if (_productsTableView == nil) {
        _productsTableView = [[UITableView alloc] init];
        _productsTableView.delegate = self;
        _productsTableView.dataSource = self;
        _productsTableView.backgroundColor = [UIColor lightGrayColor];
	}
	return _productsTableView;
}
@end
