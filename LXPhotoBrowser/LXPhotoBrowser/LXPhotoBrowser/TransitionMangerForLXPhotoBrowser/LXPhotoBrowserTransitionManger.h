//
//  LXPhotoBrowserTransitionManger.h
//  LXPhotoBrowser
//
//  Created by 轩 on 2017/5/8.
//  Copyright © 2017年 Xuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

///转场的delegate
@protocol LXPhotoBrowserPresentDelegate <NSObject>

- (CGRect)getStartRectWithIndexPath:(NSIndexPath *)indexPath;
- (CGRect)getEndRectWithIndexPath:(NSIndexPath *)indexPath;
- (UIImageView *)getAnimationImageViewWithIndexPath:(NSIndexPath *)indexPath;

@end

@protocol LXPhotoBrowserDismissDelegate <NSObject>

- (NSIndexPath *)getCurrentIndexpathForDismissView;
- (UIImageView *)getImageViewForDismissView;

@end


@interface LXPhotoBrowserTransitionManger : NSObject<UIViewControllerTransitioningDelegate,UIViewControllerAnimatedTransitioning>
/** 开始位置的frame */
@property (nonatomic,assign)CGRect startRect;
/** 图片 */
@property (nonatomic,strong)UIImage *img;
/** 转场的delegate */
@property (nonatomic,weak)id<LXPhotoBrowserPresentDelegate> presentDelegate;
/** 退场的delegate */
@property (nonatomic,weak)id<LXPhotoBrowserDismissDelegate> dismissDelegate;
/** 选中的IndexPath */
@property (nonatomic,strong)NSIndexPath *clickIndexPath;
@end
