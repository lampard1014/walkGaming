//
//  XCMCoreDataModelService.m
//  NewMDT
//
//  Created by 余妙玉 on 16/1/7.
//  Copyright © 2016年 Lampard Hong. All rights reserved.
//

#import "XMCoreDataService.h"
#import "XMBase.h"

static NSString *XMManagedObjectModelName = @"XMDataModel";

static NSString *configurationName_SaveInSqlite = @"SaveInSqlite";

static NSString *configurationName_SaveInMemory = @"SaveInMemory";

static NSString *configurationName_Default = @"Default";


@interface XMCoreDataService(){
    
}

@property (nonatomic, strong)NSPersistentStoreCoordinator *mainThreadPersistentStoreCoordinator;

@property (nonatomic, strong)NSPersistentStoreCoordinator *backgroundThreadPersistentStoreCoordinator;

@end

@implementation XMCoreDataService

static XMCoreDataService *shareInstance;

+ (instancetype(^)(void))shareInstanceWithConfig:(XMBaseServiceConfigurationObject *)config;
{
    static dispatch_once_t predicate;
    
    return ^XMCoreDataService *{
        
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
    // setup managed object model
    [self managedObjectModel];
    
    // setup persistent store coordinator
    self.mainThreadPersistentStoreCoordinator =[[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.mom];
    
    self.backgroundThreadPersistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc]initWithManagedObjectModel:self.mom];
    
    NSDictionary* options = @{NSMigratePersistentStoresAutomaticallyOption : @YES,NSInferMappingModelAutomaticallyOption : @YES};
    
    
    [self.mainThreadPersistentStoreCoordinator addPersistentStoreWithType:NSInMemoryStoreType configuration:configurationName_Default URL:[self fetchStoreURL] options:options error:nil];
  
    [self.backgroundThreadPersistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:configurationName_SaveInSqlite URL:[self fetchStoreURL] options:options error:nil];
    
    // setup Moc
    [self mainMOC];
    [self backgoundMOC];
}

-(NSURL *)fetchStoreURL;
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *documentsURL = [[fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];

    NSURL *storeURL = [documentsURL URLByAppendingPathComponent:[XMManagedObjectModelName stringByAppendingPathExtension:@"sqlite"]];
    return storeURL;
}


- (NSManagedObjectModel *)managedObjectModel
{
    if (!self.mom) {
        
        NSURL *modelURL = [[NSBundle mainBundle] URLForResource:XMManagedObjectModelName withExtension:@"momd"];
        
        NSManagedObjectModel *_managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
        
        self.mom =  _managedObjectModel;

    }
    return self.mom;
}

- (NSManagedObjectContext *)mainMOC {
    if (!_mainMOC) {
        _mainMOC = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        _mainMOC.persistentStoreCoordinator = self.mainThreadPersistentStoreCoordinator;

    }
    return _mainMOC;
}

- (NSManagedObjectContext *)backgoundMOC {
    if (!_backgoundMOC) {
        self->_backgoundMOC = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        
//        self->_mainMOC.parentContext = _backgoundMOC;
        
        self->_backgoundMOC.persistentStoreCoordinator = self.backgroundThreadPersistentStoreCoordinator;
    }
    return _backgoundMOC;
}


-(BOOL)fetchWithRequest:(NSFetchRequest *)fetchRequest;
{
    NSError *error;
    self.fetchResult = [_mainMOC.parentContext executeFetchRequest:fetchRequest error:&error];
    return !error;
//    __weak typeof (self) weakself = self;
//    return ^XCMCoreDataModelService *(NSFetchRequest *fetchRequest){
//
//        [_mainMOC.parentContext executeFetchRequest:fetchRequest error:nil];
//        return shareInstance;
//    };
}

-(XMBase *)initaializeManagedObjectWithCls:(Class)class;
{
    
    return class ? [self initaializeManagedObjectWithCls:class withMoc:self.mainMOC] : nil;
}


