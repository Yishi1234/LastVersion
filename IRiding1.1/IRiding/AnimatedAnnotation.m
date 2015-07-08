//
//  AnimatedAnnotation.m
//  IRiding
//
//  Created by qianfeng01 on 15/7/6.
//  Copyright (c) 2015年 刘丽丽. All rights reserved.
//

#import "AnimatedAnnotation.h"

@implementation AnimatedAnnotation
- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate{
    if (self = [super init]) {
        self.coordinate = coordinate;
    }
    return self;
}
@end
