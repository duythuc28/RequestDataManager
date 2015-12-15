//
//  ViewController.m
//  CustomDownloadManager
//
//  Created by IOSDev on 12/1/15.
//  Copyright © 2015 IOSDev. All rights reserved.
//

#import "ViewController.h"
#import "RequestDataManager.h"
@interface ViewController ()

@end

@implementation ViewController
static NSString * const BaseURLString = @"http://www.raywenderlich.com/demos/weather_sample/weather.php?format=json";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    RequestDataManager * requestDataManager = [[RequestDataManager alloc]initWithUrl:BaseURLString];
    [requestDataManager setRequestMethod:GET];
    [requestDataManager requestDataSuccess:^(AFHTTPRequestOperation *operation, id response) {
        NSLog(@"%@",response);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
