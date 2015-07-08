//
//  AppListViewController.m
//  IRiding
//
//  Created by qianfeng01 on 15-6-9.
//  Copyright (c) 2015年 刘丽丽. All rights reserved.
//

#import "AppListViewController.h"
#import "LogCell.h"
#import "LogModel.h"
#import "AdvModel.h"
#import "DetailViewController.h"
#import "CommentCommitViewController.h"


@interface AppListViewController ()<UITableViewDataSource,UITableViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
{
    NSInteger _selectRowLeft;
    NSInteger _selectRowRight;
    UIView *rightView;
    NSString *cityTitle;
    UIButton *saveButton;
    
    UIButton *topButton;
}
@property (nonatomic,strong)UIPickerView *pickerView;
@property (nonatomic,strong)NSMutableArray *pickerArr;

@end

@implementation AppListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (kScreenSize.width == 375) {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed: @"navigationbar_background-750"] forBarMetrics:UIBarMetricsDefault];
    }else{
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed: @"navigationbar_background"] forBarMetrics:UIBarMetricsDefault];
    }
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    [self addTitleViewWithTitle:self.title];
    [self addItemWithTitle:@"城市" image:@"nav_rightbutton" selectedImage:@"nav_rightbutton_selected" target:self action:@selector(rightClick:) isLeft:NO];
    [self creatTableView];
    self.cityName = @"";
    self.currentType = self.navigationController.tabBarController.selectedIndex + 1;
    [self dataInit];
    [self creatPickerView];
    [self creatGoToTheTopOfView];
}
#pragma mark - creatTableView
- (void)creatTableView{
    self.dataArr = [[NSMutableArray alloc]init];
    self.scrollArr = [[NSMutableArray alloc]init];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kScreenSize.width, kScreenSize.height-64-49) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"LogCell" bundle:nil] forCellReuseIdentifier:@"LogCell"];
    [self.view addSubview:self.tableView];
}
#pragma mark - tableViewProtocol
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LogCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LogCell" forIndexPath:indexPath];
    LogModel *logModel = self.dataArr[indexPath.row];
    [cell showDataWithModel:logModel];
    __weak typeof (self)weakSelf = self;
    [cell setMyBlock:^(LogModel *model) {
        CommentCommitViewController *comment = [[CommentCommitViewController alloc]init];
        comment.track_id = model.id.integerValue;
        weakSelf.menuController.tabBarController.tabBar.hidden = YES;
        [weakSelf.navigationController pushViewController:comment animated:YES];
    }];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    LogModel *model = self.dataArr[indexPath.row];
    return [LogCell heightOfCellWithModel:model];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DetailViewController *detail = [[DetailViewController alloc]init];
    LogModel *model = self.dataArr[indexPath.row];
    detail.id = @(model.id.integerValue);
    self.menuController.tabBarController.tabBar.hidden = YES;
    
    [self.navigationController pushViewController:detail animated:YES];
}
#pragma mark - 创建刷新视图
- (void)creatRefreshView{
    __weak typeof (self)weakSelf = self;
    [self.tableView addRefreshHeaderViewWithAniViewClass:[JHRefreshCommonAniView class] beginRefresh:^{
        if (weakSelf.isRefreshing) {
            return ;
        }
        switch (weakSelf.currentType) {
            case 1:
            {
                weakSelf.currentPage = 1;
                weakSelf.currentLastId = 0;
            }
                break;
            case 2:
            {
                weakSelf.currentLastId = 0;
                weakSelf.currentPage = 0;
            }
                break;
            case 3:
            {
                NSDictionary *userDict = [[NSUserDefaults standardUserDefaults]objectForKey:@"dict"];
                if ([userDict[@"token"]length]) {
                    weakSelf.currentLastId = 0;
                    weakSelf.currentPage = 0;
                }else{
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Sorry" message:@"请先登录账号" delegate:weakSelf cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    [alert show];
                    return;
                }
            }
                break;
            default:
                break;
        }
        weakSelf.isRefreshing = YES;
        [weakSelf addTaskWithIsRefresh:YES];
    }];
    [self.tableView addRefreshFooterViewWithAniViewClass:[JHRefreshCommonAniView class] beginRefresh:^{
        if (weakSelf.isLoadingMore) {
            return ;
        }
        switch (weakSelf.currentType) {
            case 1:
            {
                weakSelf.currentPage++;
            }
                break;
            case 2:
            {
                
            }
                break;
            case 3:
            {
                NSDictionary *userDict = [[NSUserDefaults standardUserDefaults]objectForKey:@"dict"];
                if ([userDict[@"token"]length]) {
                    
                }else{
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Sorry" message:@"请先登录账号" delegate:weakSelf cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    [alert show];
                    return;
                }
            }
                break;
            default:
                break;
        }
        weakSelf.isLoadingMore = YES;
        [weakSelf addTaskWithIsRefresh:YES];
    }];
}
- (void)endRefreshing{
    if (self.isRefreshing) {
        self.isRefreshing = NO;
        [self.tableView headerEndRefreshingWithResult:JHRefreshResultSuccess];
    }
    if (self.isLoadingMore) {
        self.isLoadingMore = NO;
        [self.tableView footerEndRefreshing];
    }
}
#pragma mark - 第一次下载
- (void)firstDownload{
    self.isRefreshing = YES;
    self.currentType = self.menuController.tabBarController.selectedIndex+1;
    switch (self.currentType) {
        case 1:
        {
            self.currentPage = 1;
            self.currentLastId = 0;
            [self addTaskWithIsRefresh:YES];
        }
            break;
        case 2:
        {
            self.currentLastId = 0;
            self.currentPage = 0;
            [self addTaskWithIsRefresh:YES];
        }
            break;
        case 3:
        {
            NSDictionary *userDict = [[NSUserDefaults standardUserDefaults]objectForKey:@"dict"];
            if ([userDict[@"token"]length]) {
                self.currentLastId = 0;
                self.currentPage = 0;
                [self addTaskWithIsRefresh:YES];
            }else{
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Sorry" message:@"请先登录账号" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alert show];
                self.isRefreshing = NO;
            }
        }
            break;
        default:
            break;
    }
}
#pragma mark - 创建广告头视图
//- (void)creatAdvView{
//    ADView *view = [[ADView alloc]initWithFrame:CGRectMake(0, 0, kScreenSize.width, 160)];
//    [view creatViewWithAdvArr:self.scrollArr];
//    self.tableView.tableHeaderView = view;
//}
#pragma mark - 下载数据
- (void)addTaskWithIsRefresh:(BOOL)isRefresh{
    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleFade];
    [MMProgressHUD showWithTitle:@"页面加载中" status:@"loading..."];
        switch (self.currentType) {
        case 1://热门  {"uid":0,"filter_type":1,"page":3,"last_id":0,"city":""}
        {
            self.currentLastId = 0;
        }
            break;
        case 2://最新  {"uid":0,"filter_type":2,"page":0,"last_id":7138,"city":""}
        {
            self.currentPage = 0;
        }
            break;
        case 3://收藏
        {
            self.currentPage = 0;
        }
            break;
        default:
            break;
    }
    __weak typeof (self)weakSelf = self;
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{@"uid":@(0),@"filter_type":@(2),@"page":@(1),@"last_id":@(0),@"city":@""}];
    [dict setObject:[NSNumber numberWithInteger:_currentType] forKey:@"filter_type"];
    [dict setObject:[NSNumber numberWithInteger:_currentPage] forKey:@"page"];
    [dict setObject:[NSNumber numberWithInteger:_currentLastId] forKey:@"last_id"];
    [dict setObject:self.cityName forKey:@"city"];
    NSDictionary *userDict = [[NSUserDefaults standardUserDefaults]objectForKey:@"dict"];
    NSString *url = kAppUrl;
    if ([userDict[@"token"]length]) {
        url = [kAppUrl stringByAppendingString:userDict[@"token"]];
        if (self.currentType == 3) {
            [dict setObject:userDict[@"uid"] forKey:@"uid"];
        }
    }else{
        if (self.currentType == 3) {
            [self endRefreshing];
            return;
        }
    }
    [_manager POST:url parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"主页面下载成功");
        if (responseObject) {
            //NSLog(@"%@",responseObject);
            if (self.isRefreshing) {
                [self.dataArr removeAllObjects];
            }
            NSDictionary *allDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSArray *arr1 = allDict[@"topics"];
            if (arr1.count > 0) {
                [arr1 enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    NSDictionary *advDict = (NSDictionary *)obj;
                    AdvModel *model1 = [[AdvModel alloc]init];
                    [model1 setValuesForKeysWithDictionary:advDict];
                    [weakSelf.scrollArr addObject:model1];
                    
                }];
            }
            switch (weakSelf.currentType) {
                case 1:
                {
                    //[weakSelf creatAdvView];
                }
                    break;
                case 2:
                {
                    //weakSelf.tableView.tableHeaderView = nil;
                }
                    break;
                case 3://收藏
                {
                    
                }
                    break;
                default:
                    break;
            }
            NSArray *arr2 = allDict[@"tracks"];
            [arr2 enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                NSDictionary *logDict = (NSDictionary *)obj;
                LogModel *model2 = [[LogModel alloc]init];
                [model2 setValuesForKeysWithDictionary:logDict];
                [weakSelf.dataArr addObject:model2];
                weakSelf.currentLastId = model2.display_order.integerValue;
            }];
            [weakSelf.tableView reloadData];
            [weakSelf endRefreshing];
            if ([allDict[@"tracks"]count]==0) {
                [MMProgressHUD dismissWithSuccess:@"没有啦！" title:@"亲"];
            }
        }
        [MMProgressHUD dismiss];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"下载失败");
        [weakSelf endRefreshing];
        [MMProgressHUD dismissWithError:@"加载失败" title:@"Sorry"];
    }];
};
#pragma mark - 右按钮被点击
- (void)rightClick:(UIButton *)button{
    saveButton = button;
    if (button.selected) {
        button.selected = NO;
        rightView.hidden = YES;
        topButton.hidden = NO;
    }else{
        button.selected = YES;
        rightView.hidden = NO;
        topButton.hidden = YES;
    }
}
#pragma mark - 初始化pickerView的数据源数组
- (void)dataInit{
    self.pickerArr = [[NSMutableArray alloc]init];
    NSString *path = [[NSBundle mainBundle]pathForResource:@"area" ofType:@"plist"];
    NSArray *arr = [NSArray arrayWithContentsOfFile:path];
    [self.pickerArr addObjectsFromArray:arr];
}
#pragma mark - 创建city - pickerView
- (void)creatPickerView{
    rightView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenSize.width,kScreenSize.height)];
    rightView.backgroundColor = [UIColor whiteColor];
    //[rightView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"pickerViewBac"]]];
    NSArray *arr = @[@"取消",@"确定",@"全部城市"];
    CGFloat buttonSpace = (kScreenSize.width-30*2-80*arr.count)/(arr.count-1);
    for (NSInteger i =0; i<arr.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(30+(buttonSpace+80)*i, 100, 80, 30);
        [button setTitle:arr[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setBackgroundImage:[[UIImage imageNamed:@"picker_button"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(pickerView:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 201+i;
        [rightView addSubview:button];
    }
    self.pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 130, kScreenSize.width, 300)];
    self.pickerView.dataSource = self;
    self.pickerView.delegate = self;
    //self.pickerView.backgroundColor = [UIColor lightGrayColor];
    self.pickerView.backgroundColor = [UIColor clearColor];
    [rightView addSubview:self.pickerView];
    rightView.hidden = YES;
    [self.view addSubview:rightView];
}
- (void)pickerView:(UIButton *)button{
    switch (button.tag) {
        case 201://取消
        {
            saveButton.selected = NO;
            rightView.hidden = YES;
            topButton.hidden = NO;
        }
            break;
        case 202://确定
        {
            saveButton.selected = NO;
            if (!cityTitle.length) {
                cityTitle = @"城市";
                self.cityName = @"";
                [saveButton setTitle:cityTitle forState:UIControlStateNormal];
            }else{
                [saveButton setTitle:[NSString stringWithFormat:@"%@..",[cityTitle substringToIndex:2]] forState:UIControlStateNormal];
            }
            rightView.hidden = YES;
            topButton.hidden = NO;
            [self.dataArr removeAllObjects];
            [self addTaskWithIsRefresh:YES];
        }
            break;
        case 203://全部城市
        {
            saveButton.selected = NO;
            [saveButton setTitle:@"全部" forState:UIControlStateNormal];
            rightView.hidden = YES;
            topButton.hidden = NO;
            self.cityName = @"";
            NSLog(@"%@",self.cityName);
            [self.dataArr removeAllObjects];
            [self addTaskWithIsRefresh:YES];
        }
            break;
        default:
            break;
    }
}
#pragma mark - UIPickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component==0) {
        return self.pickerArr.count;
    }else{
        return [self.pickerArr[_selectRowLeft][@"Cities"]count];
    }
}
#pragma mark - UIPickerViewDataSource
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (component==0) {
        return self.pickerArr[row][@"State"];
    }else if(component == 1){
        return self.pickerArr[_selectRowLeft][@"Cities"][row][@"city"];
    }
    return nil;
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (component == 0) {
        _selectRowLeft = row;
        [self.pickerView reloadComponent:1];
    }else if (component == 1){
        _selectRowRight = row;
    }
    if ([self.pickerArr[_selectRowLeft][@"Cities"]count] <= _selectRowRight) {
        _selectRowRight = [self.pickerArr[_selectRowLeft][@"Cities"]count]-1;
        cityTitle = [self.pickerArr[_selectRowLeft][@"Cities"]lastObject][@"city"];
    }else{
        cityTitle = self.pickerArr[_selectRowLeft][@"Cities"][_selectRowRight][@"city"];
    }
    //self.cityName = cityTitle;
    NSString *province = self.pickerArr[_selectRowLeft][@"State"];
    if([[province substringFromIndex:province.length-1]isEqualToString:@"市"]){
        cityTitle = province;
    }
    self.cityName = cityTitle;
}
#pragma mark - 创建回到顶部视图
- (void)creatGoToTheTopOfView{
//    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(kScreenSize.width-60, kScreenSize.height-120, 60, 50)];
    topButton = [UIButton buttonWithType:UIButtonTypeSystem];
    //button.frame = CGRectMake(15,0,30,30);
    //[button setBackgroundColor:[UIColor lightGrayColor]];
    topButton.frame = CGRectMake(kScreenSize.width-50,kScreenSize.height-120,50,50);
    [topButton setImage:[[UIImage imageNamed:@"gotop"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [topButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view insertSubview:topButton atIndex:100];
//    [view addSubview:button];
//    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 30, 60, 20)];
//    label.text = @"回到顶部";
//    label.font = [UIFont boldSystemFontOfSize:15];
//    label.textColor = [UIColor darkGrayColor];
//    [view addSubview:label];
//    [self.view insertSubview:view atIndex:100];
}
- (void)btnClick:(UIButton *)button{
    [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
}
#pragma mark - 界面将要显示的时候
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.menuController.tabBarController.tabBar.hidden = NO;
    if (self.currentType != self.menuController.tabBarController.selectedIndex+1) {
        [self.dataArr removeAllObjects];
        self.currentType = self.menuController.tabBarController.selectedIndex+1;
        NSLog(@"%@--->%ld",NSStringFromClass(self.class) ,(long)self.currentType);
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
