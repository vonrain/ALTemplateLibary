//
//  DragUITableViewVC.m
//  AFTabledCollectionView
//
//  Created by allen on 6/30/17.
//  Copyright © 2017 Ash Furrow. All rights reserved.
//

//#import "DragUITableViewVC.h"
//#import "ColumnCell.h"
//#import "TableViewColumnCell.h"
//
//@interface DragUITableViewVC ()<UITableViewDelegate,UITableViewDataSource,TableColumnCellDelegate>
//@property (nonatomic, strong) UITableView *dragTableView;
//@property (nonatomic, strong) NSArray *colorArray;
//@property (nonatomic, strong) NSMutableDictionary *contentOffsetDictionary;
//@end
//
//@implementation DragUITableViewVC
//
//-(void)loadView
//{
//    [super loadView];
//    
//    const NSInteger numberOfTableViewRows = 20;
//    const NSInteger numberOfCollectionViewCells = 15;
//    
//    NSMutableArray *mutableArray = [NSMutableArray arrayWithCapacity:numberOfTableViewRows];
//    
//    for (NSInteger tableViewRow = 0; tableViewRow < numberOfTableViewRows; tableViewRow++)
//    {
//        NSMutableArray *colorArray = [NSMutableArray arrayWithCapacity:numberOfCollectionViewCells];
//        
//        for (NSInteger dragTableViewItem = 0; dragTableViewItem < numberOfCollectionViewCells; dragTableViewItem++)
//        {
//            
//            CGFloat red = arc4random() % 255;
//            CGFloat green = arc4random() % 255;
//            CGFloat blue = arc4random() % 255;
//            UIColor *color = [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:1.0f];
//            
//            [colorArray addObject:color];
//        }
//        
//        [mutableArray addObject:colorArray];
//    }
//    
//    self.colorArray = [NSArray arrayWithArray:mutableArray];
//    
//    self.contentOffsetDictionary = [NSMutableDictionary dictionary];
//}
//
//- (void)viewDidLoad
//{
//    [super viewDidLoad];
//    self.view.backgroundColor = [UIColor whiteColor];
//    [self layoutPageView];
//    
////    [self addRecognize];
//    
//    // Do any additional setup after loading the view, typically from a nib.
//}
//
//- (void)didReceiveMemoryWarning
//{
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}
//
//- (void)layoutPageView {
//    [self.view addSubview:self.dragTableView];
//}
//
//#pragma mark - UITableViewDataSource Methods
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return 1;
//}
//
//-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return self.colorArray.count;
//}
//
//-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *CellIdentifier = @"CellIdentifier";
//    
//    TableViewColumnCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    
//    if (!cell)
//    {
//        cell = [[TableViewColumnCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//    }
//    
//    [cell generateData:self.colorArray[indexPath.row]];
//    // cell顺时针旋转90度
////    cell.contentView.transform = CGAffineTransformMakeRotation(M_PI / 2);
//    return cell;
//}
//
//#pragma mark - UITableViewDelegate Methods
//
//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return [TableViewColumnCell cellHeigh];
//}
//
//
//#pragma mark - UIScrollViewDelegate Methods
//
//#pragma mark - setter && getter
//
//- (UITableView *)dragTableView {
//	if (_dragTableView == nil) {
//        _dragTableView = [[UITableView alloc] init];
//        _dragTableView.transform = CGAffineTransformMakeRotation(-M_PI/2);
//        _dragTableView.frame = CGRectMake(-64, 64, MainWidth+64, MainHeight - 64);
//        _dragTableView.backgroundColor = [UIColor blueColor];
//        _dragTableView.delegate = self;
//        _dragTableView.dataSource = self;;
//	}
//	return _dragTableView;
//}
//- (NSArray *)colorArray {
//	if (_colorArray == nil) {
//        _colorArray = [[NSArray alloc] init];
//	}
//	return _colorArray;
//}
//- (NSMutableDictionary *)contentOffsetDictionary {
//	if (_contentOffsetDictionary == nil) {
//        _contentOffsetDictionary = [[NSMutableDictionary alloc] init];
//	}
//	return _contentOffsetDictionary;
//}
//
//
//@end


//
//  LongPressChangeVC.m
//  AFTabledCollectionView
//
//  Created by allen on 6/29/17.
//  Copyright © 2017 Ash Furrow. All rights reserved.
//

#import "DragUITableViewVC.h"
#import "TableViewColumnCell.h"

