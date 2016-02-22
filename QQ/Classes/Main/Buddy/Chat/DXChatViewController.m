//
//  DXChatViewController.m
//  QQ
//
//  Created by simon on 16/1/28.
//  Copyright © 2016年 simon. All rights reserved.
//

#import "DXChatViewController.h"
#import "DXChatCell.h"

@interface DXChatViewController ()<UITableViewDelegate,UITableViewDataSource,NSFetchedResultsControllerDelegate,UITextViewDelegate,XMPPvCardAvatarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

//**底部barView*/
@property (weak, nonatomic) IBOutlet UIView *chatBarView;

//**文本框输入视图*/
@property (weak, nonatomic) IBOutlet UITextView *chatBarTextView;

//**底部toolbar底部约束*/
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *barItemBottomConstraint;

//**textView高度约束*/
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewHeightConstraint;

//**底部toolbar高度约束*/
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *barItemHeightConstraint;

//**信息数据检索控制器*/
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

//**记录传入控制器聊天对象的JID*/
@property (nonatomic, strong) XMPPJID *xmppJID;

@end

@implementation DXChatViewController
///返回从sb中加载的控制器
+ (instancetype)chatViewControllerWith:(XMPPJID *)xmppJID{
     DXChatViewController *chatVc = [UIStoryboard storyboardWithName:@"DXChatViewController" bundle:nil].instantiateInitialViewController;
    chatVc.xmppJID = xmppJID;
    return chatVc;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [DXTools hidesBottomBar:YES];

}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [DXTools hidesBottomBar:NO];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.fetchedResultsController performFetch:NULL];
    self.tableView.backgroundColor = [DXTools colorWithR:239 G:239 B:239];
    [[UINavigationBar appearance]setTintColor:[UIColor whiteColor]];
//    tableView滑动到底部
    [self scrollToBottom];
  [[DXIMManager sharedManager].xmppVCardAvatarModule addDelegate:self delegateQueue:dispatch_get_main_queue()]; 
//    设置title
    self.title = [DXTools userNameWithJIDBar:self.xmppJID.bare];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.tableFooterView = [[UIView alloc]init];
//    注册键盘将要弹出通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(inputViewFrameChanged:) name:UIKeyboardWillChangeFrameNotification object:nil];
//    注册键盘弹出通知
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(inputViewFrameDidChanged) name:UIKeyboardDidChangeFrameNotification object:nil];
    
}
/// 键盘将弹出通知
- (void)inputViewFrameChanged:(NSNotification *)notify{

   CGRect frame = [notify.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.barItemBottomConstraint.constant = KScreenHeight - frame.origin.y;
    
    [UIView animateWithDuration:0.25 animations:^{
        [self.chatBarView layoutIfNeeded];
       
    }];
}
/// 键盘弹出通知
- (void)inputViewFrameDidChanged{
    [self scrollToBottom];
}
///tableView滑动到底部
-(void)scrollToBottom{
    NSInteger count = self.fetchedResultsController.fetchedObjects.count;
    if (count >0) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:count - 1 inSection:0];
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}
///发送信息
- (void)sendMessage:(NSString *)text{
    XMPPMessage *message = [XMPPMessage messageWithType:@"chat" to:self.xmppJID];
    [message addBody:text];
    [[DXIMManager sharedManager].stream sendElement:message];

}

///根据table取得cell
- (DXChatCell *)tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{

    XMPPMessageArchiving_Message_CoreDataObject *obj = [self.fetchedResultsController objectAtIndexPath:indexPath];
    NSString *cellID = obj.isOutgoing ? @"chatCell_send":@"chatCell_recive";
    
    UIImage *iconImg = obj.isOutgoing?[UIImage imageWithData:[[DXIMManager sharedManager].xmppVCardAvatarModule photoDataForJID:[DXIMManager sharedManager].stream.myJID]]:[UIImage imageWithData:[[DXIMManager sharedManager].xmppVCardAvatarModule photoDataForJID:self.xmppJID]];
    
    DXChatCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    cell.messageLabel.text = obj.body;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.contentView.backgroundColor = [DXTools colorWithR:239 G:239 B:239];
    if (iconImg == nil) {
        iconImg = [UIImage imageNamed:@"login_avatar_default"];
    }
    
    cell.messageLabel.preferredMaxLayoutWidth = KScreenWith - 120;
    
    [cell.iconView setImage:iconImg forState:UIControlStateNormal];
    
    return cell;
    
}
#pragma mark -XMPPvCardAvatarDelegate
- (void)xmppvCardAvatarModule:(XMPPvCardAvatarModule *)vCardTempModule
              didReceivePhoto:(UIImage *)photo
                       forJID:(XMPPJID *)jid{
    [self.tableView reloadData];
}
#pragma mark -UITextViewDelegate代理方法
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{

    CGRect textViewRect = textView.bounds;

   CGRect contRect = [textView.text boundingRectWithSize:CGSizeMake(textViewRect.size.width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary attributeDicWithFontSize:14 color:[UIColor blackColor]] context:nil];
//    SSLog(@"%@",NSStringFromCGRect(contRect));
    if (contRect.size.height > 30 && contRect.size.height < 60) {
        self.textViewHeightConstraint.constant = contRect.size.height;
    }else if (contRect.size.height < 30){
        self.textViewHeightConstraint.constant = 30;
    }
    self.barItemHeightConstraint.constant =  self.textViewHeightConstraint.constant + 14;
    [self scrollToBottom];
    
    if ([text isEqualToString:@"\n"]) {
//        [textView resignFirstResponder];
//        SSLog(@"%zd",lineNum);
        [self sendMessage:textView.text];
         textView.text = @"";
//        [textView becomeFirstResponder];

        return NO;
    }
    return YES;
}



#pragma mark -tableView代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.fetchedResultsController.fetchedObjects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DXChatCell *cell = [self tableView:tableView indexPath:indexPath];

    return cell;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
     DXChatCell *cell = [self tableView:tableView indexPath:indexPath];
   CGFloat cellHeight = [cell.messageLabel systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height + 24;
    
    return cellHeight > 80 ? cellHeight : 60;
    
    
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 80;
    
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{

    [self.view endEditing:NO];

}
#pragma mark -NSFetchedResultsControllerDelegate代理
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller{
    dispatch_async(dispatch_get_main_queue(), ^{
    [self.tableView reloadData];
   NSString *str = [[controller.fetchedObjects lastObject] body];
        if (str) {
            self.title = [DXTools userNameWithJIDBar:self.xmppJID.bare];
             [self scrollToBottom];
        }else{
        self.title = @"正在输入.....";
        }
   
          });
}

#pragma mark -懒加载
- (NSFetchedResultsController *)fetchedResultsController{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"XMPPMessageArchiving_Message_CoreDataObject"];
    NSSortDescriptor *sor = [NSSortDescriptor sortDescriptorWithKey:@"timestamp" ascending:YES];
    fetchRequest.sortDescriptors = @[sor];
    
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"bareJidStr ==%@",self.xmppJID.bare];
    fetchRequest.predicate = pre;
    
    _fetchedResultsController = [[NSFetchedResultsController alloc]initWithFetchRequest:fetchRequest managedObjectContext:[DXIMManager sharedManager].xmppMessageArchivingCoreDataStorage.mainThreadManagedObjectContext sectionNameKeyPath:nil cacheName:nil];
    _fetchedResultsController.delegate = self;
    
    return _fetchedResultsController;
}
@end
