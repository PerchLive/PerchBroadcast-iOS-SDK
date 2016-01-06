//
//  PerchEndpoint.m
//  Pods
//
//  Created by Chris Ballinger on 1/6/16.
//
//

#import "PerchEndpoint.h"
#import "PerchS3Endpoint.h"

@implementation PerchEndpoint

+ (NSDictionary*) JSONKeyPathsByPropertyKey {
    return @{};
}

+ (Class)classForParsingJSONDictionary:(NSDictionary *)JSONDictionary {
    if (JSONDictionary[@"S3"] != nil) {
        return PerchS3Endpoint.class;
    }
    
    NSAssert(NO, @"No matching class for the JSON dictionary '%@'.", JSONDictionary);
    return self;
}

@end
