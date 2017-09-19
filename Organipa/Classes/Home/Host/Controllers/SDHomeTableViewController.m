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
#import "BaiduDelegate.h"
#import "BaiduAuthCodeDelegate.h"

#import "WFUserBaiduLoginCredential.h"
#import "WFUserRongyunLoginCredential.h"
#import "WFHostEngine.h"
#import "WFAddNewGroupController.h"

#import "WFUser.h"

#define kHomeTableViewControllerCellId @"HomeTableViewController"

#define kHomeObserveKeyPath @"contentOffset"

const CGFloat kHomeTableViewAnimationDuration = 0.25;

//static NSString * const baiduLoginApiKey = @"IFbyqQ3dGgjEVCHfy6nUS9H6wUEhI5vO";

static NSString * const baiduLoginApiKey = @"7TjGqkwAU5rQPcC6LKGMjpKd";

//static NSString * const baiduLoginAppleId = @"9962635";

static NSString * const baiduLoginAppleId = @"2014185";


#define kCraticalProgressHeight 80

@interface SDHomeTableViewController () <UIGestureRecognizerDelegate, BaiduAuthorizeDelegate, BaiduAuthCodeDelegate, WFHostEngineProtocal>

@property (nonatomic, weak) SDEyeAnimationView *eyeAnimationView;

@property (nonatomic, strong) SDShortVideoController *shortVideoController;

@property (nonatomic, strong) WFHostEngine * hostEngine;

@property (nonatomic, assign) BOOL tableViewIsHidden;

@property (nonatomic, assign) CGFloat tabBarOriginalY;
@property (nonatomic, assign) CGFloat tableViewOriginalY;

@property (nonatomic, strong) UISearchController *searchController;

@property (nonatomic, strong) WFUser * baiduUser;

@end

@implementation SDHomeTableViewController

- (instancetype)init{
    if (self = [super init]) {
        [BaiduOAuthSDK initWithAPIKey:baiduLoginApiKey appId:baiduLoginAppleId];
        _hostEngine = [[WFHostEngine alloc]init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.rowHeight = [SDHomeTableViewCell fixedHeight];
    
    [self setupDataWithCount:10];
    
    [self.tableView registerClass:[SDHomeTableViewCell class] forCellReuseIdentifier:kHomeTableViewControllerCellId];
    
    self.tableView.backgroundColor = [UIColor clearColor];
    
    [self logInIfNeed];
    
    [self getBaiduUser];
    
    [self initBar];

}

- (UISearchController *)searchController
{
    if (!_searchController) {
        _searchController = [[UISearchController alloc] initWithSearchResultsController:[UIViewController new]];
//        _searchController.view.backgroundColor = [UIColor clearColor];
////        [_searchController setSearchResultsUpdater: self.searchVC];
//        [_searchController.searchBar setPlaceholder:@"搜索"];
//        [_searchController.searchBar setBarTintColor:[UIColor lightGrayColor]];
//        [_searchController.searchBar sizeToFit];
//        [_searchController.searchBar setDelegate:self];
//        [_searchController.searchBar.layer setBorderWidth:0.5f];
////        [_searchController.searchBar.layer setBorderColor:WBColor(220, 220, 220, 1.0).CGColor];
    }
    return _searchController;
}

- (void)panView:(UIPanGestureRecognizer *)pan
{
//    NSLog(@">>>>>  pan");
    
    if (self.tableView.contentOffset.y < -64) {
        [self performEyeViewAnimation];
    }
    
    CGPoint point = [pan translationInView:pan.view];
    [pan setTranslation:CGPointZero inView:pan.view];
    
    if (self.tableViewIsHidden && ![self.shortVideoController isRecordingVideo]) {
        CGFloat tabBarTop = self.navigationController.tabBarController.tabBar.top;
        CGFloat maxTabBarY = [UIScreen mainScreen].bounds.size.height + self.tableView.height;
        if (!(tabBarTop > maxTabBarY && point.y > 0)) {
            self.tableView.top += point.y;
            self.navigationController.tabBarController.tabBar.top += point.y;
        }
    }
    
    if (pan.state == UIGestureRecognizerStateEnded) {
        if (self.tableView.contentOffset.y < - (64 + kCraticalProgressHeight) && !self.tableViewIsHidden) {
            [self startTableViewAnimationWithHidden:YES];
        } else if (self.tableViewIsHidden) {
            BOOL shouldHidde = NO;
            if (self.tableView.top > [UIScreen mainScreen].bounds.size.height - 150) {
                shouldHidde = YES;
            }
            [self startTableViewAnimationWithHidden:shouldHidde];
        }
        
    }
}

- (void)performEyeViewAnimation
{
    CGFloat height = kCraticalProgressHeight;
    CGFloat progress = -(self.tableView.contentOffset.y + 64) / height;
    if (progress > 0) {
        self.eyeAnimationView.progress = progress;
    }

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (!self.eyeAnimationView) {
        [self setupEyeAnimationView];
        
        self.tabBarOriginalY = self.navigationController.tabBarController.tabBar.top;
        self.tableViewOriginalY = self.tableView.top;
    }
    
    if (!self.shortVideoController) {
        self.shortVideoController = [SDShortVideoController new];
        [self.tableView.superview insertSubview:self.shortVideoController.view atIndex:0];
        __weak typeof(self) weakSelf = self;
        [self.shortVideoController setCancelOperratonBlock:^{
            [weakSelf startTableViewAnimationWithHidden:NO];
        }];
    }
    
}

- (void)setupEyeAnimationView
{
    SDEyeAnimationView *view = [SDEyeAnimationView new];
    view.bounds = CGRectMake(0, 0, 65, 44);
    view.center = CGPointMake(self.view.bounds.size.width * 0.5, 70);
    [self.tableView.superview insertSubview:view atIndex:0];
    self.eyeAnimationView = view;
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panView:)];
    pan.delegate = self;
    [self.tableView.superview addGestureRecognizer:pan];
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    
    if (!self.tableView.isDragging) return;
    if (![keyPath isEqualToString:kHomeObserveKeyPath] || self.tableView.contentOffset.y > 0) return;
    
    CGFloat height = 80.0;
    CGFloat progress = -(self.tableView.contentOffset.y + 64) / height;
    if (progress > 0) {
        self.eyeAnimationView.progress = progress;
    }
}

