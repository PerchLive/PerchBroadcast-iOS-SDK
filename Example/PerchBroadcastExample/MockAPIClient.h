//
//  MockAPIClient.h
//  PerchBroadcastExample
//
//  Created by Chris Ballinger on 1/7/16.
//  Copyright © 2016 Perch Innovations, Inc. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import "BroadcastAPIClient.h"

@interface MockAPIClient : AFHTTPSessionManager <BroadcastAPIClient>

@end
