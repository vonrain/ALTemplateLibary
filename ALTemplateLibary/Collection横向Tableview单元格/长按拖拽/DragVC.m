//
//  DragVC.m
//  AFTabledCollectionView
//
//  Created by allen on 6/27/17.
//  Copyright © 2017 Ash Furrow. All rights reserved.
//

#import "DragVC.h"
#import "ColumnCell.h"

#define MainHeight  [[UIScreen mainScreen] bounds].size.height
#define MainWidth   [[UIScreen mainScreen] bounds].size.width

@interface DragVC () <UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,ColumnCellDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *collectionCellItemArrary;
@property (nonatomic, strong) UIButton *addBtn;

@property(nonatomic)         CGPoint                      currentContentOffset;                  // default CGPointZero
@end

static NSString *CollectionViewCellId = @"CollectionViewCellId";
@implementation DragVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self layoutPageView];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]
                                               initWithTarget:self action:@selector(longPressGestureRecognized:)];
    [self.collectionView addGestureRecognizer:longPress];
    
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
    for (int i =1 ; i < 15; i++) {
        NSMutableArray *itemArrary = [NSMutableArray new];
//        for (int j = 0; j<i; j++) {
        for (int j = 0; j<15; j++) {
            [itemArrary addObject:@(j)];
        }
        [collectionCellArrary addObject:[itemArrary copy]];
    }
    
    self.collectionCellItemArrary = [collectionCellArrary mutableCopy];
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
            UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:sourceIndexPath];
            cell.alpha = 0.0;
            
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
    
    UIView *mask = [[UIView alloc] initWithFrame:CGRectMake(0, 0, snapshot.frame.size.width, snapshot.frame.size.height)];
    mask.backgroundColor = [UIColor blackColor];
    mask.alpha = .5f;
    [snapshot addSubview:mask];
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

//-(void)clickDelete:(id)sender{


- (void)didDelete:(UICollectionViewCell *)cell{
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    [self.collectionCellItemArrary removeObjectAtIndex:indexPath.row];
    [self.collectionView reloadData];
}


//-(void)resetLongPressGesture {
//    self.resetGesture = YES;
//}

#pragma mark - setter and getter

- (UICollectionView *)collectionView {
	if (_collectionView == nil) {
        
       
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
//        layout.sectionInset = UIEdgeInsetsMake(10, 10, 9, 10);
        layout.itemSize = CGSizeMake(100, MainHeight-64);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
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


@end
