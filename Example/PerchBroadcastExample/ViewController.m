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

- (NSString*) randomUsername {
    NSString *alphabet  = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXZY0123456789";
    NSMutableString *s = [NSMutableString stringWithCapacity:20];
    for (NSUInteger i = 0U; i < 20; i++) {
        u_int32_t r = arc4random() % [alphabet length];
        unichar c = [alphabet characterAtIndex:r];
        [s appendFormat:@"%C", c];
    }
    return s;
}

- (IBAction)startButtonPressed:(id)sender {
#if BROADCAST_MOCK
    MockAPIClient *apiClient = [[MockAPIClient alloc] init];
#else
    //PerchAPIClient *apiClient = [[PerchAPIClient alloc] initWithBaseURL:[NSURL URLWithString:@"https://perchlive.com/api/v1/"]];
    PerchAPIClient *apiClient = [[PerchAPIClient alloc] initWithBaseURL:[NSURL URLWithString:@"http://10.11.41.186:8000/api/"]];
    NSString *email = [NSString stringWithFormat:@"%@@asdf.com", [self randomUsername]];
    [apiClient createUserWithEmail:email password:@"asdf" callbackBlock:^(NSString *apiToken, NSError *error) {
        if (apiToken) {
            NSLog(@"token: %@", apiToken);
        } else {
            NSLog(@"error: %@", error);
        }
    }];

#endif
    KFBroadcastViewController *broadcaster = [[KFBroadcastViewController alloc] initWithAPIClient:apiClient];
    [self presentViewController:broadcaster animated:YES completion:nil];
}
@end
