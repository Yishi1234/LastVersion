//
//  AppListViewController.h
//  IRiding
//
//  Created by qianfeng01 on 15-6-9.
//  Copyright (c) 2015年 刘丽丽. All rights reserved.
//

#import "BaseViewController.h"
#import "ADView.h"
#import "DDMenuController.h"
//#define kAppDict @{"uid":%ld,"filter_type":%ld,"page":%ld,"last_id":%ld,"city":%@}

@interface AppListViewController : BaseViewController
{
    UITableView *_tableView;
    NSMutableArray *_dataArr;
    NSMutableArray *_scrollArr;
    
    NSInteger _currentUid;
    NSInteger _currentType;
    NSInteger _currentPage;
    NSInteger _currentLastId;
    NSString *_cityName;
    
    BOOL _isRefreshing;
    BOOL _isLoadingMore;
    
    
   
}
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *dataArr;
@property (nonatomic,strong)NSMutableArray *scrollArr;
@property (nonatomic)NSInteger currentPage;
@property (nonatomic)BOOL isRefreshing;
@property (nonatomic)BOOL isLoadingMore;
@property (nonatomic)NSInteger currentLastId;
@property (nonatomic)NSInteger currentType;
@property (nonatomic,copy)NSString *cityName;
- (void)firstDownload;
- (void)addTaskWithIsRefresh:(BOOL)isRefresh;

- (void)creatRefreshView;
- (void)endRefreshing;

- (void)rightClick:(UIButton *)button;


@property (nonatomic)CGFloat rowHeight;
//- (void)creatAdvView;
@property (nonatomic,strong)DDMenuController *menuController;

@end
