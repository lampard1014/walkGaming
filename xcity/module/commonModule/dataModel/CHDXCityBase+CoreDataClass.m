//
//  CHDXCityBase+CoreDataClass.m
//  xcity
//
//  Created by 余妙玉 on 2016/12/27.
//  Copyright © 2016年 Lampard Hong. All rights reserved.
//

#import "CHDXCityBase+CoreDataClass.h"

@implementation CHDXCityBase
+ (NSString *) entityName;
{
    return NSStringFromClass([self class]);
}

- (NSDictionary *)transformKey;
{
    return @{};
}
@end
