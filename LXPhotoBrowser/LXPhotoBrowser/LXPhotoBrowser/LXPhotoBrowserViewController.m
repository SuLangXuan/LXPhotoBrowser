//
//  LXPhotoBrowserViewController.m
//  LXPhotoBrowser
//
//  Created by 轩 on 2017/5/8.
//  Copyright © 2017年 Xuan. All rights reserved.
//

#import "LXPhotoBrowserViewController.h"
#import "LXPhotoBrowserCollectionViewCell.h"

@interface LXPhotoBrowserViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
/** 点击图片的indexPath */
@property (nonatomic,strong)NSIndexPath *clickIndexPath;
@property (nonatomic,strong)UICollectionView *collectionView;
@property (nonatomic,strong)UICollectionViewFlowLayout *flowLayout;
@property (nonatomic,strong)NSArray *imgUrlsArr;
@end

@implementation LXPhotoBrowserViewController

+ (instancetype)LXPhotoBrowserViewControllerWithIndexPath:(NSIndexPath *)indexPath imgUrls:(NSArray *)imgUrls{
    LXPhotoBrowserViewController *vc = [[LXPhotoBrowserViewController alloc] init];
    vc.clickIndexPath = indexPath;
    vc.imgUrlsArr = imgUrls;
    return vc;
}

- (void)loadView{
    [super loadView];
    CGRect temp = self.view.frame;
    temp.size.width += 15;
    self.view.frame = temp;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.collectionView];
    [self.collectionView scrollToItemAtIndexPath:self.clickIndexPath atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark <UICollectionViewDataSource>

//- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
//    return <#返回多少组#>;
//}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.imgUrlsArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *reuseIdentifier = @"cell2";
    LXPhotoBrowserCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.imgUrl = self.imgUrlsArr[indexPath.item];
    __weak typeof(self) wSelf = self;
    [cell setCloseLXPhotoBrowser:^{
        [wSelf dismissViewControllerAnimated:YES completion:nil];
    }];
    return cell;
}

///在该方法里主要实现对之前已经放大的视图，进行还原的操作。
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self.collectionView.visibleCells enumerateObjectsUsingBlock:^(__kindof LXPhotoBrowserCollectionViewCell * _Nonnull cell, NSUInteger idx, BOOL * _Nonnull stop) {
        //延迟操作是为了，在滚动的时候缩小动画的不会同时出现，如果没有的话，会有一闪而过的效果（不好看）。
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [cell.scrollView setZoomScale:1.0f];
            CGFloat width = cell.bounds.size.width;
            CGFloat h = width *cell.image.size.height /cell.image.size.width;
            if (h > cell.bounds.size.height) {
                cell.scrollView.contentSize = CGSizeMake(0, h);
            }else{
                cell.scrollView.contentSize = CGSizeMake(0, cell.bounds.size.height);
            }
            
        });
    }];
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:self.flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[LXPhotoBrowserCollectionViewCell class] forCellWithReuseIdentifier:@"cell2"];
        _collectionView.pagingEnabled = YES;
    }
    return _collectionView;
}

- (UICollectionViewFlowLayout *)flowLayout{
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.itemSize = self.view.frame.size;
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _flowLayout.minimumLineSpacing = 0;
        _flowLayout.minimumInteritemSpacing = 0;
    }
    return _flowLayout;
}


@end
