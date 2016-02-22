//
//  DXAudioTools.h
//  QQ
//
//  Created by simon on 16/1/30.
//  Copyright © 2016年 simon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DXAudioTools : NSObject
/// 播放不带震动的音效
+ (void)playSystemSoundWithURL:(NSURL *)url;

/// 播放带震动的音效
+ (void)playAlertSoundWithURL:(NSURL *)url;

/// 清空音效文件的缓存
+ (void)clearMemory;
@end
