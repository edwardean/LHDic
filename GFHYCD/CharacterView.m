//
//  CharacterView.m
//  GFHYCD
//
//  Created by Ibokan on 13-9-20.
//  Copyright (c) 2013年 ibokan. All rights reserved.
//

#import "CharacterView.h"
#import "DisplayDetailCharacterViewController.h"
@implementation CharacterView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView *view = [[[NSBundle mainBundle]loadNibNamed:@"CharacterView" owner:self options:nil] lastObject];
        [self addSubview:view];
    }
    return self;
}
- (void) setCharacterModel:(CharacterModel *)characterModel
{
    if (_characterModel != characterModel) {
        _characterModel = characterModel;
    }
    [self setDataForSubView];
}
//填充数据
- (void) layoutSubviews
{
    [super layoutSubviews];
    [self setDataForSubView];
}
#pragma mark - 为子视图填充数据
- (void) setDataForSubView
{
    [self.jianTi setTitle:_characterModel.jianTi forState:UIControlStateNormal];
    self.pinYin.text = _characterModel.pinYin;
    self.fanTi.text = _characterModel.fanTi;
    self.buShou.text = _characterModel.buShou;
    self.biShun.text = _characterModel.biShun;
    self.zhuYin.text = _characterModel.zhuYin;
    self.jieGou.text = _characterModel.jieGou;
    self.biHua.text = _characterModel.biHua;
    self.buShouBiHua.text = _characterModel.buShouBiHua;
}
#pragma mark - 点击声音图标时 播放声音
- (IBAction)soundAction:(id)sender {
   
    NSString *soundUrlStr = [kSoundUrlStr stringByAppendingString:_characterModel.jianTi];
     NSURL *url = [NSURL URLWithString:soundUrlStr];
     [NSThread detachNewThreadSelector:@selector(loadSoundData:) toTarget:self withObject:url];
}
#pragma mark - 加载声音资源
- (void) loadSoundData:(NSURL *)url
{
     DisplayDetailCharacterViewController *disPlayViewCtr = (DisplayDetailCharacterViewController *)[self getFirstController];
    [disPlayViewCtr loadSoundData:url];
}
@end
