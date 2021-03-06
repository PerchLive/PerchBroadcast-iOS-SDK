//
//  PerchS3Endpoint.m
//  Pods
//
//  Created by Chris Ballinger on 1/6/16.
//
//

#import "PerchS3Endpoint.h"
#import "KFDateUtils.h"


@implementation PerchS3Endpoint
@synthesize bucketName;
@synthesize awsAccessKey;
@synthesize awsSecretKey;
@synthesize awsSessionToken;
@synthesize awsExpirationDate;
@synthesize awsPrefix;
@synthesize awsRegion;

/* start stream
 {
 'stream' : {
 'id' : 'stream_id', (generally a UUID or similar)
 'name' : 'some_name',
 'start_date' : '2015-10-22 15:27:40', (time always in GMT)
 },
 'endpoint': {
 'S3': {
 'aws_access_key_id': 'key'
 'aws_secret_access_key': 'secret',
 'aws_session_token': 'token',
 'aws_expiration': '2015-10-22 15:27:40',
 'aws_bucket_name': 'bucket',
 'aws_bucket_path': 'path',
 'aws_region': 'us-west-1' // valid amazon region string
 }
 // future endpoints could go here, like RTMP, WebRTC, etc
 }
 }*/
+ (NSDictionary*) JSONKeyPathsByPropertyKey {
    return @{NSStringFromSelector(@selector(bucketName)): @"S3.s3_bucket_name",
             NSStringFromSelector(@selector(awsAccessKey)): @"S3.aws_access_key_id",
             NSStringFromSelector(@selector(awsSecretKey)): @"S3.aws_secret_access_key",
             NSStringFromSelector(@selector(awsSessionToken)): @"S3.aws_session_token",
             NSStringFromSelector(@selector(awsExpirationDate)): @"S3.aws_expiration",
             NSStringFromSelector(@selector(awsPrefix)): @"S3.s3_bucket_path",
             NSStringFromSelector(@selector(awsRegion)): @"S3.s3_bucket_region",
             };
}

+ (NSValueTransformer *)awsExpirationDateJSONTransformer {
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSString *str) {
        return [[KFDateUtils utcDateFormatter] dateFromString:str];
    } reverseBlock:^(NSDate *date) {
        return [[KFDateUtils utcDateFormatter] stringFromDate:date];
    }];
}

@end
