//
//  XMSystemConfigurationService.h
//  ECoupon
//
//  Created by 余妙玉 on 16/6/17.
//  Copyright © 2016年 Xkeshi. All rights reserved.
//

#import "XMBaseService.h"
@class XMPaymentModeResponseResult;

@interface XMSystemConfigurationService : XMBaseService


@property (nonatomic, strong) NSString *appName;/**< app名称 */

@property (nonatomic, strong) NSString *appVersion;/**< 版本号 */

@property (nonatomic, strong) NSString *appBuild;/**< build号 */

//device
@property (nonatomic, strong) NSString *deviceName;/**< 设备名, e.g. "My iPhone" */

@property (nonatomic, strong) NSString *deviceModel;/**< 设备类型, e.g. @"iPhone", @"iPod touch" */

@property (nonatomic, strong) NSString *deviceSystemName;/**< 设备系统名称, e.g. @"iOS" */

@property (nonatomic, strong) NSString *deviceSystemVersion;/**< 设备系统版本, e.g. @"4.0" */


@property (nonatomic, strong)XMPaymentModeResponseResult *paymentModel;

- (void)fetchPaymentModeWithDeviceNumber:(NSString *)deviceNumber
                              withShopId:(NSNumber *)shopId
                                 success:(void (^)(NSURLSessionDataTask *task, XMCommonResponse *response))success
                                 failure:(void (^)(NSURLSessionDataTask *task, NSError *error, XMCommonResponse *response))failure;


@end
