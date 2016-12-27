//
//  CHDXCityNetworkingService.m
//  ECoupon
//
//  Created by 余妙玉 on 16/6/1.
//  Copyright © 2016年 Xkeshi. All rights reserved.
//

#import "CHDXCityNetworkingService.h"

#import <AFNetworking/AFNetworking.h>

#import "CHDXCitySignatureService.h"
#import "CHDXCityCoreDataService.h"
#import "XKSEncryptor.h"

#import "CHDXCityCommonResponse+CoreDataClass.h"







NSString * const successResponseCode = @"0";

NSString * const XAppTypeCommonForIPhoneString        = @"x-mobile-marketing-ios";

NSString * const exception_unbindRespnoseCode = @"S_1001";

NSString * const CHDXCityNetworkingService_unbindRespnoseNotification = @"CHDXCityNetworkingService_unbindRespnoseNotification";

NSString * const CHDXCityNetworkingServiceRawResponseData = @"CHDXCityNetworkingServiceRawResponseData";

NSString * const kHttpMethod = @"kErrorMethod";
NSString * const kSignatureError = @"kSignatureError";
NSString * const kErrorResult = @"kErrorResult";
NSString * const kNetworkingRechbility = @"kNetworkingRechbility";
NSString * const kCHDXCityNetworkingServiceErrorDomain = @"com.NetworkingError.CHDXCity";

#pragma mark -
#pragma mark add custom AFJSONRequestSerializer
@interface XNetworkManagerJSONRequestSerializer : AFJSONRequestSerializer

@end

@implementation XNetworkManagerJSONRequestSerializer


#pragma mark - AFURLRequestSerialization

- (NSURLRequest *)requestBySerializingRequest:(NSURLRequest *)request
                               withParameters:(id)parameters
                                        error:(NSError *__autoreleasing *)error
{
    NSParameterAssert(request);
    
    if ([self.HTTPMethodsEncodingParametersInURI containsObject:[[request HTTPMethod] uppercaseString]]) {
        return [super requestBySerializingRequest:request withParameters:parameters error:error];
    }
    
    NSMutableURLRequest *mutableRequest = [request mutableCopy];
    
    [self.HTTPRequestHeaders enumerateKeysAndObjectsUsingBlock:^(id field, id value, BOOL * __unused stop) {
        if (![request valueForHTTPHeaderField:field]) {
            [mutableRequest setValue:value forHTTPHeaderField:field];
        }
    }];
    
    if (parameters) {
        if (![mutableRequest valueForHTTPHeaderField:@"Content-Type"]) {
            [mutableRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        }
        
        NSArray *allHeaderKey = [mutableRequest.allHTTPHeaderFields allKeys];
        
        if ([allHeaderKey containsObject:@"sign"] && [allHeaderKey containsObject:@"signType"] ) {
            if ([mutableRequest.allHTTPHeaderFields[@"signType"] isEqualToString:@"MD5"]) {
                if (parameters[@"data"]) {
                    [mutableRequest setHTTPBody:[NSJSONSerialization dataWithJSONObject:parameters options:self.writingOptions error:error]];
                    [mutableRequest setHTTPBody:[parameters[@"data"] dataUsingEncoding:NSUTF8StringEncoding]];
                }
            }
        } else {
            [mutableRequest setHTTPBody:[NSJSONSerialization dataWithJSONObject:parameters options:self.writingOptions error:error]];
        }
    }
    
    return mutableRequest;
}
@end
#pragma mark -
#pragma mark add custom response serializer

@interface CHDXCityNetworkingServiceJsonResponseSerialize : AFJSONResponseSerializer

@end

@implementation CHDXCityNetworkingServiceJsonResponseSerialize

- (id)responseObjectForResponse:(NSURLResponse *)response
                           data:(NSData *)data
                          error:(NSError *__autoreleasing *)error
;
{
    id superData = [super responseObjectForResponse:response data:data error:error];
    if (
        !superData
        ||
        [superData isKindOfClass:[NSNull class]]
        ||
        ![superData isKindOfClass:[NSDictionary class]]
        ) {
        return nil;
        
    } else {
        NSMutableDictionary *rawData = [[NSMutableDictionary alloc]initWithDictionary:(NSDictionary *)superData];
        if (data && [data length]) {
            [rawData setObject:data forKey:CHDXCityNetworkingServiceRawResponseData];
        }
        return rawData;
    }
}

@end

#pragma mark -
#pragma mark service part



static CHDXCityNetworkingService *shareInstance;

@interface CHDXCityNetworkingService(){
}
@property (nonatomic, strong)AFHTTPSessionManager *manager;

- (NSDictionary *)fetchHeaderDictionary;
@end

@implementation CHDXCityNetworkingService
+ (instancetype(^)(void))shareInstanceWithConfig:(CHDXCityBaseServiceConfigurationObject *)config;
{
    static dispatch_once_t predicate;
    
    return ^CHDXCityNetworkingService *{
        
        if (!shareInstance) {
            dispatch_once(&predicate, ^{
                shareInstance = [[self alloc]init];
                [shareInstance basicInitWithConfiguration:config];
                
            });
            
        }
        return shareInstance;
    };
}

- (void)basicInitWithConfiguration:(CHDXCityBaseServiceConfigurationObject *)configuration;
{
    self.manager = [AFHTTPSessionManager manager];
    self.manager.securityPolicy.allowInvalidCertificates = YES;
    self.manager.requestSerializer = [XNetworkManagerJSONRequestSerializer serializer];
    self.manager.responseSerializer = [CHDXCityNetworkingServiceJsonResponseSerialize serializer];
    self.manager.requestSerializer.timeoutInterval = 30;
    NSDictionary *headerDictionary = [self fetchHeaderDictionary];
    if (headerDictionary && [headerDictionary count]) {
        [headerDictionary enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            [self.manager.requestSerializer setValue:obj forHTTPHeaderField:key];
        }];
    }
    
}

