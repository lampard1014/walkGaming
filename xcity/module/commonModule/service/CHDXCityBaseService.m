//
//  XCMBaseService.m
//  NewMDT
//
//  Created by 余妙玉 on 16/1/7.
//  Copyright © 2016年 Lampard Hong. All rights reserved.
//

#import "XMBaseService.h"
#import "XMBaseServiceConfigurationObject.h"
#import "XMCommonResponse.h"

static NSString *kXMBaseServiceErrorDomain = @"com.BaseService.XM";

@interface XMBaseService(){
}

@end
static XMBaseService *shareInstance;

@implementation XMBaseService

-(id)init;
{
    if (self=[super init]) {
    }
    return self;
}

-(void)basicInitWithConfiguration:(XMBaseServiceConfigurationObject *)configuration;
{
    self.serviceConfiguration = configuration;
}

+ (instancetype(^)(void))shareInstanceWithConfig:(XMBaseServiceConfigurationObject *)config;
{
    static dispatch_once_t predicate;
    
    return ^XMBaseService *{
        
        if (!shareInstance) {
            dispatch_once(&predicate, ^{
                shareInstance = [[self alloc]init];
                [shareInstance basicInitWithConfiguration:config];
                
            });
            
        }
        return shareInstance;
    };
}


- (instancetype(^)(XMBaseServiceConfigurationObject *config))reloadConfig;
{
    __weak typeof (self)weakself = self;
    
    return ^XMBaseService *(XMBaseServiceConfigurationObject *config){
        __strong typeof(weakself)strongself = weakself;
        strongself.serviceConfiguration = config;
        return self;
    };
}

- (XMServiceErrorLevel)fetchErrorLevel;
{
    return self.serviceConfiguration.errorLevel  = self.serviceConfiguration.errorLevel ? : XMServiceErrorLevel_Default;

}

-(BOOL)vaildateNoEmptyParametersWithParamtersKey:(NSString *)parameterKey
                              withParameterVaule:(NSString *)parameterValue
                                      errorLevel:(XMServiceErrorLevel)errorLevel
                                     withFailure:(void (^)(NSURLSessionDataTask *task, NSError *error, XMCommonResponse *response))failure;
{
    BOOL vaildateResult = YES;
    
    __weak typeof(self)weakself = self;
    
    if (!parameterValue) {
        if (XMServiceErrorLevel_Default == errorLevel) {
            return vaildateResult = NO;
            
        } else if (XMServiceErrorLevel_Assert == errorLevel) {
            NSAssert(parameterValue, [self serverDiscription][parameterKey][NSLocalizedFailureReasonErrorKey]);
            
            return vaildateResult = NO;
            
        } else if (XMServiceErrorLevel_FaildBlock == errorLevel) {
            if (failure) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    NSError *error = [weakself createServiceErrorWithDomain:kXMBaseServiceErrorDomain withErrorCode: [[weakself serverDiscription][parameterKey][@"code"]integerValue] withErrorUserInfo:[weakself serverDiscription][parameterKey]];
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
