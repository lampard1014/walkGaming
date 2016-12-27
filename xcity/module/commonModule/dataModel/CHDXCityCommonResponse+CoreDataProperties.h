//
//  CHDXCityCommonResponse+CoreDataProperties.h
//  xcity
//
//  Created by 余妙玉 on 2016/12/27.
//  Copyright © 2016年 Lampard Hong. All rights reserved.
//

#import "CHDXCityCommonResponse+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface CHDXCityCommonResponse (CoreDataProperties)

+ (NSFetchRequest<CHDXCityCommonResponse *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *code;
@property (nullable, nonatomic, copy) NSString *desc;
@property (nullable, nonatomic, retain) CHDXCityCommonResponseResult *result;

@end

NS_ASSUME_NONNULL_END
