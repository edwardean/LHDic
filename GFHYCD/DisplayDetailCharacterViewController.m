//
//  DisplayDetailCharacterViewController.m
//  GFHYCD
//
//  Created by Ibokan on 13-9-20.
//  Copyright (c) 2013年 ibokan. All rights reserved.
//

#import "DisplayDetailCharacterViewController.h"
#import "UMSocial.h"
#import "DBManager.h"
@interface DisplayDetailCharacterViewController ()

@end

@implementation DisplayDetailCharacterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.isLoadDataFromNet = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self initSubView];
    if (_isLoadDataFromNet) {//从网络加载数据
        [super loadWordData:_characterModel.jianTi];
        [super showMBProgressHUUD:@"正在加载......" isDin:YES];
    } else {//从本地加载数据
        _characterView.characterModel = _characterModel;
        _detailCharacterView.detailCharacterModel = _detailCharacterModel;
    }
}
#pragma mark - 初始化子视图
- (void) initSubView
{
    self.title = _characterModel.jianTi;
    _characterView = [[CharacterView alloc]init];
    _characterView.frame = CGRectMake(0, 0, kScreenWidth, 100);
    [self.view addSubview:_characterView];
    
    _detailCharacterView = [[[NSBundle mainBundle]loadNibNamed:@"DetailCharacterView" owner:self options:nil] lastObject] ;
    
    __weak typeof(self) weakSelf = self;
    _detailCharacterView.myDetailCharacterBlock = ^(NSString *selectString){
        __strong typeof(weakSelf)strongSelf = weakSelf;

        strongSelf->_selectStr = selectString;
    };
    _detailCharacterView.frame = CGRectMake(0, 100, kScreenWidth, 267);
    [self.view addSubview:_detailCharacterView];
    
    _tabBarView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight-20-44-49+4, kScreenWidth, 49)];
    _tabBarView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"calligrapher.png"]];
    [self.view addSubview:_tabBarView];
    NSArray *buttonNames = [NSArray arrayWithObjects:@"pen.png",@"document.png",@"star.png",@"share.png",nil];
    NSArray *labelNames = [NSArray arrayWithObjects:@"书法家",@"复制",@"收藏",@"分享", nil];
    for (int i = 0; i < 4; i ++) {
        NSString *btnNameStr = [buttonNames objectAtIndex:i];
        NSString *labelName = [labelNames objectAtIndex:i];
        
        _buttonView = [[UIView alloc]initWithFrame:CGRectMake((45+30)*i+25, (49-45)/2, 45, 45)];
        _buttonView.tag = i;
        UITapGestureRecognizer *tapGestureRecognize = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(buttonAction:)];
        [_buttonView addGestureRecognizer:tapGestureRecognize];
        
        UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:btnNameStr]];
        imageView.frame = CGRectMake((45-30)/2, (45-30)/2-8, 30, 30);
        [_buttonView addSubview:imageView];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0,imageView.bottom, 45, 45-imageView.bottom)];
        label.text = labelName;
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont systemFontOfSize:15.0f];
        label.textColor = [UIColor whiteColor];
        [_buttonView addSubview:label];
        [_tabBarView addSubview:_buttonView];
    }
    _selectedImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"enter.png"]];
    _selectedImageView.frame = CGRectMake(20, (49-45)/2, 55, 55);
    [_tabBarView insertSubview:_selectedImageView atIndex:0];
}

