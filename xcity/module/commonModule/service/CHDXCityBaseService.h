//
//  XCMBaseService.h
//  NewMDT
//
//  Created by 余妙玉 on 16/1/7.
//  Copyright © 2016年 Lampard Hong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CHDXCityCommonModuleHeader.h"


#import "CHDXCityBaseServiceConfigurationObject.h"

@class CHDXCityCommonResponse;


FOUNDATION_EXPORT NSString * const kCHDXCityBaseServiceErrorDomain;

@interface CHDXCityBaseService : NSObject

/**
 *  @author Lampard Hong, 16-01-07 20:01:22
 *
 *  @brief  service config
 *
 *  @since 1.0
 */
@property(nonatomic, strong)CHDXCityBaseServiceConfigurationObject *serviceConfiguration;

/**
 *  @author yomyoutama, 16-05-26 17:05:12
 *
 *  @brief  可以恢复的Error CODE集合
 */
@property(nonatomic, strong)NSMutableDictionary *serviceCanRecoveryErrorCode;

@property(nonatomic, strong)NSDictionary *serverDiscription;
/**
 *  @author Lampard Hong, 16-01-07 20:01:55
 *
 *  @brief  单例入口
 *
 *  @param config @class XCMServiceConfig
 *
 *  @since 1.0
 */
+ (instancetype(^)(void))shareInstanceWithConfig:(CHDXCityBaseServiceConfigurationObject *)config;
/**
 *  @author Lampard Hong, 16-01-18 14:01:29
 *
 *  @brief  重载配置
 *
 *  @since 1.0
 */
- (instancetype(^)(CHDXCityBaseServiceConfigurationObject *config))reloadConfig;

-(void)basicInitWithConfiguration:(CHDXCityBaseServiceConfigurationObject *)configuration;

-(NSError *)createServiceErrorWithDomain:(NSString *)domain
                           withErrorCode:(NSInteger)errorCode
                       withErrorUserInfo:(NSDictionary *)userInfo;

-(BOOL)vaildateNoEmptyParametersWithParamtersKey:(NSString *)parameterKey
                              withParameterVaule:(NSString *)parameterValue
                                      errorLevel:(CHDXCityServiceErrorLevel)errorLevel
                                     withFailure:(void (^)(NSURLSessionDataTask *task, NSError *error, CHDXCityCommonResponse *response))failure;




@end
