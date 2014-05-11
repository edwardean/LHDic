//
//  DictionaryTableView.m
//  GFHYCD
//
//  Created by Ibokan on 13-9-16.
//  Copyright (c) 2013年 ibokan. All rights reserved.
//

#import "DictionaryTableView.h"
#import "DisplayDetailCharacterViewController.h"
@implementation DictionaryTableView

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style 
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.dataSource = self;
        self.delegate = self;
        [self initSubView];
        
    }
    return self;
}
#pragma mark - 初始化子视图
- (void) initSubView
{
    UIButton *loadMoreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _loadMoreButton = loadMoreBtn;//全局的变量 需要持有
    _loadMoreButton.backgroundColor = [UIColor clearColor];
    _loadMoreButton.frame = CGRectMake(0, 0, kScreenWidth, 70);
    _loadMoreButton.titleLabel.font = [UIFont systemFontOfSize:17.0f];
    [_loadMoreButton setTitle:@"上拉加载更多......" forState:UIControlStateNormal];
    [_loadMoreButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _loadMoreButton.backgroundColor = [UIColor colorWithRed:220 green:220 blue:220 alpha:1];
    [_loadMoreButton addTarget:self action:@selector(loadMoreAction) forControlEvents:UIControlEventTouchUpInside];
    self.tableFooterView = _loadMoreButton;//能不能释放
    
    UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicatorView.frame = CGRectMake(70, (70-20)/2, 20, 20);
    [activityIndicatorView stopAnimating];
    activityIndicatorView.tag = 2011;
    [_loadMoreButton addSubview:activityIndicatorView];
}
#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *indentify = @"cellIndentify";
    DictionaryCell *cell = [tableView dequeueReusableCellWithIdentifier:indentify];
    if (cell == nil) {
        cell = [[DictionaryCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentify];
    }
    
    CharacterModel *characterModel = [_dataArray objectAtIndex:indexPath.row];
    cell.characterModel = characterModel;
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //跳转到详细汉字的界面
    CharacterModel *characterModel = [_dataArray objectAtIndex:indexPath.row];
    DisplayDetailCharacterViewController *detailCtr = [[DisplayDetailCharacterViewController alloc]init];
    detailCtr.characterModel = characterModel;
    
    [tableView performSelector:@selector(deselectRowAtIndexPath:animated:) withObject:indexPath afterDelay:0.1];
    
    [tableView.getFirstController.navigationController pushViewController:detailCtr animated:YES];
}

- (float) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 71;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    float offSet = scrollView.contentOffset.y;
    float contentHeight = scrollView.contentSize.height;
    if ((offSet + scrollView.height) - contentHeight > 40) {
        if (_isMore) {
            [self startLoadMore];
            [self.eventDelegate pullUp:self];//响应下拉加载的方法
        }
    }
//    NSLog(@"offSet%f contentHeight%f scrollView.height%f",offSet,contentHeight,scrollView.height);
}
#pragma mark - 当数据加载完成 刷新tableView时 让_loadMoreButton上面的状态恢复到原来的状态
- (void) reloadData
{
    [super reloadData];
    [self stopLoadMore];
}
#pragma mark - 停止加载更多
- (void) stopLoadMore
{
    if (self.dataArray.count > 0) {
        _loadMoreButton.hidden = NO;
        UIActivityIndicatorView *activityView = (UIActivityIndicatorView *)[_loadMoreButton viewWithTag:2011];
        [activityView stopAnimating];//先让activityView停止加载 然后判断是否有更多数据
        if (_isMore) {
            [_loadMoreButton setTitle:@"上拉加载更多......" forState:UIControlStateNormal];
        } else {//没有更多数据话 让其禁用
            [_loadMoreButton setTitle:@"加载完成" forState:UIControlStateNormal];
            _loadMoreButton.enabled = NO;
        }
    } else //没有数据的话 直接让其隐藏
    {
        _loadMoreButton.hidden = YES;
    }
}
#pragma mark - 更改_loadMoreButton上面的状态
- (void) startLoadMore
{
    if (self.dataArray.count > 0) {
        _loadMoreButton.hidden = NO;
        UIActivityIndicatorView *activityView = (UIActivityIndicatorView *)[_loadMoreButton viewWithTag:2011];
        if (_isMore) {
            [_loadMoreButton setTitle:@"正在加载数据...." forState:UIControlStateNormal];
            [activityView startAnimating];
        }else {
            [_loadMoreButton setTitle:@"加载完成" forState:UIControlStateNormal];
            _loadMoreButton.enabled = NO;
            [activityView stopAnimating];
        }
        
    } else {
        _loadMoreButton.hidden = YES;
    }
    
}
#pragma mark - 点击下拉加载更多按钮时 触发操作
- (void) loadMoreAction
{
    [self startLoadMore];
    [_eventDelegate pullUp:self];//响应下拉加载的方法
}

@end












