//
//  DXBuddyVc.m
//  QQ
//
//  Created by simon on 16/1/27.
//  Copyright © 2016年 simon. All rights reserved.
//

#import "DXBuddyVc.h"
#import "DXChatViewController.h"
#import "DXBuddyCell.h"

@interface DXBuddyVc ()<UITableViewDelegate,UITableViewDataSource,NSFetchedResultsControllerDelegate,XMPPvCardAvatarDelegate>
//好友展示列表
@property (weak, nonatomic) IBOutlet UITableView *buddyTableView;

//好友搜索“控制器”
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@end

@implementation DXBuddyVc
static NSString *buddyID = @"buddyID";
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"联系人";
//    UIImage *myImage = [UIImage imageWithData: [[DXIMManager sharedManager].xmppVCardAvatarModule photoDataForJID:[DXIMManager sharedManager].stream.myJID]];
//    UIImageView *iconView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
//    iconView.layer.masksToBounds = YES;
//    iconView.layer.cornerRadius = 20;
//    iconView.image = myImage;
    
    self.navigationItem.leftBarButtonItem = [DXTools myIconBarButtonItem];//[[UIBarButtonItem alloc]initWithCustomView:iconView];
    
    
    [self.fetchedResultsController performFetch:NULL];
    
    [[DXIMManager sharedManager].xmppVCardAvatarModule addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    self.buddyTableView.tableFooterView = [[UIView alloc]init];
    
}
- (NSString *)stateWithSection:(NSInteger)section{
    switch (section) {
        case 0:
            return @"在线";
            break;
        case 1:
            return @"离开";
            break;
        case 2:
            return @"离线";
            break;
            
        default:
            return @"未知";
            break;
    }
}

#pragma mark -UITableViewDelegate
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        XMPPUserCoreDataStorageObject *obj = [self.fetchedResultsController objectAtIndexPath:indexPath];
        [DXTools alerViewWithMessage:@"确定需要删除该联系人吗？" title:@"警告" actionStr:@"删除" handler:^(UIAlertAction *action) {
            [[DXIMManager sharedManager].xmppRoster removeUser:obj.jid];
        } actionSecondStr:@"取消" handlerSecond:nil];
        
    }
}
//跳转控制器
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
     XMPPUserCoreDataStorageObject *obj = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [self.navigationController pushViewController:[DXChatViewController chatViewControllerWith:obj.jid] animated:YES];

}
#pragma mark -UITableViewDataSource代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   return  self.fetchedResultsController.fetchedObjects.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DXBuddyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DXBuddyCell"];
    
   XMPPUserCoreDataStorageObject *obj = [self.fetchedResultsController objectAtIndexPath:indexPath];
    NSRange range = [obj.displayName rangeOfString:DXHostName];
    NSString *friendName;
    if (range.location != NSNotFound) {
        friendName = [obj.displayName substringToIndex:range.location - 1];
    }else{
     friendName = obj.displayName;
    }
//    好友名称
    cell.nameLabel.text = friendName;
//    好友状态
    cell.stateLaebl.text = [self stateWithSection:obj.section];

    [cell.iconImageView setImage:[UIImage imageWithData:[[DXIMManager sharedManager].xmppVCardAvatarModule photoDataForJID:obj.jid]]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

#pragma mark -XMPPvCardAvatarDelegate
- (void)xmppvCardAvatarModule:(XMPPvCardAvatarModule *)vCardTempModule
              didReceivePhoto:(UIImage *)photo
                       forJID:(XMPPJID *)jid{
    [self.buddyTableView reloadData];
}
#pragma mark -NSFetchedResultsControllerDelegate代理方法
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller{
    [self.fetchedResultsController performFetch:NULL];
      [self.buddyTableView reloadData];
}
#pragma mark -懒加载
- (NSFetchedResultsController *)fetchedResultsController{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"XMPPUserCoreDataStorageObject"];
    
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"!(subscription CONTAINS 'none')"];
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"displayName" ascending:YES];
    
     NSSortDescriptor *sort1 = [NSSortDescriptor sortDescriptorWithKey:@"sectionNum" ascending:YES];
    
    fetchRequest.predicate = pre;
    fetchRequest.sortDescriptors = @[sort1,sort];
    _fetchedResultsController = [[NSFetchedResultsController alloc]initWithFetchRequest:fetchRequest managedObjectContext:[DXIMManager sharedManager].xmppRosterCoreDataStorage.mainThreadManagedObjectContext sectionNameKeyPath:nil cacheName:nil];
    _fetchedResultsController.delegate = self;
    
    return _fetchedResultsController;
}



@end