- (void)setupDataWithCount:(NSInteger)count
{
    for (int i = 0; i < count; i++) {
        SDHomeTableViewCellModel *model = [SDHomeTableViewCellModel new];
        model.imageName = [SDAnalogDataGenerator randomIconImageName];
        model.name = [SDAnalogDataGenerator randomName];
        model.message = [SDAnalogDataGenerator randomMessage];
        [self.dataArray addObject:model];
    }
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
    UIViewController *vc = [[WFMessageTableViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - scrollview delegate

- (void)startTableViewAnimationWithHidden:(BOOL)hidden
{
    CGFloat tableViewH = self.tableView.height;
    CGFloat tabBarY = 0;
    CGFloat tableViewY = 0;
    if (hidden) {
        tabBarY = tableViewH + self.tabBarOriginalY;
        tableViewY = tableViewH + self.tableViewOriginalY;
    } else {
        tabBarY = self.tabBarOriginalY;
        tableViewY = self.tableViewOriginalY;
    }
    [UIView animateWithDuration:kHomeTableViewAnimationDuration animations:^{
        self.tableView.top = tableViewY;
        self.navigationController.tabBarController.tabBar.top = tabBarY;
        self.navigationController.navigationBar.alpha = (hidden ? 0 : 1);
    } completion:^(BOOL finished) {
        self.eyeAnimationView.hidden = hidden;

    }];
    if (!hidden) {
        [self.shortVideoController hidde];
    } else {
        [self.shortVideoController show];
    }
    self.tableViewIsHidden = hidden;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

#pragma mark --login
- (void)logInIfNeed{

    if (![BaiduOAuthSDK isUserTokenValid] || [WFUserBaiduLoginCredential sharedCredential].baiduLoginAccessTocken== nil) {
        //[BaiduOAuthSDK smsAuthWithTargetViewController:self scope:@"basic" andDelegate:self];
        [BaiduOAuthSDK authorizeWithTargetViewController:self scope:@"basic" andDelegate:self];
    }
    
}

- (void)getBaiduUser{
    [self.hostEngine getCurrentUserInfoWithAccessTocken:[WFUserBaiduLoginCredential sharedCredential].baiduLoginAccessTocken CompletionHandler:^(WFUser *user, NSError *error) {
        if (error == nil) {
            self.baiduUser = user;
            [self.hostEngine getRongyunUserWithBaiduUser:user completionHandler:^(NSString *userToken, NSError *error) {
                if (error == nil) {
                    [[WFUserRongyunLoginCredential sharedCredential] updateWithAccessTocken:userToken];
                }
            }];
        }
    }];
}

- (void)initBar{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewGroup)];
}

- (void)addNewGroup{
    WFAddNewGroupController * addNewGroupController = [[WFAddNewGroupController alloc]init];
    addNewGroupController.user = [self.user copy];
    [self.navigationController pushViewController:addNewGroupController animated:YES];
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
    
}

#pragma mark -- WFHostEngineProtocal
- (WFUser *)user{
    return self.user;
}
@end
