//
//  ViewController.m
//  xcity
//
//  Created by 余妙玉 on 16/10/31.
//  Copyright © 2016年 Lampard Hong. All rights reserved.
//

#import "ViewController.h"
#import <HealthKit/HealthKit.h>

@interface ViewController ()

@property (nonatomic,strong, getter=fetchHKStore)HKHealthStore *hkStore;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self testIHealth];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)testIHealth;
{
    if ([self checkHealthDataAvailable]) {
        
        HKObjectType *stepCount = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
        NSSet *healthSet = [NSSet setWithObjects:stepCount, nil];
        [self.hkStore requestAuthorizationToShareTypes:nil readTypes:healthSet completion:^(BOOL success, NSError * _Nullable error) {
            if (success) {
                NSLog(@"获取步数权限成功");
                //获取步数后我们调用获取步数的方法
                [self fetchStepCount];
            } else {
                NSLog(@"获取步数权限失败");
            }
        }];

    }
    
}


- (NSArray <NSDate *>*)fetchLocalStartDateAndEndDate;
{
    NSDate *startDate = [[NSCalendar currentCalendar]startOfDayForDate:[NSDate date]];
    NSDate *endDate = [startDate dateByAddingTimeInterval:24*3600];
    
    return @[startDate, endDate];
    
}

-(void)fetchTotalStepCount;
{
    // 统计分析
    
    HKQuantityType *sampleType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
    
    
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSDateComponents *dateCom = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit fromDate:[NSDate date]];
    
    
    
    NSDate *startDate, *endDate;
    
    endDate = [calendar dateFromComponents:dateCom];
    
    
    
    [dateCom setHour:0];
    
    [dateCom setMinute:0];
    
    [dateCom setSecond:0];
    
    
    
    startDate = [calendar dateFromComponents:dateCom];
    
    NSPredicate *predicate = [HKQuery predicateForSamplesWithStartDate:startDate endDate:endDate options:HKQueryOptionStrictStartDate];
    
    NSUInteger op = HKStatisticsOptionCumulativeSum;
    
    HKStatisticsQuery *q1 = [[HKStatisticsQuery alloc] initWithQuantityType:sampleType quantitySamplePredicate:predicate options:op completionHandler:^(HKStatisticsQuery * _Nonnull query, HKStatistics * _Nullable result, NSError * _Nullable error) {
        
        NSLog(@"\n\n");
        
        if (error)
            
        {
            
            NSLog(@"统计出错 %@", error);
            
            return;
            
        }
        
        double sum1 = [result.averageQuantity doubleValueForUnit:[HKUnit countUnit]];
        
        double sum2 = [result.minimumQuantity doubleValueForUnit:[HKUnit countUnit]];
        
        double sum3 = [result.maximumQuantity doubleValueForUnit:[HKUnit countUnit]];
        
        double sum4 = [result.sumQuantity doubleValueForUnit:[HKUnit countUnit]];
        
        NSLog(@"统计平均步数=%@步", @(sum1));
        
        NSLog(@"统计最小步数=%@步", @(sum2));
        
        NSLog(@"统计最大步数=%@步", @(sum3));
        
        NSLog(@"统计步数=%@步", @(sum4));
        
        NSLog(@"\n\n");
        
    }];
    
    
    
    
    
    // 间隔一小时统计一次
    
    NSDateComponents *hComponents = [calendar components:NSCalendarUnitHour fromDate:[NSDate date]];
    
    [hComponents setHour:1];
    
    HKStatisticsCollectionQuery *q2  =[[HKStatisticsCollectionQuery alloc] initWithQuantityType:sampleType quantitySamplePredicate:predicate options:op anchorDate:startDate intervalComponents:hComponents];
    
    q2.initialResultsHandler = ^(HKStatisticsCollectionQuery *query, HKStatisticsCollection * __nullable result, NSError * __nullable error) {
        
        if (error)
            
        {
            
            NSLog(@"统计init出错 %@", error);
            
            return;
            
        }
        
        for (HKStatistics *s in result.statistics)
            
        {
            
            double sum1 = [s.averageQuantity doubleValueForUnit:[HKUnit countUnit]];
            
            double sum2 = [s.minimumQuantity doubleValueForUnit:[HKUnit countUnit]];
            
            double sum3 = [s.maximumQuantity doubleValueForUnit:[HKUnit countUnit]];
            
            double sum4 = [s.sumQuantity doubleValueForUnit:[HKUnit countUnit]];
            
            NSLog(@"init统计平均步数=%@步", @(sum1));
            
            NSLog(@"init统计最小步数=%@步", @(sum2));
            
            NSLog(@"init统计最大步数=%@步", @(sum3));
            
            NSLog(@"init统计步数=%@步", @(sum4));
            
        }
        
    };
    
    q2.statisticsUpdateHandler = ^(HKStatisticsCollectionQuery *query, HKStatistics * __nullable statistics, HKStatisticsCollection * __nullable collection, NSError * __nullable error) {
        
        if (error)
            
        {
            
            NSLog(@"统计update出错 %@", error);
            
            return;
            
        }
        
        for (HKStatistics *result in collection.statistics)
            
        {
            
            double sum1 = [result.averageQuantity doubleValueForUnit:[HKUnit countUnit]];
            
            double sum2 = [result.minimumQuantity doubleValueForUnit:[HKUnit countUnit]];
            
            double sum3 = [result.maximumQuantity doubleValueForUnit:[HKUnit countUnit]];
            
            double sum4 = [result.sumQuantity doubleValueForUnit:[HKUnit countUnit]];
            
            NSLog(@"update统计平均步数=%@步", @(sum1));
            
            NSLog(@"update统计最小步数=%@步", @(sum2));
            
            NSLog(@"update统计最大步数=%@步", @(sum3));
            
            NSLog(@"update统计步数=%@步", @(sum4));
            
        }
        
    };
    
    
    
    //执行查询
    
    [self.hkStore executeQuery:q1];
    
    [self.hkStore executeQuery:q2];
    


}

