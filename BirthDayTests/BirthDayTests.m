//
//  BirthDayTests.m
//  BirthDayTests
//
//  Created by Phuoc on 11/21/13.
//  Copyright (c) 2013 Phuoc. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "ShopCardViewController.h"


@interface BirthDayTests : XCTestCase

@property (nonatomic, strong) ShopCardViewController *shopCardVC;

@end

@implementation BirthDayTests

- (void)setUp
{
    [super setUp];
    _shopCardVC = [[ShopCardViewController alloc]init];
}

- (void)tearDown
{
    _shopCardVC = nil;
    
    [super tearDown];
}

-(void)testExample
{
    XCTAssertEqual(1, 1, @"Equal");
}

- (void)testTitleShopCardVC
{
    XCTAssertNotNil(_shopCardVC, @"Not nil");
}

@end