#define MainHeight  [[UIScreen mainScreen] bounds].size.height
#define MainWidth   [[UIScreen mainScreen] bounds].size.width
typedef NS_ENUM(NSUInteger, XWDragCellCollectionViewScrollDirection) {
    XWDragCellCollectionViewScrollDirectionNone = 0,
    XWDragCellCollectionViewScrollDirectionLeft,
    XWDragCellCollectionViewScrollDirectionRight,
    XWDragCellCollectionViewScrollDirectionUp,
    XWDragCellCollectionViewScrollDirectionDown
};

@interface DragUITableViewVC () <UITableViewDelegate,UITableViewDataSource,TableColumnCellDelegate>

@property (nonatomic, strong) UITableView *dragTableView;
//@property (nonatomic, strong) UICollectionView *dragTableView;
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
@implementation DragUITableViewVC

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
    [self.view addSubview:self.dragTableView];
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
            NSIndexPath *indexPath = [self.dragTableView indexPathForRowAtPoint:[longGesture locationInView:self.dragTableView]];
            TableViewColumnCell *cell = (TableViewColumnCell*)[self.dragTableView cellForRowAtIndexPath:indexPath];
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
    
    CGPoint location = [longPress locationInView:self.dragTableView];
    NSIndexPath *indexPath = [self.dragTableView indexPathForRowAtPoint:location];
    
    static UIView       *snapshot = nil;        ///< A snapshot of the row user is moving.
    static NSIndexPath  *sourceIndexPath = nil; ///< Initial index path, where gesture begins.
    
    switch (state) {
        case UIGestureRecognizerStateBegan: {
            if (indexPath) {
                sourceIndexPath = indexPath;
                
                UITableViewCell *cell = [self.dragTableView cellForRowAtIndexPath:indexPath];
                
                // Take a snapshot of the selected row using helper method.
                snapshot = [self customSnapshoFromView:cell];
                
                // Add the snapshot as subview, centered at cell's center...
                __block CGPoint center = cell.center;
                snapshot.center = center;
                snapshot.alpha = 0.0;
                [self.dragTableView addSubview:snapshot];
                
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
                [self.collectionCellItemArrary exchangeObjectAtIndex:indexPath.row withObjectAtIndex:sourceIndexPath.row];
                
                // ... move the rows.
                [self.dragTableView moveRowAtIndexPath:sourceIndexPath toIndexPath:indexPath];
                
                // ... and update source so it is in sync with UI changes.
                sourceIndexPath = indexPath;
            }
            break;
        }
            
        default: {
            // Clean up.
            //            UICollectionViewCell *cell = [self.dragTableView cellForItemAtIndexPath:sourceIndexPath];
            TableViewColumnCell *cell = (TableViewColumnCell*)[self.dragTableView cellForRowAtIndexPath:sourceIndexPath];
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

#pragma mark - UITableViewDataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.collectionCellItemArrary.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
    
    TableViewColumnCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell)
    {
        cell = [[TableViewColumnCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    [cell generateData:self.collectionCellItemArrary[indexPath.row]];
    cell.delegate = self;
    // cell顺时针旋转90度
    //    cell.contentView.transform = CGAffineTransformMakeRotation(M_PI / 2);
    return cell;
}

#pragma mark - UITableViewDelegate Methods

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [TableViewColumnCell cellHeigh];
}


#pragma mark - UIScrollViewDelegate Methods

#pragma mark - setter && getter

- (UITableView *)dragTableView {
    if (_dragTableView == nil) {
        _dragTableView = [[UITableView alloc] init];
        _dragTableView.transform = CGAffineTransformMakeRotation(-M_PI/2);
        _dragTableView.frame = CGRectMake(-64, 64, MainWidth+64, MainHeight - 64);
        _dragTableView.backgroundColor = [UIColor blueColor];
        _dragTableView.delegate = self;
        _dragTableView.dataSource = self;;
    }
    return _dragTableView;
}

- (void)scrollViewDidColumnCellScroll:(UIScrollView*)scrollView{
    
    if ([scrollView isKindOfClass:[UITableView class]]) {
        for (TableViewColumnCell* cell in self.dragTableView.visibleCells) {
            for (UIView *view in cell.contentView.subviews) {
                if ([view isKindOfClass:[UITableView class]]) {
                    UITableView *dragTableView = (UITableView *)view;
                    dragTableView.contentOffset = scrollView.contentOffset;
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
    for (TableViewColumnCell* cell in self.dragTableView.visibleCells) {
        for (UIView *view in cell.contentView.subviews) {
            if ([view isKindOfClass:[UITableView class]]) {
                UITableView *dragTableView = (UITableView *)view;
                dragTableView.contentOffset = self.currentContentOffset;
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
    
    [self.dragTableView reloadData];
    
}


#pragma mark - CustomerDelegate
- (void)didDelete:(UITableViewCell *)cell{
    NSIndexPath *indexPath = [self.dragTableView indexPathForCell:cell];
    [self.collectionCellItemArrary removeObjectAtIndex:indexPath.row];
    
    self.resetGesture = YES;
    
    [self.dragTableView reloadData];
}

-(void)resetLongPressGesture {
    self.resetGesture = YES;
}


- (void)xwp_setScrollDirection{
    _scrollDirection = XWDragCellCollectionViewScrollDirectionNone;
    if (self.dragTableView.bounds.size.height + self.dragTableView.contentOffset.y - _tempMoveCell.center.y < _tempMoveCell.bounds.size.height / 2 && self.dragTableView.bounds.size.height + self.dragTableView.contentOffset.y < self.dragTableView.contentSize.height) {
        _scrollDirection = XWDragCellCollectionViewScrollDirectionDown;
    }
    if (_tempMoveCell.center.y - self.dragTableView.contentOffset.y < _tempMoveCell.bounds.size.height / 2 && self.dragTableView.contentOffset.y > 0) {
        _scrollDirection = XWDragCellCollectionViewScrollDirectionUp;
    }
    if (self.dragTableView.bounds.size.width + self.dragTableView.contentOffset.x - _tempMoveCell.center.x < _tempMoveCell.bounds.size.width / 2 && self.dragTableView.bounds.size.width + self.dragTableView.contentOffset.x < self.dragTableView.contentSize.width) {
        _scrollDirection = XWDragCellCollectionViewScrollDirectionRight;
    }
    
    if (_tempMoveCell.center.x - self.dragTableView.contentOffset.x < _tempMoveCell.bounds.size.width / 2 && self.dragTableView.contentOffset.x > 0) {
        _scrollDirection = XWDragCellCollectionViewScrollDirectionLeft;
    }
}

- (void)xwp_edgeScroll{
    [self xwp_setScrollDirection];
    switch (_scrollDirection) {
        case XWDragCellCollectionViewScrollDirectionLeft:{
            //这里的动画必须设为NO
            [self.dragTableView setContentOffset:CGPointMake(self.dragTableView.contentOffset.x - 4, self.dragTableView.contentOffset.y) animated:NO];
            _tempMoveCell.center = CGPointMake(_tempMoveCell.center.x - 4, _tempMoveCell.center.y);
        }
            break;
        case XWDragCellCollectionViewScrollDirectionRight:{
            [self.dragTableView setContentOffset:CGPointMake(self.dragTableView.contentOffset.x + 4, self.dragTableView.contentOffset.y) animated:NO];
            _tempMoveCell.center = CGPointMake(_tempMoveCell.center.x + 4, _tempMoveCell.center.y);
            
        }
            break;
        case XWDragCellCollectionViewScrollDirectionUp:{
            [self.dragTableView setContentOffset:CGPointMake(self.dragTableView.contentOffset.x, self.dragTableView.contentOffset.y - 4) animated:NO];
            _tempMoveCell.center = CGPointMake(_tempMoveCell.center.x, _tempMoveCell.center.y - 4);
        }
            break;
        case XWDragCellCollectionViewScrollDirectionDown:{
            [self.dragTableView setContentOffset:CGPointMake(self.dragTableView.contentOffset.x, self.dragTableView.contentOffset.y + 4) animated:NO];
            _tempMoveCell.center = CGPointMake(_tempMoveCell.center.x, _tempMoveCell.center.y + 4);
        }
            break;
        default:
            break;
    }
    
}

#pragma mark - setter and getter

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
    [self.dragTableView addGestureRecognizer:_longGesture];
}

- (void)addRecognize{
    //添加长按抖动手势
    if(!_recognize){
        _recognize = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    }
    //长按响应时间
    _recognize.minimumPressDuration = 1;
    [self.dragTableView addGestureRecognizer:_recognize];
}


- (void)setResetGesture:(BOOL) resetGesture {
    if (resetGesture) {
        [self.dragTableView removeGestureRecognizer:self.longGesture];
        [self addRecognize];
        
    } else {
        [self.dragTableView removeGestureRecognizer:self.recognize];
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
