//
//  CHDXCityUserDefaultsService.m
//  ECoupon
//
//  Created by 余妙玉 on 16/6/13.
//  Copyright © 2016年 Xkeshi. All rights reserved.
//

#import "CHDXCityUserDefaultsService.h"

#ifndef kCHDXCityUserDefaultSearchResultArrayMaxCount
#define kCHDXCityUserDefaultSearchResultArrayMaxCount    20
#endif


@interface CHDXCityUserDefaultsService () {
    NSUserDefaults *userDefaults;
    int page;
    int pageSize;
}

@end

@implementation CHDXCityUserDefaultsService


static CHDXCityUserDefaultsService *shareInstance;

+ (instancetype(^)(void))shareInstanceWithConfig:(CHDXCityBaseServiceConfigurationObject *)config;
{
    static dispatch_once_t predicate;
    
    return ^CHDXCityUserDefaultsService *{
        
        if (!shareInstance) {
            dispatch_once(&predicate, ^{
                shareInstance = [[self alloc]init];
                [shareInstance basicInitWithConfiguration:config];
                
            });
            
        }
        return shareInstance;
    };
    
}

- (void)basicInitWithConfiguration:(CHDXCityBaseServiceConfigurationObject *)configuration;
{
    shareInstance->userDefaults = [NSUserDefaults standardUserDefaults];
    shareInstance->page = 1;
    shareInstance->pageSize = kCHDXCityUserDefaultSearchResultArrayMaxCount;
}


-(NSArray* (^)(NSString * key))fetchArrayByKey;
{
    __weak typeof (self) weakself = self;
    
    
    return ^NSArray *(NSString *key){
        __strong typeof(weakself)strongself = weakself;
        
        NSArray *defaultArray = [strongself->userDefaults arrayForKey:key];
        
        strongself->pageSize = strongself->pageSize ? : kCHDXCityUserDefaultSearchResultArrayMaxCount;
        
        NSUInteger start = (strongself->page - 1) * strongself->pageSize;
        if (start >= [defaultArray count]) {
            return weakself.fetchResult = @[];
        } else {
            NSUInteger length = [defaultArray count ] - start;
            length = MIN(strongself->pageSize, length);
            
            return weakself.fetchResult = [defaultArray subarrayWithRange:NSMakeRange(start, length)];
        }
    };
}



-(BOOL (^)(NSString * key))removeArrayByKey;
{
    __weak typeof (self) weakself = self;
    
    return ^BOOL (NSString *key){
        __strong typeof(weakself)strongself = weakself;
        
        [strongself->userDefaults removeObjectForKey:key];
        return [strongself->userDefaults synchronize];
        
    };
}


-(BOOL (^)(NSString * key, NSArray * resultArray))saveFetchArrayByKey;
{
    __weak typeof (self) weakself = self;
    
    return ^BOOL(NSString * key, NSArray * resultArray){
        __strong typeof(weakself)strongself = weakself;
        
        weakself.fetchResult = nil;
        weakself.fetchResult = [resultArray mutableCopy];
        [strongself->userDefaults setObject:weakself.fetchResult forKey:key];
        
        return [strongself->userDefaults synchronize];
    };
}

-(BOOL (^)(NSString * key, NSString *addKeyWord))addFetchArrayByKey;
{
    __weak typeof (self) weakself = self;
    
    return ^BOOL (NSString * key, NSString *addKeyWord){
        
        if (addKeyWord) {
            NSMutableArray *tmp = [NSMutableArray arrayWithArray:weakself.fetchArrayByKey(key)];
            
            __block NSUInteger index = [tmp count];
            [tmp enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj isEqualToString:addKeyWord]) {
                    index = idx;
                }
            }];
            
            if (index < [tmp count]) {
                [tmp removeObjectAtIndex:index];
            } else if((kCHDXCityUserDefaultSearchResultArrayMaxCount == [tmp count])){
                [tmp removeObjectAtIndex:[tmp count] - 1];
            }
            [tmp insertObject:addKeyWord atIndex:0];
            return weakself.saveFetchArrayByKey(key, tmp);
        }
        return NO;
    };
}

-(BOOL (^)(NSString *key))fetchBoolByKey;
{
    __weak typeof (self) weakself = self;
    
    
    return ^BOOL (NSString *key){
        __strong typeof(weakself)strongself = weakself;
        
        BOOL value = [strongself->userDefaults boolForKey:key];
        weakself.fetchResult = @(value);
        return value;
    };
}

-(BOOL (^)(NSString *key, BOOL value))saveBoolValueByKey;
{
    __weak typeof (self) weakself = self;
    
    return ^BOOL(NSString * key, BOOL value){
        __strong typeof(weakself)strongself = weakself;
        
        weakself.fetchResult = nil;
        weakself.fetchResult = @(value);
        [strongself->userDefaults setBool:value forKey:key];
        return [strongself->userDefaults synchronize];
    };
}

@end
