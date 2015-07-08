//
//  UIImageView+ImageViewEventBlock.h
//  IRiding
//
//  Created by qianfeng01 on 15/6/22.
//  Copyright (c) 2015年 刘丽丽. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^ImageViewBlock)(UIImageView *imageView);

@interface UIImageView (ImageViewEventBlock)

- (void)addClickEvent:(ImageViewBlock)block;
@end
