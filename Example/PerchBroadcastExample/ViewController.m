//
//  ViewController.m
//  PerchBroadcastExample
//
//  Created by Chris Ballinger on 1/5/16.
//  Copyright © 2016 Perch Innovations, Inc. All rights reserved.
//

#import "ViewController.h"
#import "Kickflip.h"

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
    [Kickflip setupWithAPIKey:@"" secret:@""];
    [Kickflip presentBroadcasterFromViewController:self ready:^(KFStream *stream) {
        
    } completion:^(BOOL success, NSError *error) {
        
    }];
}
@end
