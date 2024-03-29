//
//  SDHomeTableViewController.m
//  GSD_WeiXin(wechat)
//
//  Created by aier on 16/2/10.
//  Copyright © 2016年 GSD. All rights reserved.
//


/*
 
 *********************************************************************************
 *
 * GSD_WeiXin
 *
 * QQ交流群: 362419100(2群) 459274049（1群已满）
 * Email : gsdios@126.com
 * GitHub: https://github.com/gsdios/GSD_WeiXin
 * 新浪微博:GSD_iOS
 *
 * 此“高仿微信”用到了很高效方便的自动布局库SDAutoLayout（一行代码搞定自动布局）
 * SDAutoLayout地址：https://github.com/gsdios/SDAutoLayout
 * SDAutoLayout视频教程：http://www.letv.com/ptv/vplay/24038772.html
 * SDAutoLayout用法示例：https://github.com/gsdios/SDAutoLayout/blob/master/README.md
 *
 *********************************************************************************
 
 */

#import "SDHomeTableViewController.h"
#import "SDAnalogDataGenerator.h"
#import "UIView+SDAutoLayout.h"
#import "SDHomeTableViewCell.h"
#import "SDEyeAnimationView.h"
#import "SDShortVideoController.h"
#import "WFMessageTableViewController.h"
#import "BaiduOAuthSDK.h"
#import "SVProgressHUD.h"
#import "BaiduDelegate.h"
#import "BaiduAuthCodeDelegate.h"

#import "WFUserBaiduLoginCredential.h"
#import "WFUserRongyunLoginCredential.h"

#import "WFHostEngine.h"
#import "WFGroupEngine.h"

#import "WFAddNewGroupController.h"
#import "WFJoinCurrentGroupController.h"

#import "WFUser.h"
#import "WFGroup.h"

#import "AIPUnitSDK.h"

#import "WFCalenderManager.h"

#define kHomeTableViewControllerCellId @"HomeTableViewController"

#define kHomeObserveKeyPath @"contentOffset"

const CGFloat kHomeTableViewAnimationDuration = 0.25;

//static NSString * const baiduLoginApiKey = @"IFbyqQ3dGgjEVCHfy6nUS9H6wUEhI5vO";

static NSString * const baiduLoginApiKey = @"7TjGqkwAU5rQPcC6LKGMjpKd";

//static NSString * const baiduLoginAppleId = @"9962635";

static NSString * const baiduLoginAppleId = @"2014185";

static NSString * const WFAddNewGroupSuccessNotification = @"WFAddNewGroupSuccessNotification";
static NSString * const WFJoinNewGroupSuccessNotification = @"WFJoinNewGroupSuccessNotification";
static NSString * const WFReceiveNewMessageNotification = @"WFReceiveNewMessageNotification";

static NSString * const API_KEY = @"GaUpbfXH0nelhEAwnGFXG9Cq";
static NSString * const SECRET_KEY = @"5KuCQX4p9rYZfmR8EyFMpHRj96F7GYBt";

#define kCraticalProgressHeight 80

@interface SDHomeTableViewController () <UIGestureRecognizerDelegate, BaiduAuthorizeDelegate, BaiduAuthCodeDelegate>

@property (nonatomic, strong) WFHostEngine * hostEngine;
@property (nonatomic, strong) WFGroupEngine * groupEngine;

@property (nonatomic, strong) UISearchController *searchController;

@property (nonatomic, strong) WFUser * baiduUser;

@property (nonatomic, strong) NSTimer *waitTimer;


@end

@implementation SDHomeTableViewController

