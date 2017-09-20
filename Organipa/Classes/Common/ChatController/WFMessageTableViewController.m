//
//  WFMessageTableViewController.m
//  Organipa
//
//  Created by 李向前 on 2017/9/11.
//  Copyright © 2017年 李向前. All rights reserved.
//

#import "WFMessageTableViewController.h"
#import "UUInputFunctionView.h"
#import "MJRefresh.h"
#import "UUMessageCell.h"
#import "WFChatModel.h"
#import "UUMessageFrame.h"
#import "UUMessage.h"
#import "WFUserBaiduLoginCredential.h"

static NSString * const WFReceiveNewMessageNotification = @"WFReceiveNewMessageNotification";

@interface WFMessageTableViewController ()<UUInputFunctionViewDelegate,UUMessageCellDelegate,UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) MJRefreshHeader *head;
@property (strong, nonatomic) WFChatModel *chatModel;

@property (weak, nonatomic) IBOutlet UITableView *chatTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;

@property (assign, nonatomic) BOOL keyBoardIsShow;

@end

@implementation WFMessageTableViewController{
    UUInputFunctionView *IFView;
}

- (instancetype)initWithGroupId:(NSString *)groupId groupName:(NSString *)groupName{
    if (self = [super init]) {
        _group = [[WFGroup alloc]init];
        _group.gid = groupId;
        _group.gname = [groupName copy];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initBar];
    //[self addRefreshViews];
    [self loadBaseViewsAndData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.chatModel.isGroupChat = true;
    
    //add notification
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardChange:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardChange:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(tableViewScrollToBottom) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(receiveNewMessage:) name:WFReceiveNewMessageNotification object:nil];

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)initBar
{
    self.navigationItem.title = self.group.gname;
    
    self.navigationController.navigationBar.tintColor = [UIColor grayColor];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:nil];
}

//- (void)addRefreshViews
//{
//    __weak typeof(self) weakSelf = self;
//    
//    //load more
//    int pageNum = 3;
//    
//    _head = [MJRefreshHeader headerWithRefreshingBlock:^{
//        [weakSelf.chatModel addRandomItemsToDataSource:pageNum];
//        
//        if (weakSelf.chatModel.dataSource.count > pageNum) {
//            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:pageNum inSection:0];
//            
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [weakSelf.chatTableView reloadData];
//                [weakSelf.chatTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
//            });
//        }
//        [weakSelf.head endRefreshing];
//    }];
//    //_head.scrollView = self.chatTableView;
//}

- (void)loadBaseViewsAndData
{
    self.chatModel = [[WFChatModel alloc]init];
    self.chatModel.isGroupChat = YES;
    //[self.chatModel populateRandomDataSource];
    [self.chatModel fetchInitialDataSourceWithGroupId:self.group.gid];
    
    IFView = [[UUInputFunctionView alloc]initWithSuperVC:self];
    IFView.delegate = self;
    [self.view addSubview:IFView];
    
    [self.chatTableView reloadData];
    [self tableViewScrollToBottom];
}

-(void)keyboardChange:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardEndFrame;
    
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    
    //adjust ChatTableView's height
    if (notification.name == UIKeyboardWillShowNotification) {
        self.bottomConstraint.constant = keyboardEndFrame.size.height+40;
        self.keyBoardIsShow = YES;
    }else{
        self.bottomConstraint.constant = 40;
        self.keyBoardIsShow = NO;
    }
    
    [self.view layoutIfNeeded];
    
    //adjust UUInputFunctionView's originPoint
    CGRect newFrame = IFView.frame;
    newFrame.origin.y = keyboardEndFrame.origin.y - newFrame.size.height;
    IFView.frame = newFrame;
    
    [UIView commitAnimations];
    
}

- (void)receiveNewMessage:(NSNotification *)notification{
    WFMessage * message = notification.userInfo[@"message"];
    if (message.gid == self.group.gid) {
        
    }
}

