//
//  DXRecentVc.m
//  QQ
//
//  Created by simon on 16/1/27.
//  Copyright © 2016年 simon. All rights reserved.
//

#import "DXRecentVc.h"
#import "DXChatViewController.h"
#import "DXRecentCell.h"
#import "AppDelegate.h"
@interface DXRecentVc ()<UITableViewDelegate,UITableViewDataSource,NSFetchedResultsControllerDelegate,XMPPvCardAvatarDelegate,XMPPStreamDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

//好友搜索“控制器”
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@end

@implementation DXRecentVc
static NSString *buddyID = @"recentCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"消息";
    self.automaticallyAdjustsScrollViewInsets = NO;
  
    self.navigationItem.leftBarButtonItem = [DXTools myIconBarButtonItem];
    
    [self.fetchedResultsController performFetch:NULL];
    
    [[DXIMManager sharedManager].xmppVCardAvatarModule addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    [[DXIMManager sharedManager].stream addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    self.tableView.tableFooterView = [[UIView alloc]init];

}

- (IBAction)logOutBtnClick:(UIBarButtonItem *)sender {
    [[DXIMManager sharedManager]disconnect];
    [[NSNotificationCenter defaultCenter]postNotificationName:DXNotificationLogInVcSwitchRootVc object:@(NO)];
}

//跳转控制器
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    XMPPMessageArchiving_Contact_CoreDataObject *obj = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [self.navigationController pushViewController:[DXChatViewController chatViewControllerWith:obj.bareJid] animated:YES];
}
#pragma mark -XMPPStreamDelegate

- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message{
    UILocalNotification *noti = [[UILocalNotification alloc]init];
    [noti setAlertBody:message.body];
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    if (delegate.isbackGround && message.body != nil ) {
        [noti setApplicationIconBadgeNumber:1];
    }
    [[UIApplication sharedApplication]presentLocalNotificationNow:noti];
    
}
#pragma mark -UITableViewDataSource代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  self.fetchedResultsController.fetchedObjects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DXRecentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DXRecentCell"];
    
    XMPPMessageArchiving_Contact_CoreDataObject *obj = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    //    好友名称
    cell.nameLabel.text = [DXTools userNameWithJIDBar:obj.bareJidStr];
    [cell.iconImageView setImage:[UIImage imageWithData:[[DXIMManager sharedManager].xmppVCardAvatarModule photoDataForJID:obj.bareJid]]];
    cell.messageLabel.text = obj.mostRecentMessageBody;
    
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
//    [formatter setLocale:[NSLocale localeWithLocaleIdentifier:@"en"]];
    [formatter setDateFormat:@"HH:mm"];
    
    [cell.timeLabel setText:[formatter stringFromDate:obj.mostRecentMessageTimestamp]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

#pragma mark -XMPPvCardAvatarDelegate
- (void)xmppvCardAvatarModule:(XMPPvCardAvatarModule *)vCardTempModule
              didReceivePhoto:(UIImage *)photo
                       forJID:(XMPPJID *)jid{
    [self.tableView reloadData];
}
#pragma mark -NSFetchedResultsControllerDelegate代理方法
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller{
    [self.fetchedResultsController performFetch:NULL];
    [self.tableView reloadData];
}
#pragma mark -懒加载
- (NSFetchedResultsController *)fetchedResultsController{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"XMPPMessageArchiving_Contact_CoreDataObject"];
    
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"streamBareJidStr == %@",[DXIMManager sharedManager].stream.myJID.bare];
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"mostRecentMessageTimestamp" ascending:NO];
    
    fetchRequest.predicate = pre;
    fetchRequest.sortDescriptors = @[sort];
    
    _fetchedResultsController = [[NSFetchedResultsController alloc]initWithFetchRequest:fetchRequest managedObjectContext:[DXIMManager sharedManager].xmppMessageArchivingCoreDataStorage.mainThreadManagedObjectContext sectionNameKeyPath:nil cacheName:nil];
    _fetchedResultsController.delegate = self;
    
    return _fetchedResultsController;
}

@end
