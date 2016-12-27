//
//  CHDXCityNetworkingService.h
//  ECoupon
//
//  Created by 余妙玉 on 16/6/1.
//  Copyright © 2016年 Xkeshi. All rights reserved.
//

#import "CHDXCityBaseService.h"
@class CHDXCityCommonResponse;



/**
 *  @author yomyoutama, 16-06-15 23:06:44
 *
 *  @brief  成功的code
 */
FOUNDATION_EXPORT NSString * const successResponseCode;

FOUNDATION_EXPORT NSString * const XAppTypeCommonForIPhoneString;

/**
 *  @author yomyoutama, 16-06-15 23:06:51
 *
 *  @brief  异常code－未绑定
 */
FOUNDATION_EXPORT NSString * const exception_unbindRespnoseCode;

/**
 *  @author yomyoutama, 16-06-22 15:06:43
 *
 *  @brief  未绑定的通知
 */
FOUNDATION_EXPORT NSString * const CHDXCityNetworkingService_unbindRespnoseNotification;

FOUNDATION_EXPORT NSString * const CHDXCityNetworkingServiceRawResponseData;

FOUNDATION_EXPORT NSString * const kHttpMethod;
FOUNDATION_EXPORT NSString * const kSignatureError;
FOUNDATION_EXPORT NSString * const kErrorResult;
FOUNDATION_EXPORT NSString * const kNetworkingRechbility;
FOUNDATION_EXPORT NSString * const kCHDXCityNetworkingServiceErrorDomain;


/**
 *  @author yomyoutama, 16-06-16 13:06:33
 *
 *  @brief  底层网络Service
 */
@interface CHDXCityNetworkingService : CHDXCityBaseService

/**
 *  @author yomyoutama, 16-06-06 13:06:24
 *
 *  @brief  发送请求通用入口
 *
 *  @param url              请求的地址
 *  @param params           请求的参数
 *  @param httpMethod       请求的方法 CHDXCityHTTPMethod 枚举值
 *  @param success          成功的回调（NSURLSessionDataTask *task, id responseObject）
 *  @param failure          失败的回调 (NSURLSessionDataTask *task, NSError *error)
 *  @param uploadProgress   上传的进度 POST,
 *  @param downloadProgress 下载的进度 GET,
 */
- (void)dataTaskWithUrl:(NSString *)url
                 params:(NSDictionary *)params
             httpMethod:(CHDXCityHTTPMethod)httpMethod
                success:(void (^)(NSURLSessionDataTask *task, CHDXCityCommonResponse *response))success
                failure:(void (^)(NSURLSessionDataTask *task, NSError *error, CHDXCityCommonResponse *response))failure
        withRelationMap:(NSDictionary <NSString *, NSString *>*)relationMap
         uploadProgress:(void (^)(NSProgress *uploadProgress)) uploadProgress
       downloadProgress:(void (^)(NSProgress *downloadProgress)) downloadProgress;

@end
