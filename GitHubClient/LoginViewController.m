//
//  LoginViewController.m
//  GitHubClient
//
//  Created by lzw on 5/4/16.
//  Copyright © 2016 臧其龙. All rights reserved.
//

#import "LoginViewController.h"
#import <AFNetworking/AFNetworking.h>

@interface LoginViewController ()<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://github.com/login/oauth/authorize?client_id=b9743c20d9b40adf2ed3&scope=user:email&state=123"]];
    [self.webView loadRequest:request];
    self.webView.delegate = self;
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if ([[request.URL absoluteString] hasPrefix:@"http://reviewcode.cn"]) {
        NSURLComponents *components = [NSURLComponents componentsWithString:[request.URL absoluteString]];
        NSString *code;
        for (NSURLQueryItem *item in components.queryItems) {
            if ([item.name isEqualToString:@"code"]) {
                code = item.value;
            }
        }
        if (code != nil) {
            [self fetchAccessTokenWithCode:code];
        }
        return NO;
    } else {
        return YES;
    }
}

- (void)fetchAccessTokenWithCode:(NSString *)code {
    NSDictionary *params = @{@"client_id": @"b9743c20d9b40adf2ed3",
                             @"client_secret": @"7527d0b3a7b2abcebf58dfb0a744b1c7952db5ea",
                             @"code": code,
                             @"state": @"123"};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [[AFJSONResponseSerializer alloc] init];
    manager.requestSerializer = [[AFJSONRequestSerializer alloc] init];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [manager POST:@"https://github.com/login/oauth/access_token" parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dict = (NSDictionary *)responseObject;
        NSString *accessToken = dict[@"access_token"];
        NSLog(@"fetch accessToken:%@", accessToken);
        [[NSUserDefaults standardUserDefaults] setObject:accessToken forKey:@"accessToken"];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error: %@", error);
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
