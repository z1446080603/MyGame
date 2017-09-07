//
//  GameThree.m
//  jumpGame
//
//  Created by 优学 on 16/12/13.
//  Copyright © 2016年 优学. All rights reserved.
//

#define kRandomColor [UIColor colorWithRed:arc4random_uniform(256) / 255.0 green:arc4random_uniform(256) / 255.0 blue:arc4random_uniform(256) / 255.0 alpha:1]

#import "GameThree.h"
#import <CoreMotion/CoreMotion.h>


static const uint32_t PlayerCategory  = 0x1 << 0;  // 00000000000000000000000000000001
static const uint32_t JTCategory = 0x1 << 1;       // 00000000000000000000000000000010


@interface GameThree ()<SKPhysicsContactDelegate>


@property(nonatomic,assign)BOOL isDown;
@property(nonatomic,assign)float speed1;
@property(nonatomic,strong)SKSpriteNode * player;
@property(nonatomic,strong)NSMutableArray * arr;
@property(nonatomic,strong)CMMotionManager * manager;

@property(nonatomic,strong)UIGravityBehavior * gravity;
@property(nonatomic,strong)UIDynamicAnimator * animator;

@end

@implementation GameThree

-(instancetype)initWithSize:(CGSize)size
{
    self = [super initWithSize:size];
    if (self) {
        
        //self.physicsWorld.gravity = CGVectorMake(0.0f, -9.8); //空间重力  -->0
        self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
        self.physicsBody.restitution = 0.6;
        
        self.speed1 = 0;
        self.arr = [NSMutableArray array];
        self.backgroundColor = [UIColor whiteColor];
        [self createLab:@"开始游戏" andName:@"beginGame" andPosition:CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))];
        
    }
    
    return self;
}


#pragma mark - 创建lab
-(void)createLab:(NSString *)title andName:(NSString *)name andPosition:(CGPoint)point
{
    SKLabelNode * lab = [SKLabelNode labelNodeWithText:title];
    lab.name = name;
    lab.color = [UIColor redColor];
    lab.fontColor = [UIColor orangeColor];
    lab.position = point;
    
    [self addChild:lab];
}


#pragma mark  - 点击界面
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    CGPoint point = [[touches anyObject] locationInNode:self];
    SKNode * node = [self nodeAtPoint:point];
    if ([node.name isEqualToString:@"beginGame"])
    {
        [node removeFromParent];
        [self startGame];
    }
}

#pragma mark - 开始游戏
-(void)startGame
{
    [self createPlayer];
    
    
    //[self createJTOne];
    [self createJTTwo];
}

#pragma mark - 初始化小人
-(void)createPlayer
{

    self.player = [[SKSpriteNode alloc]initWithColor:[UIColor brownColor] size:CGSizeMake(20, 20)];
    self.player.position = CGPointMake(arc4random()%400, 200);
    self.player.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.player.size];
    self.player.physicsBody.restitution = 1.0f;
    self.player.physicsBody.friction = 0.0;
    self.player.physicsBody.allowsRotation = NO;
    self.player.physicsBody.categoryBitMask = PlayerCategory;
    self.player.physicsBody.contactTestBitMask = JTCategory ;
    self.physicsWorld.contactDelegate = self;
    [self addChild:self.player];

    
    self.manager = [[CMMotionManager alloc]init];
    
    if (self.manager.deviceMotionAvailable)
    {
        self.manager.deviceMotionUpdateInterval = 0.01;
        
        [self.manager startDeviceMotionUpdatesToQueue:[[NSOperationQueue alloc]init] withHandler:^(CMDeviceMotion * _Nullable motion, NSError * _Nullable error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                CMAcceleration acceleration = motion.gravity;
                self.physicsWorld.gravity = CGVectorMake(acceleration.x*20, -9.8);
            });
        }];
    }

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
    if (firstBody.categoryBitMask == PlayerCategory && secondBody.categoryBitMask == JTCategory) {

        [self.player.physicsBody applyImpulse:CGVectorMake(0, 12)];
        
        _isDown = NO;
    }
}





#pragma mark - 添加阶梯--- one
-(void)createJTOne
{
    SKAction * ac1 = [SKAction runBlock:^{
        [self addObject];
    }];
    SKAction * ac2 = [SKAction waitForDuration:0.5];
    
    [self runAction:[SKAction repeatActionForever:[SKAction sequence:@[ac1,ac2]]] withKey:@"addObject"];
}
-(void)addObject
{
    int oWidth = arc4random()%100+100;
    SKSpriteNode * node = [SKSpriteNode spriteNodeWithColor:kRandomColor size:CGSizeMake(oWidth, 20)];
    node.position = CGPointMake(200, self.size.height+20);
    node.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:node.size];
    node.physicsBody.friction = 0.0;   //摩擦力
    node.physicsBody.restitution = 0.0f;  //反弹力
    node.physicsBody.linearDamping = 0.0;  //衰减
    [self addChild:node];
    
    
    SKAction * ac1 = [SKAction moveTo:CGPointMake(200, -10) duration:2];
    SKAction * ac2 = [SKAction runBlock:^{
        [node removeFromParent];
    }];
    
    [node runAction:[SKAction sequence:@[ac1,ac2]] withKey:@"remove"];
    
    
}


#pragma mark - 添加阶梯--- two
-(void)createJTTwo
{
    for (int i = 0; i<1; i++) {
        
        NSInteger num  = self.size.width-200;
        NSInteger xxx = arc4random()%num+100;
        
        SKSpriteNode * node = [SKSpriteNode spriteNodeWithColor:kRandomColor size:CGSizeMake(100, 1)];
        node.position = CGPointMake(xxx, 130+120*i);
        
        node.name = @"bibibi";
        node.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:node.size];
        node.physicsBody.friction = 1.0;      //摩擦力
        node.physicsBody.restitution = 0.5f;  //反弹力
        node.physicsBody.categoryBitMask = JTCategory;
        node.physicsBody.dynamic = NO;
        
        [self addChild:node];
        [self.arr addObject:node];
    }
}

-(void)update:(NSTimeInterval)currentTime
{
//    if (self.player.physicsBody.velocity.dy < 0)
//    {
//        for (SKSpriteNode * node in self.arr) {
//            if (CGRectIntersectsRect(self.player.frame, node.frame))
//            {
//                [self.player.physicsBody applyImpulse:CGVectorMake(0, 10)];
//            }
//        }
//    }
    
}


@end
