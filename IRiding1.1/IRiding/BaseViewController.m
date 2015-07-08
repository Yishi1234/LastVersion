//
//  BaseViewController.m
//  IRiding
//
//  Created by qianfeng01 on 15-6-9.
//  Copyright (c) 2015年 刘丽丽. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:226/255.0 green:226/255.0 blue:226/255.0 alpha:1];
    _manager = [AFHTTPRequestOperationManager manager];
    _manager.requestSerializer = [AFJSONRequestSerializer serializer];
    _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //[self creatGoToTheTopOfView];
}
#pragma mark - 增加标题按钮，子类调用
- (void)addTitleViewWithTitle:(NSString *)title{
    UILabel *titleLabel =[MyControl creatLabelWithFrame:CGRectMake(0, 0, 200, 30) text:title];
    titleLabel.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:25];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor blackColor];
    self.navigationItem.titleView = titleLabel;
}
#pragma mark - 增加导航左右item
- (void)addItemWithTitle:(NSString *)title image:(NSString *)image1 selectedImage:(NSString *)image2 target:(id)target action:(SEL)action isLeft:(BOOL)isLeft{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 50, 30);
    [button setTitle:title forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:image1] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:image2] forState:UIControlStateSelected];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    button.selected = NO;
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:button];
    if (isLeft) {
        self.navigationItem.leftBarButtonItem = item;
    }else{
        button.frame = CGRectMake(0, 0, 50, 30);
        self.navigationItem.rightBarButtonItem = item;
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    if ([self.view window] == nil)// 是否是正在使用的视图
    {
        self.view = nil;// 目的是再次进入时能够重新加载调用viewDidLoad函数。
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
