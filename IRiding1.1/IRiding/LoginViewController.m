//
//  LoginViewController.m
//  IRiding
//
//  Created by qianfeng01 on 15-6-16.
//  Copyright (c) 2015年 刘丽丽. All rights reserved.
//

#import "LoginViewController.h"
@interface LoginViewController ()<UIAlertViewDelegate>
{
    UITextField *numberTextField;
    UIAlertView *alert1;
    UIAlertView *alert2;
    UIAlertView *alert3;
    UIAlertView *alert4;
    UIAlertView *alert5;
    UIAlertView *alert6;
    UIAlertView *alert7;
    
    UIView *messageView;
    UITextField *verifyCode;
    UITextField *userName;
    UITextField *password;
    NSInteger _gender;
    
    UIView *loginView;
    UITextField *loginNumber;
    UITextField *loginPasswd;
    
    UIView *forgetView;
    UITextField *forgetNumber;
    UITextField *forgetVerifyCode;
    UITextField *forgetNewPasswd;
}
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //self.view.frame = CGRectMake(0, 100, kScreenSize.width, kScreenSize.height-200);
    
    [self creatView];
    [self creatLoginMessageView];
    [self creatLoginView];
    [self creatForgetView];
}
#pragma mark - 创建注册界面
- (void)creatView{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setImage:[[UIImage imageNamed: @"login_back_highlighted"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    button.tag = 301;
    button.frame = CGRectMake(10, 30, 70, 30);
    [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 70, self.view.bounds.size.width, 40)];
    label.text = @"登录";
    label.font = [UIFont systemFontOfSize:20];
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    
    numberTextField = [[UITextField alloc]initWithFrame:CGRectMake(0, 120, self.view.bounds.size.width, 40)];
    numberTextField.placeholder = @"请输入手机号";
    numberTextField.textAlignment = NSTextAlignmentCenter;
    numberTextField.textColor = [UIColor blackColor];
    numberTextField.backgroundColor = [UIColor colorWithWhite:0.9 alpha:0.8];
    [self.view addSubview:numberTextField];
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeSystem];
    button2.frame = CGRectMake(50, 170 , kScreenSize.width-100, 40);
    button2.tag = 302;
    [button2 setBackgroundImage:[UIImage imageNamed: @"navigationbar_background"] forState:UIControlStateNormal];
    //button2.backgroundColor = [UIColor colorWithRed:0.2 green:0.9 blue:0.4 alpha:0.9];
    [button2 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [button2 setTintColor:[UIColor whiteColor]];
    [button2 setTitle:@"手机号注册" forState:UIControlStateNormal];
    button2.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    [self.view addSubview:button2];
    
    UILabel *loginLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 230, kScreenSize.width/2+50, 30)];
    loginLabel.text = @"已注册过我爱骑单车?";
    loginLabel.textAlignment = NSTextAlignmentRight;
    loginLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:loginLabel];
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeSystem];
    loginButton.frame = CGRectMake(kScreenSize.width/2+60, 230, 40, 30);
    loginButton.tag = 303;
    [loginButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [loginButton setTintColor:[UIColor clearColor]];
    [loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [loginButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginButton];
    
}
- (void)btnClick:(UIButton *)button{
    switch (button.tag) {
        case 301:
        {
            //[self dismissViewControllerAnimated:YES completion:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }
            break;
        case 302:
        {
            NSString *phoneRegex = @"^\\d{11}$";
            NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
            BOOL ret = [phoneTest evaluateWithObject:numberTextField.text];
            if (ret) {
                [self addTask];
            }else{
                alert5 = [[UIAlertView alloc]initWithTitle:@"亲" message:@"手机号有误" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alert5 show];
            }
        }
            break;
        case 303:
        {
            loginView.hidden = NO;
        }
        default:
            break;
    }
}
#pragma mark - 创建已有账号的登录界面
- (void)creatLoginView{
    loginView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenSize.width, kScreenSize.height)];
    loginView.backgroundColor = [UIColor whiteColor];
    UIButton *button11 = [UIButton buttonWithType:UIButtonTypeSystem];
    [button11 setImage:[[UIImage imageNamed: @"login_back_highlighted"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    button11.tag = 107;
    button11.frame = CGRectMake(10, 30, 70, 30);
    [button11 addTarget:self action:@selector(messageViewBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [loginView addSubview:button11];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 70, self.view.bounds.size.width, 40)];
    label.text = @"登录";
    label.font = [UIFont systemFontOfSize:20];
    label.textAlignment = NSTextAlignmentCenter;
    [loginView addSubview:label];
    
    loginNumber = [[UITextField alloc]initWithFrame:CGRectMake(0, 120, self.view.bounds.size.width, 40)];
    loginNumber.placeholder = @"手机号码";
    loginNumber.textAlignment = NSTextAlignmentCenter;
    loginNumber.textColor = [UIColor blackColor];
    loginNumber.backgroundColor = [UIColor colorWithWhite:0.9 alpha:0.8];
    [loginView addSubview:loginNumber];
    
    loginPasswd = [[UITextField alloc]initWithFrame:CGRectMake(0, 180, self.view.bounds.size.width, 40)];
    loginPasswd.placeholder = @"密码";
    loginPasswd.secureTextEntry = YES;
    loginPasswd.textAlignment = NSTextAlignmentCenter;
    loginPasswd.textColor = [UIColor blackColor];
    loginPasswd.backgroundColor = [UIColor colorWithWhite:0.9 alpha:0.8];
    [loginView addSubview:loginPasswd];
    
    UIButton *forgetButton = [UIButton buttonWithType: UIButtonTypeSystem];
    forgetButton.frame = CGRectMake(kScreenSize.width-100, 240, 80, 30);
    forgetButton.tag = 108;
    [forgetButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [forgetButton setTintColor:[UIColor clearColor]];
    [forgetButton setTitle:@"忘记密码" forState:UIControlStateNormal];
    [forgetButton addTarget:self action:@selector(messageViewBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [loginView addSubview:forgetButton];
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeSystem];
    button2.frame = CGRectMake(50, 300 , kScreenSize.width-100, 40);
    button2.tag = 109;
    [button2 setBackgroundImage:[UIImage imageNamed: @"navigationbar_background"] forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(messageViewBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [button2 setTintColor:[UIColor whiteColor]];
    [button2 setTitle:@"登录" forState:UIControlStateNormal];
    button2.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    [loginView addSubview:button2];
    loginView.hidden = YES;
    [self.view addSubview:loginView];
}
#pragma mark - 提交手机号之后的响应
- (void)showAlertView{
        switch (self.responseCode) {
            case 0:
            {
                alert1 = [[UIAlertView alloc]initWithTitle:@"亲" message:@"验证码已发送" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alert1 show];
//                LoginInformationViewController *login = [[LoginInformationViewController alloc]init];
//                login.phoneNumber = numberTextField.text;
//                [self presentViewController:login animated:YES completion:nil];
                messageView.hidden = NO;
                [self performSelector:@selector(btnEnabled) withObject:self afterDelay:60];
            }
                break;
            case 3:
            {
                alert2 = [[UIAlertView alloc]initWithTitle:@"亲" message:@"验证失败，请重新登陆" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alert2 show];
            }
                break;
            case 6:
            {
                alert3 = [[UIAlertView alloc]initWithTitle:@"亲" message:@"错误的手机号码" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alert3 show];
            }
                break;
            case 7:
            {
                alert4 = [[UIAlertView alloc]initWithTitle:@"亲" message:@"用户名已经被注册" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alert4 show];
            }
                break;
            default:
                break;
        }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView == alert1) {
        //跳转到注册信息界面
        
    } else if(alertView == alert7){
        loginPasswd.text = @"";
    } else {
        numberTextField.text = @"";
    }
}
#pragma mark - 增加任务-提交手机号
- (void)addTask{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{@"phone":@"12345678911"}];
    [dict setObject:numberTextField.text forKey:@"phone"];
    NSLog(@"%@",dict);
    __weak typeof (self)weakSelf = self;
    [_manager POST:kPhoneRegisterUrl parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"下载成功");
        if (responseObject) {
            NSDictionary *allDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            weakSelf.responseCode = [allDict[@"code"]integerValue];
            NSLog(@"%ld",(long)weakSelf.responseCode);
            [self showAlertView];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"下载失败");
    }];
}
#pragma mark - 创建注册填写信息的界面
- (void)creatLoginMessageView{
    messageView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, kScreenSize.width, kScreenSize.height)];
    messageView.backgroundColor = [UIColor whiteColor];
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeSystem];
    [button1 setImage:[[UIImage imageNamed: @"login_back_highlighted"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    button1.tag = 106;
    button1.frame = CGRectMake(0, 30, 70, 30);
    [button1 addTarget:self action:@selector(messageViewBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [messageView addSubview:button1];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 60, kScreenSize.width, 30)];
    label.text = @"注册";
    label.font = [UIFont systemFontOfSize:20];
    label.textAlignment = NSTextAlignmentCenter;
    [messageView addSubview:label];
    
    UIView *verifyView = [[UIView alloc]initWithFrame:CGRectMake(0, 105, kScreenSize.width, 30)];
    verifyView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:0.8];
    verifyCode = [[UITextField alloc]initWithFrame:CGRectMake(20, 0, kScreenSize.width-130, 30)];
    verifyCode.placeholder = @"验证码";
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(kScreenSize.width-120, 0, 90, 30);
    [button setTitle:@"重发验证码" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    [button addTarget:self action:@selector(messageViewBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    button.tag = 101;
    button.enabled = NO;
    [verifyView addSubview:button];
    [verifyView addSubview:verifyCode];
    [messageView addSubview:verifyView];
    
    UIView *userView = [[UIView alloc]initWithFrame:CGRectMake(0, 150, kScreenSize.width, 30)];
    userView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:0.8];
    userName = [[UITextField alloc]initWithFrame:CGRectMake(80, 0, kScreenSize.width-80, 30)];
    UILabel *userNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 40, 30)];
    userNameLabel.text = @"昵称";
    [userView addSubview:userNameLabel];
    [userView addSubview:userName];
    [messageView addSubview:userView];
    
    UIView *passwordView = [[UIView alloc]initWithFrame:CGRectMake(0, 195, kScreenSize.width, 30)];
    passwordView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:0.8];
    password = [[UITextField alloc]initWithFrame:CGRectMake(80, 0, kScreenSize.width-80-40, 30)];
    [password setSecureTextEntry:YES];
    UILabel *passwordLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 40, 30)];
    passwordLabel.text = @"密码";
    [passwordView addSubview:passwordLabel];
    UIButton *passwordButton = [UIButton buttonWithType:UIButtonTypeSystem];
    passwordButton.frame = CGRectMake(kScreenSize.width-40,7, 20, 15);
    passwordButton.tag = 102;
    [passwordButton setTintColor:[UIColor clearColor]];
    [passwordButton setImage:[[UIImage imageNamed:@"CellHidePassword_icon"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [passwordButton setImage:[[UIImage imageNamed:@"CellHidePassword_icon_HL"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateSelected];
    [passwordButton addTarget:self action:@selector(messageViewBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [passwordView addSubview:passwordButton];
    [passwordView addSubview:password];
    [messageView addSubview:passwordView];
    
    UIView *sexView = [[UIView alloc]initWithFrame:CGRectMake(0, 240, kScreenSize.width, 30)];
    sexView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:0.8];
    //    UITextField *sex = [[UITextField alloc]initWithFrame:CGRectMake(80, 0, kScreenSize.width-80-90, 30)];
    UILabel *sexLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 40, 30)];
    sexLabel.text = @"性别";
    [sexView addSubview:sexLabel];
    UIButton *manButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    manButton.frame = CGRectMake(kScreenSize.width-120,5, 20, 20);
    manButton.tag = 103;
    [manButton setTintColor:[UIColor clearColor]];
    manButton.layer.masksToBounds = YES;
    manButton.layer.cornerRadius = 10;
    [manButton setImage:[[UIImage imageNamed:@"set_gender_boy"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [manButton setImage:[[UIImage imageNamed:@"set_gender_selected_boy"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateSelected];
    [manButton addTarget:self action:@selector(messageViewBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [sexView addSubview:manButton];
    UILabel *manLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreenSize.width-95, 0, 20, 30)];
    manLabel.text = @"男";
    [sexView addSubview:manLabel];
    
    UIButton *womanButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    womanButton.frame = CGRectMake(kScreenSize.width-65,5, 20, 20);
    womanButton.tag = 104;
    [womanButton setTintColor:[UIColor clearColor]];
    womanButton.layer.masksToBounds = YES;
    womanButton.layer.cornerRadius = 10;
    [womanButton setImage:[[UIImage imageNamed:@"set_gender_girl"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [womanButton setImage:[[UIImage imageNamed:@"set_gender_selected_girl"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateSelected];
    [womanButton addTarget:self action:@selector(messageViewBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [sexView addSubview:womanButton];
    UILabel *womanLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreenSize.width-40, 0, 20, 30)];
    womanLabel.text = @"女";
    [sexView addSubview:womanLabel];
    //[sexView addSubview:sex];
    [messageView addSubview:sexView];
    
    UIButton *but = [UIButton buttonWithType:UIButtonTypeSystem];
    but.frame = CGRectMake(50, 300 , kScreenSize.width-100, 40);
    but.tag = 105;
    [but setBackgroundImage:[UIImage imageNamed: @"navigationbar_background"] forState:UIControlStateNormal];
    [but addTarget:self action:@selector(messageViewBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [but setTintColor:[UIColor whiteColor]];
    [but setTitle:@"完成注册" forState:UIControlStateNormal];
    but.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    [messageView addSubview:but];
    
    messageView.hidden = YES;
    [self.view addSubview:messageView];
}
- (void)messageViewBtnClick:(UIButton *)button{
    switch (button.tag) {
        case 101:
        {
            [self addTask];
            button.enabled = NO;
            [self performSelector:@selector(btnEnabled) withObject:self afterDelay:60];
        }
            break;
        case 102:
        {
            if (button.selected) {
                button.selected = NO;
                [password setSecureTextEntry:YES];
            }else{
                button.selected = YES;
                [password setSecureTextEntry:NO];
            }
        }
            break;
        case 103:
        {
            if (button.selected) {
                button.selected = NO;
            }else{
                button.selected = YES;
                UIButton *but2 = (UIButton *)[messageView viewWithTag:104];
                but2.selected = NO;
                _gender = 1;
            }
        }
            break;
        case 104:
        {
            if (button.selected) {
                button.selected = NO;
            }else{
                button.selected = YES;
                UIButton *but2 = (UIButton *)[messageView viewWithTag:103];
                but2.selected = NO;
                _gender = 2;
            }
        }
            break;
        case 105:
        {
            [self messageAddTask];
        }
            break;
        case 106:
        {
            messageView.hidden = YES;
        }
            break;
        case 107:
        {
            loginView.hidden = YES;
        }
            break;
        case 108:
        {
            forgetView.hidden = NO;
        }
            break;
        case 109:
        {
            [self addLoginTask];
        }
            break;
        default:
            break;
    }
}
#pragma mark - 增加任务-已有账号用户登录
- (void)addLoginTask{
    NSMutableDictionary *messageDict = [NSMutableDictionary dictionaryWithDictionary:@{@"password":@"15041043",@"phone":@"13523743361"}];
    [messageDict setObject:loginNumber.text forKey:@"phone"];
    [messageDict setObject:loginPasswd.text forKey:@"password"];
    //NSLog(@"%@",messageDict);
    __weak typeof (self)weakSelf = self;
    [_manager POST:kLoginUrl parameters:messageDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"下载成功");
        if (responseObject) {
            NSDictionary *loginDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"%@",loginDict);
            if ([loginDict[@"status"]integerValue]==1) {
                [[NSUserDefaults standardUserDefaults]setObject:loginDict forKey:@"dict"];
                [[NSUserDefaults standardUserDefaults]synchronize];
                //[weakSelf dismissViewControllerAnimated:YES completion:nil];
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }else{
                alert7 = [[UIAlertView alloc]initWithTitle:@"Sorry" message:loginDict[@"error"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alert7 show];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"下载失败");
    }];
}
#pragma mark - 增加任务-提交用户信息
- (void)messageAddTask{
    NSMutableDictionary *messageDict = [NSMutableDictionary dictionaryWithDictionary:@{@"gender":@(2),@"user_name":@"伊始",@"phone":@"13523743361",@"password":@"15041043",@"verify_code":@"016170"}];
    [messageDict setObject:[NSNumber numberWithInteger:_gender] forKey:@"gender"];
    [messageDict setObject:userName.text forKey:@"user_name"];
    [messageDict setObject:numberTextField.text forKey:@"phone"];
    [messageDict setObject:password.text forKey:@"password"];
    [messageDict setObject:verifyCode.text forKey:@"verify_code"];
    __weak typeof (self)weakSelf = self;
    [_manager POST:kRegisterUrl parameters:messageDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"下载成功");
        if (responseObject) {
            NSDictionary *loginDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            if ([loginDict[@"status"]integerValue]==1) {
                [[NSUserDefaults standardUserDefaults]setObject:loginDict forKey:@"dict"];
                [[NSUserDefaults standardUserDefaults]synchronize];
                //[weakSelf dismissViewControllerAnimated:YES completion:nil];
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"下载失败");
    }];
}
- (void)btnEnabled{
    UIButton *button = (UIButton *)[messageView viewWithTag:101];
    button.enabled = YES;
}
#pragma mark - 创建忘记密码界面
- (void)creatForgetView{
    forgetView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenSize.width, kScreenSize.height)];
    forgetView.hidden = YES;
    forgetView.backgroundColor = [UIColor whiteColor];
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeSystem];
    [button1 setImage:[[UIImage imageNamed: @"login_back_highlighted"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    button1.tag = 401;
    button1.frame = CGRectMake(10, 30, 50, 30);
    [button1 addTarget:self action:@selector(forgetClick:) forControlEvents:UIControlEventTouchUpInside];
    [forgetView addSubview:button1];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 70, kScreenSize.width, 30)];
    label.text = @"重置密码";
    label.font = [UIFont systemFontOfSize:20];
    label.textAlignment = NSTextAlignmentCenter;
    [forgetView addSubview:label];
    
    UIView *numberView = [[UIView alloc]initWithFrame:CGRectMake(0, 115, kScreenSize.width, 30)];
    numberView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:0.8];
    UILabel *numberLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 68, 30)];
    numberLabel.text = @"手机号码";
    [numberView addSubview:numberLabel];
    forgetNumber = [[UITextField alloc]initWithFrame:CGRectMake(85, 0, kScreenSize.width-85, 30)];
    [numberView addSubview:forgetNumber];
    [forgetView addSubview:numberView];
    
    UIView *verifyView = [[UIView alloc]initWithFrame:CGRectMake(0, 165, kScreenSize.width, 30)];
    verifyView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:0.8];
    UILabel *verifyLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 68, 30)];
    verifyLabel.text = @"验证码";
    [verifyView addSubview:verifyLabel];
    forgetVerifyCode = [[UITextField alloc]initWithFrame:CGRectMake(85, 0, kScreenSize.width-85-100, 30)];
    [verifyView addSubview:forgetVerifyCode];
    UIButton *codeAgain = [UIButton buttonWithType:UIButtonTypeSystem];
    codeAgain.frame = CGRectMake(kScreenSize.width-100, 0, 100, 30);
    [codeAgain setTitle:@"获取验证码" forState:UIControlStateNormal];
    [codeAgain setTitleColor:[UIColor blackColor] forState: UIControlStateNormal];
    [codeAgain setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    [codeAgain addTarget:self action:@selector(forgetClick:) forControlEvents:UIControlEventTouchUpInside];
    codeAgain.tag = 402;
    codeAgain.enabled = YES;
    [verifyView addSubview:codeAgain];
    [forgetView addSubview:verifyView];
    
    UIView *passwordView = [[UIView alloc]initWithFrame:CGRectMake(0, 215, kScreenSize.width, 30)];
    passwordView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:0.8];
    UILabel *passwordLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 68, 30)];
    passwordLabel.text = @"密码";
    [passwordView addSubview:passwordLabel];
    forgetNewPasswd = [[UITextField alloc]initWithFrame:CGRectMake(85, 0, kScreenSize.width-85-40, 30)];
    [forgetNewPasswd setSecureTextEntry:YES];
    UIButton *passwordButton = [UIButton buttonWithType:UIButtonTypeSystem];
    passwordButton.frame = CGRectMake(kScreenSize.width-40,7, 20, 15);
    passwordButton.tag = 403;
    [passwordButton setTintColor:[UIColor clearColor]];
    [passwordButton setImage:[[UIImage imageNamed:@"CellHidePassword_icon"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [passwordButton setImage:[[UIImage imageNamed:@"CellHidePassword_icon_HL"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateSelected];
    [passwordButton addTarget:self action:@selector(forgetClick:) forControlEvents:UIControlEventTouchUpInside];
    [passwordView addSubview:passwordButton];
    [passwordView addSubview:forgetNewPasswd];
    [forgetView addSubview:passwordView];
    
    UIButton *but = [UIButton buttonWithType:UIButtonTypeSystem];
    but.frame = CGRectMake(50, 270 , kScreenSize.width-100, 40);
    but.tag = 404;
    [but setBackgroundImage:[UIImage imageNamed: @"navigationbar_background"] forState:UIControlStateNormal];
    [but addTarget:self action:@selector(forgetClick:) forControlEvents:UIControlEventTouchUpInside];
    [but setTintColor:[UIColor whiteColor]];
    [but setTitle:@"保存" forState:UIControlStateNormal];
    but.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    [forgetView addSubview:but];
    
    forgetView.hidden = YES;
    [self.view addSubview:forgetView];
}
- (void)forgetClick:(UIButton *)button{
    switch (button.tag) {
        case 401:
        {
            forgetView.hidden = YES;
        }
            break;
        case 402:
        {
            [self addGetVerifyCodeTask];
            button.enabled = NO;
            [self performSelector:@selector(verifyCodeButtonEnabled) withObject:self afterDelay:60];
        }
            break;
        case 403:
        {
            BOOL selected = button.selected;
            button.selected = !selected;
            BOOL hidden = forgetNewPasswd.secureTextEntry;
            forgetNewPasswd.secureTextEntry = !hidden;
        }
            break;
        case 404:
        {
            [self addResetPasswdTask];
        }
            break;
    
        default:
            break;
    }
}
#pragma mark - 增加任务-获取验证码
- (void)addGetVerifyCodeTask{
    NSMutableDictionary *codeDict = [NSMutableDictionary dictionaryWithDictionary:@{@"phone":@"13523743361"}];
    [codeDict setObject:forgetNumber.text forKey:@"phone"];
    NSLog(@"%@",codeDict);
    //__weak typeof (self)weakSelf = self;
    [_manager POST:kResetCodeUrl  parameters:codeDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"下载成功");
        if (responseObject) {
            NSDictionary *loginDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"%@",loginDict);
            if ([loginDict[@"message"]length]) {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"亲" message:loginDict[@"message"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }else if([loginDict[@"error"]length]){
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"亲" message:loginDict[@"error"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"下载失败");
    }];
 
}
- (void)verifyCodeButtonEnabled{
    UIButton *button = (UIButton *)[forgetView viewWithTag:402];
    button.enabled = YES;
}
#pragma mark - 增加任务-重置密码
- (void)addResetPasswdTask{
    NSMutableDictionary *resetDict = [NSMutableDictionary dictionaryWithDictionary:@{@"password":@"1504",@"phone":@"13523743361",@"verify_code":@"481942"}];
    [resetDict setObject:forgetNumber.text forKey:@"phone"];
    [resetDict setObject:forgetNewPasswd.text forKey:@"password"];
    [resetDict setObject:forgetVerifyCode.text forKey:@"verify_code"];
    NSLog(@"%@",resetDict);
    //__weak typeof (self)weakSelf = self;
    [_manager POST:kResetPasswdUrl  parameters:resetDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"下载成功");
        if (responseObject) {
            NSDictionary *resetDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"%@",resetDict);
            NSLog(@"%ld",(long)[resetDict[@"code"]integerValue]);
//            if ([resetDict[@"code"]integerValue]==0) {
//                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"亲" message:@"密码重置成功，请重新登录" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//                [alert show];
//                forgetView.hidden = YES;
//            }else{
//                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"亲" message:resetDict[@"error"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//                [alert show];
//            }
            if ([resetDict[@"message"]length]) {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"亲" message:resetDict[@"message"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
                forgetView.hidden = YES;
            }else if([resetDict[@"error"]length]){
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"亲" message:resetDict[@"error"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }

        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"下载失败");
    }];
}
#pragma mark - UITextFieldDelegate协议

//点击return键 键盘通知代理调用

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    //取消第一响应
    [textField resignFirstResponder];
    return YES;//一般返回YES  return 键是否有效
}
- (void)hiddenKeyboard{
    [numberTextField resignFirstResponder];
    [loginNumber resignFirstResponder];
    [loginPasswd resignFirstResponder];
    [verifyCode resignFirstResponder];
    [userName resignFirstResponder];
    [password resignFirstResponder];
    [forgetNumber resignFirstResponder];
    [forgetVerifyCode resignFirstResponder];
    [forgetNewPasswd resignFirstResponder];
}
//点击屏幕触摸
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self hiddenKeyboard];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
