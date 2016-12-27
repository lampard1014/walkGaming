//
//  CHDXCityCommonResponse+CoreDataProperties.m
//  xcity
//
//  Created by 余妙玉 on 2016/12/27.
//  Copyright © 2016年 Lampard Hong. All rights reserved.
//

#import "CHDXCityCommonResponse+CoreDataProperties.h"

@implementation CHDXCityCommonResponse (CoreDataProperties)

+ (NSFetchRequest<CHDXCityCommonResponse *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"CHDXCityCommonResponse"];
}

@dynamic code;
@dynamic desc;
@dynamic result;

@end
