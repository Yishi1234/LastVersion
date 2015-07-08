//
//  ChangePasswdViewController.m
//  IRiding
//
//  Created by qianfeng01 on 15/7/3.
//  Copyright (c) 2015年 刘丽丽. All rights reserved.
//

#import "ChangePasswdViewController.h"

@interface ChangePasswdViewController ()<UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *originalPasswd;
@property (weak, nonatomic) IBOutlet UITextField *changedPasswd;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswd;
- (IBAction)saveButton:(UIButton *)sender;




@end

@implementation ChangePasswdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}
- (IBAction)saveButton:(UIButton *)sender {
    if ([self.changedPasswd.text isEqualToString:self.confirmPasswd.text]) {
        [self addChangePasswdTask];
    }else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Sorry" message:@"两次密码不一致" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    }
}
#pragma mark - 增加任务 提交新密码
- (void)addChangePasswdTask{
    NSMutableDictionary *urlDict = [NSMutableDictionary dictionaryWithDictionary:@{@"password":@"1234",@"new_password":@"1"}];
    [urlDict setObject:self.originalPasswd.text forKey:@"password"];
    [urlDict setObject:self.changedPasswd.text forKey:@"new_password"];
    //__weak typeof (self)weakSelf = self;
    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleFade];
    [MMProgressHUD showWithTitle:@"密码修改中" status:@"uploading..."];
    [_manager POST:[kChangePasswdUrl stringByAppendingString:[[NSUserDefaults standardUserDefaults]objectForKey:@"dict"][@"token"]] parameters:urlDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject) {
            NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            if ([responseDict[@"message"] isEqualToString:@"修改成功"]) {
                [MMProgressHUD dismiss];
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"密码修改成功" message:@"请重新登陆" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alert show];
//                [weakSelf.navigationController popViewControllerAnimated:YES];
            }else if ([responseDict[@"error"]length]){
                [MMProgressHUD dismissWithError:responseDict[@"error"] title:@"Sorry"];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MMProgressHUD dismissWithError:@"密码修改失败" title:@"Sorry"];
    }];
}
#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"dict"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    
}

@end
