//
//  CHDXCityMapSence.m
//  xcity
//
//  Created by 余妙玉 on 16/11/7.
//  Copyright © 2016年 Lampard Hong. All rights reserved.
//

#import "CHDXCityMapSence.h"
#import "CHDXCityMainSence.h"
#import "CHDXCityHKService.h"

@interface CHDXCityMapSence (){
    SKSpriteNode *iconNode;
    SKSpriteNode *backgroundNode;
    SKSpriteNode *goBtn;
    SKLabelNode *labelStepCountNode;
    SKShapeNode *node;
}
@property (nonatomic, assign)BOOL isCreated;

@end

@implementation CHDXCityMapSence

-(void)didMoveToView:(SKView *)view {
    
    if (!self.isCreated) {
        [self createContent];
        self.isCreated = YES;
    }
}

-(void)createContent;
{
    
    [self configBackgroundNode];
    [self showTest];

}


-(void)showTest;
{
    
    node = [SKShapeNode shapeNodeWithRect:CGRectMake(20, 20, 40, 40)];
    node.fillColor = [SKColor blueColor];
//    node.position
    [self addChild:node];
    
}
//
//-(void)didFinishUpdate;
//{
//    NSLog(@"self");
//
//}

-(void)configBackgroundNode;
{
    backgroundNode = [[SKSpriteNode alloc]initWithImageNamed:@"continent0"];
//    backgroundNode.anchorPoint = CGPointMake(0.5f, 0.5f);
    backgroundNode.anchorPoint = CGPointMake(0.5,0.5);
//    backgroundNode.position = CGPointMake(100, 220);
//    backgroundNode.position = CGPointMake(CGRectGetMidX(self.frame),
//                                   CGRectGetMidY(self.frame));

//    backgroundNode.name = @"tsn";
    
    [self addChild:backgroundNode];
//    CGPoint point =  CGPointMake(700 - backgroundNode.size.width/2 -23, 330-backgroundNode.size.height/2+268);
//    CGPoint x = [self.view convertPoint:point toScene:self];
    iconNode = [[SKSpriteNode alloc]initWithImageNamed:@"Instance_location"];
    iconNode.position = CGPointZero;
//    iconNode.position = point;
    [backgroundNode addChild:iconNode];
    
    [self loadStepData];

    
}


-(BOOL)findEventBigo;
{
    BOOL eventHappen = [self getRandomNumber:1 to:100] < 25;
    return eventHappen;
}

-(int)getRandomNumber:(int)from to:(int)to

{
    return (int)(from + (arc4random() % (to-from + 1)));
}


-(void)gotoPoint:(CGPoint)point withTimeRemain:(int)second;
{
    
    NSMutableArray *sequceArr = [[NSMutableArray alloc]init];
    
    for (int i = 0 ;i< second; ) {
        i++;
        
        SKAction *goAction = [SKAction moveTo:CGPointMake(point.x * i /second, point.y *i /second) duration:1];
        [iconNode runAction:goAction];
//
        continue;
        
        BOOL eventBingo = [self findEventBigo];
        if (eventBingo) {
            [self showEventTipWithComplete:^{
                [self gotoPoint:CGPointMake((i) *point.x /second, (i) *point.y /second) withTimeRemain:second-i];
            }];
            break;
            
        } else {
            SKAction *goAction = [SKAction moveTo:CGPointMake(point.x * i /second, point.y *i /second) duration:1];
            [iconNode runAction:goAction];
        }
    }
    
}

-(void)showEventTipWithComplete:(void (^)(void))completeBlock;
{
    SKLabelNode *labelNode = [[SKLabelNode alloc]initWithFontNamed:@"Cochin"];
    labelNode.text = [NSString stringWithFormat:@"获奖啦"];
    labelNode.fontSize = 15;
    labelNode.fontColor = [SKColor redColor];
    labelNode.position = CGPointMake(iconNode.position.x,iconNode.position.y-30);
    [backgroundNode addChild:labelNode];
    if (completeBlock) {
        completeBlock ();
    }

}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        
        CGPoint backlocation = [touch locationInNode:backgroundNode];

       BOOL hit =  [goBtn containsPoint:location];
        if (hit) {
            int second = 4;
            CGPoint movePoint  = [iconNode convertPoint:CGPointMake(100, 7) toNode:backgroundNode] ;
            [self gotoPoint:movePoint withTimeRemain:second];
        }
        
        BOOL hitIconNode = [iconNode containsPoint:backlocation];
//        BOOL hitIconNode = [iconNode containsPoint:[iconNode ]];
        if (hitIconNode) {
            SKScene * mainSence = [[CHDXCityMainSence alloc] initWithSize:self.size];
            SKTransition *doors= [SKTransition flipHorizontalWithDuration:0.5];
            [self.view presentScene:mainSence transition:doors];

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
    
    
    SKAudioNode *audioNode = [[SKAudioNode alloc]initWithFileNamed:@"bgMusic_night_1.mp3"];
    [audioNode autoplayLooped];
    [self addChild:audioNode];
    
    
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
                                       
                                       labelStepCountNode = [[SKLabelNode alloc]initWithFontNamed:@"Chalkduster"];
                                       
                                       labelStepCountNode.text = [NSString stringWithFormat:@"%d", [stepCount intValue]];
                                       labelStepCountNode.fontSize = 15;
                                       labelStepCountNode.fontColor = [SKColor redColor];
                                       labelStepCountNode.position = CGPointMake(CGRectGetMaxX(self.scene.frame)-25,
                                                                                 CGRectGetMinY(self.scene.frame)+50);
                                       dispatch_async(dispatch_get_main_queue(), ^{
                                           
                                           [self configPointIcon];
                                           [self.scene addChild:labelStepCountNode];
                                       });
                                   }];
                               }
                           }
                         statisticsUpdateHandler:^(HKStatisticsCollectionQuery * _Nonnull query, HKStatistics * _Nullable statistics, HKStatisticsCollection * _Nullable collection) {
                             
                             NSNumber  *stepCount = [NSNumber numberWithDouble:[[statistics sumQuantity]doubleValueForUnit:[HKUnit countUnit]]];
                             labelStepCountNode.text = [NSString stringWithFormat:@"%d", [stepCount intValue]];
//
//
//                             NSLog(@"query %@ collection %@",query,collection);
                             
                         }
                                     withFailure:^(HKStatisticsCollectionQuery * _Nonnull query, HKStatisticsCollection * _Nullable result, NSError * _Nullable error) {
                                         NSLog(@"query %@ error %@",query,error);
                                         
                                     }];
    

}

-(void)update:(NSTimeInterval)currentTime;
{

}

@end
