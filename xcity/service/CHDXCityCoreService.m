//
//  CHDXCityCoreService.m
//  xcity
//
//  Created by 余妙玉 on 16/11/1.
//  Copyright © 2016年 Lampard Hong. All rights reserved.
//

#import "CHDXCityCoreService.h"


static CHDXCityCoreService *shareInstance;


@interface CHDXCityCoreService ()
{

}

@end

@implementation CHDXCityCoreService

#pragma mark -
#pragma mark @protocl CHDXCityCoreServiceProtocol

@synthesize serviceConfig;
@synthesize serviceError;

/**
 *  @author Lampard Hong, 16-01-07 20:01:55
 *
 *  @brief  单例入口
 *
 *  @param config @class XCMServiceConfig
 *
 *  @since 1.0
 */
+ (instancetype(^)(void))shareInstanceWithConfig:(id<CHDXCityServiceConfigModelProtocol>)config;
{
    static dispatch_once_t predicate;
    
    return ^CHDXCityCoreService *{
        
        if (!shareInstance) {
            dispatch_once(&predicate, ^{
                shareInstance = [[self alloc]init];
                shareInstance.serviceConfig = config;
                [shareInstance basicInit];
                
            });
            
        }
        return shareInstance;
    };
}


-(void)basicInit;
{
    
}

@end
