//
//  chooseGame.m
//  jumpGame
//
//  Created by 优学 on 16/12/9.
//  Copyright © 2016年 优学. All rights reserved.
//

#import "chooseGame.h"
#import "GameScene.h"
#import "GameTwo.h"
#import "GameThree.h"
#import "GameFour.h"

@implementation chooseGame

-(void)didMoveToView:(SKView *)view
{
    self.backgroundColor = [UIColor whiteColor];
    
    [self createLab:@"选择游戏" andName:@"choose" andPositon:CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)+30)];
    
    [self createLab:@"忍者跳跃" andName:@"jump" andPositon:CGPointMake(self.frame.size.width/4, CGRectGetMidY(self.frame)-30)];
    
    [self createLab:@"弹力球" andName:@"ball" andPositon:CGPointMake(self.frame.size.width/4 * 3, CGRectGetMidY(self.frame)-30)];
    
    [self createLab:@"阶梯跳" andName:@"jumpT" andPositon:CGPointMake(50, 50)];
    
    [self createLab:@"小车" andName:@"car" andPositon:CGPointMake(self.frame.size.width-50, 50)];
    
}

-(void)createLab:(NSString * )text andName:(NSString *)name andPositon:(CGPoint )point
{
    SKLabelNode * lab = [SKLabelNode labelNodeWithText:text];
    
    lab.fontSize = 14.0;
    lab.name = name;
    lab.color = [UIColor blueColor];
    lab.fontColor = [UIColor orangeColor];
    lab.position = point;
    [self addChild:lab];
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    CGPoint point = [[touches anyObject] locationInNode:self];
    SKNode * node = [self nodeAtPoint:point];

    if ([node.name isEqualToString:@"jump"])
    {
        SKScene * scene = [[GameScene alloc]initWithSize:self.size];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        SKTransition * trans = [SKTransition doorsOpenVerticalWithDuration:0.5];
        [self.scene.view presentScene:scene transition:trans];
        
    }else if ([node.name isEqualToString:@"ball"])
    {
        SKScene * scene = [[GameTwo alloc]initWithSize:self.size];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        SKTransition * trans = [SKTransition doorsOpenVerticalWithDuration:0.5];
        [self.scene.view presentScene:scene transition:trans];
        
    }else if ([node.name isEqualToString:@"jumpT"])
    {
        SKScene * scene = [[GameThree alloc]initWithSize:self.size];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        SKTransition * trans = [SKTransition doorsOpenVerticalWithDuration:0.5];
        [self.scene.view presentScene:scene transition:trans];
        
    }else if ([node.name isEqualToString:@"car"])
    {
        SKScene * scene = [[GameFour alloc]initWithSize:self.size];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        SKTransition * trans = [SKTransition doorsOpenVerticalWithDuration:0.5];
        [self.scene.view presentScene:scene transition:trans];
    }
}


@end
