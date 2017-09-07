//
//  GameScene.m
//  jumpGame
//
//  Created by 优学 on 16/12/9.
//  Copyright © 2016年 优学. All rights reserved.
//

#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height

#import <Speech/Speech.h>
#import "GameScene.h"
#import "chooseGame.h"
#import <CoreImage/CoreImage.h>
#import <AVFoundation/AVFoundation.h>

static const uint32_t bearCategory  = 0x1 << 0;  // 00000000000000000000000000000001
static const uint32_t bottomCategory = 0x1 << 1; // 00000000000000000000000000000010

@interface GameScene ()<SKPhysicsContactDelegate>

@property(nonatomic,strong)AVAudioPlayer * bgmPlayer;
@property(nonatomic,strong)NSMutableArray * objectArr;
@property(nonatomic,strong)SKSpriteNode * player;
@property(nonatomic,strong)SKAction * effectSound;

@property(nonatomic,strong)NSMutableArray * actionsArr;
@property(nonatomic,strong)NSArray * arr;
@property(nonatomic,assign)BOOL isJump;

@property(nonatomic,assign) int scole;
@property(nonatomic,strong)SKLabelNode * lab;
@property(nonatomic,strong)NSTimer * timer;

@end

@implementation GameScene


- (void)didMoveToView:(SKView *)view {
    // Setup your scene here
    
    self.arr = @[@"tree.jpg",@"zhang1.jpg",@"zhang2.jpg"];
    self.backgroundColor = [UIColor whiteColor];

    
    [self createLab:@"点击开始游戏" andName:@"start" andPoint:CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //点击开始游戏，移除lab
    CGPoint point = [[touches anyObject] locationInNode:self];
    SKNode * node = [self nodeAtPoint:point];
    if ([node.name isEqualToString:@"start"]) {
        
        [node removeFromParent];
        [self startGame];
        return;
    }else if ([node.name isEqualToString:@"reStart"])
    {
        
        
        [self removeAllActions];
        [self removeAllChildren];
        
        [self setPaused:NO];
        [self startGame];
        return;
    }else if([node.name isEqualToString:@"back"])
    {
        SKScene * scene = [[chooseGame alloc]initWithSize:self.size];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        SKTransition * trans = [SKTransition doorsOpenVerticalWithDuration:0.5];
        [self.scene.view presentScene:scene transition:trans];
    }
    else
    {
        if ([self.player actionForKey:@"walkingInPlaceBear"]) {
            [self.player removeActionForKey:@"walkingInPlaceBear"];
        }
        
        if (!_isJump) {
            //点击跳跃
//            SKAction * ac1 = [SKAction moveTo:CGPointMake(20+self.player.frame.size.width/2, 40+self.player.size.height/2+140) duration:0.5];
//            SKAction * ac2 = [SKAction waitForDuration:0.05];
//            SKAction * ac3 = [SKAction moveTo:CGPointMake(20+self.player.frame.size.width/2, 40+self.player.size.height/2) duration:0.5];
//            
//            SKAction * ac4 = [SKAction sequence:@[ac1,ac2,ac3]];
//            
//            [self.player runAction:[SKAction group:@[ac4,self.effectSound]] completion:^{
//                [self bearRunning];
//            }];
            _isJump = YES;
            [self.player.physicsBody applyImpulse:CGVectorMake(0, 110)];
        }
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
    if (firstBody.categoryBitMask == bearCategory && secondBody.categoryBitMask == bottomCategory) {
        //TODO: Replace the log statement with display of Game Over Scene
        
        _isJump = NO;
        [self bearRunning];
    }
    
}


-(void)startGame
{
    //添加背景图片
    SKSpriteNode * back = [SKSpriteNode spriteNodeWithImageNamed:@"back.jpg"];
    back.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    [self addChild:back];
    
    //添加分数
    self.scole = 0;
    self.lab = [SKLabelNode labelNodeWithText:@"0 米"];
    self.lab.fontSize = 20;
    self.lab.fontColor = [UIColor greenColor];
    self.lab.position = CGPointMake(60, self.size.height-30);
    [self addChild:self.lab];
    
    
    NSMutableArray * arrt = [[NSMutableArray alloc]init];
    for (int i = 1; i <= 8; i++) {
        SKTexture * sk = [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"b%d.jpg",i]];
        [arrt addObject:sk];
    }
    SKSpriteNode * node11 = [[SKSpriteNode alloc]initWithTexture:[SKTexture textureWithImageNamed:@"b1.jpg"]];
    node11.position = CGPointMake(self.frame.size.width-node11.size.width/2, self.frame.size.height-node11.size.height/2);
    [node11 runAction:[SKAction repeatActionForever:[SKAction animateWithTextures:arrt timePerFrame:0.1]]];
    [self addChild:node11];
    
    //添加背景音乐
    NSString * path = [[NSBundle mainBundle] pathForResource:@"background-music-aac" ofType:@"caf"];
    self.bgmPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL URLWithString:path] error:NULL];
    self.bgmPlayer.numberOfLoops = -1;
    [self.bgmPlayer play];
    
    //初始化障碍物数组
    self.objectArr = [[NSMutableArray alloc]init];
    
    //初始化点击跳跃音效
    self.effectSound = [SKAction playSoundFileNamed:@"pew-pew-lei.caf" waitForCompletion:NO];
    
    //初始化人物
    self.player = [[SKSpriteNode alloc]initWithImageNamed:@"bear1.png"];
    self.player.position = CGPointMake(20+self.player.frame.size.width/2, 40+self.player.size.height/2);
    self.player.zPosition = 3;
    self.player.xScale = -self.player.xScale;
    self.player.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.player.size];
    self.player.physicsBody.restitution = 0.0f;
    self.player.physicsBody.categoryBitMask = bearCategory;
    [self addChild:self.player];
    
    //底座
    SKSpriteNode * bottom = [[SKSpriteNode alloc]initWithColor:[UIColor clearColor] size:CGSizeMake(self.size.width, 40)];
    bottom.position = CGPointMake(CGRectGetMidX(self.frame), 20);
    bottom.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:bottom.size];
    bottom.physicsBody.dynamic = NO;
    bottom.physicsBody.restitution = 0.0f;
    bottom.physicsBody.categoryBitMask = bottomCategory;
    [self addChild:bottom];
    
    self.player.physicsBody.contactTestBitMask = bottomCategory;
    self.physicsWorld.contactDelegate = self;
    
    //动作
    self.actionsArr = [[NSMutableArray alloc]init];
    for (int i = 1; i<9; i++) {
        NSString * str =[NSString stringWithFormat:@"bear%d.png",i];
        SKTexture * texture = [SKTexture textureWithImage:[UIImage imageNamed:str]];
        [self.actionsArr addObject:texture];
    }
    [self bearRunning];

    
    //循环添加障碍物
    SKAction * ac1 = [SKAction runBlock:^{
        [self addObject];
    }];

    SKAction * ac2 = [SKAction waitForDuration:2.0];
    
    [self runAction:[SKAction repeatActionForever:[SKAction sequence:@[ac1,ac2]]]];
}

