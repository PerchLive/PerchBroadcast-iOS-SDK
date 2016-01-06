//
//  PerchAPIClient.h
//  Pods
//
//  Created by Chris Ballinger on 1/5/16.
//
//

#import <AFNetworking/AFNetworking.h>
#import "BroadcastAPIClient.h"

@interface PerchAPIClient : AFHTTPSessionManager <BroadcastAPIClient>

@end
