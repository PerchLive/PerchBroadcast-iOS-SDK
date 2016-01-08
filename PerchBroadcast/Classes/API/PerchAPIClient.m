//
//  PerchAPIClient.m
//  Pods
//
//  Created by Chris Ballinger on 1/5/16.
//
//

#import "PerchAPIClient.h"
#import "PerchStream.h"

@implementation PerchAPIClient

- (NSError *) errorWithCode:(int)code description:(NSString*)description {
    NSParameterAssert(description != nil);
    return [NSError errorWithDomain:@"com.perchlive.Perch" code:code userInfo:@{NSLocalizedDescriptionKey: description}];
}

// e.g. Authorization: Token 9944b09199c62bcf9418ad846dd0e4bbdfc6ee4b
- (void) setApiToken:(NSString *)apiToken {
    _apiToken = apiToken;
    [self.requestSerializer setValue:[NSString stringWithFormat:@"Token %@", apiToken] forHTTPHeaderField:@"Authorization"];
}

- (void) fetchAPITokenWithEmail:(NSString*)email
                   password:(NSString*)password
              callbackBlock:(void (^)(NSString *apiToken, NSError *error))callbackBlock {
    [self POST:@"authenticate"
    parameters:@{@"email": email,
                 @"password": password}
       success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
           if ([responseObject isKindOfClass:[NSDictionary class]]) {
               NSDictionary *responseDict = responseObject;
               NSString *token = responseDict[@"token"];
               self.apiToken = token;
               callbackBlock(token, nil);
           } else {
               callbackBlock(nil, [self errorWithCode:1 description:@"No token"]);
           }
       }
       failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
           callbackBlock(nil, error);
    }];
}

/**
 *  Requests new API token associated with a user.
 *
 *  @param email User's email address
 *  @param password User's password
 *  @param callbackBlock called when the request completes with either an active user token or an error
 */
- (void) loginUserWithEmail:(NSString*)email
                   password:(NSString*)password
              callbackBlock:(void (^)(NSString *apiToken, NSError *error))callbackBlock {
    [self POST:@"user/login"
    parameters:@{@"email": email,
                 @"password": password}
       success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
           [self fetchAPITokenWithEmail:email password:password callbackBlock:callbackBlock];
       }
       failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
           callbackBlock(nil, error);
       }];
}
/**
 *  Requests new user from Perch server.
 *
 *  @param email User's email address
 *  @param password User's password
 *  @param callbackBlock called when the request completes with either an active user token or an error
 */
- (void) createUserWithEmail:(NSString*)email
                    password:(NSString*)password
               callbackBlock:(void (^)(NSString *apiToken, NSError *error))callbackBlock {
    [self POST:@"user/signup"
    parameters:@{@"email": email,
                 @"password": password}
       success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
           [self fetchAPITokenWithEmail:email password:password callbackBlock:callbackBlock];
       }
       failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
           callbackBlock(nil, error);
       }];
}


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
    NSParameterAssert(endpointCallback != nil);
    [self POST:@"stream/start" parameters:@{@"type": @"hls"} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSError *error = nil;
        PerchStream *stream = [MTLJSONAdapter modelOfClass:PerchStream.class fromJSONDictionary:responseObject error:&error];
        endpointCallback(stream, error);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        endpointCallback(nil, error);
    }];
}

/**
 *  Marks the stream as stopped on the server
 *
 *  @param stream        stream to be stopped
 *  @param callbackBlock (optional) whether or not this was successful
 */
- (void) stopStream:(id <BroadcastStream>)stream callbackBlock:(void (^)(BOOL success, NSError *error))callbackBlock {
    [self POST:@"stream/stop" parameters:@{@"id": stream.streamID} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSError *error = nil;
        PerchStream *stream = [MTLJSONAdapter modelOfClass:PerchStream.class fromJSONDictionary:responseObject error:&error];
        if (callbackBlock) {
            callbackBlock(stream, error);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (callbackBlock) {
            callbackBlock(nil, error);
        }
    }];
}

@end
