//
//  XMNetworkingService.h
//  ECoupon
//
//  Created by 余妙玉 on 16/6/1.
//  Copyright © 2016年 Xkeshi. All rights reserved.
//

#import "XMBaseService.h"
@class XMCommonResponse;
/**
 *  @author yomyoutama, 16-06-15 23:06:44
 *
 *  @brief  成功的code
 */
static NSString const *successResponseCode = @"0";

extern NSString * const XAppTypeCommonForIPhoneString;

/**
 *  @author yomyoutama, 16-06-15 23:06:51
 *
 *  @brief  异常code－未绑定
 */
static NSString const *exception_unbindRespnoseCode = @"S_1001";

/**
 *  @author yomyoutama, 16-06-22 15:06:43
 *
 *  @brief  未绑定的通知
 */
static NSString *XMNetworkingService_unbindRespnoseNotification = @"XMNetworkingService_unbindRespnoseNotification";


static NSString *kHttpMethod = @"kErrorMethod";
static NSString *kSignatureError = @"kSignatureError";
static NSString *kErrorResult = @"kErrorResult";
static NSString *kNetworkingRechbility = @"kNetworkingRechbility";
static NSString *kXMNetworkingServiceErrorDomain = @"com.NetworkingError.XM";


/**
 *  @author yomyoutama, 16-06-16 13:06:33
 *
 *  @brief  底层网络Service
 */
@interface XMNetworkingService : XMBaseService

/**
 *  @author yomyoutama, 16-06-06 13:06:24
 *
 *  @brief  发送请求通用入口
 *
 *  @param url              请求的地址
 *  @param params           请求的参数
 *  @param httpMethod       请求的方法 XMHTTPMethod 枚举值
 *  @param success          成功的回调（NSURLSessionDataTask *task, id responseObject）
 *  @param failure          失败的回调 (NSURLSessionDataTask *task, NSError *error)
 *  @param uploadProgress   上传的进度 POST,
 *  @param downloadProgress 下载的进度 GET,
 */
- (void)dataTaskWithUrl:(NSString *)url
                 params:(NSDictionary *)params
             httpMethod:(XMHTTPMethod)httpMethod
                success:(void (^)(NSURLSessionDataTask *task, XMCommonResponse *response))success
                failure:(void (^)(NSURLSessionDataTask *task, NSError *error, XMCommonResponse *response))failure
        withRelationMap:(NSDictionary <NSString *, NSString *>*)relationMap
         uploadProgress:(void (^)(NSProgress *uploadProgress)) uploadProgress
       downloadProgress:(void (^)(NSProgress *downloadProgress)) downloadProgress;

@end
