//
//  RootViewController.m
//  GFHYCD
//
//  Created by Ibokan on 13-9-16.
//  Copyright (c) 2013年 ibokan. All rights reserved.
//

#import "RootViewController.h"
#import "PinYinViewController.h"
#import "DisplaySearchCharacterController.h"
#import "BuShouViewController.h"
#import "PersonalCenterViewController.h"
#import "DBManager.h"
#import "DisplayDetailCharacterViewController.h"
@interface RootViewController ()

@end

@implementation RootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"汉语词典";
        self.isHomeCtr = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initData];
    [self initSubView];
}
#pragma mark - 初始化数据
- (void) initData
{
    _pinYinArray = [NSArray arrayWithObjects:@"A",@"B",@"C",@"D",
                     @"E",@"F",@"G",@"H",
                     @"I",@"J",@"K",@"L",
                     @"M",@"N",@"O",@"P",
                     @"Q",@"R",@"S",@"T",
                     @"U",@"V",@"W",@"X",
                     @"Y",@"Z", nil];
    _biShunArray = [NSArray arrayWithObjects:@"1",@"2",@"3",@"4",
                     @"5",@"6",@"7",@"8",
                     @"9",@"10",@"11",@"12",
                     @"13",@"14",@"15",@"16",
                     @"17", nil] ;
#pragma makr - 从数据库中得到所有汉语拼音
    NSArray *resultArray = [[DBManager sharedInstance]findDataFromTableName:PinYinTable];
    _myShuZiAry = [[NSMutableArray alloc]init];//存放合法的1-17数字的数组
     _myPinYinAry1 = [[NSMutableArray alloc]init];//存放汉字的所有拼音
    _myZiMuAry = [[NSMutableArray alloc]init];
    
    for (int i = 0; i < resultArray.count; i++) {
        NSString *ziMuStr = [resultArray objectAtIndex:i];
        if (i < 17) {
            NSString *shuZiStr = [NSString stringWithFormat:@"%d",i + 1];
            [_myShuZiAry addObject:shuZiStr];
        }
        if (i < 26) {
            [_myZiMuAry addObject:ziMuStr];
        } else {
            [_myPinYinAry1 addObject:ziMuStr];
        }
    }
    
}

