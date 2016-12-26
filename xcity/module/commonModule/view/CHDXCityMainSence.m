//
//  CHDXCityMainSence.m
//  xcity
//
//  Created by 余妙玉 on 16/11/7.
//  Copyright © 2016年 Lampard Hong. All rights reserved.
//

#import "CHDXCityMainSence.h"

@interface CHDXCityMainSence (){

}
@property (nonatomic, assign)BOOL isCreated;

@end

@implementation CHDXCityMainSence

-(void)didMoveToView:(SKView *)view {
    
    if (!self.isCreated) {
        [self createContent];
        self.isCreated = YES;
    }
}

-(void)createContent;
{
    NSMutableArray *pintTextures = [NSMutableArray array];
    for(int i = 0 ;i <=14; ++i) {
        NSString *imageName = [NSString stringWithFormat:@"littleShap%d",i];
        
        SKTexture *t = [SKTexture textureWithImageNamed:imageName] ;
        [pintTextures addObject:t];
    }
    SKSpriteNode *backNode = [[SKSpriteNode alloc]initWithTexture:[SKTexture textureWithImageNamed:@"littleShap0"]];
    backNode.position = CGPointMake(CGRectGetMidX(self.scene.frame),3008);
    backNode.name = @"backNode";
    [self.scene addChild:backNode];
    
    SKAction *walkAnimation = [SKAction animateWithTextures:pintTextures timePerFrame:2/[pintTextures count]];
    [backNode runAction:walkAnimation];
}

@end
