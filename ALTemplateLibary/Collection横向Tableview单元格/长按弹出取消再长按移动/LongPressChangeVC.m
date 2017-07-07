//
//  LongPressChangeVC.m
//  AFTabledCollectionView
//
//  Created by allen on 6/29/17.
//  Copyright © 2017 Ash Furrow. All rights reserved.
//

#import "LongPressChangeVC.h"
#import "ColumnCell.h"

#define MainHeight  [[UIScreen mainScreen] bounds].size.height
#define MainWidth   [[UIScreen mainScreen] bounds].size.width
typedef NS_ENUM(NSUInteger, XWDragCellCollectionViewScrollDirection) {
    XWDragCellCollectionViewScrollDirectionNone = 0,
    XWDragCellCollectionViewScrollDirectionLeft,
    XWDragCellCollectionViewScrollDirectionRight,
    XWDragCellCollectionViewScrollDirectionUp,
    XWDragCellCollectionViewScrollDirectionDown
};

@interface LongPressChangeVC () <UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,ColumnCellDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *collectionCellItemArrary;
@property (nonatomic, strong) UIButton *addBtn;
@property (nonatomic, strong) UIView   *maskView;
@property (nonatomic, strong) UIView   *mask;
@property (nonatomic) BOOL resetGesture;
/**抖动手势*/
@property (nonatomic,strong) UILongPressGestureRecognizer *recognize;
/**移动手势*/
@property (nonatomic,strong) UILongPressGestureRecognizer *longGesture;

@property(nonatomic)         CGPoint                      currentContentOffset;                  // default CGPointZero




@property (nonatomic, strong) CADisplayLink *edgeTimer;
@property (nonatomic) BOOL isPanning;
@property (nonatomic, assign) XWDragCellCollectionViewScrollDirection scrollDirection;
@property (nonatomic, weak) UIView *tempMoveCell;


@end

static NSString *CollectionViewCellId = @"CollectionViewCellId";
@implementation LongPressChangeVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self layoutPageView];
    
    [self addRecognize];
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)layoutPageView {
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.addBtn];
}


-(void)generateData:(id)data {
    
    NSMutableArray *collectionCellArrary = [NSMutableArray new];
    for (int i =1 ; i < 5; i++) {
        NSMutableArray *itemArrary = [NSMutableArray new];
        //        for (int j = 0; j<i; j++) {
        for (int j = 0; j<15; j++) {
            [itemArrary addObject:@(j)];
        }
        [collectionCellArrary addObject:[itemArrary copy]];
    }
    
    self.collectionCellItemArrary = [collectionCellArrary mutableCopy];
}


