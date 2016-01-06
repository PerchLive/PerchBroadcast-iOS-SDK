//
//  KFHLSMonitor.m
//  FFmpegEncoder
//
//  Created by Christopher Ballinger on 1/16/14.
//  Copyright (c) 2014 Christopher Ballinger. All rights reserved.
//

#import "KFHLSMonitor.h"
#import "KFHLSUploader.h"
#import "KFLog.h"

@interface KFHLSMonitor()
@property (nonatomic, strong) NSMutableDictionary *hlsUploaders;
@property (nonatomic) dispatch_queue_t monitorQueue;
@property (nonatomic, strong) id<BroadcastAPIClient> apiClient;
@end

static KFHLSMonitor *_sharedMonitor = nil;

@implementation KFHLSMonitor

- (id) initWithAPIClient:(id<BroadcastAPIClient>)apiClient {
    if (self = [super init]) {
        _apiClient = apiClient;
        self.hlsUploaders = [NSMutableDictionary dictionary];
        self.monitorQueue = dispatch_queue_create("KFHLSMonitor Queue", DISPATCH_QUEUE_SERIAL);
    }
    return self;
}

- (void) startMonitoringFolderPath:(NSString *)path endpoint:(KFS3Stream *)endpoint delegate:(id<KFHLSUploaderDelegate>)delegate {
    dispatch_async(self.monitorQueue, ^{
        KFHLSUploader *hlsUploader = [[KFHLSUploader alloc] initWithDirectoryPath:path stream:endpoint apiClient:self.apiClient];
        hlsUploader.delegate = delegate;
        [self.hlsUploaders setObject:hlsUploader forKey:path];
    });
}

- (void) finishUploadingContentsAtFolderPath:(NSString*)path endpoint:(KFS3Stream*)endpoint {
    dispatch_async(self.monitorQueue, ^{
        KFHLSUploader *hlsUploader = [self.hlsUploaders objectForKey:path];
        if (!hlsUploader) {
            hlsUploader = [[KFHLSUploader alloc] initWithDirectoryPath:path stream:endpoint apiClient:self.apiClient];
            [self.hlsUploaders setObject:hlsUploader forKey:path];
        }
        hlsUploader.delegate = self;
        [hlsUploader finishedRecording];
    });
}

- (void) uploader:(KFHLSUploader *)uploader didUploadSegmentAtURL:(NSURL *)segmentURL uploadSpeed:(double)uploadSpeed numberOfQueuedSegments:(NSUInteger)numberOfQueuedSegments {
    DDLogInfo(@"[Background monitor] Uploaded segment %@ @ %f KB/s, numberOfQueuedSegments %d", segmentURL, uploadSpeed, numberOfQueuedSegments);
}

- (void) uploaderHasFinished:(KFHLSUploader*)uploader {
    DDLogInfo(@"Uploader finished, switched to VOD manifest");
    dispatch_async(self.monitorQueue, ^{
        [self.hlsUploaders removeObjectForKey:uploader.directoryPath];
    });
}

@end
