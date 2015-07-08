//
//  AnimatedAnnotationView.m
//  IRiding
//
//  Created by qianfeng01 on 15/7/6.
//  Copyright (c) 2015年 刘丽丽. All rights reserved.
//

#import "AnimatedAnnotationView.h"
#import "AnimatedAnnotation.h"
#define kWidth 60.f
#define kHeight 60.f
#define kTimeInterval 0.15f
@implementation AnimatedAnnotationView
- (id)initWithAnnotation:(id<MAAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setBounds:CGRectMake(0.f, 0.f, kWidth, kHeight)];
        [self setBackgroundColor:[UIColor clearColor]];
        self.imageView = [[UIImageView alloc]initWithFrame:self.bounds];
        [self addSubview:self.imageView];
    }
    return self;
}
- (void)updateImageView{
    AnimatedAnnotation *animatedAnnotation = (AnimatedAnnotation *)self.annotation;
    if ([self.imageView isAnimating]) {
        [self.imageView stopAnimating];
    }
    self.imageView.animationImages = animatedAnnotation.animatedImages;
    self.imageView.animationDuration = kTimeInterval * [animatedAnnotation.animatedImages count];
    self.imageView.animationRepeatCount = 0;
    [self.imageView startAnimating];
}

- (void)setAnnotation:(id<MAAnnotation>)annotation{
    [super setAnnotation:annotation];
    [self updateImageView];
}













@end
