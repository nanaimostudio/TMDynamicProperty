//
//  TestObject.h
//  TMDynamicProperty
//
//  Created by Zitao Xiong on 1/31/15.
//  Copyright (c) 2015 Zitao Xiong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+TMDynamicProperty.h"

@interface TestObject : NSObject
@property (nonatomic, strong) NSString *testString;
@property (nonatomic, assign) float testFloat;
@property (nonatomic, assign) int testInt;
@property (nonatomic, assign) double testDouble;
@property (nonatomic, assign) long long testLongLong;
@property (nonatomic, assign) bool testBool;
@end