- (NSDictionary *)fetchHeaderDictionary;
{
    return @{
             @"App-Type": XAppTypeCommonForIPhoneString
             };
}

- (NSString *)fetchHttpMethodDescriptionWithHttpMethod:(CHDXCityHTTPMethod)httpMethod;
{
    switch (httpMethod) {
        case CHDXCityHTTPMethod_Get:
            return @"GET";
        case CHDXCityHTTPMethod_Head:
            return @"HEAD";
        case CHDXCityHTTPMethod_Post:
            return @"POST";
        case CHDXCityHTTPMethod_Put:
            return @"PUT";
        case CHDXCityHTTPMethod_Delete:
            return @"DELETE";
        case CHDXCityHTTPMethod_Trace:
            return @"TRACE";
        default:
            return nil;
    }
    
}

-(NSDictionary *)serverDiscription;
{
    return @{
             kHttpMethod:@{
                        @"code":@((int)[kHttpMethod UTF8String]),
                        NSLocalizedDescriptionKey:@"httpMethod-请求的方法",
                        NSLocalizedFailureReasonErrorKey:@"请求METHOD错误",
                     },
             kErrorResult:@{
                     @"code":@((int)[kErrorResult UTF8String]),
                     NSLocalizedDescriptionKey:@"请求执行失败",
                     NSLocalizedFailureReasonErrorKey:@"请求执行失败，result<>0",
                     },
             kNetworkingRechbility:@{
                     @"code":@((int)[kNetworkingRechbility UTF8String]),
                     NSLocalizedDescriptionKey:@"网络异常",
                     NSLocalizedFailureReasonErrorKey:@"请检查你的网络是否正常",
                     },
             exception_unbindRespnoseCode:@{
                     @"code":@((int)[exception_unbindRespnoseCode UTF8String]),
                     NSLocalizedDescriptionKey:@"操作失败",
                     NSLocalizedFailureReasonErrorKey:@"后台已经解绑了",
                     NSLocalizedRecoverySuggestionErrorKey:exception_unbindRespnoseCode,
                     },
             kSignatureError:@{
                     @"code":@((int)[kSignatureError UTF8String]),
                     NSLocalizedDescriptionKey:@"验签失败",
//                     NSLocalizedFailureReasonErrorKey:@"后台已经解绑了",
                     }
             };
}

- (void)dataTaskWithUrl:(NSString *)url
                 params:(NSDictionary *)params
             httpMethod:(CHDXCityHTTPMethod)httpMethod
                success:(void (^)(NSURLSessionDataTask *task, CHDXCityCommonResponse *response))success
                failure:(void (^)(NSURLSessionDataTask *task, NSError *error, CHDXCityCommonResponse *response))failure
        withRelationMap:(NSDictionary <NSString *, NSString *>*)relationMap
         uploadProgress:(void (^)(NSProgress *uploadProgress)) uploadProgress
       downloadProgress:(void (^)(NSProgress *downloadProgress)) downloadProgress;

