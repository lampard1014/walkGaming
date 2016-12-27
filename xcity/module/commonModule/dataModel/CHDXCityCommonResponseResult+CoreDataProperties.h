//
//  CHDXCityCommonResponseResult+CoreDataProperties.h
//  xcity
//
//  Created by 余妙玉 on 2016/12/27.
//  Copyright © 2016年 Lampard Hong. All rights reserved.
//

#import "CHDXCityCommonResponseResult+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface CHDXCityCommonResponseResult (CoreDataProperties)

+ (NSFetchRequest<CHDXCityCommonResponseResult *> *)fetchRequest;

@property (nullable, nonatomic, retain) CHDXCityCommonResponse *response;

@end

NS_ASSUME_NONNULL_END