-(void)timerAction
{
    self.scole = self.scole + 1;
    self.lab.text = [NSString stringWithFormat:@"%d 米",self.scole];
}

-(void)bearRunning
{
    [self.player runAction:[SKAction repeatActionForever:[SKAction animateWithTextures:self.actionsArr timePerFrame:0.05f resize:NO restore:YES]] withKey:@"walkingInPlaceBear"];
}

-(void)addObject
{
    //得到障碍物的随机宽度
    int randWidth = arc4random()%10 + 30;
    int randHeight = arc4random()%30 + 30;
    //int actualDuration = (arc4random() % rangeDuration) + minDuration;
    
    //创建障碍物
    int num = arc4random()%3;
    
    
    SKTexture * ture = [SKTexture textureWithImage:[UIImage imageNamed:self.arr[num]]];
    SKSpriteNode * zObject = [[SKSpriteNode alloc]initWithTexture:ture color:[UIColor whiteColor] size:CGSizeMake(randWidth, randHeight)];
    zObject.position = CGPointMake(WIDTH + zObject.size.width/2, 40+zObject.size.height/2);
    [self addChild:zObject];
    
    //添加动作
    SKAction * ac1 = [SKAction moveTo:CGPointMake(-zObject.size.width/2, 40+zObject.size.height/2) duration:2.5];
    SKAction * ac2 = [SKAction runBlock:^{
        
        [self.objectArr removeObject:zObject];
        [zObject removeFromParent];
    }];
    
    [zObject runAction:[SKAction sequence:@[ac1,ac2]]];
    
    [self.objectArr addObject:zObject];
    
}


-(void)update:(CFTimeInterval)currentTime {
    // Called before each frame is rendered
    static int num = 0;
    
    num ++;
    if (num == 20) {
        num = 0;
        self.scole = self.scole + 1;
        self.lab.text = [NSString stringWithFormat:@"%d 米",self.scole];
    }
    for (SKSpriteNode * node in self.objectArr)
    {
        if (CGRectIntersectsRect(self.player.frame, node.frame)) {
            
            [self setPaused:YES];
            [self.bgmPlayer stop];
            self.bgmPlayer = nil;

            [self createLab:@"重新开始" andName:@"reStart" andPoint:CGPointMake(WIDTH/2.0, HEIGHT/2.0)];
            
            [self createLab:@"返回选择" andName:@"back" andPoint:CGPointMake(80, 50)];
        }
    }
}

-(void)createLab:(NSString *)text andName:(NSString * )name andPoint:(CGPoint)point
{
    SKLabelNode * lab = [SKLabelNode labelNodeWithText:text];
    lab.name = name;
    lab.color = [UIColor redColor];
    lab.fontColor = [UIColor orangeColor];
    lab.position = point;
    
    [self addChild:lab];
}

@end
