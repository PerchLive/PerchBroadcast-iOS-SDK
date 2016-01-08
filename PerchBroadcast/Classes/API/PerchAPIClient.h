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

/** Set an existing API token to authenticate as a user to the API. */
@property (nonatomic, strong) NSString *apiToken;

/**
 *  Requests new API token associated with a user.
 *
 *  @param email User's email address
 *  @param password User's password
 *  @param callbackBlock called when the request completes with either an active user token or an error
 */
- (void) loginUserWithEmail:(NSString*)email
                        password:(NSString*)password
                   callbackBlock:(void (^)(NSString *apiToken, NSError *error))callbackBlock;
/**
 *  Requests new user from Perch server.
 *
 *  @param email User's email address
 *  @param password User's password
 *  @param callbackBlock called when the request completes with either an active user token or an error
 */
- (void) createUserWithEmail:(NSString*)email
                    password:(NSString*)password
               callbackBlock:(void (^)(NSString *apiToken, NSError *error))callbackBlock;
@end
