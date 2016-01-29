//
//  KFHLSManifestGenerator.h
//  Kickflip
//
//  Created by Christopher Ballinger on 10/1/13.
//  Copyright (c) 2013 OpenWatch, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, KFHLSManifestPlaylistType) {
    KFHLSManifestPlaylistTypeLive = 0,
    KFHLSManifestPlaylistTypeVOD,
    KFHLSManifestPlaylistTypeEvent
};

@interface KFHLSManifestGenerator : NSObject

@property (nonatomic) NSUInteger targetDuration;
@property (nonatomic) NSInteger mediaSequence;
@property (nonatomic) NSUInteger version;
@property (nonatomic) KFHLSManifestPlaylistType playlistType;
@property (nonatomic) CGSize videoSize;

- (id) initWithTargetDuration:(float)targetDuration playlistType:(KFHLSManifestPlaylistType)playlistType videoSize:(CGSize)videoSize;

- (void) appendFileName:(NSString *)fileName duration:(float)duration mediaSequence:(NSUInteger)mediaSequence;
- (void) appendFromLiveManifest:(NSString*)liveManifest;

- (void) finalizeManifest;

- (NSString *) masterString;
- (NSString *) manifestString;

@end
