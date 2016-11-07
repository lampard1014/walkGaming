//
//  CHDXCityHKService.m
//  xcity
//
//  Created by 余妙玉 on 16/11/1.
//  Copyright © 2016年 Lampard Hong. All rights reserved.
//

#import "CHDXCityHKService.h"


static CHDXCityHKService *shareInstance;

@interface CHDXCityHKService (){

}
@property (nonatomic,strong, getter=fetchHKStore)HKHealthStore *hkStore;

@end

@implementation CHDXCityHKService
#pragma mark -
#pragma mark @protocl CHDXCityCoreServiceProtocol

@synthesize serviceConfig;
@synthesize serviceError;

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
{
    static dispatch_once_t predicate;
    
    return ^CHDXCityHKService *{
        
        if (!shareInstance) {
            dispatch_once(&predicate, ^{
                shareInstance = [[self alloc]init];
                shareInstance.serviceConfig = config;
                [shareInstance basicInit];
                
            });
            
        }
        return shareInstance;
    };
}


-(void)basicInit;
{
    
}


- (BOOL)checkHKServiceEnable;
{
    BOOL enable = [HKHealthStore isHealthDataAvailable];
    
    if (!enable) {
        self.serviceError = [NSError
                             errorWithDomain:CHDXCityHKServiceErrorDomain
                             code:(NSInteger)([CHDXCityHKServiceError_HEALTHKITNOTSUPPORT UTF8String])
                             userInfo:@{NSLocalizedFailureReasonErrorKey:CHDXCityHKServiceError_HEALTHKITNOTSUPPORT,NSLocalizedDescriptionKey:CHDXCityHKServiceError_DESC}];
    }
    return enable;
}

-(HKHealthStore *)fetchHKStore;
{
    if (!_hkStore) {
        _hkStore = [[HKHealthStore alloc]init];
    }
    return _hkStore;
}

- (void)checkPermissionsWithShareTypes:(NSSet<HKSampleType *> *)shareTypes
                             readTypes:(NSSet<HKObjectType *> *)readTypes
                           withSuccess:(void (^)(void))successBlock
                           withFailure:(void (^)(HKStatisticsCollectionQuery *query, HKStatisticsCollection * __nullable result,NSError * __nullable error))failureBlock;
{
    __weak typeof (self)weakself = self;
    
    [self.hkStore requestAuthorizationToShareTypes:shareTypes readTypes:readTypes completion:^(BOOL success, NSError * _Nullable error) {
       
        if (success) {
            if (successBlock) {
                successBlock();
            }
        } else {
            if (failureBlock) {
                weakself.serviceError = error;
                failureBlock(nil, nil, error);
            }
        }
    }];
}

- (void)fetchStatisticsDataWithShareTypes:(NSSet<HKSampleType *> *__nullable)shareTypes
                                readTypes:(NSSet<HKObjectType *> *__nonnull)readTypes
                     statisticsSampleType:(HKQuantityType *__nonnull)sampleType
                            withStartDate:(NSDate *__nonnull)startDate
                              withEndDate:(NSDate *__nonnull)endDate
                    initialResultsHandler:(void (^__nullable)(HKStatisticsCollectionQuery * __nonnull query, HKStatisticsCollection * __nullable result))initialResultHandlerBlock
                  statisticsUpdateHandler:(void (^__nullable)(HKStatisticsCollectionQuery * __nonnull query, HKStatistics * __nullable statistics, HKStatisticsCollection * __nullable collection))statisticsUpdateHandlerBlock
                              withFailure:(void (^__nullable)(HKStatisticsCollectionQuery * __nonnull query, HKStatisticsCollection * __nullable result,NSError * __nullable error))failureBlock;
{
    __weak typeof (self)weakself = self;

    [self checkPermissionsWithShareTypes:shareTypes readTypes:readTypes withSuccess:^{
        
        __strong typeof(weakself)strongself = weakself;
        NSPredicate *predicate = [HKQuery predicateForSamplesWithStartDate:startDate endDate:endDate options:HKQueryOptionStrictStartDate];
        NSUInteger op = HKStatisticsOptionSeparateBySource|HKStatisticsOptionCumulativeSum;
        
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        
        NSDateComponents *hComponents = [calendar components:NSCalendarUnitHour fromDate:startDate];
        
        [hComponents setHour:24];
        HKStatisticsCollectionQuery *query  =[[HKStatisticsCollectionQuery alloc] initWithQuantityType:sampleType quantitySamplePredicate:predicate options:op anchorDate:startDate intervalComponents:hComponents];
        
        
        HKStatisticsQuery *statisticsQuery = [[HKStatisticsQuery alloc]initWithQuantityType:sampleType quantitySamplePredicate:predicate options:op completionHandler:^(HKStatisticsQuery * _Nonnull query, HKStatistics * _Nullable result, NSError * _Nullable error) {
            NSLog(@"completed");
        }];
        
        query.initialResultsHandler = ^(HKStatisticsCollectionQuery *query, HKStatisticsCollection * __nullable result, NSError * __nullable error) {
            
            if (error) {
                if (failureBlock) {
                    failureBlock(query, nil, error);
                }
            } else {
                if (initialResultHandlerBlock) {
                    initialResultHandlerBlock(query, result);
                }
            }
        };
        
        query.statisticsUpdateHandler = ^(HKStatisticsCollectionQuery *query, HKStatistics * __nullable statistics, HKStatisticsCollection * __nullable collection, NSError * __nullable error) {
            if (error) {
                if (failureBlock) {
                    failureBlock(query, nil, error);
                }
            } else {
                if (statisticsUpdateHandlerBlock) {
                    statisticsUpdateHandlerBlock(query, statistics, collection);
                }
            }

        };
        
        [strongself.hkStore executeQuery:query];

    } withFailure:failureBlock];
}

@end


#pragma mark -
#pragma mark service error

NSString * const CHDXCityHKServiceErrorDomain = @"CHDXCityHKServiceErrorDomains";

NSString * const CHDXCityHKServiceError_HEALTHKITNOTSUPPORT = @"CHDXCityHKServiceError_HEALTHKITNOTSUPPORT";

NSString * const CHDXCityHKServiceError_DESC = @"出错了";
