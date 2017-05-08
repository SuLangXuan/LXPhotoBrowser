//
//  LXPhotoBrowserCollectionViewCell.h
//  LXPhotoBrowser
//
//  Created by 轩 on 2017/5/8.
//  Copyright © 2017年 Xuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LXPhotoBrowserCollectionViewCell : UICollectionViewCell
@property (nonatomic,copy) NSString *imgUrl;
@property (nonatomic,copy) void(^closeLXPhotoBrowser)();
@property (nonatomic,strong)UIScrollView *scrollView;
@property (nonatomic,strong)UIImageView *imageView;
@property (nonatomic,strong)UIImage *image;
@end
