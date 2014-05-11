//
//  BaseViewController.m
//  GFHYCD
//
//  Created by Ibokan on 13-9-16.
//  Copyright (c) 2013年 ibokan. All rights reserved.
//

#import "BaseViewController.h"
#import "GFHttpRequest.h"
@interface BaseViewController ()

@end

@implementation BaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.showNavRightButton = YES;//默认的开启右边的导航栏按钮
        self.isHomeCtr = NO;//默认的不显示home下的那个右边的导航按钮 而是显示一个普通的按钮
        }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    [self initNavSubView];
    
}
#pragma mark - 初始化导航栏
- (void) initNavSubView
{
    if (self.navigationController.viewControllers.count > 1) {
        UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 61+1, 44)];
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        backBtn.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"calligrapher.png"]];
        [backBtn setImage:[UIImage imageNamed:@"return.png"] forState:UIControlStateNormal];
        [backBtn addTarget:self action:@selector(backBtn) forControlEvents:UIControlEventTouchUpInside];
        backBtn.frame = CGRectMake(0, 0, 61, 44);
        [backView addSubview:backBtn];
        
        UIImageView *sepatatorView = [[UIImageView alloc]initWithFrame:CGRectMake(backBtn.right + 1, 0, 1, 44)];
        sepatatorView.image = [UIImage imageNamed:@"top.png"];
        [backView addSubview:sepatatorView];
        
        UIBarButtonItem *leftBarItem = [[UIBarButtonItem alloc]initWithCustomView:backView];
        self.navigationItem.leftBarButtonItem = leftBarItem;
    }
    if (_showNavRightButton) {//有无右边的导航按钮
        NSString *picName = nil;
        if (_isHomeCtr) {
            picName = @"more.png";
        } else {
            picName = @"home.png";
        }
        UIView *nextView = [[UIView alloc]initWithFrame:CGRectMake(kScreenWidth-(61+1), 0, 61+1, 44)];
        
        UIImageView *sepatatorView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 1, 44)];
        sepatatorView.image = [UIImage imageNamed:@"top.png"];
        [nextView addSubview:sepatatorView];
        
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        backBtn.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"calligrapher.png"]];
        [backBtn setImage:[UIImage imageNamed:picName] forState:UIControlStateNormal];
        if (_isHomeCtr) {
            [backBtn addTarget:self action:@selector(goNextAction) forControlEvents:UIControlEventTouchUpInside];
        }else{
            [backBtn addTarget:self action:@selector(pushToRootCtr) forControlEvents:UIControlEventTouchUpInside];
        }
        backBtn.frame = CGRectMake(1, 0, 61, 44);
        [nextView addSubview:backBtn];
        
        UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc]initWithCustomView:nextView];
        self.navigationItem.rightBarButtonItem = rightBarItem;
    }
    _activityView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _activityView.frame = CGRectMake((kScreenWidth-40)/2, (kScreenHeight-20-44)/2-80, 40, 40);
    [self.view addSubview:_activityView];
    
    //设置背景图片
    UIImage *backImage = [UIImage imageNamed:@"beijing.png"];
    self.view.backgroundColor = [UIColor colorWithPatternImage:backImage];
}
#pragma mark - 返回到上一级
- (void) backBtn
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - 在home下 其功能是跳转到下一个界面 需额外的控制
- (void) goNextAction
{
//不可以在此释放 因为当前界面可能多次出现
    _myBlock();
}
#pragma mark - 返回到根视图控制器
- (void) pushToRootCtr
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
#pragma mark - 解析汉字的基本信息 并把他们填充到数组中 然后再把本次解析下来的额外的标记结果 保持下来 一并返回出去
- (NSDictionary *) analysisWordResult:(NSDictionary *)result
{
    NSDictionary *data = [result objectForKey:@"data"];
    NSString *pagenum = [[data valueForKey:@"pagenum"] stringValue];
    NSString *curpage = [[data valueForKey:@"curpage"] stringValue];
    NSString *pagesize = [[data valueForKey:@"pagesize"] stringValue];
    NSArray *array = [data objectForKey:@"words"];
    NSMutableArray *words = [[NSMutableArray alloc]initWithCapacity:array.count];

    for (NSDictionary *itemDic in array) {
        CharacterModel *character = [[CharacterModel alloc]init];
        character.jianTi = [itemDic objectForKey:@"simp"];
        NSDictionary *yinDic = [itemDic objectForKey:@"yin"];
        character.pinYin = [yinDic objectForKey:@"pinyin"];
        character.zhuYin = [yinDic objectForKey:@"zhuyin"];
        character.fanTi = [itemDic objectForKey:@"tra"];
        character.jieGou = [itemDic objectForKey:@"frame"];
        character.buShou = [itemDic objectForKey:@"bushou"];
        character.biHua = [itemDic objectForKey:@"num"];
        character.buShouBiHua = [itemDic objectForKey:@"bsnum"];
        character.biShun = [itemDic objectForKey:@"seq"];
        [words addObject:character];
    }
    NSDictionary *resultDic = [NSDictionary dictionaryWithObjectsAndKeys:words,kResult,pagenum,kPagenum,pagesize,kPagesize,curpage,kCurpage,nil];
    return resultDic;
}

