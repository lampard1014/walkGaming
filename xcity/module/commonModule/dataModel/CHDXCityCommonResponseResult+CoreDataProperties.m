//
//  CHDXCityCommonResponseResult+CoreDataProperties.m
//  xcity
//
//  Created by 余妙玉 on 2016/12/27.
//  Copyright © 2016年 Lampard Hong. All rights reserved.
//

#import "CHDXCityCommonResponseResult+CoreDataProperties.h"

@implementation CHDXCityCommonResponseResult (CoreDataProperties)

+ (NSFetchRequest<CHDXCityCommonResponseResult *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"CHDXCityCommonResponseResult"];
}

@dynamic response;

@end