- (void)fetchStepCount;
{
    NSArray <NSDate *> *dates = [self fetchLocalStartDateAndEndDate];
    
    NSPredicate *queryPredicate = [HKQuery predicateForSamplesWithStartDate:dates[0] endDate:dates[1] options:HKQueryOptionStrictStartDate];
    
    HKQuantityType *sampleType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
    //NSSortDescriptors用来告诉healthStore怎么样将结果排序。
    NSSortDescriptor *start = [NSSortDescriptor sortDescriptorWithKey:HKSampleSortIdentifierStartDate ascending:NO];
    NSSortDescriptor *end = [NSSortDescriptor sortDescriptorWithKey:HKSampleSortIdentifierEndDate ascending:NO];
    
    __block double totalStepCount = 0.f;
    
    NSDateComponents *hComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitHour fromDate:[NSDate date]];
    
    [hComponents setSecond:5];

    HKStatisticsCollectionQuery *collectionQuery = [[HKStatisticsCollectionQuery alloc]initWithQuantityType:sampleType quantitySamplePredicate:queryPredicate options:HKStatisticsOptionCumulativeSum | HKStatisticsOptionSeparateBySource anchorDate:dates[0] intervalComponents:hComponents];
    
    [collectionQuery setInitialResultsHandler:^(HKStatisticsCollectionQuery * _Nonnull collectionQuery, HKStatisticsCollection * _Nullable statisticsCollection, NSError * _Nullable error) {
//        NSLog(@"asdf");
        
        [statisticsCollection enumerateStatisticsFromDate:dates[0] toDate:dates[1] withBlock:^(HKStatistics * _Nonnull result, BOOL * _Nonnull stop) {
            NSLog(@"result source %@, result count %@", result.sources, result.sumQuantity);
        }];
    }];
    [collectionQuery setStatisticsUpdateHandler:^(HKStatisticsCollectionQuery * _Nonnull collectionQuery, HKStatistics * _Nullable statistics, HKStatisticsCollection * _Nullable statisticsCollection, NSError * _Nullable error) {
        NSLog(@"asdfsf");
    }];
    
    [self.hkStore executeQuery:collectionQuery];
    
    
    HKSampleQuery *sampleQuery = [[HKSampleQuery alloc] initWithSampleType:sampleType predicate:queryPredicate limit:HKObjectQueryNoLimit sortDescriptors:@[start,end] resultsHandler:^(HKSampleQuery * _Nonnull query, NSArray<__kindof HKSample *> * _Nullable results, NSError * _Nullable error) {
        
        
        if ([results count]) {
            [results enumerateObjectsUsingBlock:^(__kindof HKSample * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj isKindOfClass:[HKQuantitySample class]]) {
                   HKQuantity *quantity = ((HKQuantitySample *)obj).quantity;
                   totalStepCount += [quantity doubleValueForUnit:[HKUnit countUnit]];
                }
            }];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"totalStepCount %@", [NSNumber numberWithDouble:totalStepCount]);
        });
    }];
    //执行查询
    [self.hkStore executeQuery:sampleQuery];


}

- (BOOL)checkHealthDataAvailable;
{
    return [HKHealthStore isHealthDataAvailable];
}

-(HKHealthStore *)fetchHKStore;
{
    if (!_hkStore) {
        _hkStore = [[HKHealthStore alloc]init];
    }
    return _hkStore;
}

@end
