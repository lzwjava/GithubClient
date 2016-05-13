//
//  ViewController.m
//  GitHubClient
//
//  Created by 臧其龙 on 16/4/30.
//  Copyright © 2016年 臧其龙. All rights reserved.
//

#import "ViewController.h"
#import <AFNetworking/AFNetworking.h>
#import <SDWebImage/UIImageView+WebCache.h>

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *loginLabel;
@property (strong, nonatomic) NSString *etag;
@property (weak, nonatomic) IBOutlet UITableViewCell *imageCell;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if ([self accessToken] != nil) {
        self.loginLabel.text = @"登录情况：已登录";
    } else {
        self.loginLabel.text = @"登录情况：未登录";
    }
}

- (NSString *)accessToken {
    NSString *accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"accessToken"];
    return accessToken;
}

- (void)fetchUserInfo {
    NSString *accessToken = [self accessToken];
    if (accessToken != nil) {
        [self fetchUserWithToken:accessToken];
    }
}

- (void)fetchUserWithToken:(NSString *)token {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"token %@", token] forHTTPHeaderField:@"Authorization"];
    if (self.etag.length > 0) {
//        NSString *tagValue = [NSString stringWithFormat:@"\"%@\"", self.etag];
//        NSLog(@"tagValue: %@", tagValue);
//        [manager.requestSerializer setValue:self.etag forHTTPHeaderField:@"If-None-Match"];
    }
    [manager GET:@"https://api.github.com/user" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"headerFields: %@", task.currentRequest.allHTTPHeaderFields);
        NSLog(@"responseObject: %@", responseObject);
        NSLog(@"response: %@", task.response);
        NSHTTPURLResponse *resp = (NSHTTPURLResponse *)task.response;
        self.etag = resp.allHeaderFields[@"Etag"];
        NSLog(@"etag: %@", self.etag);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error: %@", error);
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 2) {
        [self fetchUserInfo];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    if (indexPath.row == 3) {
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:@"https://avatars2.githubusercontent.com/u/5022872?v=3&s=460"] placeholderImage:[UIImage imageNamed:@"defaultImage"]];
    }
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
