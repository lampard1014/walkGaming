//
//  CHDXCitySystemConfigurationService.m
//  ECoupon
//
//  Created by 余妙玉 on 16/6/17.
//  Copyright © 2016年 Xkeshi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CHDXCitySystemConfigurationService.h"
#import "CHDXCityNetworkingService.h"
#import "CHDXCityCoreDataService.h"



NSString * const kCHDXCitySystemConfigurationService_DeviceNumber = @"kDeviceNumber";
NSString * const kCHDXCitySystemConfigurationService_ShopId = @"kShopId";

static CHDXCitySystemConfigurationService *shareInstance;

@implementation CHDXCitySystemConfigurationService

+ (instancetype(^)(void))shareInstanceWithConfig:(CHDXCityBaseServiceConfigurationObject *)config;
{
    static dispatch_once_t predicate;
    
    return ^CHDXCitySystemConfigurationService *{
        
        if (!shareInstance) {
            dispatch_once(&predicate, ^{
                shareInstance = [[self alloc]init];
                [shareInstance basicInitWithConfiguration:config];
                
            });
            
        }
        return shareInstance;
    };
}


-(void)basicInitWithConfiguration:(CHDXCityBaseServiceConfigurationObject *)configuration;
{
    
    NSDictionary *info = [[NSBundle mainBundle] infoDictionary];
    self.appName = [info objectForKey:@"CFBundleName"];
    self.appVersion = [info objectForKey:@"CFBundleShortVersionString"];
    self.appBuild = [info objectForKey:@"CFBundleVersion"];
    
    UIDevice *device = [UIDevice currentDevice];
    self.deviceName = device.name;
    self.deviceModel = device.model;
    self.deviceSystemName = device.systemName;
    self.deviceSystemVersion = device.systemVersion;
}

-(NSDictionary *)serverDiscription;
{
    return @{

             kCHDXCitySystemConfigurationService_DeviceNumber:@{
                     @"code":@((int)[kCHDXCitySystemConfigurationService_DeviceNumber UTF8String]),
                     NSLocalizedDescriptionKey:@"设备号",
                     NSLocalizedFailureReasonErrorKey:@"设备号为空",
                     },
            kCHDXCitySystemConfigurationService_ShopId:@{
                     @"code":@((int)[kCHDXCitySystemConfigurationService_ShopId UTF8String]),
                     NSLocalizedDescriptionKey:@"shopId",
                     NSLocalizedFailureReasonErrorKey:@"shopId为空,请先绑定",
                     }
             };
}


@end
