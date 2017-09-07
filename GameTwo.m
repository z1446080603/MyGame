//
//  GameTwo.m
//  jumpGame
//
//  Created by 优学 on 16/12/9.
//  Copyright © 2016年 优学. All rights reserved.
//

#import "GameTwo.h"


static const uint32_t ballCategory  = 0x1 << 0;  // 00000000000000000000000000000001
static const uint32_t bottomCategory = 0x1 << 1; // 00000000000000000000000000000010
static const uint32_t blockCategory = 0x1 << 2;  // 00000000000000000000000000000100
static const uint32_t paddleCategory = 0x1 << 3; // 00000000000000000000000000001000

@interface GameTwo ()<SKPhysicsContactDelegate>

@property(nonatomic,strong)SKSpriteNode * player;
@property(nonatomic,strong)SKSpriteNode * ball;

@end
@implementation GameTwo

-(void)didMoveToView:(SKView *)view
{
    //路径
//    UIBezierPath * path = [[UIBezierPath alloc]init];
//    
//    [path moveToPoint:CGPointMake(0, 0)];
//    [path addLineToPoint:CGPointMake(0, self.size.height)];
//    
//    [path moveToPoint:CGPointMake(0, self.size.height)];
//    [path addLineToPoint:CGPointMake(self.size.width, self.size.height)];
//    
//    [path moveToPoint:CGPointMake(self.size.width, self.size.height)];
//    [path addLineToPoint:CGPointMake(self.size.width, 0)];

    //以屏幕为边界）
    
    //self.physicsWorld.gravity = CGVectorMake(0.0f, 0.0f); //空间重力  -->0
    self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
    self.physicsBody.friction = 0.0;
    
    //初始化球拍
    self.player = [[SKSpriteNode alloc]initWithColor:[UIColor blueColor] size:CGSizeMake(60, 20)];
    self.player.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.player.size];
    self.player.position = CGPointMake(30, 10);
    self.player.physicsBody.dynamic = NO;
    self.player.physicsBody.friction = 0.4;
    self.player.physicsBody.restitution = 1.0f;
    self.player.physicsBody.linearDamping = 0.0f;
    
    [self addChild:self.player];
    
    
    
    //初始化球
    self.ball = [[SKSpriteNode alloc]initWithColor:[UIColor yellowColor] size:CGSizeMake(20, 20)];
    self.ball.position =  CGPointMake(self.frame.size.width/3, self.frame.size.height/3);
    self.ball.physicsBody =[SKPhysicsBody bodyWithCircleOfRadius:self.ball.frame.size.width/2];
    self.ball.physicsBody.friction = 0.0f;
    self.ball.physicsBody.restitution = 1.0f;
    self.ball.physicsBody.usesPreciseCollisionDetection = YES;
    self.ball.physicsBody.allowsRotation = NO;
    [self addChild:self.ball];
    
    //给定动力
    //[self.ball.physicsBody applyImpulse:CGVectorMake(10.0f, -10.0f)];
    
    
    CGRect bottomRect = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, 1);
    SKNode* bottom = [SKNode node];
    bottom.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:bottomRect];
    [self addChild:bottom];
    bottom.physicsBody.categoryBitMask = bottomCategory;
    
    self.ball.physicsBody.categoryBitMask = ballCategory;
    self.player.physicsBody.categoryBitMask = paddleCategory;
    
    
    self.ball.physicsBody.contactTestBitMask = bottomCategory | blockCategory;
    self.physicsWorld.contactDelegate = self;
    
}


-(void)didBeginContact:(SKPhysicsContact *)contact
{
    SKPhysicsBody* firstBody;
    SKPhysicsBody* secondBody;
    // 2 Assign the two physics bodies so that the one with the lower category is always stored in firstBody
    
    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask) {
        firstBody = contact.bodyA;
        secondBody = contact.bodyB;
    } else {
        firstBody = contact.bodyB;
        secondBody = contact.bodyA;
    }
    // 3 react to the contact between ball and bottom
    if (firstBody.categoryBitMask == ballCategory && secondBody.categoryBitMask == bottomCategory) {
        //TODO: Replace the log statement with display of Game Over Scene
     
        NSLog(@"撞倒底,输了");
    }
   
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    CGPoint point = [[touches anyObject] locationInView:self.view];
    self.player.position = CGPointMake(point.x, 10);
//    if (point.x >=30  && point.x <= self.size.width-30 ) {
//        self.player.position = CGPointMake(point.x, 10);
//    }
}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    CGPoint point = [[touches anyObject] locationInView:self.view];
    self.player.position = CGPointMake(point.x, 10);
//    if (point.x >=30  && point.x <= self.size.width-30 ) {
//        self.player.position = CGPointMake(point.x, 10);
//    }
}



@end
