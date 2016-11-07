//
//  CHDXCityMapSence.m
//  xcity
//
//  Created by 余妙玉 on 16/11/7.
//  Copyright © 2016年 Lampard Hong. All rights reserved.
//

#import "CHDXCityMapSence.h"

#import "CHDXCityHKService.h"

@interface CHDXCityMapSence (){
    SKSpriteNode *iconNode;
    SKSpriteNode *backgroundNode;
    SKSpriteNode *goBtn;
}
@property (nonatomic, assign)BOOL isCreated;

@end

@implementation CHDXCityMapSence

-(void)didMoveToView:(SKView *)view {
    
    if (!self.isCreated) {
        [self createContent];
        self.isCreated = YES;

//    self.backgroundColor = [UIColor redColor];
    }
}

-(void)createContent;
{
    [self configBackgroundNode];
    
}

-(void)configBackgroundNode;
{
//    SKTexture *texture = [SKTexture textureWithImageNamed:@"continent0"];
    
//    SKLabelNode *backgroundNode = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
//    backgroundNode.text = @"Hello, World!";

    backgroundNode = [[SKSpriteNode alloc]initWithImageNamed:@"continent0"];
    backgroundNode.position = CGPointMake(100, 220);
//    backgroundNode.position = CGPointMake(CGRectGetMidX(self.frame),
//                                   CGRectGetMidY(self.frame));

//    backgroundNode.name = @"tsn";
    
    [self addChild:backgroundNode];
    CGPoint point =  CGPointMake(700 - backgroundNode.size.width/2 -23, 330-backgroundNode.size.height/2+268);
//    CGPoint x = [self.view convertPoint:point toScene:self];
    iconNode = [[SKSpriteNode alloc]initWithImageNamed:@"Instance_location"];
    iconNode.position = point;
    [backgroundNode addChild:iconNode];
    
    [self loadStepData];

    
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
       BOOL hit =  [goBtn containsPoint:location];
        if (hit) {
            SKAction *goAction = [SKAction sequence:@[
                                                      [SKAction moveTo:CGPointMake(778.5-backgroundNode.size.width/2 -23, 335-backgroundNode.size.height/2+268) duration:2],
                                                      [SKAction waitForDuration:0.2],
                                                      [SKAction moveTo:CGPointMake(860-backgroundNode.size.width/2 -23, 320-backgroundNode.size.height/2+268) duration:1]
                                                      ]];
            
            [iconNode runAction:goAction];

            
        }
    }
}

-(void)configPointIcon;
{
//    SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:@"goBtn.atlas"];
    NSMutableArray *pintTextures = [NSMutableArray array];
    for(int i = 0 ;i <=14; ++i) {
        NSString *imageName = [NSString stringWithFormat:@"btnGo%d",i];
        
        SKTexture *t = [SKTexture textureWithImageNamed:imageName] ;
        [pintTextures addObject:t];
    }
    goBtn = [[SKSpriteNode alloc]initWithTexture:[SKTexture textureWithImageNamed:@"btnGo0"]];
    goBtn.position = CGPointMake(CGRectGetMidX(self.scene.frame),
                                 CGRectGetMinY(self.scene.frame)+50);
    goBtn.name = @"goBtn";
//    [[self.scene addChild:goBtn];
    [self.scene addChild:goBtn];

    SKAction *walkAnimation = [SKAction animateWithTextures:pintTextures timePerFrame:2/[pintTextures count]];
    [goBtn runAction:walkAnimation];
    
    
    
}
-(void)loadStepData;
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSDateComponents *dateCom = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:[NSDate date]];
    
    
    
    NSDate *startDate, *endDate;
    
    endDate = [calendar dateFromComponents:dateCom];
    
    [dateCom setHour:0];
    
    [dateCom setMinute:0];
    
    [dateCom setSecond:0];
    
    startDate = [calendar dateFromComponents:dateCom];
    
    CHDXCityHKService *hkService = [CHDXCityHKService shareInstanceWithConfig:nil]();
    
    [hkService fetchStatisticsDataWithShareTypes:nil
                                       readTypes:[NSSet setWithObjects:[HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount], nil]
                            statisticsSampleType:[HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount]
                                   withStartDate:startDate
                                     withEndDate:endDate
                           initialResultsHandler:^(HKStatisticsCollectionQuery * _Nonnull query, HKStatisticsCollection * _Nullable result) {
                                                              if (result.statistics) {
                                   [result.statistics enumerateObjectsUsingBlock:^(HKStatistics * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                                       NSLog(@"query %@ result %@",query,result);
                                       
                                       NSNumber  *stepCount = [NSNumber numberWithDouble:[[obj sumQuantity]doubleValueForUnit:[HKUnit countUnit]]];
                                       
                                       SKLabelNode *labelStepCountNode = [[SKLabelNode alloc]initWithFontNamed:@"Chalkduster"];
                                       
                                       labelStepCountNode.text = [NSString stringWithFormat:@"%d", [stepCount intValue]];
                                       labelStepCountNode.fontSize = 15;
                                       labelStepCountNode.fontColor = [SKColor redColor];
//                                       labelStepCountNode.position = CGPointMake(-40 + backgroundNode.size.width/2, 40 -backgroundNode.size.height /2 );
                                       labelStepCountNode.position = CGPointMake(CGRectGetMaxX(self.scene.frame)-25,
                                                                                 CGRectGetMinY(self.scene.frame)+50);

                                       
//                                       SKTexture *texture = [SKTextureAtlas ]
                                       
                                       
                                       
                                       
                                       
                                       dispatch_async(dispatch_get_main_queue(), ^{
                                           [self configPointIcon];

                                           [self.scene addChild:labelStepCountNode];
                                           
                                           


                                       });
                                       
//                                       NSLog(@"%f" ,stepCount);
                                       
                                   }];
                               }
                           }
                         statisticsUpdateHandler:^(HKStatisticsCollectionQuery * _Nonnull query, HKStatistics * _Nullable statistics, HKStatisticsCollection * _Nullable collection) {
                             NSLog(@"query %@ collection %@",query,collection);
                             
                         }
                                     withFailure:^(HKStatisticsCollectionQuery * _Nonnull query, HKStatisticsCollection * _Nullable result, NSError * _Nullable error) {
                                         NSLog(@"query %@ error %@",query,error);
                                         
                                     }];
    

}

//-(void)configPersonIconNode;
//{
//
//}

//-(void)update:(CFTimeInterval)currentTime {
//}

//-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//}
@end
