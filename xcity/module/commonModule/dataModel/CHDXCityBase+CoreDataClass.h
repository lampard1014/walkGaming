//
//  CHDXCityBase+CoreDataClass.h
//  xcity
//
//  Created by 余妙玉 on 2016/12/27.
//  Copyright © 2016年 Lampard Hong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface CHDXCityBase : NSManagedObject



- (NSDictionary *)transformKey;

+ (NSString *) entityName;


@end

NS_ASSUME_NONNULL_END

#import "CHDXCityBase+CoreDataProperties.h"
