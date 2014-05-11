//
//  SharedViewController.h
//  GFHYCD
//
//  Created by yuan on 13-10-16.
//  Copyright (c) 2013年 ibokan. All rights reserved.
//

#import "BaseViewController.h"

@interface SharedViewController : BaseViewController
- (IBAction)sendMessage:(id)sender;
@property (retain, nonatomic) IBOutlet UILabel *contentLabel;

@end