#pragma mark - 解析单个汉字的详细信息
- (DetailCharacterModel *) analysisDetailWordResult:(NSDictionary *)result
{
   
    DetailCharacterModel *detailModel = [[DetailCharacterModel alloc]init];
    NSDictionary *data = [result objectForKey:@"data"];
    detailModel.hanYu = [data objectForKey:@"hanyu"];
    detailModel.base = [data objectForKey:@"base"];
    detailModel.english = [data objectForKey:@"english"];
    detailModel.idiom = [data objectForKey:@"idiom"];
    return detailModel;
}

#pragma mark - 是否显示加载数据的提醒
- (void) showLoading:(BOOL)isShow
{
    if (isShow) {
        [_activityView startAnimating];
        [self showTopNetWorkActivity];
    } else {
        [_activityView stopAnimating];
        [self hidTopNetWorkActivity];
    }
}

#pragma mark - 加载单个汉字的方法
- (void) loadWordData:(NSString *)word;
{
    NSMutableArray *params = [NSMutableArray arrayWithObject:word];
    [GFHttpRequest getRequestWithURL:@"word" params:params completeBlock:^(id result) {
        //if (result != nil) {
            [self loadWordDataFinish:result];
        /*}else {
            NSLog(@"请求数据失败!");
            return ;
        }*/
    }];
}
#pragma mark - 显示状态栏上面的网络加载提示按钮
- (void) showTopNetWorkActivity
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}
#pragma mark - 隐藏状态栏上面的网络加载提示按钮
- (void) hidTopNetWorkActivity
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}
#pragma mark - 显示提示加载数据的view
- (void) showMBProgressHUUD:(NSString *)title isDin:(BOOL)isDin
{
    self.mbProHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.mbProHud.dimBackground = isDin;//是否有灰色背景
    self.mbProHud.labelText = title;//显示加载提示的提示语言
    [self showTopNetWorkActivity];
}
#pragma mark - 隐藏提示加载数据的view
- (void) hidMBProgressHUD
{
    [self.mbProHud hide:YES];
    [self hidTopNetWorkActivity];
}
#pragma mark - 隔两秒隐藏提示加载数据的view 并显示提示话语
- (void) showHUDComplete:(NSString *)title
{
    [self hidTopNetWorkActivity];
    self.mbProHud.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
    self.mbProHud.mode = MBProgressHUDModeCustomView;
    if (title.length > 0) {
        self.mbProHud.labelText = title;
    }
    [self.mbProHud hide:YES afterDelay:2];
}

#pragma mark - 加载并播放声音的方法
- (void) loadSoundData:(NSURL *)url
{
    NSData *data = [NSData dataWithContentsOfURL:url];
    if (data != nil) {
        [self performSelectorOnMainThread:@selector(playSound:) withObject:data waitUntilDone:YES];
    }
}

#pragma mark - 下载完成后在主线程上播放
- (void) playSound:(NSData *)data
{
    NSError *error = nil;
    AVAudioPlayer *player = [[AVAudioPlayer alloc]initWithData:data error:&error];
    self.player = player;
    if (error) {
        NSLog(@"audioPlayer Error = %@",error);
    }
    [_player prepareToPlay];
    [_player play];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
