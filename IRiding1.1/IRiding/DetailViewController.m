//
//  DetailViewController.m
//  IRiding
//
//  Created by qianfeng01 on 15-6-16.
//  Copyright (c) 2015年 刘丽丽. All rights reserved.
//

#import "DetailViewController.h"
#import "DetailModel.h"
#import "DetailLogCell.h"
#import "LZXHelper.h"
#import "UserHeadView.h"

#import <MAMapKit/MAMapKit.h>
#define kGaoAppKey @"c3432701a213e48552a73b96ff9aa464"

#import "CommentView.h"
#import "BarView.h"
#import "CommentCommitViewController.h"
#import "LikeCollectionViewController.h"
//#import <CoreText/CoreText.h>
@interface DetailViewController ()<UITableViewDataSource,UITableViewDelegate,MAMapViewDelegate>
{
    UITableView *_tableView;
    NSMutableArray *_dataArr;
    UserHeadView *_headerView;
    
    UIView *tableHeadView;
    MAMapView *_mapView;//高德地图
    
    UIView *footerCommentView;
    NSInteger footerHeight;
    
    NSString *_commentMessageUrl;
    NSMutableArray *_commentArr;
    NSInteger _lastId;
    BOOL _isLoadingMore;
    NSInteger _commentPage;
}

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *dataArr;
@property (nonatomic,strong)NSMutableArray *commentArr;
@property (nonatomic)BOOL isLoadingMore;
@property (nonatomic,copy)NSString *commentMessageUrl;
@property (nonatomic)NSInteger commentPage;
@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _lastId = 0;
    self.title =@"日志详情";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Arial Rounded MT Bold" size:20]}];
    _commentPage = 0;
    self.commentArr = [[NSMutableArray alloc]init];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(creatHeadAndFootView) name:@"dataArrChanged" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(creatCommentView) name:@"commentArrChanged" object:nil];
    [self creatTableView];
    //[self createMap];
    [self addTaskWithIsRefresh:YES];
    
    _headerView = [[[NSBundle mainBundle]loadNibNamed:@"UserHeadView" owner:nil options:nil]lastObject];
    self.isLoadingMore = NO;
    [self creatLoadView];
    //[self creatLikeAndCommentAndFavoriteView];
    [self creatGoToTheTopOfView];
}
#pragma mark - creatBackBarbuttonItem
- (void)creatBackBarbuttonItem{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 80, 30)];
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    image.image = [UIImage imageNamed:@"nav_back"];
    [view addSubview:image];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(30, 0, 50, 30)];
    label.text = @"最新";
    [view addSubview:label];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithCustomView:view];
    self.navigationItem.leftBarButtonItem = bar;
}
#pragma mark - creatTableView
- (void)creatTableView{
    self.dataArr = [[NSMutableArray alloc]init];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kScreenSize.width, kScreenSize.height-64-44) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"DetailLogCell" bundle:nil] forCellReuseIdentifier:@"DetailLogCell"];
    [self.view addSubview:self.tableView];
}
#pragma mark - 下载任务
- (void)addTaskWithIsRefresh:(BOOL)isRefresh{
    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleFade];
    [MMProgressHUD showWithTitle:@"页面加载中" status:@"loading..."];

    NSMutableDictionary *dict =[NSMutableDictionary dictionaryWithDictionary:@{@"trackId":@6375}];
    [dict setObject:self.id forKey:@"trackId"];
    __weak typeof (self)weakSelf = self;
    [_manager POST:kDetailUrl parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"下载成功");
        if (responseObject) {
            NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            DetailModel *model = [[DetailModel alloc]init];
            [model setValuesForKeysWithDictionary:dataDict];
            weakSelf.numberRows = model.photos.count;
            [weakSelf.dataArr addObject:model];
            NSLog(@"%@",weakSelf.dataArr);
            [_headerView showDataWithModel:weakSelf.dataArr[0]];
            NSArray *arr = model.comments;
            NSLog(@"%@",arr);
//            [weakSelf.commentArr addObjectsFromArray:arr];
//            NSDictionary *lastDict = weakSelf.commentArr.lastObject;
//            _lastId = [lastDict[@"id"]integerValue];
//            [[NSNotificationCenter defaultCenter]postNotificationName:@"dataArrChanged" object:nil];
            if (arr.count != 0) {
                [weakSelf.commentArr addObjectsFromArray:arr];
                NSDictionary *lastDict = weakSelf.commentArr.lastObject;
                _lastId = [lastDict[@"id"]integerValue];
//                [[NSNotificationCenter defaultCenter]postNotificationName:@"commentArrChanged" object:nil];
            }
            [[NSNotificationCenter defaultCenter]postNotificationName:@"dataArrChanged" object:nil];
            [weakSelf.tableView reloadData];
        }
        [MMProgressHUD dismiss];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"下载失败");
        [MMProgressHUD dismissWithError:@"加载失败" title:@"Sorry"];
    }];
}
#pragma mark - tableview协议
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.numberRows;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DetailLogCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DetailLogCell" forIndexPath:indexPath];
    DetailModel *model = self.dataArr[0];
    [cell showDataWithModel:model indexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    DetailModel *model = self.dataArr[0];
    NSArray *arr = model.photos;
    CGFloat height = 38;
    NSDictionary *dict = arr[indexPath.row];
    if ([dict[@"url"] length]) {
        height += 7 + 275;
    }
    if ([dict[@"desc"]length]) {
        height += 7 + [LZXHelper textHeightFromTextString:dict[@"desc"] width:kScreenSize.width-20 fontSize:16];
    }
    return height+7;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ---------地图----------
#pragma mark - 创建地图
- (void)createMap {
//获取用户详情视图
    CGRect frame = _headerView.frame;
    frame.origin.x = 0;
    frame.origin.y = 200;
    _headerView.frame = frame;
    __weak typeof (self)weakSelf = self;
    [_headerView setMyBlockWithBlock:^(DetailModel *model) {
        LikeCollectionViewController *like = [[LikeCollectionViewController alloc]init];
        like.model = model;
        [weakSelf.navigationController pushViewController:like animated:YES];
    }];

//创建地图
    [MAMapServices sharedServices].apiKey = kGaoAppKey;
    _mapView = [[MAMapView alloc]initWithFrame:CGRectMake(0, 0, kScreenSize.width, 200)];
    
    tableHeadView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenSize.width, 200+_headerView.frame.size.height)];
    [tableHeadView addSubview:_headerView];
    
    _mapView.delegate = self;
    _mapView.mapType = MAMapTypeStandard;
    
    DetailModel *model = self.dataArr[0];
    NSArray *mapTracks = model.tracks;
    NSInteger trackCount = mapTracks.count;
    if (mapTracks.count > 0) {
        NSDictionary *dict = mapTracks[trackCount/2];
        _mapView.showsScale = NO;
        _mapView.region = MACoordinateRegionMake(CLLocationCoordinate2DMake([dict[@"lat"]floatValue], [dict[@"lon"]floatValue]), MACoordinateSpanMake(0.1, 0.2));
        _mapView.centerCoordinate = CLLocationCoordinate2DMake([dict[@"lat"]floatValue], [dict[@"lon"]floatValue]);
        [self creatPolyLineWithModel:model];
        [self creatAnnotationWithModel:model];
    }
    
    [tableHeadView addSubview:_mapView];
    
    self.tableView.tableHeaderView = tableHeadView;
}
#pragma mark - 填充头视图
//- (void)fillHeadView{
//    
//    
//
//}
#pragma mark - 折线/路线
- (void)creatPolyLineWithModel:(DetailModel *)model{
    NSArray *tracks = model.tracks;
    NSInteger count = tracks.count;
    CLLocationCoordinate2D commonPolylineCoords[count];
    for (NSInteger i=0;i<tracks.count;i++) {
        NSDictionary *dict = tracks[i];
        commonPolylineCoords[i].latitude = [dict[@"lat"]floatValue];
        commonPolylineCoords[i].longitude = [dict[@"lon"]floatValue];
    }
    //构造折线对象
    MAPolyline *commonPolyline = [MAPolyline polylineWithCoordinates:commonPolylineCoords count:count];
    
    //在地图上添加折线对象
    [_mapView addOverlay: commonPolyline];
}
#pragma mark - MAMapViewDelegate协议
- (MAOverlayView *)mapView:(MAMapView *)mapView viewForOverlay:(id <MAOverlay>)overlay
{
    if ([overlay isKindOfClass:[MAPolyline class]])
    {
        MAPolylineView *polylineView = [[MAPolylineView alloc] initWithPolyline:overlay];
        
        polylineView.lineWidth = 4.f;
        polylineView.strokeColor = [UIColor colorWithRed:0 green:0 blue:1 alpha:0.6];
        
        polylineView.lineJoin = (CGLineJoin)kCALineJoinRound;//连接类型
        polylineView.lineCap = (CGLineCap)kCALineCapRound;//端点类型
        
        return polylineView;
    }
    return nil;
}
#pragma mark - 大头针
- (void)creatAnnotationWithModel:(DetailModel *)model{
    NSArray *tracks = model.tracks;
    NSInteger count = tracks.count;
    for (NSInteger i = 0; i < 2; i ++) {
        MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
        if (i==0) {
            NSDictionary *dict = tracks[0];
            pointAnnotation.coordinate = CLLocationCoordinate2DMake([dict[@"lat"]floatValue], [dict[@"lon"]floatValue]);
            pointAnnotation.title = @"起点";
        }else{
            NSDictionary *dict = tracks[count-1];
            pointAnnotation.coordinate = CLLocationCoordinate2DMake([dict[@"lat"]floatValue], [dict[@"lon"]floatValue]);
            pointAnnotation.title = @"终点";
        }
        [_mapView addAnnotation:pointAnnotation];
    }
}
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *reuseIndetifier = @"annotationReuseIndetifier";
        MAAnnotationView *annotationView = (MAAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseIndetifier];
        }
        if ([[annotation title]isEqualToString:@"起点"]) {
            annotationView.image = [UIImage imageNamed:@"startPoint"];
        }else{
            annotationView.image = [UIImage imageNamed:@"endPoint"];
        }
        //设置中⼼心点偏移，使得标注底部中间点成为经纬度对应点
        annotationView.centerOffset = CGPointMake(0, -18);
        return annotationView;
    }
    return nil;
}
#pragma mark - 头尾视图
- (void)creatHeadAndFootView{
    [self createMap];
    [self creatLikeAndCommentAndFavoriteView];
    [self creatCommentView];
}
#pragma mark - 尾视图-评论
- (void)creatCommentView{
    if (self.commentArr.count == 0) {
        return;
    }else{
        if (_commentPage == 0) {
            footerCommentView = [[UIView alloc]init];
            footerHeight = 47;
            //footerCommentView.backgroundColor = [UIColor redColor];
            UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 1, kScreenSize.width, 1)];
            lineView.backgroundColor = [UIColor darkGrayColor];
            [footerCommentView addSubview:lineView];
            UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, 7, kScreenSize.width-80, 40)];
            titleLabel.text = @"评论";
            titleLabel.font = [UIFont boldSystemFontOfSize:18];
            [footerCommentView addSubview:titleLabel];
        }
        for (NSInteger i =_commentPage*10; i<self.commentArr.count; i++) {
            NSDictionary *dict = self.commentArr[i];
            NSLog(@"%@",dict);
            CommentView *comment = [[[NSBundle mainBundle]loadNibNamed:@"CommentView" owner:nil options:nil]lastObject];
            [comment showDataWithHeadView:dict[@"avatar_url"] userName:dict[@"username"] time:dict[@"add_time"] content:dict[@"content"] gender:[dict[@"gender"]integerValue] replyUserName:dict[@"reply_username"]];
            comment.frame = CGRectMake(0, footerHeight, kScreenSize.width, comment.rowHeight);
            footerHeight +=  comment.rowHeight+1;
            [footerCommentView addSubview:comment];
        }
        footerCommentView.frame = CGRectMake(0, 0, kScreenSize.width, footerHeight+2);
        self.tableView.tableFooterView = footerCommentView;
    }
    //[self creatLikeAndCommentAndFavoriteView];
    [self.tableView reloadData];
}
#pragma mark - 创建加载视图
- (void)creatLoadView{
    __weak typeof (self)weakSelf = self;
    [self.tableView addRefreshFooterViewWithAniViewClass:[JHRefreshCommonAniView class] beginRefresh:^{
        if (weakSelf.isLoadingMore) {
            return ;
        }else{
           weakSelf.commentPage ++;
            weakSelf.isLoadingMore = YES;
            NSDictionary *dict = [[NSUserDefaults standardUserDefaults]objectForKey:@"dict"];
            if ([dict[@"token"]length]) {
                weakSelf.commentMessageUrl = [kCommentMessageUrl stringByAppendingString:dict[@"token"]];
            }else{
                weakSelf.commentMessageUrl = kCommentMessageUrl;
            }
            [weakSelf addCommentTaskWithUrl:weakSelf.commentMessageUrl];
        }
    }];
}
- (void)endLoad{
    if (self.isLoadingMore) {
        self.isLoadingMore = NO;
        [self.tableView footerEndRefreshing];
    }
}
#pragma mark - 下拉加载 评论
- (void)addCommentTaskWithUrl:(NSString *)url{
    //[self.commentArr removeAllObjects];
    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleFade];
    [MMProgressHUD showWithTitle:@"页面加载中" status:@"loading..."];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{@"last_id":@(2360),@"track_id":@(6469)}];
    [dict setObject:[NSNumber numberWithInteger:_lastId] forKey:@"last_id"];
    [dict setObject:self.id forKey:@"track_id"];
    __weak typeof (self)weakSelf = self;
    [_manager POST:url parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"评论加载成功");
        if (responseObject) {
            NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSArray *responseComment = responseDict[@"comments"];
            [weakSelf.commentArr addObjectsFromArray:responseComment];
            NSLog(@"%@",weakSelf.commentArr);
            NSDictionary *lastDict = weakSelf.commentArr.lastObject;
            _lastId = [lastDict[@"id"]integerValue];
            [weakSelf endLoad];
            //[weakSelf.tableView reloadData];
            if (responseComment.count==0){
                [MMProgressHUD dismissWithSuccess:@"没有啦！" title:@"亲"];
            }else{
                [[NSNotificationCenter defaultCenter]postNotificationName:@"commentArrChanged" object:nil];
            }
            //[weakSelf.tableView reloadData];
        }
        [MMProgressHUD dismiss];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"评论加载失败");
        [weakSelf endLoad];
        [MMProgressHUD dismissWithError:@"加载失败" title:@"Sorry"];
    }];
}
#pragma mark - 点赞，收藏，评论视图
- (void)creatLikeAndCommentAndFavoriteView{
    BarView *bar = [[[NSBundle mainBundle]loadNibNamed:@"BarView" owner:nil options:nil]lastObject];
//    if (kScreenSize.width == 375) {
//        [bar setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bar-750"]]];
//    }else{
//        [bar setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bar"]]];
//    }
//    if (kScreenSize.width == 375) {
//        [bar setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"navigationbar_background-750"]]];
//    }else{
//        [bar setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"navigationbar_background"]]];
//    }

//    [bar setBackgroundColor:[UIColor colorWithRed:0.95 green:0.5 blue:0.2 alpha:0.3]];
    bar.frame = CGRectMake(0, self.view.bounds.size.height-44, kScreenSize.width, 44);
    DetailModel *detailModel = self.dataArr[0];
    [bar showDataWithModel:detailModel];
    __weak typeof (self)weakSelf = self;
    [bar setMyBlock:^(DetailModel *model) {
        CommentCommitViewController *comment = [[CommentCommitViewController alloc]init];
        comment.track_id = model.id.integerValue;
        
        [weakSelf.navigationController pushViewController:comment animated:YES];
    }];
    [self.view addSubview:bar];
    
}

#pragma mark - 创建回到顶部视图
- (void)creatGoToTheTopOfView{
    //    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(kScreenSize.width-60, kScreenSize.height-120, 60, 50)];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    //button.frame = CGRectMake(15,0,30,30);
    //[button setBackgroundColor:[UIColor lightGrayColor]];
    button.frame = CGRectMake(kScreenSize.width-50,kScreenSize.height-120,50,50);
    [button setImage:[[UIImage imageNamed:@"gotop"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view insertSubview:button atIndex:100];
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











@end
