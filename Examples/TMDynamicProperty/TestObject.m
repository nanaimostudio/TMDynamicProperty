//
//  TestObject.m
//  TMDynamicProperty
//
//  Created by Zitao Xiong on 1/31/15.
//  Copyright (c) 2015 Zitao Xiong. All rights reserved.
//

#import "TestObject.h"

@implementation TestObject
@dynamic testString;
@dynamic testInt;
@dynamic testDouble;
@dynamic testLongLong;
@dynamic testFloat;
@dynamic testBool;

+ (void)load {
    [self generateAccessorMethods];
}
@end
