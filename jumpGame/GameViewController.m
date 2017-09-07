//
//  GameViewController.m
//  jumpGame
//
//  Created by 优学 on 16/12/9.
//  Copyright © 2016年 优学. All rights reserved.
//



#import "GameViewController.h"
#import "chooseGame.h"

@implementation GameViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];

    SKView * skv = (SKView *)self.view;
    skv.showsFPS = YES;
    skv.showsNodeCount = YES;
    
    
    SKScene * scene = [[chooseGame alloc]initWithSize:[UIScreen mainScreen].bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    [skv presentScene:scene];
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