#pragma mark - 点击页面下面的工具按钮,根据tag值做出不同的响应
- (void) buttonAction:(UITapGestureRecognizer *)tapGestureRecongnizer
{
    UIView *view = tapGestureRecongnizer.view;
    int index = view.tag;
    [UIView animateWithDuration:0.18 animations:^{
        _selectedImageView.left = (45+30)*index+20;
    }];
    
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd-hh-mm-ss"];
    NSString *dateStr = [formatter stringFromDate:date];
    NSArray *array = [NSArray arrayWithObjects:_characterModel,_detailCharacterModel,dateStr,nil];
    
    UIAlertView *alertViewSuccess = [[UIAlertView alloc]initWithTitle:nil message:@"收藏成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    
    UIAlertView *alertViewSuccessed = [[UIAlertView alloc]initWithTitle:nil message:@"已经收藏" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    
    UIAlertView *alertViewFail = [[UIAlertView alloc]initWithTitle:nil message:@"收藏失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    //把搜藏中的数据 读取出来 放到一个数组中
   NSMutableArray *allArrayItem = (NSMutableArray *)[[DBManager sharedInstance]findDetailCharactersFromTable:ShouCangTable];
    
    switch (index) {
        case 0:
            NSLog(@"书法家");
            break;
        case 1:
            NSLog(@"复制");
            break;
        case 2:
            //判断是否已经收藏
            for (NSArray *array in allArrayItem)
            {
                CharacterModel *chaModel = [array objectAtIndex:0];
                if ([_characterModel.jianTi isEqualToString:chaModel.jianTi])
                {
                    [alertViewSuccessed show];
                    return;
                }
            }

            if ([[DBManager sharedInstance]addDetailCharacterToTable:array tableName:ShouCangTable]) {
                [alertViewSuccess show];
            } else {
                [alertViewFail show];
            }
            break;
        case 3:
            [UMSocialSnsService presentSnsIconSheetView:self appKey:nil shareText:_selectStr shareImage:nil shareToSnsNames:@[UMShareToSina,UMShareToTencent,UMShareToQzone,UMShareToQQ,UMShareToRenren,UMShareToDouban,UMShareToEmail,UMShareToSms] delegate:nil];
            break;
        default:
            break;
    }
}

#pragma mark - 加载完成后 解析数据
- (void) loadWordDataFinish:(NSDictionary *)result
{
    if (result != nil) {
        [super hidMBProgressHUD];
        self.detailCharacterModel = [super analysisDetailWordResult:result];
        _characterView.characterModel = _characterModel;
        _detailCharacterView.detailCharacterModel = _detailCharacterModel;
        //处理从网络得到两个model时
        [self saveLatestSearchCharacter];
    } else {
        [super hidMBProgressHUD];
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"警告" message:@"加载数据出错" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
    }
    
}
#pragma mark - 处理不是从网络得到那两个model
- (void) setCharacterModel:(CharacterModel *)characterModel
{
    if (_characterModel != characterModel) {
        _characterModel = characterModel;
    }
    [self saveLatestSearchCharacter];
}
#pragma mark - 处理不是从网络得到那两个model
- (void) setDetailCharacterModel:(DetailCharacterModel *)detailCharacterModel
{
    if (_detailCharacterModel != detailCharacterModel) {
        _detailCharacterModel = detailCharacterModel;
    }
    [self saveLatestSearchCharacter];
}
#pragma mark - 把最近搜索的汉字保存到NSUserDefaults中
- (void) saveLatestSearchCharacter
{
    if (_characterModel != nil && _detailCharacterModel != nil)
    {//两个都有值时才进行操作 说明已经都请求下来数据了        
        NSDate *date = [NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy-MM-dd-hh-mm-ss"];
        NSString *dateStr = [formatter stringFromDate:date];
        
        NSArray *arrayItem = [NSArray arrayWithObjects:_characterModel,_detailCharacterModel,dateStr,nil];
        NSMutableArray *allArrayItem = (NSMutableArray *)[[DBManager sharedInstance]findDetailCharactersFromTable:LatestSearchTable];
        
        if (allArrayItem.count > 0) {
            for (NSArray *array in allArrayItem)
            {
                CharacterModel *chaModel = [array objectAtIndex:0];
                NSString *time = [array objectAtIndex:2];
                if ([_characterModel.jianTi isEqualToString:chaModel.jianTi])
                {//如果已经存在则直接删除 把当前的 插入到第一位
                    [[DBManager sharedInstance] deleteDetailCharactersFromTableByTime:time tableName:LatestSearchTable];
                }
            }
            
            if (allArrayItem.count  > kLatestSearchWordCount)
            {
                //如果插入新数据后总的个数大于9,则删除最后一个
                NSArray *myArray = [allArrayItem lastObject];
                NSString *myTime = [myArray objectAtIndex:2];
                [[DBManager sharedInstance] deleteDetailCharactersFromTableByTime:myTime tableName:LatestSearchTable];
            }

        }
        
        [[DBManager sharedInstance] addDetailCharacterToTable:arrayItem tableName:LatestSearchTable];
//        else
//        {
//            [[DBManager sharedInstance] addDetailCharacterToTable:arrayItem tableName:LatestSearchTable];//第一个时 直接放进去
//        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
