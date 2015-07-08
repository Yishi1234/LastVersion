//
//  LeftViewController.m
//  IRiding
//
//  Created by qianfeng01 on 15-6-16.
//  Copyright (c) 2015年 刘丽丽. All rights reserved.
//

#import "LeftViewController.h"
#import "AppListTabBarViewController.h"
#import "DDMenuController.h"
#import "LoginViewController.h"
#import "MySettingViewController.h"
#import "MyShareViewController.h"
@interface LeftViewController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>
{
    UIView *headerView;
    
    NSIndexPath *selectIndexPath;
    
    BOOL isFullScreen;
}
@end

@implementation LeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.view.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.3];
    self.view.backgroundColor = [UIColor whiteColor];
    //[self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"left_bac"]]];
    if (kScreenSize.width == 375) {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed: @"navigationbar_background-750"] forBarMetrics:UIBarMetricsDefault];
    }else{
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed: @"navigationbar_background"] forBarMetrics:UIBarMetricsDefault];
    }
    //isFullScreen = NO;
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    [self addTitleViewWithTitle:@"更多设置"];
    [self creatTableView];
}
#pragma mark - 重写父类
- (void)addTitleViewWithTitle:(NSString *)title{
    UILabel *titleLabel =[MyControl creatLabelWithFrame:CGRectMake(0, 0, 200, 30) text:title];
    titleLabel.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:20];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor blackColor];
    self.navigationItem.titleView = titleLabel;
}
- (void)creatTableView{
    if (!_tableView) {
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,10, self.view.bounds.size.width, self.view.bounds.size.height-60) style:UITableViewStylePlain];
        //tableView.backgroundColor = [UIColor clearColor];
        tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.bounces = NO;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:tableView];
        self.tableView = tableView;
        [self creatHeaderView];
    }
}
-(void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self == viewController && isFullScreen) {
        UIWindow *window = [UIApplication sharedApplication].windows[0];
        UITabBarController *tabBar = (UITabBarController *)window.rootViewController;
        DDMenuController *menu = (DDMenuController *)tabBar.selectedViewController;
        [menu showLeftController:YES];
        isFullScreen = NO;
    }
}


- (void)creatHeaderView{
    headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 100)];
    self.headImage = [[UIImageView alloc]initWithFrame:CGRectMake(20, 20, 60, 60)];
    self.headImage.image = [UIImage imageNamed: @"set_gender_boy"];
    self.headImage.layer.masksToBounds = YES;
    self.headImage.layer.cornerRadius = 30;
    [headerView addSubview:self.headImage];
    self.userLabel = [[UILabel alloc]initWithFrame:CGRectMake(90, 40 , 100, 20)];
    self.userLabel.text = @"未登录";
//    UIImageView *selectImage = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.bounds.size.width-80, 35, 20, 30)];
//    selectImage.image = [UIImage imageNamed: @"cell_select"];
//    [headerView addSubview:selectImage];
    [headerView addSubview:self.userLabel];
}
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //return 8;
    return 5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"CellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    if (indexPath.row == 0) {
        [cell.contentView addSubview:headerView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }else{
        //cell.textLabel.text = @[@"发现路线",@"我的骑行日志",@"公共自行车",@"消息中心",@"吐槽一下",@"清除缓存",@"退出登录"][indexPath.row-1];
        cell.textLabel.text = @[@"发现路线",@"分享路线",@"清除缓存",@"退出登录"][indexPath.row-1];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (selectIndexPath != nil && selectIndexPath.row == indexPath.row) {
            cell.textLabel.textColor = [UIColor redColor];
        }else{
            cell.textLabel.textColor = [UIColor blackColor];
        }

    }
   // [cell setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]]];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 100;
    }else{
        return 50;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
        {
            NSDictionary *dict = [[NSUserDefaults standardUserDefaults]objectForKey:@"dict"];
            UIWindow *window = [UIApplication sharedApplication].windows[0];
            UITabBarController *tabBar = (UITabBarController *)window.rootViewController;
            DDMenuController *menu = (DDMenuController *)tabBar.selectedViewController;
//            if ([UIDevice currentDevice].systemVersion.integerValue < 8.0) {
//                self.hidesBottomBarWhenPushed = YES;
//            }
            menu.tabBarController.tabBar.hidden = YES;
            isFullScreen = YES;
            [menu showLeftViewControllerFullScreen];
            if ([dict[@"token"]length]) {
                MySettingViewController *setting = [[MySettingViewController alloc]init];
                setting.url = [kMySettingUrl stringByAppendingString:dict[@"token"]];
                [self.navigationController pushViewController:setting animated:YES];
            }else{
                LoginViewController *login = [[LoginViewController alloc]init];
                //[self presentViewController:login animated:YES completion:nil];
                [self.navigationController pushViewController:login animated:YES];
            }
        }
            break;
        case 1:
        {
            UIWindow *window = [UIApplication sharedApplication].windows[0];
            UITabBarController *tabBar = (UITabBarController *)window.rootViewController;
            DDMenuController *menu = (DDMenuController *)tabBar.selectedViewController;
            [menu showRootController:YES];
        }
            break;
        case 2:
        {
            UIWindow *window = [UIApplication sharedApplication].windows[0];
            UITabBarController *tabBar = (UITabBarController *)window.rootViewController;
            DDMenuController *menu = (DDMenuController *)tabBar.selectedViewController;
            menu.tabBarController.tabBar.hidden = YES;
            isFullScreen = YES;
            [menu showLeftViewControllerFullScreen];
            MyShareViewController *share = [[MyShareViewController alloc]init];
            [self.navigationController pushViewController:share animated:YES];
        }
            break;
        case 3:
        {
            CGFloat imageCatheSize = (CGFloat)[[SDImageCache sharedImageCache]getSize]/1024/1024;
            
            UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"清除缓存" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:[NSString stringWithFormat:@"共有%.2fM缓存，确定清除？",imageCatheSize] otherButtonTitles:@"确定", nil];
            [sheet showInView:self.view];
        }
            break;
        case 4:
        {
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"dict"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            self.userLabel.text = @"未登录";
            self.headImage.image = [UIImage imageNamed:@"set_gender_boy"];
        }
            break;
        default:
            break;
    }
    selectIndexPath = indexPath;
    [self.tableView reloadData];

}
#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        [[SDImageCache sharedImageCache]clearMemory];
        [[SDImageCache sharedImageCache]clearDisk];
    }
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    UIWindow *window = [UIApplication sharedApplication].windows[0];
    UITabBarController *tabBar = (UITabBarController *)window.rootViewController;
    DDMenuController *menu = (DDMenuController *)tabBar.selectedViewController;
    menu.tabBarController.tabBar.hidden = NO;
    //[menu showLeftController:YES];
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults]objectForKey:@"dict"];
    if ([dict[@"token"]length]) {
        self.userLabel.text = dict[@"name"];
        if ([dict[@"gender"]integerValue]==1) {
            [self.headImage sd_setImageWithURL:[NSURL URLWithString:dict[@"avatar_url"]] placeholderImage:[UIImage imageNamed:@"set_gender_selected_boy"]];
        }else{
            [self.headImage sd_setImageWithURL:[NSURL URLWithString:dict[@"avatar_url"]] placeholderImage:[UIImage imageNamed:@"set_gender_selected_girl"]];
        }
    }else{
        self.userLabel.text = @"未登录";
        self.headImage.image = [UIImage imageNamed:@"set_gender_boy"];
    }
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
