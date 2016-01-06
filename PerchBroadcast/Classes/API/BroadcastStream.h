//
//  BroadcastStream.h
//  Pods
//
//  Created by Chris Ballinger on 1/5/16.
//
//

#import <Foundation/Foundation.h>
#import "BroadcastEndpoint.h"

@protocol BroadcastStream <NSObject>

/**
 *  Stream UUID (unique identifier)
 */
@property (nonatomic, strong, readonly) NSString *streamID;

/**
 *  When recording was started
 */
@property (nonatomic, strong, readonly) NSDate *startDate;

/**
 *  Stream name
 */
@property (nonatomic, strong, readonly) NSString *name;

/**
 *  Stream endpoint
 */
@property (nonatomic, strong, readonly) id<BroadcastEndpoint> endpoint;

@end
