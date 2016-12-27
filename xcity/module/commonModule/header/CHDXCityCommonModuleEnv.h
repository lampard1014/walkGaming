//
//  CHDXCityCommonModuleEnv.h
//  xcity
//
//  Created by 余妙玉 on 2016/12/27.
//  Copyright © 2016年 Lampard Hong. All rights reserved.
//

#ifndef CHDXCityCommonModuleEnv_h
#define CHDXCityCommonModuleEnv_h


#ifdef  ENVOIRMENT_DEVELOPMENT
//static NSString *API_HOST = @"http://192.168.181.145:8018";//日常开发
static NSString *API_HOST = @"http://openapi.dev.xka.so:8082";//开发服务器 // http://openapi.dev.xka.so:8082

//签名信息
static NSString *CHDXCitySignAppID = @"x-7f3c602c00134068bca820f5fac243b2";
static NSString *CHDXCitySignMD5Secret = @"782a700475564d4baae98479ac8fef70";

#elif defined ENVOIRMENT_DEBUG
static NSString *API_HOST = @"http://api.dev.xkeshi.so:8082";//开发服务器
static NSString *CHDXCitySignAppID = @"x-7f3c602c00134068bca820f5fac243b2";
static NSString *CHDXCitySignMD5Secret = @"782a700475564d4baae98479ac8fef70";

#elif defined ENVOIRMENT_BETA
static NSString *API_HOST = @"http://api.test.xkeshi.so:8082";//内测服务器
static NSString *CHDXCitySignAppID = @"x-3ff3dc51556648178daac03ee6e888ff";
static NSString *CHDXCitySignMD5Secret = @"70eecf5a6dda480893e258bc6be1ca8d";

#elif defined ENVOIRMENT_PREVIEW
static NSString *API_HOST = @"http://api.prepub.xkeshi.net";//预发布服务器
static NSString *CHDXCitySignAppID = @"x-b1f3ead0bf2f4e1f926b1258822b32d0";//
static NSString *CHDXCitySignMD5Secret = @"2b8d2f0f495f443258cc424ca81f25d2";//

#elif defined ENVOIRMENT_RELEASE
static NSString *API_HOST = @"http://api.xkeshi.net";//发布服务器
static NSString *CHDXCitySignAppID = @"x-3351f9d26d0f4f0aa85b1cbfe374579c";
static NSString *CHDXCitySignMD5Secret = @"";

#else
static NSString *API_HOST = @"http://api.xkeshi.net";//发布服务器
static NSString *CHDXCitySignAppID = @"x-3351f9d26d0f4f0aa85b1cbfe374579c";
static NSString *CHDXCitySignMD5Secret = @"";


#endif



#endif /* CHDXCityCommonModuleEnv_h */
