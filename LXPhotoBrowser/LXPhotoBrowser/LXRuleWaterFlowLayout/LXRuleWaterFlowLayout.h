//
//  LXRuleWaterFlowLayout.h
//  LXPhotoBrowser
//
//  Created by 轩 on 2017/5/7.
//  Copyright © 2017年 Xuan. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 有规律的瀑布流
 */
@interface LXRuleWaterFlowLayout : UICollectionViewFlowLayout
/** 列数 */
@property (nonatomic,assign)int cols;
/** 左右间距 */
@property (nonatomic,assign)CGFloat padding;
@end
