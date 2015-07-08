//
//  MySettingViewController.h
//  IRiding
//
//  Created by qianfeng01 on 15/7/1.
//  Copyright (c) 2015年 刘丽丽. All rights reserved.
//

#import "BaseViewController.h"

@interface MySettingViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
- (IBAction)btnClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *passwdView;
@property (weak, nonatomic) IBOutlet UIButton *manButton;
@property (weak, nonatomic) IBOutlet UIButton *womanButton;
@property (weak, nonatomic) IBOutlet UIImageView *passwdGoForwoad;

@property (nonatomic,copy)NSString *url;
@end
