//
//  ADView.m
//  UITableView_Cell定制
//
//  Created by LZXuan on 14-12-18.
//  Copyright (c) 2014年 LZXuan. All rights reserved.
//

#import "ADView.h"
#import "UIImageView+WebCache.h"
#import "UIImageView+ImageViewEventBlock.h"
#define kScreenSize [UIScreen mainScreen].bounds.size
@implementation ADView
{
    UIScrollView *_scrollView;
    UIPageControl *_pageControl;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
    }
    return self;
}
- (void)creatViewWithAdvArr:(NSMutableArray *)arr {
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0,kScreenSize.width, 160)];
    _scrollView.backgroundColor = [UIColor whiteColor];
    for (int i = 1; i < arr.count; i++) {
        AdvModel *model = (AdvModel *)arr[i];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenSize.width*(i-1), 2, kScreenSize.width, 160-4)];
        [imageView sd_setImageWithURL:[NSURL URLWithString:model.cover] placeholderImage:[UIImage imageNamed: @"logPlaceholder"]];
        //imageView.contentMode = UIViewContentModeScaleAspectFit;
        [imageView addClickEvent:^(UIImageView *imageView) {
            
        }];
        [_scrollView addSubview:imageView];
    }
    //下面设置滚动视图
    _scrollView.contentSize = CGSizeMake((arr.count-1)*_scrollView.bounds.size.width, 160);
    _scrollView.showsVerticalScrollIndicator = NO;
    //按页
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    
    [self addSubview:_scrollView];
    //页码器
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 160-30-6, kScreenSize.width, 30)];
    _pageControl.numberOfPages = arr.count-1;
    
    [_pageControl addTarget:self action:@selector(pageClick:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:_pageControl];
}
- (void)pageClick:(UIPageControl *)page {
    //修改滚动视图的偏移量
    [_scrollView setContentOffset:CGPointMake(_scrollView.bounds.size.width*page.currentPage, 0) animated:YES];
}
//减速停止的时候
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    //修改页码
    CGPoint offset = _scrollView.contentOffset;
    _pageControl.currentPage = offset.x/_scrollView.bounds.size.width;
}

@end
