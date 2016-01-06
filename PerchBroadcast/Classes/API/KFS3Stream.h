//
//  KFS3Stream.h
//  Kickflip
//
//  Created by Christopher Ballinger on 1/16/14.
//  Copyright (c) 2014 Christopher Ballinger. All rights reserved.
//

#import "KFStream.h"
#import <BroadcastS3Endpoint.h>

extern NSString * const KFS3StreamType;

@interface KFS3Stream : KFStream <BroadcastS3Endpoint>

@end
