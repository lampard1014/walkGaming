//
//  CHDXCityHKService.h
//  xcity
//
//  Created by 余妙玉 on 16/11/1.
//  Copyright © 2016年 Lampard Hong. All rights reserved.
//



#import <Foundation/Foundation.h>
#import "CHDXCityCoreServiceProtocol.h"
#import <HealthKit/HealthKit.h>

#pragma mark -
#pragma mark service error

FOUNDATION_EXTERN NSString *__nonnull const CHDXCityHKServiceErrorDomain;
FOUNDATION_EXTERN NSString *__nonnull const CHDXCityHKServiceError_HEALTHKITNOTSUPPORT;
FOUNDATION_EXTERN NSString *__nonnull const CHDXCityHKServiceError_DESC;


@interface CHDXCityHKService : NSObject<CHDXCityCoreServiceProtocol>

- (BOOL)checkHKServiceEnable;

- (void)fetchStatisticsDataWithShareTypes:(NSSet<HKSampleType *> *__nullable)shareTypes
                                readTypes:(NSSet<HKObjectType *> *__nonnull)readTypes
                     statisticsSampleType:(HKQuantityType *__nonnull)sampleType
                            withStartDate:(NSDate *__nonnull)startDate
                              withEndDate:(NSDate *__nonnull)endDate
                    initialResultsHandler:(void (^__nullable)(HKStatisticsCollectionQuery * __nonnull query, HKStatisticsCollection * __nullable result))initialResultHandlerBlock
                  statisticsUpdateHandler:(void (^__nullable)(HKStatisticsCollectionQuery * __nonnull query, HKStatistics * __nullable statistics, HKStatisticsCollection * __nullable collection))statisticsUpdateHandlerBlock
                              withFailure:(void (^__nullable)(HKStatisticsCollectionQuery * __nonnull query, HKStatisticsCollection * __nullable result,NSError * __nullable error))failureBlock;

@end