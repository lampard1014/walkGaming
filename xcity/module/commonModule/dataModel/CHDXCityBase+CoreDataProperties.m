//
//  CHDXCityBase+CoreDataProperties.m
//  xcity
//
//  Created by 余妙玉 on 2016/12/27.
//  Copyright © 2016年 Lampard Hong. All rights reserved.
//

#import "CHDXCityBase+CoreDataProperties.h"

@implementation CHDXCityBase (CoreDataProperties)

+ (NSFetchRequest<CHDXCityBase *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"CHDXCityBase"];
}


@end
