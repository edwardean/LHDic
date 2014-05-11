//
//  DetailCharacterView.m
//  GFHYCD
//
//  Created by Ibokan on 13-9-20.
//  Copyright (c) 2013年 ibokan. All rights reserved.
//

#import "DetailCharacterView.h"

@implementation DetailCharacterView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubView];
    }
    return self;
}
- (void) awakeFromNib
{
    [super awakeFromNib];
    [self initSubView];
}
#pragma mark - 初始化子视图
- (void) initSubView{
    _segmentedControl = (UISegmentedControl *)[self viewWithTag:200];
    _imageView = (UIImageView *)[self viewWithTag:201];
    _nameLabel = (UILabel *)[self viewWithTag:202];
    _textView = (UITextView *)[self viewWithTag:203];
    
    [_segmentedControl addTarget:self action:@selector(selectAction) forControlEvents:UIControlEventValueChanged];
}
#pragma mark - 填充数据
- (void) layoutSubviews
{
    [super layoutSubviews];
    [self setDataForSubView];
}

- (void) setDetailCharacterModel:(DetailCharacterModel *)detailCharacterModel
{
    if (_detailCharacterModel != detailCharacterModel) {
        _detailCharacterModel = detailCharacterModel;
    }
    [self setDataForSubView];
}
#pragma mark - 为子视图填充数据
- (void) setDataForSubView
{
    _textView.text = _detailCharacterModel.hanYu;
    _myDetailCharacterBlock(_detailCharacterModel.hanYu);
}
#warning 需要做是否为空的处理 但是既然传过来值说明都已经是不为空了,为啥还崩溃
#pragma mark - 点击那个_segmentedControl时,响应的事件
- (void) selectAction
{
    NSArray *array = [NSArray arrayWithObjects:_detailCharacterModel.hanYu,_detailCharacterModel.base,_detailCharacterModel.idiom,_detailCharacterModel.english, nil];
    int index = _segmentedControl.selectedSegmentIndex;
    _nameLabel.text = [_segmentedControl titleForSegmentAtIndex:index];
    NSString *selectStr = [array objectAtIndex:index];
    _textView.text = selectStr;
    _myDetailCharacterBlock(selectStr);
}
@end







