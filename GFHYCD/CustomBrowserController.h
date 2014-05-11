//
//  CustomBrowserController.h
//  GFHYCD
//
//  Created by LiHang on 14-5-11.
//  Copyright (c) 2014年 ibokan. All rights reserved.
//
#import "BaseViewController.h"
#import "NJKWebViewProgress.h"
#import "NJKWebViewProgressView.h"

@interface CustomBrowserController : BaseViewController<NJKWebViewProgressDelegate,UIWebViewDelegate,UIActionSheetDelegate>

@property (nonatomic, strong) UIWebView *browser;
@property (nonatomic, strong) NJKWebViewProgressView *progressView;
@property (nonatomic, strong) NSURLRequest *request;
@end
