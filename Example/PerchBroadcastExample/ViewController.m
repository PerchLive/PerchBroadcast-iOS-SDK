//
//  ViewController.m
//  PerchBroadcastExample
//
//  Created by Chris Ballinger on 1/5/16.
//  Copyright © 2016 Perch Innovations, Inc. All rights reserved.
//

#import "ViewController.h"
#import "KFBroadcastViewController.h"
#import "PerchAPIClient.h"
#import "MockAPIClient.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)startButtonPressed:(id)sender {
#if BROADCAST_MOCK
    MockAPIClient *apiClient = [[MockAPIClient alloc] init];
#else
    PerchAPIClient *apiClient = [[PerchAPIClient alloc] initWithBaseURL:[NSURL URLWithString:@"https://perchlive.com/api/v1/"]];
#endif
    KFBroadcastViewController *broadcaster = [[KFBroadcastViewController alloc] initWithAPIClient:apiClient];
    [self presentViewController:broadcaster animated:YES completion:nil];
}
@end
