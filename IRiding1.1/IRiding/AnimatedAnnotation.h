//
//  AnimatedAnnotation.h
//  IRiding
//
//  Created by qianfeng01 on 15/7/6.
//  Copyright (c) 2015年 刘丽丽. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MAMapKit/MAMapKit.h>
@interface AnimatedAnnotation : NSObject<MAAnnotation>
@property (nonatomic,assign)CLLocationCoordinate2D coordinate;
@property (nonatomic,copy)NSString *title;
@property (nonatomic,strong)NSMutableArray *animatedImages;
- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate;


@end
