//
//  BroadcastAPIClient.h
//  Pods
//
//  Created by Chris Ballinger on 1/5/16.
//
//

#import <Foundation/Foundation.h>
#import "KFStream.h"

@protocol BroadcastAPIClient <NSObject>

@required

///-------------------------------
/// @name Stream Lifecycle
///-------------------------------

/**
 *  Starts a new public stream to be fed to KFRecorder
 *
 *  @param endpointCallback Called when request completes for new stream or error
 */
- (void) startNewStream:(void (^)(id <KFStream> newStream, NSError *error))endpointCallback;

/**
 *  Marks the stream as stopped on the server
 *
 *  @param stream        stream to be stopped
 *  @param callbackBlock (optional) whether or not this was successful
 */
- (void) stopStream:(id <KFStream>)stream callbackBlock:(void (^)(BOOL success, NSError *error))callbackBlock;

@optional

/**
 *  Posts to /api/stream/change the changes in your KFStream. This will return a new
 *  stream object, leaving the original object unchanged.
 *
 *  @param stream        stream to be updated
 *  @param callbackBlock (optional) serialized KFStream response or error
 */
- (void) updateMetadataForStream:(id <KFStream>)stream callbackBlock:(void (^)(id <KFStream> updatedStream, NSError *error))callbackBlock;

@end
