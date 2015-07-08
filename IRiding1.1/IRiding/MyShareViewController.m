//
//  MyShareViewController.m
//  IRiding
//
//  Created by qianfeng01 on 15/7/3.
//  Copyright (c) 2015年 刘丽丽. All rights reserved.
//

#import "MyShareViewController.h"
#import <MAMapKit/MAMapKit.h>
#define kGaoAppKey @"c3432701a213e48552a73b96ff9aa464"
#import "ShareButtonView.h"

#import "AnimatedAnnotation.h"
#import "AnimatedAnnotationView.h"
@interface MyShareViewController ()<MAMapViewDelegate>
{
    MAMapView *_mapView;
    MAUserLocation *_pointAnnotation;
    //AnimatedAnnotation *_pointAnnotation;
    CLLocationManager *locationManager;
}

@end

@implementation MyShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    [self creatMapView];
    [self creatShareButton];
    
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    locationManager = [[CLLocationManager alloc]init];
    if ([CLLocationManager authorizationStatus]==kCLAuthorizationStatusNotDetermined) {
        if ([locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
            [locationManager performSelector:@selector(requestAlwaysAuthorization)];//用这个方法，plist 中需要NSLocationAlwaysUsageDescription
        }
    }
    _mapView.userTrackingMode = MAUserTrackingModeFollowWithHeading;
    [_mapView setZoomLevel:16.1 animated:YES];
}
#pragma mark - 封装创建大头针
- (void)creatAnnotation{
    _pointAnnotation = [[MAUserLocation alloc]init];
    _pointAnnotation.title = @"当前位置";
    [_mapView addAnnotation:_pointAnnotation];
}
//- (void)creatAnnotation{
//    //_pointAnnotation = [[MAPointAnnotation alloc]init];
//    _pointAnnotation = [[AnimatedAnnotation alloc]init];
//    //_pointAnnotation.coordinate = CLLocationCoordinate2DMake(39.989631, 116.481018);
//    _pointAnnotation.title = @"当前位置";
//    [_mapView addAnnotation:_pointAnnotation];
//}

#pragma mark - creatMapView
- (void)creatMapView{
    [MAMapServices sharedServices].apiKey = kGaoAppKey;
    self.locationArr = [[NSMutableArray alloc]init];
    _mapView = [[MAMapView alloc]initWithFrame:CGRectMake(0, 0,CGRectGetWidth(self.view.bounds),CGRectGetHeight(self.view.bounds))];
    _mapView.delegate = self;
    _mapView.region = MACoordinateRegionMake(CLLocationCoordinate2DMake(39.989631, 116.481018), MACoordinateSpanMake(0.01, 0.01));
    _mapView.pausesLocationUpdatesAutomatically = NO;
    [self creatAnnotation];
    
    [self.view addSubview:_mapView];
    _mapView.showsUserLocation = YES;
}
#pragma mark - MAMapViewDelegate
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation{
    if ([annotation isKindOfClass:[MAUserLocation class]]) {
        static NSString *reuseId = @"annotationId";
        MAAnnotationView *annotationView = (MAAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseId];
        if (annotationView == nil) {
            annotationView = [[MAAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:reuseId];
        }
        annotationView.image = [UIImage imageNamed:@"userlocation"];
        annotationView.centerOffset = CGPointMake(0, -18);
        return annotationView;
    }
    return nil;
}
- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation{
    if (updatingLocation) {
        NSLog(@"lat:%f,lon:%f",userLocation.coordinate.latitude,userLocation.coordinate.longitude);
    }
    _mapView.centerCoordinate = userLocation.coordinate;
    _pointAnnotation.coordinate = userLocation.coordinate;
    if (!self.locationArr.count) {
        [self.locationArr addObject:userLocation.location];
    }
    if (self.locationArr.count) {
        CLLocation *lastLocation = self.locationArr.lastObject;
        if (lastLocation.coordinate.latitude != userLocation.location.coordinate.latitude || lastLocation.coordinate.longitude != userLocation.location.coordinate.longitude) {
            [self.locationArr addObject:userLocation.location];
        }
    }
    NSLog(@"%@",self.locationArr);
    if (self.locationArr.count>0) {
        [self creatPolyLineWithArr:[NSMutableArray arrayWithObject:self.locationArr.lastObject]];
    }
}
#pragma mark - 折线/路线
- (void)creatPolyLineWithArr:(NSMutableArray *)arr{
    NSInteger count = arr.count;
    CLLocationCoordinate2D commonPolylineCoords[count];
    for (NSInteger i=0;i<arr.count;i++) {
        commonPolylineCoords[i].latitude = [arr[i]coordinate].latitude;
        commonPolylineCoords[i].longitude = [arr[i]coordinate].longitude;
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

//- (void)mapView:(MAMapView *)mapView didAddAnnotationViews:(NSArray *)views{
//    AnimatedAnnotationView *view = views[0];
//    //放到该方法中用以保证userLocation的annotationView已经添加到地图上了
//    if ([view.annotation isKindOfClass:[AnimatedAnnotation class]]) {
//        MAUserLocationRepresentation *pre = [[MAUserLocationRepresentation alloc]init];
//        pre.fillColor = [UIColor colorWithRed:0.9 green:0.1 blue:0.1 alpha:0.3];
//        pre.strokeColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.9 alpha:1.0];
//        pre.image = [UIImage imageNamed:@"userlocation"];
//        pre.lineWidth = 3;
//        pre.lineDashPattern = @[@6,@3];
//        [_mapView updateUserLocationRepresentation:pre];
//        view.calloutOffset = CGPointMake(0, 0);
//    }
//}
#pragma mark - 创建分享按钮设置界面
- (void)creatShareButton{
    UIView *view = [[UIView alloc]initWithFrame:self.view.bounds];
    view.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    ShareButtonView *shareView = [[[NSBundle mainBundle]loadNibNamed:@"ShareButtonView" owner:nil options:nil]lastObject];
    CGRect frame = shareView.frame;
    frame.origin.x = (self.view.bounds.size.width-shareView.frame.size.width)/2;
    frame.origin.y = (self.view.bounds.size.height-shareView.frame.size.height)/2;
    shareView.frame = frame;
    [view addSubview:shareView];
    //[self.view addSubview:view];
    //[self.view addSubview:shareView];
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
