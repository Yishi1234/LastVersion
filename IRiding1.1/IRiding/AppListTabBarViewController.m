//
//  AppListTabBarViewController.m
//  IRiding
//
//  Created by qianfeng01 on 15-6-9.
//  Copyright (c) 2015年 刘丽丽. All rights reserved.
//

#import "AppListTabBarViewController.h"
#import "AppListViewController.h"
#import "DDMenuController.h"
#import "LeftViewController.h"
@interface AppListTabBarViewController ()

@end

@implementation AppListTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatViewControllers];
}
#pragma mark - 创建子视图控制器
- (void)creatViewControllers{
    NSArray *vcNames = @[@"HotViewController",@"NewestViewController",@"FavoriteViewController"];
    NSArray *titles = @[@"热 门",@"最 新",@"收 藏"];
    NSArray *images = @[@"tabbar_home",@"tabbar_new",@"tabbar_favorite"];
    NSArray *selImages = @[@"tabbar_home_selected",@"tabbar_new_selected",@"tabbar_favorite_selected"];
    NSMutableArray *vcArr = [[NSMutableArray alloc]init];
    for (NSInteger i = 0; i < vcNames.count; i++) {
        Class vc = NSClassFromString(vcNames[i]);
        AppListViewController *app = [[vc alloc]init];
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:app];
        app.title = titles[i];
         
        DDMenuController *rootController = [[DDMenuController alloc]initWithRootViewController:nav];
        app.menuController = rootController;
        
        LeftViewController *leftViewController = [[LeftViewController alloc]init];
        UINavigationController *navLeft = [[UINavigationController alloc]initWithRootViewController:leftViewController];
        navLeft.delegate = leftViewController;
        
        //rootController.leftViewController = leftViewController;
        rootController.leftViewController = navLeft;
        [rootController.tabBarItem setTitle:titles[i]];
        rootController.tabBarItem.image = [[UIImage imageNamed:images[i]]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        rootController.tabBarItem.selectedImage = [[UIImage imageNamed:selImages[i]]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        

        [rootController.tabBarItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Arial Rounded MT Bold" size:12], NSForegroundColorAttributeName:[UIColor darkGrayColor]} forState:UIControlStateNormal];
        
        
        [vcArr addObject:rootController];
    }
    self.viewControllers = vcArr;
    
    if (kScreenSize.width == 320) {
        [self.tabBar setBackgroundImage:[[UIImage imageNamed: @"tabBar-320"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    }else{
        [self.tabBar setBackgroundImage:[[UIImage imageNamed: @"tabBar"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    }
    self.selectedIndex = 1;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
