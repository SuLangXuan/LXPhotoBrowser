//
//  ViewController.m
//  LXPhotoBrowser
//
//  Created by 轩 on 2017/5/7.
//  Copyright © 2017年 Xuan. All rights reserved.
//

#import "ViewController.h"
#import "LXRuleWaterFlowLayout.h"
#import "LXWaterItemCollectionViewCell.h"
#import "LXPhotoBrowserViewController.h"
#import "LXPhotoBrowserTransitionManger.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface ViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,LXPhotoBrowserPresentDelegate>
/** 自定义的流水布局 */
@property (nonatomic,strong)LXRuleWaterFlowLayout *lxRuleWaterFlowLayout;
@property (nonatomic,strong)UICollectionView *waterCollectionView;
@property (nonatomic,strong)NSArray *imgUrlArrs;
/** 自定义转场动画的管理者 */
@property (nonatomic,strong)LXPhotoBrowserTransitionManger *transitionManger;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.waterCollectionView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark <UICollectionViewDataSource>

//- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
//    return <#返回多少组#>;
//}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.imgUrlArrs.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *reuseIdentifier = @"cell";
    NSString *url = self.imgUrlArrs[indexPath.row];
    LXWaterItemCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
//    cell.backgroundColor = [UIColor cyanColor];
    [cell.iconImgV sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"ct"]];
    // Configure the cell
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    LXPhotoBrowserViewController *vc = [LXPhotoBrowserViewController LXPhotoBrowserViewControllerWithIndexPath:indexPath imgUrls:self.imgUrlArrs];
    vc.modalPresentationStyle = UIModalPresentationCustom;
    vc.transitioningDelegate = self.transitionManger;
    
    self.transitionManger.presentDelegate = self;
    self.transitionManger.clickIndexPath = indexPath;
    self.transitionManger.dismissDelegate = vc;
    
    [self presentViewController:vc animated:YES completion:nil];
}

#pragma mark - LXPhotoBrowserPresentDelegate
- (CGRect)getStartRectWithIndexPath:(NSIndexPath *)indexPath{
    LXWaterItemCollectionViewCell *cell = (LXWaterItemCollectionViewCell *)[self.waterCollectionView cellForItemAtIndexPath:indexPath];
    return [self.waterCollectionView convertRect:cell.frame toCoordinateSpace:[UIApplication sharedApplication].keyWindow];
}

- (CGRect)getEndRectWithIndexPath:(NSIndexPath *)indexPath{
    UIImage *img = [[[SDWebImageManager sharedManager]imageCache] imageFromDiskCacheForKey:self.imgUrlArrs[indexPath.item]];
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat h = width *img.size.height /img.size.width;
    CGFloat y;
    if (h > [UIScreen mainScreen].bounds.size.height) {
        y = 0;
        
    }else{
        y = ([UIScreen mainScreen].bounds.size.height - h)*0.5;
    }
    return CGRectMake(0, y, width, h);
}

- (UIImageView *)getAnimationImageViewWithIndexPath:(NSIndexPath *)indexPath{
    LXWaterItemCollectionViewCell *cell = (LXWaterItemCollectionViewCell *)[self.waterCollectionView cellForItemAtIndexPath:indexPath];
    return [[UIImageView alloc]initWithImage:cell.iconImgV.image];
}



- (UICollectionView *)waterCollectionView{
    if (!_waterCollectionView) {
        _waterCollectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:self.lxRuleWaterFlowLayout];
        _waterCollectionView.dataSource = self;
        _waterCollectionView.delegate = self;
//        [_waterCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        [_waterCollectionView registerNib:[UINib nibWithNibName:@"LXWaterItemCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"cell"];
    }
    return _waterCollectionView;
}

- (LXRuleWaterFlowLayout *)lxRuleWaterFlowLayout{
    if (!_lxRuleWaterFlowLayout) {
        _lxRuleWaterFlowLayout = [[LXRuleWaterFlowLayout alloc] init];
        _lxRuleWaterFlowLayout.cols = 2;
        _lxRuleWaterFlowLayout.padding = 15;
    }
    return _lxRuleWaterFlowLayout;
}

- (LXPhotoBrowserTransitionManger *)transitionManger{
    if (!_transitionManger) {
        _transitionManger = [[LXPhotoBrowserTransitionManger alloc] init];
    }
    return _transitionManger;
}

- (NSArray *)imgUrlArrs{
    if (!_imgUrlArrs) {
        _imgUrlArrs = @[
                        @"http://wx3.sinaimg.cn/mw690/65bdf84fgy1ffdqfx782hj20qo0qotel.jpg",
                        @"http://wx4.sinaimg.cn/mw690/7049c17bly1ffdoera00uj20b00gi797.jpg",
                        @"http://wx4.sinaimg.cn/mw690/0065PGQDly1ffdqlcsj80j30jg0t6dku.jpg",
                        @"http://wx1.sinaimg.cn/mw690/594fb883ly1ffdq99x07zj20c80gamyx.jpg",
                        @"http://wx3.sinaimg.cn/mw690/682d957aly1ffdobjwhuwj20dc08cjrk.jpg",
                        @"http://wx4.sinaimg.cn/mw690/67dd74e0gy1ffdtenvlufj20hs4v41kx.jpg"
                    ];
    }
    return _imgUrlArrs;
}

@end
