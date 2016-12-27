//
//  CHDXCityCommonModuleEnum.h
//  xcity
//
//  Created by 余妙玉 on 2016/12/27.
//  Copyright © 2016年 Lampard Hong. All rights reserved.
//

#ifndef CHDXCityCommonModuleEnum_h
#define CHDXCityCommonModuleEnum_h
typedef NS_OPTIONS(NSUInteger, CHDXCityHTTPMethod)
{
    CHDXCityHTTPMethod_Options = 0,
    CHDXCityHTTPMethod_Get    = 1,
    CHDXCityHTTPMethod_Head   = 2,
    CHDXCityHTTPMethod_Post   = 3,
    CHDXCityHTTPMethod_Put    = 4,
    CHDXCityHTTPMethod_Delete = 5,
    CHDXCityHTTPMethod_Trace  = 6,
    CHDXCityHTTPMethod_Connect = 7
};

typedef NS_OPTIONS(NSUInteger, CHDXCitySignatureType){
    CHDXCitySignatureType_Neither   =   1   <<  2,
    CHDXCitySignatureType_Request   =   1   <<  1,
    CHDXCitySignatureType_Response  =   1   <<  0,
    CHDXCitySignatureType_Both      =   0,
    CHDXCitySignatureType_Default   =   CHDXCitySignatureType_Both,
};


#endif /* CHDXCityCommonModuleEnum_h */
