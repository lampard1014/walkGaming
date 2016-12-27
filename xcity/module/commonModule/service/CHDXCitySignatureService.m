//
//  CHDXCitySignatureService.m
//  ECoupon
//
//  Created by 余妙玉 on 16/6/1.
//  Copyright © 2016年 Xkeshi. All rights reserved.
//

#import "CHDXCitySignatureService.h"
#import "XKSEncryptor.h"
#import "XKSSystemObj.h"

static CHDXCitySignatureService *shareInstance;

@implementation CHDXCitySignatureService

+ (instancetype(^)(void))shareInstanceWithConfig:(CHDXCityBaseServiceConfigurationObject *)config;
{
    static dispatch_once_t predicate;
    
    return ^CHDXCitySignatureService *{
        
        if (!shareInstance) {
            dispatch_once(&predicate, ^{
                shareInstance = [[self alloc]init];
                [shareInstance basicInitWithConfiguration:config];
                
            });
            
        }
        return shareInstance;
    };
}


-(void)basicInitWithConfiguration:(CHDXCityBaseServiceConfigurationObject *)configuration;
{
    self.serviceConfiguration = configuration;
    XKSSystemObj *sdkObj = [XKSSystemObj shareXKSSystemObj];
    sdkObj.md5Secret = CHDXCitySignMD5Secret;
    sdkObj.appKey = CHDXCitySignAppID;
    sdkObj.signaterEnable = [self signatureEnable];
    sdkObj.validateEnable = [self vaildateEnable];
    sdkObj.encryptType = XKSEncryptType_MD5;
    

}

-(CHDXCitySignatureType)fetchCHDXCitySignatureType;
{
    return _signatureType = _signatureType?:CHDXCitySignatureType_Default;
}

-(NSDictionary *)signDataWithUrl:(NSString *)url
                      withParams:(NSDictionary *)params
                  withHttpMethod:(CHDXCityHTTPMethod)httpMethod;
{
    NSDictionary *signDic;
    if ([self signatureEnable]) {
        
        BOOL isGet = [self needEncodingParametersInURIWithHTTPMethod:httpMethod];

        signDic = [XKSEncryptor signWithRequestParams:params uri:url strategy:(isGet == YES ? XKSEncryptStrategy_A:XKSEncryptStrategy_B)];
    }
    
    return signDic;
}

-(BOOL)signatureEnable;
{
    return CHDXCitySignatureType_Request == [self fetchCHDXCitySignatureType] ||CHDXCitySignatureType_Both == [self fetchCHDXCitySignatureType];
}
-(BOOL)vaildateEnable;
{
    return CHDXCitySignatureType_Response == [self fetchCHDXCitySignatureType] ||CHDXCitySignatureType_Both == [self fetchCHDXCitySignatureType];

}

- (BOOL)needEncodingParametersInURIWithHTTPMethod:(CHDXCityHTTPMethod)HTTPMethod
{
    switch (HTTPMethod) {
        case CHDXCityHTTPMethod_Get:
        case CHDXCityHTTPMethod_Head:
        case CHDXCityHTTPMethod_Delete:
            return YES;
        default:
            return NO;
    }
}

@end
