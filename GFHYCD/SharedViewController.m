//
//  SharedViewController.m
//  GFHYCD
//
//  Created by yuan on 13-10-16.
//  Copyright (c) 2013年 ibokan. All rights reserved.
//

#import "SharedViewController.h"
#import "UMSocial.h"
@interface SharedViewController ()

@end

@implementation SharedViewController

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
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

- (IBAction)sendMessage:(id)sender {
    NSString *str = _contentLabel.text;
    UIImage *image = [UIImage imageNamed:@"zidian@2x.png"];
    [UMSocialSnsService presentSnsIconSheetView:self appKey:nil shareText:str shareImage:image shareToSnsNames:@[UMShareToSina,UMShareToTencent,UMShareToQzone,UMShareToQQ,UMShareToRenren,UMShareToDouban,UMShareToEmail,UMShareToSms] delegate:nil];
}

@end