{
    //Check HttpMethod
    
    NSString *methodDesc = [self fetchHttpMethodDescriptionWithHttpMethod:httpMethod];
    
    if (![self vaildateNoEmptyParametersWithParamtersKey:kHttpMethod withParameterVaule:methodDesc errorLevel:self.serviceConfiguration.errorLevel withFailure:failure]) {
        return;
    }
    
    //CheckReachbility
    NSString *reachbility = AFNetworkReachabilityStatusNotReachable == self.manager.reachabilityManager.networkReachabilityStatus ? nil : kNetworkingRechbility;

    if (![self vaildateNoEmptyParametersWithParamtersKey:kNetworkingRechbility withParameterVaule:reachbility errorLevel:CHDXCityServiceErrorLevel_FaildBlock withFailure:failure]) {
        return;
    }
    
    //Check Signature
    
    CHDXCitySignatureService * signatureService = [CHDXCitySignatureService shareInstanceWithConfig:nil]();
    NSDictionary *signDic = [signatureService signDataWithUrl:url withParams:params withHttpMethod:httpMethod];
    if (signDic) {
        //签名成功
        NSDictionary *headerData = signDic[XKSSignater_HEADER];
        url = signDic[XKSSignater_RESULT][XKSSignater_URI];
        params = signDic[XKSSignater_RESULT][XKSSignater_DATA];
        if (headerData) {
            if (headerData && [headerData count]) {
                [headerData enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                    [self.manager.requestSerializer setValue:obj forHTTPHeaderField:key];
                }];
            }
        }
        
        if (signDic.count == 0) {
            signDic = nil;
        }
        url = [self totalUrl:url];
    }
    
    //startNetworkingProcess
    NSError *serializationError = nil;
    NSMutableURLRequest *request = [self.manager.requestSerializer requestWithMethod:[self fetchHttpMethodDescriptionWithHttpMethod:httpMethod] URLString:[[NSURL URLWithString:url] absoluteString] parameters:params error:&serializationError];
    
    if (serializationError) {
        if (failure) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wgnu"
            __weak typeof (serializationError)weakSerializationError = serializationError;
            dispatch_async(dispatch_get_main_queue(), ^{
                __strong typeof (weakSerializationError)strongSerializationError = weakSerializationError;
                failure(nil, strongSerializationError, nil);
            });
#pragma clang diagnostic pop
        }
        
        return;
    }
    
    __block NSURLSessionDataTask *dataTask = nil;
    
    __weak typeof (self)weakself = self;
    dataTask = [[self manager] dataTaskWithRequest:request
                                    uploadProgress:uploadProgress
                                  downloadProgress:downloadProgress
                                 completionHandler:^(NSURLResponse * __unused response, id responseObject, NSError *error) {
                                     
                                     __weak typeof (error)weakError = error;
                                     dispatch_async(dispatch_get_main_queue(), ^{
                                     
                                         __strong typeof(weakError)strongError = weakError;
                                         if (error) {
                                             if (-1009 == [strongError code] || -1003 == [strongError code]) {
                                                 NSMutableDictionary *errorDic = [[NSMutableDictionary alloc]initWithDictionary: [strongError userInfo]];
                                                 
                                                 
                                                 errorDic[NSLocalizedFailureReasonErrorKey] = [weakself serverDiscription][kNetworkingRechbility][NSLocalizedFailureReasonErrorKey];
                                                 errorDic[NSLocalizedDescriptionKey] = [weakself serverDiscription][kNetworkingRechbility][NSLocalizedDescriptionKey];

                                                 NSUInteger code = [[weakself serverDiscription][kNetworkingRechbility][@"code"]integerValue];
                                                 strongError = [NSError errorWithDomain:[strongError domain] code:code userInfo:errorDic];
                                             }
                                             
                                             if (failure) {                                                 
                                                 failure(dataTask, strongError, nil);
                                             }
                                         } else {
                                             if ([signatureService vaildateEnable] && [response isKindOfClass:[NSHTTPURLResponse class]]) {
                                                 NSError *vaildateSignError = nil;
                                                 
                                                 NSString *responseString = (responseObject && [responseObject isKindOfClass:[NSDictionary class]] && responseObject[CHDXCityNetworkingServiceRawResponseData]) ? [[NSString alloc]initWithData:responseObject[CHDXCityNetworkingServiceRawResponseData] encoding:NSUTF8StringEncoding] : nil;
                                                 
                                                BOOL vaildateResponse = [XKSEncryptor validateResponseString:responseString header:((NSHTTPURLResponse *)response).allHeaderFields error:&vaildateSignError];
                                                 
                                                 if (!vaildateResponse || vaildateSignError) {
                                                     if (failure) {
                                                         NSMutableDictionary *errorDictionary =  [NSMutableDictionary dictionaryWithDictionary: vaildateSignError.userInfo];
                                                         errorDictionary[NSLocalizedDescriptionKey] = [weakself serverDiscription][kSignatureError][NSLocalizedDescriptionKey];
                                                         
                                                         NSError *failureError = vaildateSignError ?[NSError errorWithDomain:vaildateSignError.domain code:[[weakself serverDiscription][kSignatureError][@"code"]integerValue] userInfo:errorDictionary]:[NSError errorWithDomain:kCHDXCityNetworkingServiceErrorDomain code:[kCHDXCityNetworkingServiceErrorDomain integerValue] userInfo:errorDictionary];
                                                         
                                                         failure(dataTask, failureError, nil);
                                                     }
                                                     return ;
                                                 }
                                             }
                                             
                                             CHDXCityCoreDataService *coredataService = [CHDXCityCoreDataService shareInstanceWithConfig:nil]();
                                             
                                             CHDXCityCommonResponse *responseMo = (CHDXCityCommonResponse *)[coredataService parseResponseWithResponseObject:responseObject withParseClass:[CHDXCityCommonResponse class] withRelationMap:relationMap];
                                             
                                             if ([successResponseCode isEqualToString: [responseObject objectForKey:@"code"]]) {
                                                 if (success) {
                                                     success(dataTask,responseMo);
                                                 }
                                             } else if ([exception_unbindRespnoseCode isEqualToString:[responseObject objectForKey:@"code"]]) {
                                                                                                  
                                                 [[NSNotificationCenter defaultCenter]postNotificationName:CHDXCityNetworkingService_unbindRespnoseNotification object:self userInfo:nil];
                                                 
                                                 if (failure) {
                                                     
                                                     NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithDictionary:[self serverDiscription][exception_unbindRespnoseCode]];
                                                     if (responseMo && [responseMo desc]) {
                                                         userInfo[NSLocalizedFailureReasonErrorKey] = [responseMo desc];
                                                     }
                                                     NSError *error = [NSError errorWithDomain:kCHDXCityNetworkingServiceErrorDomain
                                                                                          code:[[self serverDiscription][exception_unbindRespnoseCode][@"code"] integerValue]
                                                                                      userInfo:userInfo];
                                                     failure(dataTask, error, responseMo);
                                                     
                                                 }
                                             } else {
                                                 if (failure) {
                                                     NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithDictionary:[self serverDiscription][kErrorResult]];
                                                     if (responseMo && [responseMo desc]) {
                                                         userInfo[NSLocalizedFailureReasonErrorKey] = [responseMo desc];
                                                     }
                                                     NSError *error = [NSError errorWithDomain:kCHDXCityNetworkingServiceErrorDomain
                                                                                          code:[kCHDXCityNetworkingServiceErrorDomain integerValue]
                                                                                      userInfo:userInfo];
                                                     failure(dataTask, error, responseMo);
                                                 }
                                             }
                                         }
                                     });
                                     
                                 }];
    [dataTask resume];

}

