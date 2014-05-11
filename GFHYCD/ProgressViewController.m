//
//  ProgressViewController.m
//  GFHYCD
//
//  Created by yuan on 13-10-16.
//  Copyright (c) 2013年 ibokan. All rights reserved.
//

#import "ProgressViewController.h"
#import "RootViewController.h"
@interface ProgressViewController ()

@end

@implementation ProgressViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"startup-interface"]];
    _progressView=[[YLProgressBar alloc]init];
    self.progressView.frame=CGRectMake(85, 350, 150, 15);
    [self.view addSubview:_progressView];
    
    _progressValueLabel=[[UILabel alloc]init];
    self.progressValueLabel.frame=CGRectMake(140, 300, 50, 30);
    self.progressValueLabel.backgroundColor=[UIColor clearColor];
    self.progressValueLabel.textColor=[UIColor whiteColor];
    [self.view addSubview:self.progressValueLabel];
    
    self.progressTimer = [NSTimer scheduledTimerWithTimeInterval:0.07f target:self selector:@selector(changeProgressValue)userInfo:nil repeats:YES];
}
#pragma mark - 定时器响应的方法
- (void)changeProgressValue
{
    float progressValue = _progressView.progress;
    progressValue += 0.05f;
    if (progressValue > 1)
    {
        [_progressTimer invalidate];//停止定时器
        [self performSelector:@selector(pushToshouye) withObject:nil afterDelay:0.2];
    }
    [_progressValueLabel setText:[NSString stringWithFormat:@"%.0f%%", (progressValue * 100)]];
    [_progressView setProgress:progressValue];
}

#pragma mark - 推送到首页
-(void)pushToshouye{
    RootViewController *rootCtr=[[RootViewController alloc]init];
    UINavigationController *nvc=[[UINavigationController alloc]initWithRootViewController:rootCtr];
    //设置变化动作为渐渐褪色到该视图
    nvc.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
    [self presentViewController:nvc animated:YES completion:NULL];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
