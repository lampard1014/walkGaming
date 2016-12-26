//
//  XMUserDefaultsService.h
//  ECoupon
//
//  Created by 余妙玉 on 16/6/13.
//  Copyright © 2016年 Xkeshi. All rights reserved.
//

#import "XMBaseService.h"

@interface XMUserDefaultsService : XMBaseService

/**
 *  @author Lampard Hong, 16-01-18 10:01:13
 *
 *  @brief  最后一次获取的结果集合
 *
 *  @since 1.0
 */
@property (nonatomic,strong)id fetchResult;
/**
 *  @author Lampard Hong, 16-01-18 10:01:25
 *
 *  @brief  根据指定的key来获取结果
 *
 *  @since 1.0
 */
-(NSArray* (^)(NSString * key))fetchArrayByKey;
/**
 *  @author Lampard Hong, 16-01-18 10:01:51
 *
 *  @brief  去除指定key的array
 *
 *  @since 1.0
 */
-(BOOL (^)(NSString * key))removeArrayByKey;
/**
 *  @author Lampard Hong, 16-01-18 10:01:23
 *
 *  @brief  根据指定的key增加数据
 *
 *  @since 1.0
 */
-(BOOL (^)(NSString * key, NSString *addKeyWord))addFetchArrayByKey;
/**
 *  @author Lampard Hong, 16-01-18 10:01:44
 *
 *  @brief  保存指定的key
 *
 *  @since 1.0
 */
-(BOOL (^)(NSString * key, NSArray * resultArray))saveFetchArrayByKey;

/**
 *  @author yomyoutama, 16-06-13 14:06:15
 *
 *  @brief  获取bool值
 */
-(BOOL (^)(NSString *key))fetchBoolByKey;

/**
 *  @author yomyoutama, 16-06-13 14:06:29
 *
 *  @brief  save指定的key
 */
-(BOOL (^)(NSString *key, BOOL value))saveBoolValueByKey;


@end
