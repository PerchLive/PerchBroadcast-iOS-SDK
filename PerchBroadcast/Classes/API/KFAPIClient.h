//
//  KFAPIClient.h
//  Kickflip
//
//  Created by Christopher Ballinger on 1/16/14.
//  Copyright (c) 2014 Christopher Ballinger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KFStream.h"
#import "AFNetworking.h"
#import <CoreLocation/CoreLocation.h>
#import "KFPaginationInfo.h"
#import "KFUser.h"
#import "BroadcastAPIClient.h"


/**
 *  Use KFAPIClient to interact with the kickflip.io API.
 */

@protocol KFAPIClient <BroadcastAPIClient>

@optional

///-------------------------------
/// @name Users
///-------------------------------

/**
 *  Logs in an existing user. This fetches the credentials required for streaming
 *  and makes it the current active KFUser.
 *
 *  @param username Existing Kickflip username
 *  @param password User's password
 *  @param callbackBlock called when the request completes with either an active user or an error
 */
- (void) loginExistingUserWithUsername:(NSString*)username password:(NSString*)password callbackBlock:(void (^)(id<KFUser> activeUser, NSError *error))callbackBlock;

/**
 *  Requests new active KFUser.
 *
 *  @param username      (optional) desired username
 *  @param callbackBlock called when the request completes with either an active user or an error
 */
- (void) requestNewActiveUserWithUsername:(NSString*)username callbackBlock:(void (^)(id<KFUser> activeUser, NSError *error))callbackBlock;

/**
 *  Requests new active KFUser.
 *
 *  @param username      (optional) desired username
 *  @param password User's password
 *  @param email User's email address
 *  @param displayName Name shown instead of username
 *  @param extraInfo Any additional context-specific information you'd like to store for your user.
 *  @param callbackBlock called when the request completes with either an active user or an error
 */
- (void) requestNewActiveUserWithUsername:(NSString*)username password:(NSString*)password email:(NSString*)email  displayName:(NSString*)displayName extraInfo:(NSDictionary*)extraInfo callbackBlock:(void (^)(id<KFUser> activeUser, NSError *error))callbackBlock;



/**
 *  Updates existing user metadata.
 *
 *  @param email User's email address
 *  @param newPassword (optional) For changing the user's current password
 *  @param displayName Name shown instead of username
 *  @param extraInfo Any additional context-specific information you'd like to store for your user.
 *  @param callbackBlock called when the request completes with either an active user or an error
 */
- (void) updateMetadataForActiveUserWithNewPassword:(NSString*)newPassword email:(NSString*)email displayName:(NSString*)displayName extraInfo:(NSDictionary*)extraInfo callbackBlock:(void (^)(id<KFUser> updatedUser, NSError *error))callbackBlock;

/**
 *  Fetches public data for an existing username.
 *
 *  @param username Existing user's username
 *  @param callbackBlock Serialized existing user or error
 *
 */
- (void) requestUserInfoForUsername:(NSString*)username callbackBlock:(void (^)(id<KFUser> existingUser, NSError *error))callbackBlock;

///-------------------------------
/// @name Stream Lifecycle
///-------------------------------

/**
 *  Starts a new private stream to be fed to KFRecorder
 *
 *  @param endpointCallback Called when request completes for new stream or error
 */
- (void) startNewPrivateStream:(void (^)(id <KFStream> newStream, NSError *error))endpointCallback;


///-------------------------------
/// @name Stream Search
///-------------------------------

/**
 *  Requests all streams created by a particular user
 *
 *  @param username      username to filter by
 *  @param pageNumber    desired page offset for paginating results. The first page starts at 1, not 0.
 *  @param itemsPerPage  desired number of items per page (max 200), default 25.
 *  @param callbackBlock Returns array of KFStream and a KFPaginationInfo for pagination information, or an error.
 *  @see KFPaginationInfo
 */
- (void) requestStreamsForUsername:(NSString*)username pageNumber:(NSUInteger)pageNumber itemsPerPage:(NSUInteger)itemsPerPage callbackBlock:(void (^)(NSArray *streams, id<KFPaginationInfo> paginationInfo, NSError *error))callbackBlock;

/**
 *  Returns all the streams created near a certain location
 *
 *  @param location      Center point of search
 *  @param radius        (optional)
 *  @param pageNumber    desired page offset for paginating results. The first page starts at 1, not 0.
 *  @param itemsPerPage  desired number of items per page (max 200), default 25.
 *  @param callbackBlock Returns array of KFStream and a KFPaginationInfo for pagination information, or an error.
 *  @see KFPaginationInfo
 */
- (void) requestStreamsForLocation:(CLLocation*)location radius:(CLLocationDistance)radius pageNumber:(NSUInteger)pageNumber itemsPerPage:(NSUInteger)itemsPerPage callbackBlock:(void (^)(NSArray *streams, id<KFPaginationInfo> paginationInfo, NSError *error))callbackBlock;

/**
 *  Returns all the streams with metadata containing keyword
 *
 *  @param keyword (Optional) If this parameter is omitted it will return all streams
 *  @param pageNumber    desired page offset for paginating results. The first page starts at 1, not 0.
 *  @param itemsPerPage  desired number of items per page (max 200), default 25.
 *  @param callbackBlock Returns array of KFStream and a KFPaginationInfo for pagination information, or an error.
 *  @see KFPaginationInfo
 */
- (void) requestStreamsByKeyword:(NSString*)keyword pageNumber:(NSUInteger)pageNumber itemsPerPage:(NSUInteger)itemsPerPage callbackBlock:(void (^)(NSArray *streams, id<KFPaginationInfo> paginationInfo, NSError *error))callbackBlock;

/**
 *  Returns all the streams associated with this application.
 *
 *  @param pageNumber    desired page offset for paginating results. The first page starts at 1, not 0.
 *  @param itemsPerPage  desired number of items per page (max 200), default 25.
 *  @param callbackBlock Returns array of KFStream and a KFPaginationInfo for pagination information, or an error.
 *  @see KFPaginationInfo
 */
- (void) requestAllStreamsWithPageNumber:(NSUInteger)pageNumber itemsPerPage:(NSUInteger)itemsPerPage callbackBlock:(void (^)(NSArray *streams, id<KFPaginationInfo> *paginationInfo, NSError *error))callbackBlock;

@end

@interface KFAPIClient : AFHTTPSessionManager <KFAPIClient>

@property (nonatomic, strong, readonly) NSString *apiKey;
@property (nonatomic, strong, readonly) NSString *apiSecret;

- (instancetype) initWithAPIKey:(NSString*)apiKey apiSecret:(NSString*)apiSecret;

@end