- (instancetype)init{
    if (self = [super init]) {
        [BaiduOAuthSDK initWithAPIKey:baiduLoginApiKey appId:baiduLoginAppleId];
        _hostEngine = [[WFHostEngine alloc]init];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(addNewGroupSuccess:) name:WFAddNewGroupSuccessNotification object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(joinNewGroupSuccess:) name:WFJoinNewGroupSuccessNotification object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(receiveNewMessage:) name:WFReceiveNewMessageNotification object:nil];

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.rowHeight = [SDHomeTableViewCell fixedHeight];
    
    //[self setupDataWithCount:10]; 模拟自己造数据
    
    [self setUpRealData];
    
    [self.tableView registerClass:[SDHomeTableViewCell class] forCellReuseIdentifier:kHomeTableViewControllerCellId];
    
    self.tableView.backgroundColor = [UIColor clearColor];
    
    [self logInIfNeed];
    
    [self initBar];
    
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
    [SVProgressHUD show];
    [[AIPUnitSDK sharedInstance] getAccessTokenWithAK:API_KEY SK:SECRET_KEY completion:^{
        [SVProgressHUD dismiss];
    }];
    
    [[AIPUnitSDK sharedInstance] setSceneID:8658];
    
    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([AIPUnitSDK sharedInstance].accessToken == nil) {
            weakSelf.waitTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(waitAccessToken) userInfo:nil repeats:YES];
        }
    });

}

- (UISearchController *)searchController
{
    if (!_searchController) {
        _searchController = [[UISearchController alloc] initWithSearchResultsController:[UIViewController new]];
    }
    return _searchController;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self setUpRealData];
    [self.tableView reloadData];
}

- (void)setUpRealData{
    //NSArray * conversationArray = [NSArray arrayWithObjects:[NSNumber numberWithUnsignedInteger:ConversationType_GROUP],nil];
    //[self.dataArray addObjectsFromArray:[[RCIMClient sharedRCIMClient]getConversationList:conversationArray]];
    //[self.dataArray addObjectsFromArray:];
    [self.dataArray removeAllObjects];
    
    RLMResults<WFGroup *> *groups = [WFGroup allObjects];
    for (WFGroup * group in groups) {
        [self.dataArray addObject:group];
    }
}


- (void)addGroupDataToTop:(WFGroup *)group{
    [self.dataArray insertObject:group atIndex:0];
    [self.tableView reloadData];
}

#pragma mark - tableview delegate and datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SDHomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kHomeTableViewControllerCellId];
    cell.model = self.dataArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * gid = [self.dataArray[indexPath.row] valueForKey:@"gid"];
    NSString * gname = [self.dataArray[indexPath.row] valueForKey:@"gname"];
    WFMessageTableViewController *vc = [[WFMessageTableViewController alloc]initWithGroupId:gid groupName:gname];
    vc.hidesBottomBarWhenPushed = YES;
    vc.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController pushViewController:vc animated:YES];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [[WFGroupEngine sharedGroupEngine] deleteGroupFromDatabase:[self.dataArray objectAtIndex:indexPath.row]];
        // Delete the row from the data source.
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self.dataArray removeObjectAtIndex:indexPath.row];

        
    }
    
}

#pragma mark --login
- (void)logInIfNeed{

    if (![BaiduOAuthSDK isUserTokenValid] || [WFUserBaiduLoginCredential sharedCredential].baiduLoginAccessTocken== nil) {
        //[BaiduOAuthSDK smsAuthWithTargetViewController:self scope:@"basic" andDelegate:self];
        [BaiduOAuthSDK authorizeWithTargetViewController:self scope:@"basic" andDelegate:self];
    }else{
        [self getBaiduUser];
    }
    
}

