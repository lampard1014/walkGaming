//
//  XMSystemConfigurationService.m
//  ECoupon
//
//  Created by 余妙玉 on 16/6/17.
//  Copyright © 2016年 Xkeshi. All rights reserved.
//

#import "XMSystemConfigurationService.h"
#import "XMLoginService.h"
#import "XMNetworkingService.h"
#import "XMCoreDataService.h"

#import "XMPaymentModeResponseResult.h"
#import "XMPaymentModeResponseResult_paymentChannels.h"


static NSString *kXMSystemConfigurationService_DeviceNumber = @"kDeviceNumber";
static NSString *kXMSystemConfigurationService_ShopId = @"kShopId";
static NSString *kXMSystemConfigure_paymentMode_url = @"/api/xpos/payment/mode";

static XMSystemConfigurationService *shareInstance;

@implementation XMSystemConfigurationService

+ (instancetype(^)(void))shareInstanceWithConfig:(XMBaseServiceConfigurationObject *)config;
{
    static dispatch_once_t predicate;
    
    return ^XMSystemConfigurationService *{
        
        if (!shareInstance) {
            dispatch_once(&predicate, ^{
                shareInstance = [[self alloc]init];
                [shareInstance basicInitWithConfiguration:config];
                
            });
            
        }
        return shareInstance;
    };
}


-(void)basicInitWithConfiguration:(XMBaseServiceConfigurationObject *)configuration;
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

             kXMSystemConfigurationService_DeviceNumber:@{
                     @"code":@((int)[kXMSystemConfigurationService_DeviceNumber UTF8String]),
                     NSLocalizedDescriptionKey:@"设备号",
                     NSLocalizedFailureReasonErrorKey:@"设备号为空",
                     },
            kXMSystemConfigurationService_ShopId:@{
                     @"code":@((int)[kXMSystemConfigurationService_ShopId UTF8String]),
                     NSLocalizedDescriptionKey:@"shopId",
                     NSLocalizedFailureReasonErrorKey:@"shopId为空,请先绑定",
                     }
             };
}

- (void)fetchPaymentModeWithDeviceNumber:(NSString *)deviceNumber
                              withShopId:(NSNumber *)shopId
                                 success:(void (^)(NSURLSessionDataTask *task, XMCommonResponse *response))success
                                 failure:(void (^)(NSURLSessionDataTask *task, NSError *error, XMCommonResponse *response))failure;
{
    NSString *shopIdStr = shopId ? [NSString stringWithFormat:@"%ld", (long)[shopId integerValue]] : nil;
    
    __weak typeof(self)weakself = self;
    if (
        [self vaildateNoEmptyParametersWithParamtersKey:kXMSystemConfigurationService_ShopId withParameterVaule:shopIdStr errorLevel:XMServiceErrorLevel_FaildBlock withFailure:failure]
        &&
        [self vaildateNoEmptyParametersWithParamtersKey:kXMSystemConfigurationService_DeviceNumber withParameterVaule:deviceNumber errorLevel:XMServiceErrorLevel_FaildBlock withFailure:failure]
        ) {
        //
        XMNetworkingService *networkService = [XMNetworkingService shareInstanceWithConfig:nil]();
        
        [networkService dataTaskWithUrl:kXMSystemConfigure_paymentMode_url
                                 params:@{
                                          @"deviceNumber":deviceNumber,
                                          @"shopId":shopIdStr
                                          }
                             httpMethod:XMHTTPMethod_Post
                                success:^(NSURLSessionDataTask *task, XMCommonResponse *response){
                                    
                                    if (response && [[response result]isKindOfClass:[XMPaymentModeResponseResult class]]) {
                                    
                                        weakself.paymentModel = (XMPaymentModeResponseResult *)[response result];

                                        if (success) {
                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                success(task, response);
                                            });
                                        }
                                        
                                    } else {
                                        weakself.paymentModel = nil;
                                        if (failure) {
                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                failure(nil, nil, response);
                                            });
                                        }
                                    }
                                }
                                failure:failure
                        withRelationMap:@{
                                          @"result":NSStringFromClass([XMPaymentModeResponseResult class]),
                                          @"paymentChannels":NSStringFromClass([XMPaymentModeResponseResult_paymentChannels class])
                                          }
                         uploadProgress:nil
                       downloadProgress:nil];
        
    }
}

@end
