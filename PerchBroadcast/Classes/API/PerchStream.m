//
//  PerchStream.m
//  Pods
//
//  Created by Chris Ballinger on 1/6/16.
//
//

#import "PerchStream.h"
#import "PerchEndpoint.h"
#import "NSValueTransformer+MTLPredefinedTransformerAdditions.h"

@implementation PerchStream
@synthesize name, streamID, startDate, endpoint;

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
 'aws_expiration': 3600.0 // in seconds
 'aws_bucket_name': 'bucket',
 'aws_bucket_path': 'path',
 'aws_region': 'us-west-1' // valid amazon region string
 }
 // future endpoints could go here, like RTMP, WebRTC, etc
 }
 }*/
+ (NSDictionary*) JSONKeyPathsByPropertyKey {
    return @{NSStringFromSelector(@selector(name)): @"stream.name",
             NSStringFromSelector(@selector(streamID)): @"stream.id",
             NSStringFromSelector(@selector(startDate)): @"stream.start_date",
             NSStringFromSelector(@selector(endpoint)): @"endpoint",
             };
}

+ (NSValueTransformer *)endpointJSONTransformer {
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:PerchEndpoint.class];
}

@end
