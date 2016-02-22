//
//  DXIMManager.m
//  QQ
//
//  Created by simon on 16/1/24.
//  Copyright © 2016年 simon. All rights reserved.
//

#import "DXIMManager.h"
#import "DXAudioTools.h"

@interface DXIMManager ()<XMPPStreamDelegate,XMPPRosterDelegate>

@property (nonatomic, copy) NSString *password;
//记录是否登陆成功的block回调
@property (nonatomic, copy) void(^resultBlock)(BOOL sucess);
//自动连接模块
@property (nonatomic, strong) XMPPReconnect *xmppReconnect;


@end

@implementation DXIMManager
@synthesize stream = _stream;
static const int ddLogLevel = LOG_LEVEL_VERBOSE;
+ (instancetype)sharedManager{

    static DXIMManager *sharedManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[DXIMManager alloc]init];
        // 1. 设置Logger
        [DDTTYLogger sharedInstance].colorsEnabled = YES;
        [[DDTTYLogger sharedInstance] setForegroundColor:[UIColor blueColor] backgroundColor:nil forFlag:LOG_FLAG_INFO];
        [[DDTTYLogger sharedInstance] setForegroundColor:[UIColor darkGrayColor] backgroundColor:nil forFlag:XMPP_LOG_FLAG_SEND_RECV];
        [DDLog addLogger:[DDTTYLogger sharedInstance] withLogLevel:XMPP_LOG_FLAG_SEND_RECV | LOG_LEVEL_INFO];
    });
    return sharedManager;
}

///连接服务器
- (void)connectWithHostName:(NSString *)hostName userName:(NSString *)userName password:(NSString *)password isSucess:(void (^)(BOOL))resultBlock{
//    记录结果的block
    self.resultBlock = resultBlock;
    NSString *JIDString = [NSString stringWithFormat:@"%@@%@",userName,hostName];
    XMPPJID *myJID = [XMPPJID jidWithString:JIDString];
    self.stream.hostName = hostName;
    self.stream.myJID = myJID;
    //    self.stream.hostPort = @"";
    [self.stream connectWithTimeout:XMPPStreamTimeoutNone error:NULL];
    self.password = password;
}
- (void)disconnect{
    [self.stream disconnect];
    [self cleanUserInfo];
}
///上线状态
- (void)setPresenceState{
    XMPPPresence *presence = [XMPPPresence presence];
    //    发送上线状态的节点

    [self.stream sendElement:presence];
    SSLog(@"发送上线状态");
//    DDLogInfo(@"ff");
}
- (void)setOffLinePresence{
    XMPPPresence *p = [XMPPPresence presenceWithType:@"unavailable"];
    [self.stream sendElement:p];
    SSLog(@"发送下线连接");
    
}
///清除用户信息
- (void)cleanUserInfo{

    [SSKeychain deletePasswordForService:[NSBundle mainBundle].bundleIdentifier account:[DXTools userNameForUserDefaults]];
    [DXTools deleteUserNamFromUserDefaults];

}
#pragma mark -XMPPRoster代理方法

