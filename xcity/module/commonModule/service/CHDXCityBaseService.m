//
//  XCMBaseService.m
//  NewMDT
//
//  Created by 余妙玉 on 16/1/7.
//  Copyright © 2016年 Lampard Hong. All rights reserved.
//

#import "CHDXCityBaseService.h"
#import "CHDXCityBaseServiceConfigurationObject.h"
#import "CHDXCityCommonResponse+CoreDataClass.h"

NSString * const kCHDXCityBaseServiceErrorDomain = @"com.BaseService.CHDXCity";

@interface CHDXCityBaseService(){
}

@end
static CHDXCityBaseService *shareInstance;

@implementation CHDXCityBaseService

-(id)init;
{
    if (self=[super init]) {
    }
    return self;
}

-(void)basicInitWithConfiguration:(CHDXCityBaseServiceConfigurationObject *)configuration;
{
    self.serviceConfiguration = configuration;
}

+ (instancetype(^)(void))shareInstanceWithConfig:(CHDXCityBaseServiceConfigurationObject *)config;
{
    static dispatch_once_t predicate;
    
    return ^CHDXCityBaseService *{
        
        if (!shareInstance) {
            dispatch_once(&predicate, ^{
                shareInstance = [[self alloc]init];
                [shareInstance basicInitWithConfiguration:config];
                
            });
            
        }
        return shareInstance;
    };
}


- (instancetype(^)(CHDXCityBaseServiceConfigurationObject *config))reloadConfig;
{
    __weak typeof (self)weakself = self;
    
    return ^CHDXCityBaseService *(CHDXCityBaseServiceConfigurationObject *config){
        __strong typeof(weakself)strongself = weakself;
        strongself.serviceConfiguration = config;
        return self;
    };
}

- (CHDXCityServiceErrorLevel)fetchErrorLevel;
{
    return self.serviceConfiguration.errorLevel  = self.serviceConfiguration.errorLevel ? : CHDXCityServiceErrorLevel_Default;

}

-(BOOL)vaildateNoEmptyParametersWithParamtersKey:(NSString *)parameterKey
                              withParameterVaule:(NSString *)parameterValue
                                      errorLevel:(CHDXCityServiceErrorLevel)errorLevel
                                     withFailure:(void (^)(NSURLSessionDataTask *task, NSError *error, CHDXCityCommonResponse *response))failure;
{
    BOOL vaildateResult = YES;
    
    __weak typeof(self)weakself = self;
    
    if (!parameterValue) {
        if (CHDXCityServiceErrorLevel_Default == errorLevel) {
            return vaildateResult = NO;
            
        } else if (CHDXCityServiceErrorLevel_Assert == errorLevel) {
            NSAssert(parameterValue, [self serverDiscription][parameterKey][NSLocalizedFailureReasonErrorKey]);
            
            return vaildateResult = NO;
            
        } else if (CHDXCityServiceErrorLevel_FaildBlock == errorLevel) {
            if (failure) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    NSError *error = [weakself createServiceErrorWithDomain:kCHDXCityBaseServiceErrorDomain withErrorCode: [[weakself serverDiscription][parameterKey][@"code"]integerValue] withErrorUserInfo:[weakself serverDiscription][parameterKey]];
                    failure(nil, error, nil);
                    
                });
            }
            return vaildateResult = NO;
        } else {
            return vaildateResult = NO;
        }
    } else {
        return vaildateResult;
    }
}

-(NSError *)createServiceErrorWithDomain:(NSString *)domain
                           withErrorCode:(NSInteger)errorCode
                       withErrorUserInfo:(NSDictionary *)userInfo;
{
    NSError *error = [NSError errorWithDomain:domain code:errorCode userInfo:userInfo];
    if  (self->_serviceConfiguration) {
        return self.serviceConfiguration.serviceError = error;
    } else {
        return error;
    }
}
@end
