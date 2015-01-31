//
//  ViewController.m
//  TMDynamicProperty
//
//  Created by Zitao Xiong on 1/31/15.
//  Copyright (c) 2015 Zitao Xiong. All rights reserved.
//

#import "ViewController.h"
#import "TestObject.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    TestObject *obj = [TestObject new];
    obj.testString = @"test";
    obj.testInt = 1234567;
    obj.testBool = YES;
    obj.testFloat = 123.321f;
    obj.testDouble = 123.1234567;
    obj.testLongLong = 987654321;
    NSLog(@"string: %@", obj.testString);
    NSLog(@"int: %@", @(obj.testInt));
    NSLog(@"bool: %@", @(obj.testBool));
    NSLog(@"float: %@", @(obj.testFloat));
    NSLog(@"double: %@", @(obj.testDouble));
    NSLog(@"long long: %@", @(obj.testLongLong));
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
