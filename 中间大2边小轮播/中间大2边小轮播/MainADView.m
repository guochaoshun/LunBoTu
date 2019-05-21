//
//  MainADView.m
//  中间大2边小轮播
//
//  Created by 郭朝顺 on 2019/5/20星期一.
//  Copyright © 2019年 智网易联. All rights reserved.
//

#import "MainADView.h"
#import "MainADCell.h"

@interface MainADView ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (strong, nonatomic) UICollectionView *colloectView;


@property (nonatomic,assign) CGFloat startX ;
@property (nonatomic,assign) CGFloat endX ;

@end

@implementation MainADView



- (void)setDataSourse:(NSArray *)dataSourse {
    _dataSourse = dataSourse;
    [self.colloectView reloadData];
    
    NSInteger allItems = [self.colloectView numberOfItemsInSection:0];
    
    [self.colloectView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:allItems*0.5 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self scrollViewDidScroll:self.colloectView];
        
    });
}



// NSInteger的取值范围是2^63-1,9 223 372 036 854 775 807大约是9*10^18,所以肯定不会超的
// 就算dataSourse里面只有一个元素,1s滑动一次,需要滑动50000次,用户需要无聊的滑动13多个小时才会滑到最右边,如果对10W还是不放心,那就改成100W
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSourse.count * 100000;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MainADCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MainADCell" forIndexPath:indexPath];
    cell.mainImage.image = [UIImage imageNamed:self.dataSourse[indexPath.item%self.dataSourse.count]];
    cell.tag = indexPath.item%self.dataSourse.count;
    return cell;
}



- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    _startX = scrollView.contentOffset.x;
}
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    // 设置targetContentOffset之后就不会有惯性减速了
    *targetContentOffset = scrollView.contentOffset;
    _endX = scrollView.contentOffset.x;
    [self scrollToIndex];
    
}


- (void)scrollToIndex {
    
    UICollectionViewCell * centerCell = self.colloectView.visibleCells.firstObject ;
    
    UICollectionViewCell * rightCell = self.colloectView.visibleCells.firstObject ;
    UICollectionViewCell * leftCell = self.colloectView.visibleCells.firstObject ;
    
    for (UICollectionViewCell * cell in self.colloectView.visibleCells) {
        if (cell.frame.origin.x>rightCell.frame.origin.x) {
            rightCell = cell;
        }
        if (cell.frame.origin.x<leftCell.frame.origin.x) {
            leftCell = cell;
        }
    }
    for (UICollectionViewCell * cell in self.colloectView.visibleCells) {
        if (cell == leftCell || cell==rightCell) {
            continue;
        }
        centerCell = cell;
    }
    
    // 滑动距离太短,就认为是未滑动,还回到中间位置
    if (self.colloectView.visibleCells.count==3) {
        [self.colloectView scrollToItemAtIndexPath:[self.colloectView indexPathForCell:centerCell] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        return;
    }
    
    // 右滑
    if (_endX>_startX) {
        [self.colloectView scrollToItemAtIndexPath:[self.colloectView indexPathForCell:rightCell] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        
    }
    // 左滑
    if (_endX<_startX) {
        [self.colloectView scrollToItemAtIndexPath:[self.colloectView indexPathForCell:leftCell] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        
    }
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat ScreenWidth = [UIScreen mainScreen].bounds.size.width;
    for (UICollectionViewCell * cell in self.colloectView.visibleCells) {
        CGPoint centerPoint = [self convertPoint:cell.center fromView:scrollView];
        
        CGFloat d = fabs(centerPoint.x - ScreenWidth*0.5)/cell.contentView.bounds.size.width;
        // 中间的为1,旁边2个为0.9
        CGFloat scale = 1-0.2*d ;
        cell.layer.transform = CATransform3DMakeScale(scale, scale, 1);
        
        
    }
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"第几张图----%lu",indexPath.item%self.dataSourse.count);
    
    if (self.callBack) {
        self.callBack(self.dataSourse[indexPath.item%self.dataSourse.count]);
    }
    
}

- (UICollectionView *)colloectView {
    if (_colloectView == nil) {
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
        layout.scrollDirection =UICollectionViewScrollDirectionHorizontal;
        layout.itemSize = CGSizeMake(self.frame.size.width*0.75, self.frame.size.height);
        // 设置间距,也可以控制cell之间的缝隙大小
        layout.minimumLineSpacing = 2;
        _colloectView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
        _colloectView.backgroundColor = [UIColor orangeColor];
        _colloectView.delegate = self;
        _colloectView.dataSource = self;
        _colloectView.backgroundColor = [UIColor whiteColor];
        _colloectView.decelerationRate = UIScrollViewDecelerationRateFast;
        _colloectView.showsHorizontalScrollIndicator = NO;
        [_colloectView registerNib:[UINib nibWithNibName:@"MainADCell" bundle:nil] forCellWithReuseIdentifier:@"MainADCell"];
        
        [self addSubview:_colloectView];
        
    }
    return _colloectView;
}




@end