-(XMBase *)initaializeManagedObjectWithCls:(Class)class withMoc:(NSManagedObjectContext *)moc;
{
    NSManagedObjectContext *processMoc = moc ? : [self mainMOC];
    
    return ([class isSubclassOfClass:[XMBase class]]) ? [NSEntityDescription insertNewObjectForEntityForName:[class entityName] inManagedObjectContext:processMoc] : nil;
}

- (XMBase *)copyManageObjectBy:(XMBase *)obj;
{
    XMBase *emptyCopy = [self initaializeManagedObjectWithCls:[obj class]];
    __weak typeof(self)weakself = self;
    
    [[[emptyCopy entity]properties]enumerateObjectsUsingBlock:^(__kindof NSPropertyDescription * _Nonnull property, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([property isKindOfClass:[NSAttributeDescription class]]) {
            if ([obj valueForKey:[property name]]) {
                [emptyCopy setValue:[obj valueForKey:[property name]] forKey:[property name]];
            }
        } else if ([property isKindOfClass:[NSRelationshipDescription class]]) {
            NSRelationshipDescription *relationProperty = (NSRelationshipDescription *)property;
            
            if (!relationProperty || ![relationProperty destinationEntity]) {
                return ;
            }
            NSString *destEntityName = [[relationProperty destinationEntity] name];
            if ([destEntityName isEqualToString:NSStringFromClass([obj class])]) {
                return ;
            }
            if ([relationProperty isToMany]) {
                __block NSMutableOrderedSet *newDestSet = [[NSMutableOrderedSet alloc]init];
                
                [[obj valueForKey:[property name]]enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([obj isKindOfClass:[XMBase class]]){
                        XMBase *tempobj = [weakself copyManageObjectBy:(XMBase *)obj];
                        [newDestSet addObject:tempobj];
                    }
                }];
                [emptyCopy setValue:newDestSet forKey:[property name]];
            } else {
//                if ([obj valueForKey:[property name]] && [[obj valueForKey:[property name]]isKindOfClass:[XCMBase class]]) {
//                    XCMBase *tempobj = [weakself copyManageObjectBy:(XCMBase *)[obj valueForKey:[property name]]];
//                    [emptyCopy setValue:tempobj forKey:[property name]];
//                }
            }
        }
    }];
    return emptyCopy;
}


- (BOOL)detectHasChangeWithManagedObject:(NSManagedObject *)mo;
{
    
    if ([mo hasChanges]) {
        return YES;
    } else {
        
        BOOL hasChange = NO;
        
        for (NSPropertyDescription *propertyDesc in mo.entity.properties) {
            if ([propertyDesc isKindOfClass:[NSRelationshipDescription class]] && [(NSRelationshipDescription *)propertyDesc isToMany]) {
                
                

                for (id innerMo in [mo valueForKey:[propertyDesc name]]) {

                    if ([innerMo isKindOfClass:[NSManagedObject class]]) {
                        hasChange = [self detectHasChangeWithManagedObject:(NSManagedObject *)innerMo];
                    }
                    if (hasChange) {
                        return hasChange;
                    }
                }
            }
        }
        
        return hasChange;
    }
}


- (void)saveWithMoc:(NSManagedObjectContext *)moc
            success:(void(^)(void))success
            failure:(void (^)(NSError *error))failure;
{
    NSManagedObjectContext *processMoc = moc ? : [self mainMOC];
    
    NSError *saveError;
    if ([processMoc save:&saveError]) {
        if (success) {
            success();
        }
    } else {
        if (failure) {
            failure(saveError);
        }
    }
}

- (NSArray <NSManagedObject *>*)fetchManageObjectsWithRequest:(NSFetchRequest *)request
                                                      withMoc:(NSManagedObjectContext *)moc
                                                      success:(void(^)(NSArray <NSManagedObject *>* manageObjectCollection))success
                                                      failure:(void (^)(NSError *error))failure;
{
    NSError *error = nil;
    NSManagedObjectContext *processMoc = moc ? : self.mainMOC;
    
    NSArray *results = [processMoc executeFetchRequest:request error:&error];
    
    if (!results) {
        if (failure) {
            failure(error);
        }
    } else {
        if (success) {
            success(results);
        }
    }
    return results;
}

