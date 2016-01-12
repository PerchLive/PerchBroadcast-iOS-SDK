//
//  PerchStream.h
//  Pods
//
//  Created by Chris Ballinger on 1/6/16.
//
//

#import <Mantle/Mantle.h>
#import "BroadcastStream.h"

@interface PerchStream : MTLModel <BroadcastStream, MTLJSONSerializing>

@end
