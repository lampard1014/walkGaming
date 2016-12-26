//
//  XMSignatureService.m
//  ECoupon
//
//  Created by 余妙玉 on 16/6/1.
//  Copyright © 2016年 Xkeshi. All rights reserved.
//

#import "XMSignatureService.h"
#import "XKSEncryptor.h"
#import "XKSSystemObj.h"

static XMSignatureService *shareInstance;

@implementation XMSignatureService

+ (instancetype(^)(void))shareInstanceWithConfig:(XMBaseServiceConfigurationObject *)config;
{
    static dispatch_once_t predicate;
    
    return ^XMSignatureService *{
        
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
    self.serviceConfiguration = configuration;
    XKSSystemObj *sdkObj = [XKSSystemObj shareXKSSystemObj];
    sdkObj.md5Secret = XMSignMD5Secret;
    sdkObj.appKey = XMSignAppID;
    sdkObj.signaterEnable = [self signatureEnable];
    sdkObj.validateEnable = [self vaildateEnable];
    sdkObj.encryptType = XKSEncryptType_MD5;
    

}

-(XMXMSignatureType)fetchXMXMSignatureType;
{
    return _signatureType = _signatureType?:XMXMSignatureType_Default;
}

-(NSDictionary *)signDataWithUrl:(NSString *)url
                      withParams:(NSDictionary *)params
                  withHttpMethod:(XMHTTPMethod)httpMethod;
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
    return XMXMSignatureType_Request == [self fetchXMXMSignatureType] ||XMXMSignatureType_Both == [self fetchXMXMSignatureType];
}
-(BOOL)vaildateEnable;
{
    return XMXMSignatureType_Response == [self fetchXMXMSignatureType] ||XMXMSignatureType_Both == [self fetchXMXMSignatureType];

}

- (BOOL)needEncodingParametersInURIWithHTTPMethod:(XMHTTPMethod)HTTPMethod
{
    switch (HTTPMethod) {
        case XMHTTPMethod_Get:
        case XMHTTPMethod_Head:
        case XMHTTPMethod_Delete:
            return YES;
        default:
            return NO;
    }
}

@end
