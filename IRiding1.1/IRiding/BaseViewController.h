//
//  BaseViewController.h
//  IRiding
//
//  Created by qianfeng01 on 15-6-9.
//  Copyright (c) 2015年 刘丽丽. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController
{
     AFHTTPRequestOperationManager *_manager;
}
//标题按钮
- (void)addTitleViewWithTitle:(NSString *)title;
//导航左右按钮
- (void)addItemWithTitle:(NSString *)title image:(NSString *)image1  selectedImage:(NSString *)image2 target:(id)target action:(SEL)action isLeft:(BOOL)isLeft;

@end
