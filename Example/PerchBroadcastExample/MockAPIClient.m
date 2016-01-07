//
//  MockAPIClient.m
//  PerchBroadcastExample
//
//  Created by Chris Ballinger on 1/7/16.
//  Copyright © 2016 Perch Innovations, Inc. All rights reserved.
//

#import "MockAPIClient.h"
#import "PerchStream.h"

@implementation MockAPIClient

- (void) startNewStream:(void (^)(id <BroadcastStream> newStream, NSError *error))endpointCallback {
    NSParameterAssert(endpointCallback != nil);
    NSString * json =
    @"{\
    \"stream\" : {\
    \"id\" : \"stream_id\",\
    \"name\" : \"some_name\",\
    \"start_date\" : \"2015-10-22 15:27:40\"\
    },\
    \"endpoint\": {\
    \"S3\": {\
    \"aws_access_key_id\": \"key\",\
    \"aws_secret_access_key\": \"secret\",\
    \"aws_session_token\": \"token\",\
    \"aws_expiration\": 3600.0,\
    \"aws_bucket_name\": \"bucket\",\
    \"aws_bucket_path\": \"path\",\
    \"aws_region\": \"us-west-1\"\
    }\
    }\
    }";
    NSError *error = nil;
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding]  options:0 error:&error];
    PerchStream *stream = [MTLJSONAdapter modelOfClass:PerchStream.class fromJSONDictionary:jsonDict error:&error];
    endpointCallback(stream, error);
}

/**
 *  Marks the stream as stopped on the server
 *
 *  @param stream        stream to be stopped
 *  @param callbackBlock (optional) whether or not this was successful
 */
- (void) stopStream:(id <BroadcastStream>)stream callbackBlock:(void (^)(BOOL success, NSError *error))callbackBlock {
    if (callbackBlock) {
        callbackBlock(YES, nil);
    }
}


@end