- (NSArray <NSManagedObject *>*)fetchManageObjectsWithRequest:(NSFetchRequest *)request;
{
    return [self fetchManageObjectsWithRequest:request withMoc:self.mainMOC];
}

- (NSArray <NSManagedObject *>*)fetchManageObjectsWithRequest:(NSFetchRequest *)request withMoc:(NSManagedObjectContext *)moc;
{
    NSManagedObjectContext *processMoc = moc ? : [self mainMOC];
    return [self fetchManageObjectsWithRequest:request withMoc:processMoc success:nil failure:nil];
}

-(BOOL)deleteManageObject:(NSManagedObject *)mo;
{
    return [self deleteManageObject:mo withMoc:self.mainMOC];
}

-(BOOL)deleteManageObject:(NSManagedObject *)mo withMoc:(NSManagedObjectContext *)moc;
{
    if (mo) {
        
        NSManagedObjectContext *processMoc = moc ? : [self mainMOC];
        [processMoc deleteObject:mo];
        return YES;
    } else {
        return NO;
    }

}

- (XMBase *)parseResponseWithResponseObject:(id)responseObject
                             withParseClass:(Class)className
                            withRelationMap:(NSDictionary <NSString *, NSString *>*)relationMap;
{
    
    XMBase *mo = (XMBase *)[self initaializeManagedObjectWithCls:className];
    
    if ([className isSubclassOfClass:[XMBase class]] && [responseObject isKindOfClass:[NSDictionary class]]) {
        
        NSArray <__kindof NSPropertyDescription *> *modelProperties =  mo.entity.properties;
        
        [modelProperties enumerateObjectsUsingBlock:^(__kindof NSPropertyDescription * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            NSString *key = obj.name;
            
            NSString *modelKey = [mo transformKey][key];
            
            NSString *realKey = modelKey ? : key;
            
            if ([obj isKindOfClass:[NSRelationshipDescription class]] && responseObject[realKey]) {
                
                if ([(NSRelationshipDescription *)obj isToMany]) {
                    //To many
                    NSArray *dataArr;
                    if (![responseObject[realKey]  isKindOfClass:[NSArray class]]) {
                        dataArr = @[responseObject[realKey]];
                    } else {
                        dataArr = [NSArray arrayWithArray:(NSArray *)responseObject[realKey]];
                    }
                    NSMutableOrderedSet *orderSet = [[NSMutableOrderedSet alloc]initWithCapacity:[dataArr count]];
                    
                    [dataArr enumerateObjectsUsingBlock:^(id  _Nonnull dataArrData, NSUInteger idx, BOOL * _Nonnull stop) {
                        XMBase *enumMo = nil;
                        if (relationMap && relationMap[[obj name]]) {
                            enumMo = [self parseResponseWithResponseObject:dataArrData withParseClass:NSClassFromString(relationMap[[obj name]]) withRelationMap:relationMap];
                        } else {
                            enumMo = [self parseResponseWithResponseObject:dataArrData withParseClass:[[[(NSRelationshipDescription *)obj destinationEntity]managedObjectModel]class] withRelationMap:relationMap];
                        }
                        if (enumMo) {
                            [orderSet addObject:enumMo];
                        }
                    }];
                    
                    [mo setValue:orderSet forKey:[obj name]];
                    
                } else {
                    //To one
                    XMBase *enumMo = nil;
                    if (relationMap && relationMap[[obj name]]) {
                        enumMo = [self parseResponseWithResponseObject:responseObject[realKey] withParseClass:NSClassFromString(relationMap[[obj name]]) withRelationMap:relationMap];
                    } else {
                        enumMo = [self parseResponseWithResponseObject:responseObject[realKey] withParseClass:[[[(NSRelationshipDescription *)obj destinationEntity]managedObjectModel]class] withRelationMap:relationMap];
                    }
                    [mo setValue:enumMo forKey:[obj name]];
                }
            } else if ([obj isKindOfClass:[NSAttributeDescription class]]) {
                if (responseObject[realKey] && ![responseObject[realKey] isKindOfClass:[NSNull class]]) {
                    [mo setValue:responseObject[realKey] forKey:key];
                }
            }
        }];
    }
    return mo;
}

@end