- (void)longPress:(UILongPressGestureRecognizer *)longGesture {
    //判断手势状态
    switch (longGesture.state) {
        case UIGestureRecognizerStateBegan:{
            //判断手势落点位置是否在路径上
            NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:[longGesture locationInView:self.collectionView]];
            ColumnCell *cell = (ColumnCell*)[self.collectionView cellForItemAtIndexPath:indexPath];
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
    
    CGPoint location = [longPress locationInView:self.collectionView];
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:location];
    
    static UIView       *snapshot = nil;        ///< A snapshot of the row user is moving.
    static NSIndexPath  *sourceIndexPath = nil; ///< Initial index path, where gesture begins.
    
    switch (state) {
        case UIGestureRecognizerStateBegan: {
            if (indexPath) {
                sourceIndexPath = indexPath;
                
                UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];
                
                // Take a snapshot of the selected row using helper method.
                snapshot = [self customSnapshoFromView:cell];
                
                // Add the snapshot as subview, centered at cell's center...
                __block CGPoint center = cell.center;
                snapshot.center = center;
                snapshot.alpha = 0.0;
                [self.collectionView addSubview:snapshot];
                
                self.tempMoveCell = snapshot;
                //开启边缘滚动定时器
                [self xwp_setEdgeTimer];
                
                [UIView animateWithDuration:0.25 animations:^{
                    
                    // Offset for gesture location.
                    center.x = location.x;
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
            center.x = location.x;
            snapshot.center = center;
            
            // Is destination valid and is it different from source?
            if (indexPath && ![indexPath isEqual:sourceIndexPath]) {
                
                // ... update data source.
                [self.collectionCellItemArrary exchangeObjectAtIndex:indexPath.row withObjectAtIndex:sourceIndexPath.row];
                
                // ... move the rows.
                [self.collectionView moveItemAtIndexPath:sourceIndexPath toIndexPath:indexPath];
                
                // ... and update source so it is in sync with UI changes.
                sourceIndexPath = indexPath;
            }
            break;
        }
            
        default: {
            // Clean up.
//            UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:sourceIndexPath];
            ColumnCell *cell = (ColumnCell*)[self.collectionView cellForItemAtIndexPath:sourceIndexPath];
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

#pragma mark - UICollectionViewDataSource Methods

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.collectionCellItemArrary.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ColumnCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CollectionViewCellId forIndexPath:indexPath];
    
    cell.delegate = self;
    [cell generateData:self.collectionCellItemArrary[indexPath.row]];
    cell.backgroundColor= [UIColor yellowColor];
    
    return cell;
}


- (void)scrollViewDidColumnCellScroll:(UIScrollView*)scrollView{
    
    if ([scrollView isKindOfClass:[UITableView class]]) {
        for (ColumnCell* cell in self.collectionView.visibleCells) {
            for (UIView *view in cell.contentView.subviews) {
                if ([view isKindOfClass:[UITableView class]]) {
                    UITableView *collectionView = (UITableView *)view;
                    collectionView.contentOffset = scrollView.contentOffset;
                    self.currentContentOffset = scrollView.contentOffset;
                }
            }
            
        }
    }
}

-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    
    NSLog(@"scrollViewWillBeginDecelerating");
    if ([scrollView isKindOfClass:[UICollectionView class]]) {
        [self alignedCell];
    }
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    NSLog(@"%@",decelerate?@"YES":@"NO");
    if (!decelerate) {
        if ([scrollView isKindOfClass:[UICollectionView class]]) {
            [self alignedCell];
        }
        
    }
}

-(void)alignedCell {
    for (ColumnCell* cell in self.collectionView.visibleCells) {
        for (UIView *view in cell.contentView.subviews) {
            if ([view isKindOfClass:[UITableView class]]) {
                UITableView *collectionView = (UITableView *)view;
                collectionView.contentOffset = self.currentContentOffset;
            }
        }
        
    }
}
#pragma mark - click events
-(void)clickAdd:(id)sender{
    
    NSMutableArray *itemArrary = [NSMutableArray new];
    for (int j = 0; j<3; j++) {
        [itemArrary addObject:@(j)];
    }
    [self.collectionCellItemArrary addObject:[itemArrary mutableCopy]];
    
    [self.collectionView reloadData];
    
}


#pragma mark - CustomerDelegate
- (void)didDelete:(UICollectionViewCell *)cell{
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    [self.collectionCellItemArrary removeObjectAtIndex:indexPath.row];
    
    self.resetGesture = YES;
    
    [self.collectionView reloadData];
}

-(void)resetLongPressGesture {
    self.resetGesture = YES;
}


- (void)xwp_setScrollDirection{
    _scrollDirection = XWDragCellCollectionViewScrollDirectionNone;
    if (self.collectionView.bounds.size.height + self.collectionView.contentOffset.y - _tempMoveCell.center.y < _tempMoveCell.bounds.size.height / 2 && self.collectionView.bounds.size.height + self.collectionView.contentOffset.y < self.collectionView.contentSize.height) {
        _scrollDirection = XWDragCellCollectionViewScrollDirectionDown;
    }
    if (_tempMoveCell.center.y - self.collectionView.contentOffset.y < _tempMoveCell.bounds.size.height / 2 && self.collectionView.contentOffset.y > 0) {
        _scrollDirection = XWDragCellCollectionViewScrollDirectionUp;
    }
    if (self.collectionView.bounds.size.width + self.collectionView.contentOffset.x - _tempMoveCell.center.x < _tempMoveCell.bounds.size.width / 2 && self.collectionView.bounds.size.width + self.collectionView.contentOffset.x < self.collectionView.contentSize.width) {
        _scrollDirection = XWDragCellCollectionViewScrollDirectionRight;
    }
    
    if (_tempMoveCell.center.x - self.collectionView.contentOffset.x < _tempMoveCell.bounds.size.width / 2 && self.collectionView.contentOffset.x > 0) {
        _scrollDirection = XWDragCellCollectionViewScrollDirectionLeft;
    }
}

- (void)xwp_edgeScroll{
    [self xwp_setScrollDirection];
    switch (_scrollDirection) {
        case XWDragCellCollectionViewScrollDirectionLeft:{
            //这里的动画必须设为NO
            [self.collectionView setContentOffset:CGPointMake(self.collectionView.contentOffset.x - 4, self.collectionView.contentOffset.y) animated:NO];
            _tempMoveCell.center = CGPointMake(_tempMoveCell.center.x - 4, _tempMoveCell.center.y);
        }
            break;
        case XWDragCellCollectionViewScrollDirectionRight:{
            [self.collectionView setContentOffset:CGPointMake(self.collectionView.contentOffset.x + 4, self.collectionView.contentOffset.y) animated:NO];
            _tempMoveCell.center = CGPointMake(_tempMoveCell.center.x + 4, _tempMoveCell.center.y);
            
        }
            break;
        case XWDragCellCollectionViewScrollDirectionUp:{
            [self.collectionView setContentOffset:CGPointMake(self.collectionView.contentOffset.x, self.collectionView.contentOffset.y - 4) animated:NO];
            _tempMoveCell.center = CGPointMake(_tempMoveCell.center.x, _tempMoveCell.center.y - 4);
        }
            break;
        case XWDragCellCollectionViewScrollDirectionDown:{
            [self.collectionView setContentOffset:CGPointMake(self.collectionView.contentOffset.x, self.collectionView.contentOffset.y + 4) animated:NO];
            _tempMoveCell.center = CGPointMake(_tempMoveCell.center.x, _tempMoveCell.center.y + 4);
        }
            break;
        default:
            break;
    }
    
}

#pragma mark - setter and getter

- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        //        layout.sectionInset = UIEdgeInsetsMake(10, 10, 9, 10);
        layout.itemSize = CGSizeMake(100, MainHeight-64);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 1;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, MainWidth,MainHeight ) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.scrollEnabled = YES;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        
        [_collectionView registerClass:[ColumnCell class] forCellWithReuseIdentifier:CollectionViewCellId];
        
    }
    return _collectionView;
}

- (UIButton *)addBtn {
    if (_addBtn == nil) {
        _addBtn = [[UIButton alloc] initWithFrame:CGRectMake(0,64, 30, 30)];
        _addBtn.titleLabel.text = @"+";
        _addBtn.backgroundColor = [UIColor redColor];
        [_addBtn addTarget:self action:@selector(clickAdd:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addBtn;
}


- (void)addLongGesture{
    //此处给其增加长按手势，用此手势触发cell移动效果
    if(!_longGesture){
        _longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGestureRecognized:)];
    }
    // 时间因素影响按钮点击事件的响应
    _longGesture.minimumPressDuration = 0.2;
    [self.collectionView addGestureRecognizer:_longGesture];
}

- (void)addRecognize{
    //添加长按抖动手势
    if(!_recognize){
        _recognize = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    }
    //长按响应时间
    _recognize.minimumPressDuration = 1;
    [self.collectionView addGestureRecognizer:_recognize];
}


- (void)setResetGesture:(BOOL) resetGesture {
    if (resetGesture) {
        [self.collectionView removeGestureRecognizer:self.longGesture];
        [self addRecognize];
        
    } else {
        [self.collectionView removeGestureRecognizer:self.recognize];
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
@end