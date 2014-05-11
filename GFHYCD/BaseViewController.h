//
//  BaseViewController.h
//  GFHYCD
//  公共基类 如定义导航栏的风格 解析数据的两个方法 
//  Created by Ibokan on 13-9-16.
//  Copyright (c) 2013年 ibokan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CharacterModel.h"
#import "DetailCharacterModel.h"
#import "MBProgressHUD.h"
#import <AVFoundation/AVFoundation.h>
typedef void (^MyGoNextBlock)();
@interface BaseViewController : UIViewController
{
    UIActivityIndicatorView *_activityView;//显示正在加载数据的提醒
}
@property (nonatomic,assign) BOOL showNavRightButton;//是否显示右边的导航按钮
@property (nonatomic,assign) BOOL isHomeCtr;//是否是主控制器
@property (nonatomic,copy) MyGoNextBlock myBlock;
@property (nonatomic,retain) MBProgressHUD *mbProHud;//显示正在加载的图标

@property (nonatomic,retain) AVAudioPlayer *player;

- (NSDictionary *) analysisWordResult:(NSDictionary *)result;//解析汉字的基本信息 并把他们填充到数组中
- (DetailCharacterModel *) analysisDetailWordResult:(NSDictionary *)result;//解析单个汉字的详细信息
- (void) showLoading:(BOOL)isShow;//是否显示加载数据的提醒
//加载单个汉字的方法
- (void) loadWordData:(NSString *)word;
//请求数据完成后的操作
- (void) loadWordDataFinish:(NSDictionary *)result;

//显示提示加载view
- (void) showMBProgressHUUD:(NSString *)title isDin:(BOOL)isDin;
//直接关闭提示加载view
- (void) hidMBProgressHUD;
//延迟关闭显示加载等待的view并显示提示文字
- (void) showHUDComplete:(NSString *)title;
//加载并播放声音的方法
- (void) loadSoundData:(NSURL *)url;
@end





