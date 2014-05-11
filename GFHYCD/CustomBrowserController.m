//
//  CustomBrowserController.m
//  GFHYCD
//
//  Created by LiHang on 14-5-11.
//  Copyright (c) 2014年 ibokan. All rights reserved.
//

#import "CustomBrowserController.h"
static NSString * const kBrowserRefresh = @"刷新";
static NSString * const kBroswerOpenInSafari = @"用Safari打开";
static NSString * const kBroswerCancel = @"取消";
static NSString * const kBroswerBack = @"后退";
static NSString * const kBroswerGoForward = @"前进";
@interface CustomBrowserController ()
@property (nonatomic, strong) NJKWebViewProgress *progressProxy;

@end

@implementation CustomBrowserController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.browser = [UIWebView new];
    _browser.scalesPageToFit = YES;
    _browser.dataDetectorTypes = UIDataDetectorTypeNone;
    [self.view addSubview:_browser];
    _browser.frame = self.view.bounds;//CGRectMake(0, self.customNaviBar.bottom, [self.view width], [self.view height] - [self.customNaviBar height]);
    
//    [self addLeftButtonWithImage:[UIImage imageNamed:@"base_top_navigation_back.png"] target:self action:@selector(back)];
//    [self addRightButtonWithTitle:@"•••" target:self action:@selector(popActionSheet)];
    
    //webview progress
    CGFloat barTopY = 0;//self.customNaviBar.bottom - 2;
    CGRect progressBarFrame = CGRectMake(0, barTopY, self.view.width, 2);
    self.progressView = [[NJKWebViewProgressView alloc] initWithFrame:progressBarFrame];
    _progressView.progressBarView.backgroundColor = [UIColor whiteColor];
    self.progressProxy = [NJKWebViewProgress new];
    self.browser.delegate = _progressProxy;
    _progressProxy.webViewProxyDelegate = self;
    _progressProxy.progressDelegate = self;
    [self.browser loadRequest:_request];
    [self.view addSubview:_progressView];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.view addSubview:_progressView];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_progressView removeFromSuperview];
    if (_browser.isLoading) {
        [_browser stopLoading];
    }
}

#pragma mark -
#pragma mark - Actions
- (void)back{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)popActionSheet{
    NSUInteger cancelIndex = 1;
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:kBrowserRefresh,nil];
    if (_browser.canGoForward) {
        [sheet addButtonWithTitle:kBroswerBack];
        cancelIndex ++;
    }
    if (_browser.canGoBack) {
        [sheet addButtonWithTitle:kBroswerGoForward];
        cancelIndex ++;
    }
    [sheet addButtonWithTitle:kBroswerOpenInSafari];
    cancelIndex ++;
    
    [sheet addButtonWithTitle:kBroswerCancel];
    sheet.cancelButtonIndex = cancelIndex;
    sheet.delegate = self;
    [sheet showInView:self.view.window];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSString *buttonTitleClicked = [actionSheet buttonTitleAtIndex:buttonIndex];
    if ([buttonTitleClicked isEqualToString:kBrowserRefresh]) {
        [_browser stopLoading];
        [_browser reload];
        return;
    }
    if ([buttonTitleClicked isEqualToString:kBroswerOpenInSafari]) {
        [[UIApplication sharedApplication] openURL:_browser.request.URL];
        return;
    }
    if ([buttonTitleClicked isEqualToString:kBroswerCancel]) {
        
        return;
    }
    if ([buttonTitleClicked isEqualToString:kBroswerBack]) {
        [_browser stopLoading];
        [_browser goBack];
        return;
    }
    if ([buttonTitleClicked isEqualToString:kBroswerGoForward]) {
        [_browser stopLoading];
        [_browser goForward];
        return;
    }
}
#pragma mark -
#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    return YES;
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    NSString *title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    if ([title length]>9) {
        self.title = [title componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"-_，,|"]][0];
    }else{
        self.title = title;
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    if ([error code] == NSURLErrorCancelled) {
        return;
    }
    [[[UIAlertView alloc] initWithTitle:@"网络不给力" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
}

#pragma mark - NJKWebViewProgressDelegate
- (void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress{
    [_progressView setProgress:progress animated:YES];
}


#pragma mark - Orientation
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#ifdef __IPHONE_6_0

- (BOOL)shouldAutorotate{
    return NO;
}

#endif


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
