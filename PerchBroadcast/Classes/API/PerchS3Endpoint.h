//
//  PerchS3Endpoint.h
//  Pods
//
//  Created by Chris Ballinger on 1/6/16.
//
//

#import <Mantle/Mantle.h>
#import "BroadcastS3Endpoint.h"

@interface PerchS3Endpoint : MTLModel <BroadcastS3Endpoint, MTLJSONSerializing>

@end
