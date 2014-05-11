//
//  ProgressViewController.h
//  GFHYCD
//  启动界面的控制器
//  Created by yuan on 13-10-16.
//  Copyright (c) 2013年 ibokan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YLProgressBar.h"
@interface ProgressViewController : UIViewController
@property(retain,nonatomic)YLProgressBar *progressView;
@property(retain,nonatomic)UILabel *progressValueLabel;
@property(retain,nonatomic)NSTimer *progressTimer;
@end
