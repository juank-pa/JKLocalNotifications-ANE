//
//  NSArray+HigherOrderTest.m
//  LocalNotificationLib
//
//  Created by Juan Carlos Pazmino on 11/28/17.
//
//

#import <XCTest/XCTest.h>
#import "NSArray+HigherOrder.h"

@interface NSArray_HigherOrderTest : XCTestCase
@property (nonatomic, strong) NSArray *subject;
@end

@implementation NSArray_HigherOrderTest

- (void)setUp {
    [super setUp];
    self.subject = [NSArray arrayWithObjects:@"Hello", @"World!", @"JK", nil];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testMap {
    NSArray *res = [self.subject map:^NSNumber *(NSString *item) {
        return @(item.length);
    }];
    XCTAssertEqual(res.count, 3);
    XCTAssertEqualObjects(res[0], @(5));
    XCTAssertEqualObjects(res[1], @(6));
    XCTAssertEqualObjects(res[2], @(2));
}

@end
