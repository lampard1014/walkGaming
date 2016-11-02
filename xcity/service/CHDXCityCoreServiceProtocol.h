//
//  CHDXCityCoreServiceProtocol.h
//  xcity
//
//  Created by 余妙玉 on 16/11/1.
//  Copyright © 2016年 Lampard Hong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CHDXCityCoreServiceProtocol.h"
@protocol CHDXCityServiceConfigModelProtocol <NSObject>

@end

@protocol CHDXCityCoreServiceProtocol <NSObject>

/**
 *  @author Lampard Hong, 16-01-07 20:01:39
 *
 *  @brief  service error
 *
 *  @since 1.0
 */
@property(nonatomic, strong)NSError *serviceError;

/**
 *  @author Lampard Hong, 16-01-07 20:01:22
 *
 *  @brief  service config
 *
 *  @since 1.0
 */
@property(nonatomic, strong)id<CHDXCityServiceConfigModelProtocol> serviceConfig;

@required
/**
 *  @author Lampard Hong, 16-01-07 20:01:55
 *
 *  @brief  单例入口
 *
 *  @param config @class XCMServiceConfig
 *
 *  @since 1.0
 */
+ (instancetype(^)(void))shareInstanceWithConfig:(id<CHDXCityServiceConfigModelProtocol>)config;

/**
 *  @author yomyoutama, 16-09-21 11:09:30
 *
 *  @brief  初始化方法
 */
-(void)basicInit;

@optional
/**
 *  @author Lampard Hong, 16-01-18 14:01:29
 *
 *  @brief  重载配置
 *
 *  @since 1.0
 */
- (instancetype(^)(id<CHDXCityServiceConfigModelProtocol> config))reloadConfig;

@end
