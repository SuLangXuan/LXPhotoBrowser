//
//  LXPhotoBrowserCollectionViewCell.m
//  LXPhotoBrowser
//
//  Created by 轩 on 2017/5/8.
//  Copyright © 2017年 Xuan. All rights reserved.
//

#import "LXPhotoBrowserCollectionViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface LXPhotoBrowserCollectionViewCell ()<UIScrollViewDelegate>

@end

@implementation LXPhotoBrowserCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.scrollView];
    }
    return self;
}

- (void)dealloc{
    self.imageView = nil;
}

#pragma mark - UIScrollViewDelegate
- (nullable UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return self.imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView

{
    
    CGFloat xcenter = scrollView.center.x , ycenter = scrollView.center.y;
    
    //目前contentsize的width是否大于原scrollview的contentsize，如果大于，设置imageview中心x点为contentsize的一半，以固定imageview在该contentsize中心。如果不大于说明图像的宽还没有超出屏幕范围，可继续让中心x点为屏幕中点，此种情况确保图像在屏幕中心。
    
    xcenter = scrollView.contentSize.width > scrollView.frame.size.width ? scrollView.contentSize.width/2 : xcenter;
    
    ycenter = scrollView.contentSize.height > scrollView.frame.size.height ? scrollView.contentSize.height/2 : ycenter;
    
    [self.imageView setCenter:CGPointMake(xcenter, ycenter)];
    
}

- (void)closePhotoBrowser{
    if (self.closeLXPhotoBrowser) {
        self.closeLXPhotoBrowser();
    }else{
        NSLog(@"你没有实现closeLXPhotoBrowser的关闭图片浏览器block/r/n或者关闭方式不对");
    }
}

- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width - 15, self.bounds.size.height)];
        [_scrollView addSubview:self.imageView];
        _scrollView.delegate = self;
        _scrollView.maximumZoomScale = 2.0f;
        _scrollView.minimumZoomScale = 0.8f;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closePhotoBrowser)];
        [_scrollView addGestureRecognizer:tap];
    }
    return _scrollView;
}

- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closePhotoBrowser)];
        [_imageView addGestureRecognizer:tap];
    }
    return _imageView;
}

- (void)setImgUrl:(NSString *)imgUrl{
    _imgUrl = imgUrl;
    
    __weak typeof(self) wSelf = self;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:[UIImage imageNamed:@"ct"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        wSelf.image = image;
    }];
}

- (void)setImage:(UIImage *)image{
    _image = image;
    CGFloat width = self.bounds.size.width;
    CGFloat h = width *image.size.height /image.size.width;
    CGFloat y;
    if (h > self.bounds.size.height) {
        y = 0;
        self.scrollView.contentSize = CGSizeMake(0, h);
    }else{
        y = (self.bounds.size.height - h)*0.5;
    }
    self.imageView.frame = CGRectMake(0, y, width, h);
    self.scrollView.contentSize = CGSizeMake(0, h);
    
}

@end
