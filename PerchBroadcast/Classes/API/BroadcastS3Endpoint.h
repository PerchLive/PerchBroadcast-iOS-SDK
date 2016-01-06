//
//  BroadcastS3Endpoint.h
//  Pods
//
//  Created by Chris Ballinger on 1/6/16.
//
//

#import <Foundation/Foundation.h>
#import "BroadcastEndpoint.h"

@protocol BroadcastS3Endpoint <BroadcastEndpoint>

@property (nonatomic, strong) NSString *bucketName;
@property (nonatomic, strong) NSString *awsAccessKey;
@property (nonatomic, strong) NSString *awsSecretKey;
@property (nonatomic, strong) NSString *awsSessionToken;
@property (nonatomic, strong) NSDate *awsExpirationDate;
@property (nonatomic, strong) NSString *awsPrefix;
@property (nonatomic, strong) NSString *awsRegion;

@end
