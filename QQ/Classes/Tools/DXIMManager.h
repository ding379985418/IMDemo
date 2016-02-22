//
//  DXIMManager.h
//  QQ
//
//  Created by simon on 16/1/24.
//  Copyright © 2016年 simon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <DDLog.h>
#import <DDTTYLogger.h>
#import <XMPPLogging.h>
#import "SSKeychain.h"
#import <XMPPFramework.h>
#import <XMPPReconnect.h>
#import <XMPPRoster.h>
#import <XMPPRosterCoreDataStorage.h>
#import <XMPPMessageArchiving.h>
#import <XMPPMessageArchivingCoreDataStorage.h>
#import <XMPPvCardTempModule.h>
#import <XMPPvCardAvatarModule.h>
#import <XMPPvCardCoreDataStorage.h>
@interface DXIMManager : NSObject
//判断是否为注册
@property (nonatomic, assign) BOOL isRegister;
//xmpp数据流
@property (nonatomic, strong,readonly) XMPPStream *stream;
//联系人模块
@property (nonatomic, strong,readonly) XMPPRoster *xmppRoster;
//联系人储存模块
@property (nonatomic, strong,readonly) XMPPRosterCoreDataStorage *xmppRosterCoreDataStorage;
//消息归档模块
@property (nonatomic, strong,readonly) XMPPMessageArchiving *xmppMessageArchiving;
//消息归档CoreData
@property (nonatomic, strong,readonly) XMPPMessageArchivingCoreDataStorage *xmppMessageArchivingCoreDataStorage;
//个人资料模块
@property (nonatomic, strong,readonly) XMPPvCardTempModule *xmppVCardTempModule;
@property (nonatomic, strong) XMPPvCardAvatarModule *xmppVCardAvatarModule;

//*单例方法*/
+ (instancetype)sharedManager;

//*连接服务器*/
- (void)connectWithHostName:(NSString *)hostName userName:(NSString *)userName password:(NSString *)password isSucess:(void(^)(BOOL sucess))resultBlock;

//*断开与服务器*/
- (void)disconnect;
///添加好友
- (void)subscribePresenceToUser:(XMPPJID *)jid isSucess:(void(^)(BOOL sucess))resultBlock;
@end
