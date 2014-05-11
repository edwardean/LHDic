//
//  DisplaySearchCharacterController.m
//  GFHYCD
//
//  Created by Ibokan on 13-9-18.
//  Copyright (c) 2013年 ibokan. All rights reserved.
//

#import "DisplaySearchCharacterController.h"
#import "GFHttpRequest.h"

@interface DisplaySearchCharacterController ()

@end

@implementation DisplaySearchCharacterController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.curpage = @"0";
        self.characterArray = [[NSArray alloc]init];//一定要初始化数组
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self initSubView];
    [self loadCharacterData];
}
#pragma mark - 初始化ui
- (void) initSubView
{
    _tableView = [[DictionaryTableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
    _tableView.eventDelegate = self;//设置上拉刷新的委托为本对象
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.hidden = YES;//刚开始让表隐藏
    [self.view addSubview:_tableView];
}
#pragma mark - 开始请求数据
- (void) loadCharacterData
{
    [super showLoading:YES];
    NSString *urlParam = nil;
    NSMutableArray *params = [NSMutableArray arrayWithObjects:_searchIndentify,_curpage,PageSize,nil];//每次默认请求从0开始 请求5条数据
    if (_type == PinYin) {
        urlParam = @"pinyin";
        
    } else if (_type == BiHua) {
        urlParam = @"bushou";
    }
    [GFHttpRequest getRequestWithURL:urlParam params:params completeBlock:^(id result) {
        if (result != nil) {
            [self loadFinishCharacterData:result];
        } else {
            NSLog(@"请求数据失败");
            return;
        }
        
    }];
}
#pragma mark - 数据请求结束 解析并更新ui
- (void) loadFinishCharacterData:(NSDictionary *)result
{
    NSDictionary *resultDic = [self analysisWordResult:result];
    NSMutableArray *dataArray = [resultDic objectForKey:kResult];
    self.pagenum = [resultDic objectForKey:kPagenum];//获取共有多少页数据
    self.curpage = [self addString:_curpage and:PageSize];
//拼音接口:请求的数据时,没有pagenum curpage pagesize这三个数值
//拼音接口:当请求下来的数目小于没次请求的标准数量时,证明已经没有更多数据了
    if (self.pagenum == nil) {
        if (dataArray.count >= PageSize.intValue) {
            _tableView.isMore = YES;
        } else {
            _tableView.isMore = NO;
        }
    }else {//笔顺接口:如果当前页大于总的页数 则不显示更多,
        if ([_curpage intValue] >= ([_pagenum intValue])) {
            _tableView.isMore = NO;
        } else {
            _tableView.isMore = YES;
        }
    }
    self.characterArray =  [self.characterArray arrayByAddingObjectsFromArray:dataArray];
    _tableView.dataArray = _characterArray;
    [super showLoading:NO];//不再显示加载提示
    _tableView.hidden = NO;//让tableView从新出来 并更新UI
    [_tableView reloadData];
}

#pragma mark - 计算两个字符串的和 并把所得结果返回
- (NSString *)addString:(NSString *)curPage and:(NSString *)pageSize
{
    int curpage = curPage.intValue + pageSize.intValue;
    return [NSString stringWithFormat:@"%d",curpage];
}

#pragma mark - UITableViewUpDownEvent
- (void)pullUp:(UITableView *)tableView
{
    if (_tableView.isMore) {//有更多时 加载数据
        [self loadCharacterData];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
