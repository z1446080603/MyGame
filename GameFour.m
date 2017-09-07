//
//  GameFour.m
//  jumpGame
//
//  Created by 优学 on 16/12/15.
//  Copyright © 2016年 优学. All rights reserved.
//

#import "GameFour.h"

@interface GameFour ()

@property(nonatomic,assign)CGFloat  widx;
@property(nonatomic,strong)CAShapeLayer *pathLayer;

@end

@implementation GameFour

-(instancetype)initWithSize:(CGSize)size{
    
    if (self = [super initWithSize:size]) {
        
        self.widx = self.size.width/2;
        self.backgroundColor = [SKColor whiteColor];
        self.physicsWorld.gravity = CGVectorMake(0, -2);
        
        _pathLayer = [CAShapeLayer layer];
        _pathLayer.fillColor = [UIColor clearColor].CGColor;
        _pathLayer.strokeColor = [UIColor redColor].CGColor;
        _pathLayer.lineWidth = 3.0f;
        [self.scene.view.layer addSublayer:_pathLayer];
    }
    
    return self;
}

-(void)didMoveToView:(SKView *)view{
    
    
    [self cubeNode];
    
         //设置边界
    //self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.size.width, self.size.height)];
    
    
    [self arcLine];
    
    
    
//    SKSpriteNode * node = [[SKSpriteNode alloc]initWithColor:[UIColor redColor] size:CGSizeMake(30, 30)];
//    node.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:node.size];
//    node.position = CGPointMake(50, self.frame.size.height/2);
//    node.physicsBody.friction = 0.0f;
//    [self addChild:node];
}

-(void)arcLine
{
    //曲面路径
    UIBezierPath * path = [[UIBezierPath alloc]init];
    [path addArcWithCenter:CGPointMake(self.size.width/2, self.size.height) radius:self.size.width/2 startAngle:0 endAngle:M_PI clockwise:NO];
    
    UIBezierPath * path1 = [[UIBezierPath alloc]init];
    [path1 addArcWithCenter:CGPointMake(self.size.width/2, 0) radius:self.size.width/2 startAngle:M_PI endAngle:2*M_PI clockwise:NO];
    
    CAShapeLayer *pathLayer = [CAShapeLayer layer];
    pathLayer.path = path1.CGPath;
    pathLayer.fillColor = [UIColor clearColor].CGColor;
    pathLayer.strokeColor = [UIColor redColor].CGColor;
    pathLayer.lineWidth = 3.0f;
    [self.scene.view.layer addSublayer:pathLayer];
    
    self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromPath:path.CGPath];
    self.physicsBody.friction = 0.0f;
}

#pragma mark ----创建两个正方体 ---

-(void)cubeNode{
    
    SKSpriteNode *cubeNode = [[SKSpriteNode alloc]initWithColor:[UIColor blueColor] size:CGSizeMake(55, 30)];
    
    cubeNode.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:cubeNode.size];
    
    cubeNode.position = CGPointMake(self.size.width/2-100, self.size.height/2+40);
    
    cubeNode.anchorPoint = CGPointMake(0.5, 0.5);
    
    cubeNode.zPosition = 1;
    
    cubeNode.name = @"cubeNode";
    
    [self addChild:cubeNode];
    
    
    
    SKSpriteNode *cubeNode1 = [[SKSpriteNode alloc]initWithColor:[UIColor orangeColor] size:CGSizeMake(50, 15)];
    
    cubeNode1.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:cubeNode1.size];
    
    cubeNode1.position = CGPointMake(self.size.width/2-100, self.size.height/2);
    
    cubeNode1.anchorPoint = CGPointMake(0.5, 0.5);
    
    cubeNode1.zPosition = 1;
    
    cubeNode1.name = @"cubeNode1";
    
    [self addChild:cubeNode1];

    
    SKPhysicsJointSpring *springPhysicsJoint = [SKPhysicsJointSpring jointWithBodyA:cubeNode.physicsBody bodyB:cubeNode1.physicsBody anchorA:cubeNode.position anchorB:cubeNode1.position];
    //弹簧的阻尼
    //springPhysicsJoint.damping  = 1.0;
    
    //弹簧的振动频率
    springPhysicsJoint.frequency = 2.0;
    
    [self.physicsWorld addJoint:springPhysicsJoint];

    
    SKPhysicsJointSliding * slider = [SKPhysicsJointSliding jointWithBodyA:cubeNode.physicsBody bodyB:cubeNode1.physicsBody anchor:CGPointMake(cubeNode.position.x-cubeNode.size.width/2, cubeNode.position.y) axis:CGVectorMake(0, 10)];
    [self.physicsWorld addJoint:slider];
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    CGPoint point = [[touches anyObject] locationInView:self.view];
    if (point.x<self.size.width/2) {
        self.widx = self.widx + 10;
        
    }else
    {
        self.widx = self.widx - 10;
    }
    UIBezierPath * path = [[UIBezierPath alloc]init];
    [path addArcWithCenter:CGPointMake(self.widx, self.size.height) radius:self.size.width/2 startAngle:0 endAngle:M_PI clockwise:NO];
    
    self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromPath:path.CGPath];
    
    
    UIBezierPath * path1 = [[UIBezierPath alloc]init];
    [path1 addArcWithCenter:CGPointMake(self.widx, 0) radius:self.size.width/2 startAngle:M_PI endAngle:2*M_PI clockwise:NO];
    
    self.pathLayer.path = path1.CGPath;
     [self.scene.view.layer addSublayer:_pathLayer];

}
@end
