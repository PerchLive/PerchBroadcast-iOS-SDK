//
//  PerchEndpoint.h
//  Pods
//
//  Created by Chris Ballinger on 1/6/16.
//
//

#import <Mantle/Mantle.h>
#import "BroadcastEndpoint.h"

@interface PerchEndpoint : MTLModel <BroadcastEndpoint, MTLJSONSerializing>

@end
