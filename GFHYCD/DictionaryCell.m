//
//  DictionaryCell.m
//  GFHYCD
//
//  Created by Ibokan on 13-9-18.
//  Copyright (c) 2013年 ibokan. All rights reserved.
//

#import "DictionaryCell.h"
#import "DisplaySearchCharacterController.h"
@implementation DictionaryCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier 
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIView *view = [[[NSBundle mainBundle] loadNibNamed:@"DictionaryCell" owner:self options:nil]lastObject];
        [self.contentView addSubview:view];
#warning NSBundle loadNibNamed 出来的东西千万不能释放
        self.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    return self;
}
#pragma mark - 加载数据
- (void) layoutSubviews
{
    [super layoutSubviews];
    [self.jianTi setTitle: _characterModel.jianTi forState:UIControlStateNormal];
    self.pinYin.text = [NSString stringWithFormat:@"[%@]",_characterModel.pinYin];
    self.buShou.text = _characterModel.buShou;
    self.biHua.text = _characterModel.biHua;
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(soundAction:)];
    [self.shengYin addGestureRecognizer:tapGestureRecognizer];
}
#pragma mark - 若用户响应手势 则播放网络声音
- (void) soundAction:(UITapGestureRecognizer *)tapGestureRecognizer
{
    NSString *soundUrlStr = [kSoundUrlStr stringByAppendingString:_characterModel.jianTi];
    NSURL *url = [NSURL URLWithString:soundUrlStr];
    [NSThread detachNewThreadSelector:@selector(loadSoundData:) toTarget:self withObject:url];
}
#pragma mark - 下载声音数据
- (void) loadSoundData:(NSURL *)url
{
    DisplaySearchCharacterController *displaySearchCharacterController  = (DisplaySearchCharacterController *)self.getFirstController;
    [displaySearchCharacterController loadSoundData:url];

}

@end
