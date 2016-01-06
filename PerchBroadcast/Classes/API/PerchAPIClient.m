//
//  PerchAPIClient.m
//  Pods
//
//  Created by Chris Ballinger on 1/5/16.
//
//

#import "PerchAPIClient.h"

@implementation PerchAPIClient

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

/**
 *  Starts a new public stream to be fed to KFRecorder
 *
 *  @param endpointCallback Called when request completes for new stream or error
 
 
 
 */
- (void) startNewStream:(void (^)(id <BroadcastStream> newStream, NSError *error))endpointCallback {
    
}

/**
 *  Marks the stream as stopped on the server
 *
 *  @param stream        stream to be stopped
 *  @param callbackBlock (optional) whether or not this was successful
 */
- (void) stopStream:(id <BroadcastStream>)stream callbackBlock:(void (^)(BOOL success, NSError *error))callbackBlock {
    
}

@end
