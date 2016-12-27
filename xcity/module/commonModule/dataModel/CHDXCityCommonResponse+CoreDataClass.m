//
//  CHDXCityCommonResponse+CoreDataClass.m
//  xcity
//
//  Created by 余妙玉 on 2016/12/27.
//  Copyright © 2016年 Lampard Hong. All rights reserved.
//

#import "CHDXCityCommonResponse+CoreDataClass.h"
#import "CHDXCityCommonResponseResult+CoreDataClass.h"
@implementation CHDXCityCommonResponse

- (NSDictionary *)transformKey;
{
    return @{@"desc":@"description"};
}

@end
