//
//  LXPhotoBrowserViewController.h
//  LXPhotoBrowser
//
//  Created by 轩 on 2017/5/8.
//  Copyright © 2017年 Xuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LXPhotoBrowserTransitionManger.h"
/**
 查看照片大图的浏览器
 */
@interface LXPhotoBrowserViewController : UIViewController<LXPhotoBrowserDismissDelegate>
+ (instancetype)LXPhotoBrowserViewControllerWithIndexPath:(NSIndexPath *)indexPath imgUrls:(NSArray *)imgUrls;
@end
