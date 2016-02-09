//
//  KFHLSManifestGenerator.m
//  Kickflip
//
//  Created by Christopher Ballinger on 10/1/13.
//  Copyright (c) 2013 OpenWatch, Inc. All rights reserved.
//

#import "KFHLSManifestGenerator.h"
#import "KFLog.h"

@interface KFHLSManifestGenerator()
@property (nonatomic, strong) NSMutableDictionary *segments;
@property (nonatomic) BOOL finished;
@end

@implementation KFHLSManifestGenerator

- (NSMutableString*) headerWithMediaSequence:(NSUInteger)mediaSequence {
    NSMutableString *header = [NSMutableString stringWithFormat:@"#EXTM3U\n#EXT-X-VERSION:%lu\n#EXT-X-TARGETDURATION:%d\n", (unsigned long)self.version, (int)self.targetDuration];
    NSString *type = nil;
    if (self.playlistType == KFHLSManifestPlaylistTypeVOD) {
        type = @"VOD";
    } else if (self.playlistType == KFHLSManifestPlaylistTypeEvent) {
        type = @"EVENT";
    }
    if (type) {
        [header appendFormat:@"#EXT-X-PLAYLIST-TYPE:%@\n", type];
    }
    [header appendFormat:@"#EXT-X-MEDIA-SEQUENCE:%ld\n", (long)mediaSequence];
    return header;
}

- (NSString*) footer {
    return @"#EXT-X-ENDLIST\n";
}

- (id) initWithTargetDuration:(float)targetDuration playlistType:(KFHLSManifestPlaylistType)playlistType videoSize:(CGSize)videoSize {
    if (self = [super init]) {
        self.targetDuration = targetDuration;
        self.playlistType = playlistType;
        self.version = 3;
        self.mediaSequence = -1;
        self.segments = [NSMutableDictionary new];
        self.finished = NO;
        self.videoSize = videoSize;
    }
    return self;
}

- (void) appendFileName:(NSString *)fileName duration:(float)duration mediaSequence:(NSUInteger)mediaSequence {
    if (mediaSequence > self.mediaSequence) {
        self.mediaSequence = mediaSequence;
    }
    
    if (duration > self.targetDuration) {
        self.targetDuration = (int)ceilf(duration);
    }
    
    if ([self.segments objectForKey:[NSNumber numberWithInteger:mediaSequence]] == nil) {
        DDLogDebug(@"%@", [NSString stringWithFormat:@"Writing to manifest... #EXTINF:%g %@", duration, fileName]);
        [self.segments setObject:[NSString stringWithFormat:@"#EXTINF:%g,\n%@\n", duration, fileName] forKey:[NSNumber numberWithInteger:mediaSequence]];
    }
}

- (void) finalizeManifest {
    self.finished = YES;
    self.mediaSequence = 0;
}

- (NSString*) stripToNumbers:(NSString*)string {
    NSMutableCharacterSet *set = [NSMutableCharacterSet decimalDigitCharacterSet];
    [set addCharactersInString:@"."];
    NSCharacterSet *invertedSet = [set invertedSet];
    
    return [[string componentsSeparatedByCharactersInSet:
             invertedSet]
            componentsJoinedByString:@""];
}

- (void) appendFromLiveManifest:(NSString *)liveManifest {
    NSArray *rawLines = [liveManifest componentsSeparatedByString:@"\n"];
    
    NSUInteger index = 0;
    for (NSString *line in rawLines) {
        if ([line rangeOfString:@"#EXTINF:"].location != NSNotFound) {
            NSString *extInf = line;
            NSString *extInfNumberString = [self stripToNumbers:extInf];
            NSString *segmentName = rawLines[index+1];
            NSString *segmentNumberString = [self stripToNumbers:segmentName];
            float duration = [extInfNumberString floatValue];
            NSInteger sequence = [segmentNumberString integerValue];
            [self appendFileName:segmentName duration:duration mediaSequence:sequence];
        }
        index++;
    }
}


- (NSString *) masterString {
    int videoWidth;
    int videoHeight;
    
    if (UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation)) {
        videoWidth = self.videoSize.height;
        videoHeight = self.videoSize.width;
    } else {
        videoWidth = self.videoSize.width;
        videoHeight = self.videoSize.height;
    }
    
    return [NSString stringWithFormat:@"#EXTM3U\n#EXT-X-STREAM-INF:BANDWIDTH=556000,CODECS=\"avc1.77.21,mp4a.40.2\",RESOLUTION=%dx%d\n%@.m3u8",
                videoWidth,
                videoHeight,
                (self.finished ? @"vod" : @"index")];
}

- (NSString*) manifestString {
    return [self manifestStringAtMediaSequence:self.mediaSequence];
}

- (NSString *) manifestStringAtMediaSequence:(NSUInteger)mediaSequence {
    NSMutableString *manifest = [self headerWithMediaSequence:mediaSequence];
    
    NSArray *sortedKeys = [[self.segments allKeys] sortedArrayUsingSelector:@selector(compare:)];
    for (NSNumber *key in sortedKeys) {
        [manifest appendString:[self.segments objectForKey:key]];
    }
    
    [manifest appendString:[self footer]];
    
    DDLogVerbose(@"Latest manifest:\n%@", manifest);
    
    return manifest;
}

@end
