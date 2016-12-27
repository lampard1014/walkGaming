//
//  CHDXCityBaseServiceConfigurationObject.h
//  ECoupon
//
//  Created by 余妙玉 on 16/6/1.
//  Copyright © 2016年 Xkeshi. All rights reserved.
//

#import "CHDXCityBaseObject.h"

#ifndef kCHDXCityBaseServiceCanRecoveryError
#define kCHDXCityBaseServiceCanRecoveryError @"kCHDXCityBaseServiceCanRecoveryError"
#endif


typedef NS_ENUM(NSUInteger, CHDXCityServiceErrorLevel) {
    CHDXCityServiceErrorLevel_Interception    =   0,
    CHDXCityServiceErrorLevel_Assert  =   1,
    CHDXCityServiceErrorLevel_FaildBlock  =   2,
    CHDXCityServiceErrorLevel_LogLocalFile = 3,
    CHDXCityServiceErrorLevel_LogRemoteServer =   4,
    CHDXCityServiceErrorLevel_Default = CHDXCityServiceErrorLevel_Interception,

};

@interface CHDXCityBaseServiceConfigurationObject : CHDXCityBaseObject


/**
 *  @author Lampard Hong, 16-01-07 20:01:39
 *
 *  @brief  当前的ERROR service Error
 *
 *  @since 1.0
 */
@property(nonatomic, strong)NSError *serviceError;


/**
 *  @author yomyoutama, 16-06-06 14:06:31
 *
 *  @brief  日志级别
 */
@property(nonatomic, assign, getter=fetchErrorLevel)CHDXCityServiceErrorLevel errorLevel;

@end
