//
//  XCMCoreDataModelService.h
//  NewMDT
//
//  Created by 余妙玉 on 16/1/7.
//  Copyright © 2016年 Lampard Hong. All rights reserved.
//

#import "CHDXCityBaseService.h"
#import <CoreData/CoreData.h>


@class CHDXCityBase;


FOUNDATION_EXPORT NSString * const CHDXCityManagedObjectModelName;

FOUNDATION_EXPORT NSString * const configurationName_SaveInSqlite;

FOUNDATION_EXPORT NSString * const configurationName_SaveInMemory;

FOUNDATION_EXPORT NSString * const configurationName_Default;


/**
 *  @author Lampard Hong, 16-01-18 10:01:09
 *
 *  @brief  数据模型操作相关service
 *
 *  @since 1.0
 */
@interface CHDXCityCoreDataService : CHDXCityBaseService

/**
 *  @author Lampard Hong, 16-01-18 10:01:28
 *
 *  @brief  最后获取的结果集合
 *
 *  @since 1.0
 */
@property (nonatomic, strong)NSArray *fetchResult;

/**
 *  @author Lampard Hong, 16-01-18 10:01:42
 *
 *  @brief  当前的ManagedObjectModel
 *
 *  @since 1.0
 */
@property (nonatomic, strong)NSManagedObjectModel *mom;

/**
 *  @author Lampard Hong, 16-01-18 10:01:55
 *
 *  @brief  当前的主线程moc
 *
 *  @since 1.0
 */
@property (nonatomic, strong)NSManagedObjectContext *mainMOC;

/**
 *  @author Lampard Hong, 15-11-19 18:11:15
 *
 *  @brief  后台MOC
 *
 *  @since 1.0
 */
@property (nonatomic, strong)NSManagedObjectContext *backgoundMOC;



//- (NSString *(^)(void))getSearchResultUserDefaultEntityName;
//
//- (NSString *(^)(void))getSearchResultInTimeEntityName;
//
//- (NSString *(^)(void))getSearchResultResponseEntityName;
//
//- (NSString *(^)(void))getTemplateCollectionEntityName;

/**
 *  @author Lampard Hong, 16-01-18 10:01:15
 *
 *  @brief  获取数据
 *
 *  @param fetchRequest @NSFetchRequest
 *
 *  @return 是否成功
 *
 *  @since 1.0
 */
-(BOOL)fetchWithRequest:(NSFetchRequest *)fetchRequest;

/**
 *  @author Lampard Hong, 16-01-18 10:01:46
 *
 *  @brief  创建一个新的模型
 *
 *  @param class ［ManagedObject class］
 *
 *  @return @class XCMBase
 *
 *  @since 1.0
 */
-(CHDXCityBase *)initaializeManagedObjectWithCls:(Class)class;

-(CHDXCityBase *)initaializeManagedObjectWithCls:(Class)class withMoc:(NSManagedObjectContext *)moc;

/**
 *  @author yomyoutama, 16-03-16 10:03:44
 *
 *  @brief  只复制save或者last fetch的内容 深度复制
 *
 *  @param obj @class NSManagedObject
 *
 *  @return the copy one
 */
- (CHDXCityBase *)copyManageObjectBy:(CHDXCityBase *)obj;


/**
 *  @author yomyoutama, 16-06-14 09:06:55
 *
 *  @brief  监测mo 是否贝修改过
 *
 *  @param mo NSManagedObject
 *
 *  @return yes/no
 */
- (BOOL)detectHasChangeWithManagedObject:(NSManagedObject *)mo;


/**
 *  @author yomyoutama, 16-06-14 09:06:37
 *
 *  @brief  生成已赋值的特定的CHDXCityBase子类对象
 *
 *  @param responseObject 赋值object
 *  @param className      需生成的目标子类
 *  @param relationMap    relationship的特殊映射关系
 *
 *  @return 解析返回内存中的CHDXCityBase子类对象
 */
- (CHDXCityBase *)parseResponseWithResponseObject:(id)responseObject
                             withParseClass:(Class)className
                            withRelationMap:(NSDictionary <NSString *, NSString *>*)relationMap;

/**
 *  @author yomyoutama, 16-06-14 17:06:39
 *
 *  @brief  保存操作
 *
 *  @param moc     moc
 *  @param success
 *  @param failure
 */
- (void)saveWithMoc:(NSManagedObjectContext *)moc
            success:(void(^)(void))success
            failure:(void (^)(NSError *error))failure;


- (NSArray <NSManagedObject *>*)fetchManageObjectsWithRequest:(NSFetchRequest *)request
                                                      withMoc:(NSManagedObjectContext *)moc
                                                      success:(void(^)(NSArray <NSManagedObject *>* manageObjectCollection))success
                                                      failure:(void (^)(NSError *error))failure;

- (NSArray <NSManagedObject *>*)fetchManageObjectsWithRequest:(NSFetchRequest *)request;

- (NSArray <NSManagedObject *>*)fetchManageObjectsWithRequest:(NSFetchRequest *)request withMoc:(NSManagedObjectContext *)moc;


-(BOOL)deleteManageObject:(NSManagedObject *)mo;
-(BOOL)deleteManageObject:(NSManagedObject *)mo withMoc:(NSManagedObjectContext *)moc;



@end