//*收到好友订阅请求*/
- (void)xmppRoster:(XMPPRoster *)sender didReceivePresenceSubscriptionRequest:(XMPPPresence *)presence{
    
    SSLog(@"%@",presence.from);
    NSString *message = [NSString stringWithFormat:@"%@ 请求添加您为好友",presence.fromStr];

    [DXTools alerViewWithMessage:message title:@"添加好友请求" actionStr:@"接受" handler:^(UIAlertAction *action) {
        [sender acceptPresenceSubscriptionRequestFrom:presence.from andAddToRoster:YES];
//        SSLog(@"************接受**********");
    } actionSecondStr:@"不接受" handlerSecond:^(UIAlertAction *action) {
        [sender rejectPresenceSubscriptionRequestFrom:presence.from];
//         SSLog(@"**********不接受*********");
    } ];
    
}
#pragma mark -XMPPStream代理方法
- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message{
    if (message.body != nil) {
        NSURL *scound = [[NSBundle mainBundle]URLForResource:@"QQ_Scound.wav" withExtension:nil];
        [DXAudioTools playSystemSoundWithURL:scound];
    }
}
//*连接服务器成功*/
- (void)xmppStreamDidConnect:(XMPPStream *)sender{
    SSLog(@"连接到服务器");
    if (self.isRegister) {
        self.isRegister = NO;
        [self.stream registerWithPassword:self.password error:NULL];
    }else{
    [self.stream authenticateWithPassword:self.password error:NULL];
        
    }
}
//**注册成功*/
- (void)xmppStreamDidRegister:(XMPPStream *)sender{
    SSLog(@"注册成功");
    if (self.resultBlock) {
        self.resultBlock(YES);
    }
    [self disconnect];
}
//**注册失败*/
- (void)xmppStream:(XMPPStream *)sender didNotRegister:(DDXMLElement *)error{
     SSLog(@"注册失败");
    [self disconnect];
    if (self.resultBlock) {
        self.resultBlock(NO);
    }
    
}
///密码错误，登陆失败
- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(DDXMLElement *)error{
    if (self.resultBlock) {
         self.resultBlock(NO);
    }
    [self disconnect];
    
   [[NSNotificationCenter defaultCenter]postNotificationName:DXNotificationLogInVcSwitchRootVc object:@(NO)];
    SSLog(@"密码错误");
}
///密码正确，登陆成功
- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender{
    SSLog(@"登陆成功");
    if (self.resultBlock) {
        self.resultBlock(YES);
    }
    
    [self setPresenceState];
    [[NSNotificationCenter defaultCenter]postNotificationName:DXNotificationLogInVcSwitchRootVc object:@(YES)];
    
}
///断开服务器连接
- (void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error{
//    设置下线状态
    [self setOffLinePresence];
}
#pragma mark -懒加载
- (XMPPStream *)stream{
    if (!_stream) {
        _stream = [[XMPPStream alloc]init];
//        实例化自动连接模块
        _xmppReconnect = [[XMPPReconnect alloc]init];
//        实例化联系人模块
        _xmppRosterCoreDataStorage = [XMPPRosterCoreDataStorage sharedInstance];
        
       _xmppRoster = [[XMPPRoster alloc]initWithRosterStorage:_xmppRosterCoreDataStorage dispatchQueue:dispatch_get_global_queue(0, 0)];
        
//        实例化消息模块
        _xmppMessageArchivingCoreDataStorage = [XMPPMessageArchivingCoreDataStorage sharedInstance];
        _xmppMessageArchiving = [[XMPPMessageArchiving alloc]initWithMessageArchivingStorage:_xmppMessageArchivingCoreDataStorage dispatchQueue:dispatch_get_global_queue(0, 0)];
        
//        实例化个人资料模块
        _xmppVCardTempModule = [[XMPPvCardTempModule alloc]initWithvCardStorage:[XMPPvCardCoreDataStorage sharedInstance] dispatchQueue:dispatch_get_global_queue(0, 0)];
        
        _xmppVCardAvatarModule = [[XMPPvCardAvatarModule alloc]initWithvCardTempModule:_xmppVCardTempModule dispatchQueue:dispatch_get_global_queue(0, 0)];
        
//        激活自动连接模块
        [_xmppReconnect activate:_stream];
//        自动接受好友请求
        _xmppRoster.autoAcceptKnownPresenceSubscriptionRequests = NO;
//        激活联系人模块
        [_xmppRoster activate:_stream];
//        激活消息模块
        [_xmppMessageArchiving activate:_stream];
        
//        激活个人中心模块
        [_xmppVCardTempModule activate:_stream];
        [_xmppVCardAvatarModule activate:_stream];
        
//        添加代理
        [_stream addDelegate:self delegateQueue:dispatch_get_global_queue(0, 0)];
        [_xmppRoster addDelegate:self delegateQueue:dispatch_get_global_queue(0, 0)];
//        [_xmppMessageArchiving addDelegate:self delegateQueue:dispatch_get_global_queue(0, 0)];
    }
    return _stream;
}

//对象被销毁时，销毁对象和观察者
- (void)dealloc{
//    移除观察
    [self.xmppRoster removeDelegate:self];
    [self.stream removeDelegate:self];

    
//    禁用模块
    [self.xmppRoster deactivate];
    [self.xmppReconnect deactivate];
    [self.xmppMessageArchiving deactivate];
    
//    释放内存
//    self.xmppRoster = nil;
//    self.xmppReconnect = nil;
//    self.xmppRosterCoreDataStorage = nil;
//    self.xmppMessageArchiving = nil;
//    self.xmppMessageArchivingCoreDataStorage = nil;
    
    
//    self.stream = nil;
}
@end