#pragma mark - 初始化子视图
- (void) initSubView
{
    self.myBlock = ^(){
        [self pushNextCtr];
    };
    _textField.delegate = self;
    _latestSearchView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Key-frame1.png"]];
    _searchTypeView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Key-frame2.png"]];
    [_segmentCtr addTarget:self action:@selector(changeSearchType) forControlEvents:UIControlEventValueChanged];
    [self drawLatestSearchSubView];//绘制最近搜索的"button" 总共让显示最近搜索的9个汉字
    [self drawPinYinSubView];
    [self drawBiShunSubView];
    [self showSearchTypeSubView:YES searchType:PinYin];
    [self makeTextFieldDisappear];
    //警告的视图
    self.alertView = [[UIAlertView alloc]initWithTitle:@"警告" message:@"请输入单个汉字或1-17的数字或合法的拼音" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    _latestSearchArray = [[DBManager sharedInstance]findDetailCharactersFromTable:LatestSearchTable];
    
    [self displayLatestSearchSubView];
    
}
#pragma mark - 给self.view添加单击手势 点击屏幕的任意位置 让键盘自动消失
- (void) makeTextFieldDisappear
{
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(textFieldDisappea:)];
    [self.view addGestureRecognizer:tapGestureRecognizer];
}
#pragma mark - 手势响应事件
- (void) textFieldDisappea:(UITapGestureRecognizer *)tapGestureRecognizer
{
    [_textField resignFirstResponder];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self searchInSideWord];
    textField.text = nil;//每次操作完成后,把textField上面的内容置空
    return YES;
}
#pragma mark - 响应输入框中输入的事件
- (void) searchInSideWord
{
    NSString *insideString = _textField.text;
    int lenth = insideString.length;
    if (lenth > 0) {//判断是否有输入
        for (int i =0; i < _myPinYinAry1.count; i++) {//先判断输入的是否是有效的汉语拼音
            NSString *legalPinYin = [_myPinYinAry1 objectAtIndex:i];
            NSComparisonResult compResult = [insideString compare:legalPinYin options:NSCaseInsensitiveSearch];
            if (compResult == NSOrderedSame) {//如果是有效的输入则请求数据 不区分大小写
                //请求数据 判断是否请求成功
                DisplaySearchCharacterController *displayCtr = [[DisplaySearchCharacterController alloc]init];
                displayCtr.type = PinYin;
                displayCtr.searchIndentify = insideString;
                displayCtr.title = insideString;
                [self.navigationController pushViewController:displayCtr animated:YES];
                return;//说明输入的是合法的拼音,则直接从函数中返回 不再继续往下面执行
            }
        }
        //判断是否是有效的1-17的数子
        for (int i =0; i < _myShuZiAry.count; i++) {
            int inputShuZi = insideString.intValue;
            insideString = [NSString stringWithFormat:@"%d",inputShuZi-1];
            NSString *legalShuZi = [_myShuZiAry objectAtIndex:i];
            if ([insideString isEqualToString:legalShuZi]) {//如果是有效的输入(1 - 17)则请求数据  
                //请求数据 判断是否请求成功
                BuShouViewController *buShouCtr = [[BuShouViewController alloc]init];
                buShouCtr.title = @"部首检字";
                buShouCtr.indentify = insideString.intValue;
                [self.navigationController pushViewController:buShouCtr animated:YES];
                return;//说明输入的是合法的拼音,则直接从函数中返回 不再继续往下面执行
            }
        }
        //剩下的情况 (一个汉字的长度是1)该接口只允许请求一个汉字,所以lenth大于1则为非法请求,当lenth为1时(汉字,字母,其他非法字符)(上面已经判断过单个的数字了)
        if (insideString.length == 1) {
            for (int i = 0; i < _myZiMuAry.count; i++) {//判断是否是字母
                NSString *ziMu = [_myZiMuAry objectAtIndex:i];
                if ([insideString caseInsensitiveCompare:ziMu] == NSOrderedSame) {//如果是其中的一个字母的话
                    //弹出警告窗口,提示输入错误
                    [_alertView show];
                    return;
                }
            }
            //请求网络数据,如果请求下来,则是汉字 ，否则是非法输入
            [super loadWordData:insideString];//调用父类的方法,加载单个汉字的数据
            [super showMBProgressHUUD:@"正在加载数据......." isDin:YES];
        }else {
            //弹出警告窗口,提示输入错误
            [_alertView show];
        }
    }
    
}
#pragma mark - 请求数据完成后的操作
- (void) loadWordDataFinish:(NSDictionary *)result
{
    if (result == nil) {
        [_alertView show];
        [super hidMBProgressHUD];//加载失败时,也要把HUD提示view给关闭
        return;
    }
    [super hidMBProgressHUD];//加载完成时把HUD提示view关闭
    DisplayDetailCharacterViewController *disDetailCtr =[[DisplayDetailCharacterViewController alloc]init];
    DetailCharacterModel *detailCharacterModel = [super analysisDetailWordResult:result];
    NSDictionary *dicResult = [result objectForKey:@"data"];
    NSDictionary *baseInfoDic = [dicResult objectForKey:@"baseinfo"];
    CharacterModel *characterModel = [self analysisCharacterModelResult:baseInfoDic];
    disDetailCtr.isLoadDataFromNet = NO;
    disDetailCtr.characterModel = characterModel;
    disDetailCtr.detailCharacterModel = detailCharacterModel;
    [self.navigationController pushViewController:disDetailCtr animated:YES];
}
#pragma mark - 解析汉字接口请求下来的数据 返回的是CharacterModel类型的数据
- (CharacterModel *)analysisCharacterModelResult:(NSDictionary *)itemDic
{
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
}

