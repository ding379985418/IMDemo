//
//  DXAudioTools.m
//  QQ
//
//  Created by simon on 16/1/30.
//  Copyright © 2016年 simon. All rights reserved.
//

#import "DXAudioTools.h"
#import <AVFoundation/AVFoundation.h>
static NSMutableDictionary *_soundDict;

@implementation DXAudioTools

//只要头文件参与了编译就会调用
+ (void)load
{
    NSLog(@"%s",__func__);
}

//类的实例对象被创建的时候会调用
+ (void)initialize
{
    _soundDict = [NSMutableDictionary dictionary];
}

// 此时, SoundID会重复创建
// 一个URL地址, 将来对应的是一个soundID

/// 播放不带震动的音效
+ (void)playSystemSoundWithURL:(NSURL *)url
{
    //播放音效
    AudioServicesPlaySystemSound([self loadSoundIDWithURL:url]);
}

/// 播放带震动的音效
+ (void)playAlertSoundWithURL:(NSURL *)url
{
    // 播放音效
    AudioServicesPlayAlertSound([self loadSoundIDWithURL:url]);
}

// 公用的加载soundID的方法
+ (SystemSoundID)loadSoundIDWithURL:(NSURL *)url
{
    // 先判断缓存字典中, 是否有URL对应的soundID. 如果soundID存在, 直接播放
    
    //1. 获取URL的绝对路径
    NSString *urlStr = url.absoluteString;
    
    //2. 从缓存字典中获取SystemSoundID UInt32
    SystemSoundID soundID = [_soundDict[urlStr] intValue];
    
    //3. 判断, 如果soundID为0, 代表着, 值为空, 需要创建
    if (soundID == 0) {
        //3.1. 创建音效
        AudioServicesCreateSystemSoundID((__bridge CFURLRef _Nonnull)(url), &soundID);
        
        //3.2 记录URL对应的soundID
        NSString *urlStr = url.absoluteString;
        _soundDict[urlStr] = @(soundID);
    }
    
    NSLog(@"soundID:%zd",soundID);
    
    return soundID;
}


/// 清空音效文件的缓存
+ (void)clearMemory
{
    // 遍历字典
    [_soundDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        
        SystemSoundID soundID = [obj intValue];
        
        AudioServicesDisposeSystemSoundID(soundID);
    }];
    
    // 缓存字典清空
    [_soundDict removeAllObjects];
    
}

@end
