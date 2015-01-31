//
//  TMDynamicPropertyTests.m
//  TMDynamicPropertyTests
//
//  Created by Zitao Xiong on 1/31/15.
//  Copyright (c) 2015 Zitao Xiong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "TestNormalObject.h"
#import "TestObject.h"

@interface TMDynamicPropertyTests : XCTestCase

@end

@implementation TMDynamicPropertyTests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testNormalObjectPerformance {
    [self measureBlock:^{
        for (int i = 0; i < 100000; i++) {
            TestNormalObject *obj = [[TestNormalObject alloc] init];
            obj.testString = @"test";
            obj.testString = @"test2";
//            obj.testInt = 1234567;
//            obj.testBool = YES;
//            obj.testFloat = 123.321f;
//            obj.testDouble = 123.1234567;
//            obj.testLongLong = 987654321;
        }
    }];
}

- (void)testDynamicObjectPerformance {
    [self measureBlock:^{
        for (int i = 0; i < 100000; i++) {
            TestObject *obj = [[TestObject alloc] init];
            obj.testString = @"test";
            obj.testString = @"test2";
//            obj.testInt = 1234567;
//            obj.testBool = YES;
//            obj.testFloat = 123.321f;
//            obj.testDouble = 123.1234567;
//            obj.testLongLong = 987654321;
        }
    }];
}
@end