#pragma mark -
#pragma mark http method vaildate

-(BOOL)vaildateHttpMethodWithHttpMethod:(CHDXCityHTTPMethod)httpMethod
                                failure:(void (^)(NSURLSessionDataTask *task, NSError *error, CHDXCityCommonResponse *response))failure
;{
    BOOL vaildateResult = YES;
    NSString *methodDesc = [self fetchHttpMethodDescriptionWithHttpMethod:httpMethod];
    if (!methodDesc) {
        if (CHDXCityServiceErrorLevel_Default == self.serviceConfiguration.errorLevel) {
            return vaildateResult = NO;
        } else if (CHDXCityServiceErrorLevel_Assert == self.serviceConfiguration.errorLevel) {
            NSAssert(methodDesc, [self serverDiscription][kHttpMethod][NSLocalizedFailureReasonErrorKey]);
            return vaildateResult = NO;
        } else if (CHDXCityServiceErrorLevel_FaildBlock == self.serviceConfiguration.errorLevel) {
            if (failure) {
                NSError *error = [self createServiceErrorWithDomain:kCHDXCityNetworkingServiceErrorDomain withErrorCode: [[self serverDiscription][kHttpMethod][@"code"]integerValue] withErrorUserInfo:[self serverDiscription][kHttpMethod]];
                failure(nil, error, nil);
            }
            return vaildateResult = NO;
        }
    }
    return vaildateResult;
}

#pragma mark - 
#pragma mark signature 

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

- (NSString *)dataToJsonString:(id)object
{
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    if (!jsonData) {
//        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}

- (NSString *)totalUrl:(NSString *)url
{
    //部分url，不带域名或ip。
    if ([url rangeOfString:@"http"].location == NSNotFound /*&& [url rangeOfString:API_HOST].location == NSNotFound*/) {
        url = [NSString stringWithFormat:@"%@%@", API_HOST, url];
    }
    return url;
}

@end