#pragma mark - 每次遍历数组 把当前里面的数值填充到最近搜索的"button"
- (void) displayLatestSearchSubView
{
    for (int i = 0; i < _latestSearchArray.count; i++) {
        NSArray *array = [_latestSearchArray objectAtIndex:i];
        CharacterModel *characterModel = [array objectAtIndex:0];
        
        NSString *word = characterModel.jianTi;
        UIButton *btnLatestWord = (UIButton *)[_latestSearchView viewWithTag:i+100];
        if ([btnLatestWord isKindOfClass:[UIButton class]]) {
            [btnLatestWord setTitle:word forState:UIControlStateNormal];
        }
    }
}
#pragma mark - 绘制最近搜索的"button" 总共让显示最近搜索的9个汉字
- (void) drawLatestSearchSubView
{
#warning 一个界面中tag值千万不能重复
    for (int i = 0; i < kLatestSearchWordCount; i++) {
        UIButton *btnLatestWord = [UIButton buttonWithType:UIButtonTypeCustom];
        btnLatestWord.titleLabel.font = [UIFont systemFontOfSize:20.0f];
        [btnLatestWord setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btnLatestWord.tag = i+100;
        btnLatestWord.backgroundColor = [UIColor clearColor];
        btnLatestWord.frame = CGRectMake(i*30+(272-30*kLatestSearchWordCount)/2,(35-30)/2, 30, 30);
        [btnLatestWord addTarget:self action:@selector(displayLatestWordAction:) forControlEvents:UIControlEventTouchUpInside];
        [_latestSearchView addSubview:btnLatestWord];
    }
}
#pragma mark - 绘制显示拼音搜索方式的"button"
- (void) drawPinYinSubView
{
    int row = 0,colum = 0;
    for (int i = 0; i < _pinYinArray.count; i++) {
        NSString *pinYin = [_pinYinArray objectAtIndex:i];
        UIButton *btnPinYin = [UIButton buttonWithType:UIButtonTypeCustom];
        btnPinYin.titleLabel.font = [UIFont systemFontOfSize:25.0f];
        [btnPinYin setTitle:pinYin forState:UIControlStateNormal];
        [btnPinYin setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btnPinYin.tag = i + 10;
        btnPinYin.backgroundColor = [UIColor clearColor];
        [btnPinYin addTarget:self action:@selector(pinYinAction:) forControlEvents:UIControlEventTouchUpInside];
        btnPinYin.frame = CGRectMake(colum*32+8, row*40+15, 32, 40);
        colum ++;
        if (colum % 8 == 0) {
            row ++;
            colum = 0;
        }
        if (row > 3) {
            row = 4;
        }
        [_searchTypeView addSubview:btnPinYin];
    }
}

#pragma mark - 绘制显示笔顺搜索方式的"button"
- (void) drawBiShunSubView
{
    int row = 0,colum = 0;
    for (int i = 0; i < _biShunArray.count; i++) {
        NSString *biShun = [_biShunArray objectAtIndex:i];
        UIButton *btnBiShun = [UIButton buttonWithType:UIButtonTypeCustom];
        btnBiShun.titleLabel.font = [UIFont systemFontOfSize:25.0f];
        [btnBiShun setTitle:biShun forState:UIControlStateNormal];
        [btnBiShun setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btnBiShun.tag = i + 40;
        btnBiShun.backgroundColor = [UIColor clearColor];
        [btnBiShun addTarget:self action:@selector(biShunAction:) forControlEvents:UIControlEventTouchUpInside];
        btnBiShun.frame = CGRectMake(colum*37+13/2, row*50+15, 37, 50);
        colum ++;
        if (colum % 7 == 0) {
            row ++;
            colum = 0;
        }
        if (row > 2) {
            row = 3;
        }
        [_searchTypeView addSubview:btnBiShun];
    }

}

#pragma mark - 根据传入的参数值 来设置哪些subView的显示属性
- (void) showSearchTypeSubView:(BOOL)isShow searchType:(SearchType)searchType
{
    for (UIView *subView in _searchTypeView.subviews) {
        if (searchType == BiHua) {
            if (subView.tag > 9&&subView.tag < 36 ) {
                subView.hidden = isShow;
            } else {
                subView.hidden = !isShow;
            }
        }else if (searchType == PinYin) {
            if (subView.tag > 39&&subView.tag < 57 ) {
                subView.hidden = isShow;
            } else {
                subView.hidden = !isShow;
            }
        }
    }
}
#pragma mark - 切换搜索类型
- (void) changeSearchType
{
    int index = _segmentCtr.selectedSegmentIndex;
    if (index == 0) {
        [self showSearchTypeSubView:YES searchType:PinYin];
        _searchTypeLabel.text = @"按照拼音字母检索:";
    } else if (index == 1) {
        [self showSearchTypeSubView:YES searchType:BiHua];
        _searchTypeLabel.text = @"按照笔顺顺序检索:";
    }
    [_textField resignFirstResponder];
}
#pragma mark - 当点击最近搜索的汉字时,做出响应跳转到该汉字详细的界面
- (void) displayLatestWordAction:(UIButton *)btnLatestWord
{
    int index = btnLatestWord.tag - 100;
    if (index > _latestSearchArray.count) {
        return;
    }
    NSArray *array = [_latestSearchArray objectAtIndex:index];
    CharacterModel *characterModel = [array objectAtIndex:0];
    DetailCharacterModel *detailCharacterModel = [array objectAtIndex:1];
    DisplayDetailCharacterViewController *disDetCtr = [[DisplayDetailCharacterViewController alloc]init];
    disDetCtr.characterModel = characterModel;
    disDetCtr.detailCharacterModel = detailCharacterModel;
    disDetCtr.isLoadDataFromNet = NO;
    [self.navigationController pushViewController:disDetCtr animated:YES];

}
#pragma mark - 点击笔顺搜索汉字时 做出的响应事件
- (void) biShunAction:(UIButton *)btnBiShun
{
    int index = btnBiShun.tag - 40;
    BuShouViewController *buShouCtr = [[BuShouViewController alloc]init];
    buShouCtr.title = @"部首检字";
    buShouCtr.indentify = index;
    [self.navigationController pushViewController:buShouCtr animated:YES];
}
#pragma mark - 点击拼音搜索汉字时 做出响应事件
- (void) pinYinAction:(UIButton *)btnPinYin
{
    PinYinViewController *pinYinCtr = [[PinYinViewController alloc]init];
    pinYinCtr.indentify = btnPinYin.tag - 10;
    pinYinCtr.title = @"拼音检字";
    [self.navigationController pushViewController:pinYinCtr animated:YES];
}

#pragma mark - 点击导航栏右边的按钮时 响应事件 进入个人中心
- (void) pushNextCtr
{
    PersonalCenterViewController *personCenterCtr = [[PersonalCenterViewController alloc]init];
    [self.navigationController pushViewController:personCenterCtr animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
