//
//  LXRuleWaterFlowLayout.m
//  LXPhotoBrowser
//
//  Created by 轩 on 2017/5/7.
//  Copyright © 2017年 Xuan. All rights reserved.
//

#import "LXRuleWaterFlowLayout.h"



@interface LXRuleWaterFlowLayout ()
/** 存储布局属性的数组 */
@property (nonatomic,strong)NSMutableArray *attributesArr;
/** item的个数 */
@property (nonatomic,assign)NSInteger itemCount;
/** 记录ItemY值的数组 */
@property (nonatomic,strong)NSMutableArray *itemYs;
@end


@implementation LXRuleWaterFlowLayout

///准备布局
- (void)prepareLayout{
    [super prepareLayout];
    //拿到当前section的cell
    NSInteger itemCount = [self.collectionView numberOfItemsInSection:0];
    self.itemCount = itemCount;
    for (int i = 0; i < itemCount; i++) {
        //为每个cell创建布局属性
        UICollectionViewLayoutAttributes *attribute = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        CGFloat width = [self getItemWidth];
        CGFloat height = [self getItemHeightWithCurrentItem:i];
        CGFloat itemX = [self getItemXWithCurrentItem:i];
        CGFloat itemY = [self getItemYWithCurrentItem:i];
        attribute.frame = CGRectMake(itemX, itemY, width, height);
//        NSLog(@"%@",NSStringFromCGRect(CGRectMake(itemX, itemY, width, height)));
        [self.attributesArr addObject:attribute];
    }
    
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    return self.attributesArr;
}

- (CGSize)collectionViewContentSize{
    return CGSizeMake(0, [self getMaxY] + self.padding);
}

#pragma mark - 计算每个item的frame
- (CGFloat)getItemWidth{
    return (self.collectionView.bounds.size.width - (self.cols - 1) * self.minimumInteritemSpacing - self.padding * 2) / self.cols;
}

- (CGFloat)getItemHeightWithCurrentItem:(int)currentItem{
    CGFloat width = [self getItemWidth];
    return currentItem % 2 == 0 ? width * 1.5 : width *0.8;
}

- (CGFloat)getItemXWithCurrentItem:(int)currentItem{
    CGFloat width = [self getItemWidth];
    
    NSUInteger minCols = [self getMinCols];
    return self.padding + (width +self.padding)*(minCols);
}

- (CGFloat)getItemYWithCurrentItem:(int)currentItem{
    CGFloat width = [self getItemWidth];
    //获取最短的Y值的列数
    NSUInteger minCols = [self getMinCols];
    CGFloat minColsItemY = [self.itemYs[minCols] floatValue];
    CGFloat height = currentItem % 2 == 0 ? width * 1.5 : width *0.8;
    self.itemYs[minCols] = @(minColsItemY + self.padding + height);
    return minColsItemY + self.padding;
}



- (NSMutableArray *)attributesArr{
    if (!_attributesArr) {
        _attributesArr = [NSMutableArray array];
    }
    return _attributesArr;
}

- (NSMutableArray *)itemYs{
    if (!_itemYs) {
        _itemYs = [NSMutableArray array];
        CGFloat defaultY = self.sectionInset.top;
        for (int i = 0; i < self.cols; i++) {
            [_itemYs addObject:@(defaultY)];
        }
    }
    return _itemYs;
}

#pragma mark - 对Y值数组的操作
- (CGFloat)getMaxY{
    __block CGFloat maxY = [self.itemYs[0] floatValue];
    [self.itemYs enumerateObjectsUsingBlock:^(NSNumber *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (maxY < [obj floatValue]) {
            maxY = [obj floatValue];
        }
    }];
    return maxY;
}

- (CGFloat)getMinY{
    __block CGFloat minY = [self.itemYs[0] floatValue];
    [self.itemYs enumerateObjectsUsingBlock:^(NSNumber *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (minY > [obj floatValue]) {
            minY = [obj floatValue];
        }
    }];
    return minY;
}

- (NSUInteger)getMinCols{
    __block NSUInteger minCols = 0;
    __weak typeof(self) wSelf = self;
    [self.itemYs enumerateObjectsUsingBlock:^(NSNumber *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([wSelf.itemYs[minCols] floatValue] > [obj floatValue]) {
            minCols = idx;
        }
    }];
    return minCols;
}

- (NSUInteger)getMaxCols{
    __block NSUInteger maxCols = 0;
    __weak typeof(self) wSelf = self;
    [self.itemYs enumerateObjectsUsingBlock:^(NSNumber *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([wSelf.itemYs[maxCols] floatValue] < [obj floatValue]) {
            maxCols = idx;
        }
    }];
    return maxCols;
}

@end
