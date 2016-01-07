//
//  NSBundle+Perch.m
//  Pods
//
//  Created by Chris Ballinger on 1/7/16.
//
//

#import "NSBundle+Perch.h"

@implementation NSBundle (Perch)

+ (NSBundle*) perchBundle {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"PerchBroadcast" ofType:@"bundle"];
    NSAssert(path != nil, @"perch bundle not found");
    return [NSBundle bundleWithPath:path];
}

@end
