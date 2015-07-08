//
//  LikeCollectionViewController.m
//  IRiding
//
//  Created by qianfeng01 on 15/6/29.
//  Copyright (c) 2015年 刘丽丽. All rights reserved.
//

#import "LikeCollectionViewController.h"
#import "LikeCollectionCell.h"

@interface LikeCollectionViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic,retain)UICollectionView *collectionView;
@property (nonatomic,strong)NSMutableArray *dataArr;
@property (nonatomic)BOOL isRefreshing;
@property (nonatomic)BOOL isLoadingMore;
@property (nonatomic)NSInteger currentPage;
@end

@implementation LikeCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [NSString stringWithFormat:@"%ld个人赞过",self.model.like_count.integerValue];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Arial Rounded MT Bold" size:20]}];
    [self creatCollectionView];
    [self creatRefreshView];
    [self firstDownload];
}
- (void)creatCollectionView{
    self.dataArr = [[NSMutableArray alloc]init];
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
    layout.minimumLineSpacing = 10;
    layout.minimumInteritemSpacing = 10;
    layout.itemSize = CGSizeMake(60, 100);
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 64, kScreenSize.width, kScreenSize.height-64) collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.collectionView registerClass:[LikeCollectionCell class] forCellWithReuseIdentifier:@"LikeCollectionCell"];
    [self.view addSubview:self.collectionView];
}
#pragma mark - 协议方法
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArr.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    LikeCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LikeCollectionCell" forIndexPath:indexPath];
    NSDictionary *dict = self.dataArr[indexPath.row];
    [cell showDataWithHeadImage:dict[@"avatar_url"] name:dict[@"username"] gender:[dict[@"gender"]integerValue]];
    return cell;
}
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
//    NSDictionary *dict = self.dataArr[indexPath.row];
//    return CGSizeMake(60, [LikeCollectionCell itemHeightWithName:dict[@"username"]]);
//    //return CGSizeMake(60, 90);
//}
#pragma mark - 第一次加载
- (void)firstDownload{
    self.currentPage = 1;
    [self addTask];
}
#pragma mark - 创建刷新视图
- (void)creatRefreshView{
    __weak typeof (self)weakSelf = self;
    [self.collectionView addRefreshHeaderViewWithAniViewClass:[JHRefreshCommonAniView class] beginRefresh:^{
        if (weakSelf.isRefreshing) {
            return ;
        }
        weakSelf.currentPage = 1;
        weakSelf.isRefreshing = YES;
        [weakSelf addTask];
    }];
    [self.collectionView addRefreshFooterViewWithAniViewClass:[JHRefreshCommonAniView class] beginRefresh:^{
        if (weakSelf.isLoadingMore) {
            return ;
        }
        weakSelf.currentPage ++;
        weakSelf.isLoadingMore = YES;
        [weakSelf addTask];
    }];
}
- (void)endRefreshing{
    if (self.isRefreshing) {
        self.isRefreshing = NO;
        [self.collectionView headerEndRefreshingWithResult:JHRefreshResultSuccess];
    }
    if (self.isLoadingMore) {
        self.isLoadingMore = NO;
        [self.collectionView footerEndRefreshing];
    }
}
#pragma mark - 增加任务 下载点赞列表
- (void)addTask{
    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleFade];
    [MMProgressHUD showWithTitle:@"页面加载中" status:@"loading..."];
    __weak typeof (self)weakSelf = self;
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{@"page":@(1),@"trackId":@(8093)}];
    [dict setObject:[NSNumber numberWithInteger:_currentPage] forKey:@"page"];
    [dict setObject:self.model.id forKey:@"trackId"];
    NSDictionary *userDict = [[NSUserDefaults standardUserDefaults]objectForKey:@"dict"];
    NSString *url = kLikeListUrl;
    if ([userDict[@"token"]length]) {
        url = [kLikeListUrl stringByAppendingString:userDict[@"token"]];
    }
    [_manager POST:url parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"主页面下载成功");
        if (responseObject) {
            //NSLog(@"%@",responseObject);
            if (self.isRefreshing) {
                [self.dataArr removeAllObjects];
            }
            NSDictionary *allDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSArray *arr2 = allDict[@"like"];
            [weakSelf.dataArr addObjectsFromArray:arr2];
            [weakSelf.collectionView reloadData];
            [weakSelf endRefreshing];
            if ([allDict[@"like"]count]==0) {
                [MMProgressHUD dismissWithSuccess:@"没有啦！" title:@"亲"];
            }
        }
        [MMProgressHUD dismiss];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"下载失败");
        [weakSelf endRefreshing];
        [MMProgressHUD dismissWithError:@"加载失败" title:@"Sorry"];
    }];

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
