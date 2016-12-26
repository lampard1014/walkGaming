//
//  XMSignatureService.h
//  ECoupon
//
//  Created by 余妙玉 on 16/6/1.
//  Copyright © 2016年 Xkeshi. All rights reserved.
//

#import "XMBaseService.h"


/**
 *  @author yomyoutama, 16-06-16 13:06:15
 *
 *  @brief  签名相关服务
 */
@interface XMSignatureService : XMBaseService
/**
 *  @author yomyoutama, 16-06-16 13:06:25
 *
 *  @brief  验签和签名模式
 */
@property (nonatomic, assign, getter = fetchXMXMSignatureType)XMXMSignatureType signatureType;

/**
 *  @author yomyoutama, 16-06-16 13:06:59
 *
 *  @brief  签名对指定的url和prameter 签名
 *
 *  @param url        url地址
 *  @param params     prameters
 *  @param httpMethod 请求的方式
 *
 *  @return 签名信息
 */
-(NSDictionary *)signDataWithUrl:(NSString *)url
                      withParams:(NSDictionary *)params
                  withHttpMethod:(XMHTTPMethod)httpMethod;

/**
 *  @author yomyoutama, 16-06-16 13:06:59
 *
 *  @brief  是否需要签名
 *
 *  @return yes/no
 */
-(BOOL)signatureEnable;

/**
 *  @author yomyoutama, 16-06-16 13:06:59
 *
 *  @brief  是否需要验签
 *
 *  @return yes/no
 */
-(BOOL)vaildateEnable;
@end