- (void)getBaiduUser{
    [self.hostEngine getCurrentUserInfoWithAccessTocken:[WFUserBaiduLoginCredential sharedCredential].baiduLoginAccessTocken CompletionHandler:^(WFUser *user, NSError *error) {
        if (error == nil) {
            self.baiduUser = user;
            [[WFUserBaiduLoginCredential sharedCredential] updateWithUserId:user.uid];
            [self.hostEngine getRongyunUserWithBaiduUser:user completionHandler:^(NSString *userToken, NSError *error) {
                if (error == nil) {
                    [[WFUserRongyunLoginCredential sharedCredential] updateWithAccessTocken:userToken];
                    [[RCIMClient sharedRCIMClient] connectWithToken:userToken success:^(NSString *userId) {
                        NSLog(@"连接到融云服务器成功");
                    } error:^(RCConnectErrorCode status) {
                        NSLog(@"连接到融云服务器失败 %ld",(long)status);
                    } tokenIncorrect:^{
                        NSLog(@"连接到融云服务器Token错误");
                    }];
                }
            }];
        }
    }];
}

- (void)initBar{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(createNewGroupOrJoinGroup)];
}

- (void)createNewGroupOrJoinGroup{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"新建群" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self createNewGroup];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"加入群" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self joinCurrentGroup];
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)createNewGroup{
    WFAddNewGroupController * addNewGroupController = [[WFAddNewGroupController alloc]init];
    addNewGroupController.user = [self.baiduUser copy];
    [self.navigationController pushViewController:addNewGroupController animated:YES];
}

- (void)joinCurrentGroup{
    WFJoinCurrentGroupController * joinNewGroupController = [[WFJoinCurrentGroupController alloc]init];
    joinNewGroupController.user = [self.baiduUser copy];
    [self.navigationController pushViewController:joinNewGroupController animated:YES];
}

- (void)waitAccessToken {
    if ([AIPUnitSDK sharedInstance].accessToken != nil) {
        [self.waitTimer invalidate];
        self.waitTimer = nil;
    }
}
#pragma mark --login delegate
- (IBAction)doGetAuthCodeBySms:(id)sender {
    
    [BaiduOAuthSDK initWithAPIKey:baiduLoginApiKey appId:baiduLoginAppleId];
    [BaiduOAuthSDK smsAuthCodeWithTargetViewController:self
                                                 scope:@"basic"
                                                mobile:@""
                                            redirctUrl:@"http://x.baidu.com/plug-in-services/demo/easysleepdiary/auth.php"
                                            needSignUp:NO
                                           andDelegate:self];
}

- (void)authorizationCodeSuccessWithCode:(NSString *)code
{
    NSString *message = [NSString stringWithFormat:@"Authorization Code 是 %@",code];
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"授权提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    
    [alertController addAction:defaultAction];
    [self presentViewController:alertController animated:YES completion:nil];
    
}

- (void)authorizationCodeWithError:(NSError*)error
{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"授权提示" message:[error localizedDescription] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    
    [alertController addAction:defaultAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)loginFailedWithError:(NSError *)error{
    NSLog(@"login error.");
}

- (void)loginDidCancel{
    NSLog(@"login cancel.");
}

- (void)loginDidSuccessWithTokenInfo:(BaiduTokenInfo *)tokenInfo
{
    NSLog(@"access_token:%@,\nexpire_time:%@,\nscope:%@",tokenInfo.accessToken,tokenInfo.expiresIn, tokenInfo.scope);
    [[WFUserBaiduLoginCredential sharedCredential]updateWithExpiredTime:tokenInfo.expiresIn accessTocken:tokenInfo.accessToken];
    [self getBaiduUser];
}

- (void)addNewGroupSuccess:(NSNotification *)notification{
    NSDictionary * userinfo = notification.userInfo;
    WFGroup * group = userinfo[@"group"];
    [self addGroupDataToTop:group];
}

- (void)joinNewGroupSuccess:(NSNotification *)notification{
    NSDictionary * userinfo = notification.userInfo;
    WFGroup * group = userinfo[@"group"];
    [self addGroupDataToTop:group];
}

- (void)receiveNewMessage:(NSNotification *)notification{
    WFMessage * message = notification.userInfo[@"message"];
    dispatch_async(dispatch_get_main_queue(), ^{
        [[WFGroupEngine sharedGroupEngine] updateMessageListGroupIfNeed:message completionHandler:nil];
    });
}
@end
