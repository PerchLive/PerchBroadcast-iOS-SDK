//
//  PerchAPIClientTests.m
//  PerchBroadcastExample
//
//  Created by Chris Ballinger on 1/5/16.
//  Copyright © 2016 Perch Innovations, Inc. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "PerchAPIClient.h"
#import "PerchStream.h"
#import "URLMock.h"

@interface PerchAPIClientTests : XCTestCase
@property (nonatomic, strong) XCTestExpectation *expectation;
@end

@implementation PerchAPIClientTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    [UMKMockURLProtocol enable];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    [UMKMockURLProtocol disable];
}

- (void)testJSONSerialization {
    NSString * json =
    @"{\
    \"stream\" : {\
    \"id\" : \"stream_id\",\
    \"name\" : \"some_name\",\
    \"start_date\" : \"2015-10-22 15:27:40\"\
    },\
    \"endpoint\": {\
    \"S3\": {\
    \"aws_access_key_id\": \"key\",\
    \"aws_secret_access_key\": \"secret\",\
    \"aws_session_token\": \"token\",\
    \"aws_expiration\": 3600.0,\
    \"aws_bucket_name\": \"bucket\",\
    \"aws_bucket_path\": \"path\",\
    \"aws_region\": \"us-west-1\"\
    }\
    }\
    }";
    NSError *error = nil;
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding]  options:0 error:&error];
    XCTAssertNil(error);
    PerchStream *stream = [MTLJSONAdapter modelOfClass:PerchStream.class fromJSONDictionary:jsonDict error:&error];
    XCTAssertNil(error);
    XCTAssertNotNil(stream);
    XCTAssertNotNil(stream.endpoint);
}

- (void) testNewStreamAPI {
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    configuration.protocolClasses = @[ [UMKMockURLProtocol class] ];
    NSURL *baseURL = [NSURL URLWithString:@"https://perchlive.com/api/v1/"];
    PerchAPIClient *apiClient = [[PerchAPIClient alloc] initWithBaseURL:baseURL sessionConfiguration:configuration];
    apiClient.requestSerializer = [AFJSONRequestSerializer serializer];
    // The request is a POST with some JSON data
    NSURL *URL = [baseURL URLByAppendingPathComponent:@"stream/start"];
    NSString * json =
    @"{\
    \"stream\" : {\
    \"id\" : \"stream_id\",\
    \"name\" : \"some_name\",\
    \"start_date\" : \"2015-10-22 15:27:40\"\
    },\
    \"endpoint\": {\
    \"S3\": {\
    \"aws_access_key_id\": \"key\",\
    \"aws_secret_access_key\": \"secret\",\
    \"aws_session_token\": \"token\",\
    \"aws_expiration\": 3600.0,\
    \"aws_bucket_name\": \"bucket\",\
    \"aws_bucket_path\": \"path\",\
    \"aws_region\": \"us-west-1\"\
    }\
    }\
    }";
    NSError *error = nil;
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding]  options:0 error:&error];
    XCTAssertNil(error);
    
    [UMKMockURLProtocol expectMockHTTPPostRequestWithURL:URL requestJSON:@{@"type": @"hls"} responseStatusCode:200 responseJSON:jsonDict];
    
    self.expectation = [self expectationWithDescription:@"new stream"];

    [apiClient startNewStream:^(id<BroadcastStream> newStream, NSError *error) {
        XCTAssertNil(error);
        XCTAssertNotNil(newStream);
        XCTAssertNotNil(newStream.endpoint);
        if (newStream) {
            [self.expectation fulfill];
        }
    }];
    
    
    [self waitForExpectationsWithTimeout:10 handler:^(NSError * _Nullable error) {
        XCTAssertNil(error);
    }];
}

@end
