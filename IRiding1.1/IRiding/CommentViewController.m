//
//  CommentViewController.m
//  IRiding
//
//  Created by qianfeng01 on 15/6/23.
//  Copyright (c) 2015年 刘丽丽. All rights reserved.
//

#import "CommentViewController.h"
#import "AFNetworking.h"
@interface CommentViewController ()<UITextViewDelegate>
{
    UITextView *commentTextView ;
    UILabel *guideLabel;
    AFHTTPRequestOperationManager *manager;
    NSString *commentUrl;
}
@end

@implementation CommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"写评论";
    [self creatItemsWithIsLeft];
    [self creatTextView];
    manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
}
- (void)creatItemsWithIsLeft{
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(rightItemClick:)];
    self.navigationItem.rightBarButtonItem = item;
}
- (void)creatTextView{
    commentTextView = [[UITextView alloc]initWithFrame:self.view.bounds];
    commentTextView.backgroundColor = [UIColor lightGrayColor];
    commentTextView.delegate = self;
    commentTextView.font = [UIFont systemFontOfSize:17];
    guideLabel = [[UILabel alloc]initWithFrame:CGRectMake(3, 0, 180, 40)];
    guideLabel.font = [UIFont systemFontOfSize:17];
    guideLabel.text = @"在这里写下你的评论吧";
    guideLabel.textColor = [UIColor darkGrayColor];
    [commentTextView addSubview:guideLabel];
    
    [self.view addSubview:commentTextView];
}
- (void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length) {
        guideLabel.hidden = YES;
    }
}
- (void)rightItemClick:(UIBarButtonItem *)item{
    NSDictionary *userDict = [[NSUserDefaults standardUserDefaults]objectForKey:@"dict"];
    if ([userDict[@"token"]length]) {
        commentUrl = [kCommentUrl stringByAppendingString:userDict[@"token"]];
        [self addCommitCommentTask];
    }else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Sorry" message:@"请先重新账号" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
}
- (void)addCommitCommentTask{
    NSMutableDictionary *commentDict = [NSMutableDictionary dictionaryWithDictionary:@{@"content":@"棒棒哒",@"reply_uid":@(0),@"track_id":@(6094)}];
    [commentDict setObject:commentTextView.text forKey:@"content"];
    [commentDict setObject:[NSNumber numberWithInteger:self.track_id] forKey:@"track_id"];
    [manager POST:commentUrl parameters:commentDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"评论成功");
        if (responseObject) {
            
            [self.navigationController popViewControllerAnimated:YES];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"评论失败");
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