//tableView Scroll to bottom
- (void)tableViewScrollToBottom
{
    if (self.chatModel.dataSource.count==0)
        return;
    if (self.keyBoardIsShow == NO && self.chatTableView.contentSize.height < WFSCREEN_H - 64) {
        return;
    }
    if (self.keyBoardIsShow == YES && self.chatTableView.contentSize.height < WFSCREEN_H - 104) {
        return;
    }
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.chatModel.dataSource.count-1 inSection:0];
    [self.chatTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}


#pragma mark - InputFunctionViewDelegate
- (void)UUInputFunctionView:(UUInputFunctionView *)funcView sendMessage:(NSString *)message
{
    NSDictionary *dic = @{@"strContent": message,
                          @"type": @(UUMessageTypeText)};
    funcView.TextViewInput.text = @"";
    [funcView changeSendBtnWithPhoto:YES];
    [self dealTheFunctionData:dic];
}

- (void)UUInputFunctionView:(UUInputFunctionView *)funcView sendPicture:(UIImage *)image
{
    NSDictionary *dic = @{@"picture": image,
                          @"type": @(UUMessageTypePicture)};
    [self dealTheFunctionData:dic];
}

- (void)UUInputFunctionView:(UUInputFunctionView *)funcView sendVoice:(NSData *)voice time:(NSInteger)second
{
    NSDictionary *dic = @{@"voice": voice,
                          @"strVoiceTime": [NSString stringWithFormat:@"%d",(int)second],
                          @"type": @(UUMessageTypeVoice)};
    [self dealTheFunctionData:dic];
}

- (void)dealTheFunctionData:(NSDictionary *)dic
{
    NSInteger messageType = [dic[@"type"] integerValue];
    WFMessage * message = [[WFMessage alloc]init];
    message.from_id = [WFUserBaiduLoginCredential sharedCredential].uid;
    message.from = UUMessageFromMe;
    message.content = dic[@"strContent"];
    message.gid = self.group.gid;
    message.messageType = UUMessageTypeText;
    message.fromStr = @"我";
    message.create_time = [NSDate dateWithTimeIntervalSinceNow:0];
    message.create_time_interval = [message.create_time timeIntervalSince1970];
    switch (messageType) {
        case UUMessageTypeText:{
            RCTextMessage * textMessage = [RCTextMessage messageWithContent:dic[@"strContent"]];
            [[RCIMClient sharedRCIMClient] sendMessage:ConversationType_GROUP targetId:self.group.gid content:textMessage pushContent:nil pushData:nil success:^(long messageId) {
                //dispatch_async(dispatch_get_main_queue(), ^{
                    [self.chatModel addSpecifiedItem:dic];
                    [self.chatTableView reloadData];
                    [self tableViewScrollToBottom];
                //});
                RLMRealm * real = [RLMRealm defaultRealm];
                [real beginWriteTransaction];
                [real addObject:message];
                [real commitWriteTransaction];
                NSLog(@"发送成功，当前消息ID : %ld",messageId);
            } error:^(RCErrorCode nErrorCode, long messageId) {
                NSLog(@"发送失败，消息ID：%ld, 错误码%ld", messageId, nErrorCode);
            }];
            break;
        }
        default:
            break;
    }
}

#pragma mark - tableView delegate & datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.chatModel.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UUMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellID"];
    if (cell == nil) {
        cell = [[UUMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellID"];
        cell.delegate = self;
    }
    
    [cell setMessageFrame:self.chatModel.dataSource[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self.chatModel.dataSource[indexPath.row] cellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.view endEditing:YES];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

#pragma mark - cellDelegate
- (void)headImageDidClick:(UUMessageCell *)cell userId:(NSString *)userId{
    // headIamgeIcon is clicked
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:cell.messageFrame.message.fromStr message:@"headImage clicked" delegate:nil cancelButtonTitle:@"sure" otherButtonTitles:nil];
    [alert show];
}

- (WFChatModel *)chatModel{
    if (!_chatModel) {
        _chatModel = [[WFChatModel alloc]init];
    }
    return _chatModel;
}
@end
