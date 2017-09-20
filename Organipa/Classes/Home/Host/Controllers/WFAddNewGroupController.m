//
//  WFAddNewGroupController.m
//  Organipa
//
//  Created by 李向前 on 2017/9/19.
//  Copyright © 2017年 李向前. All rights reserved.
//

#import "WFAddNewGroupController.h"
#import "WFUser.h"
#import "WFGroupEngine.h"

static NSString * const WFAddNewGroupSuccessNotification = @"WFAddNewGroupSuccessNotification";

@interface WFAddNewGroupController ()

@property (weak, nonatomic) IBOutlet UITextField *groupName;

@end

@implementation WFAddNewGroupController

- (instancetype)init{
    if (self = [super init]) {
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"编辑群资料";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(sendRequest)];
    _groupName.placeholder = @"群名称（2-15个字）";
    _groupName.autocorrectionType = UITextAutocorrectionTypeNo;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)sendRequest{
    [[WFGroupEngine sharedGroupEngine] createGroup:_user.uid groupName:_groupName.text completionHandler:^(WFGroup *group, NSError *error) {
        if (error == nil) {
            [[NSNotificationCenter defaultCenter]postNotificationName:WFAddNewGroupSuccessNotification object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:group,@"group",nil]];
            wf_showHud(self.view, @"建群成功", 1);
        }else{
            MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.labelText = error.description;
        }
        [self.navigationController popViewControllerAnimated:YES];
    }];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

static inline
void wf_showHud(UIView *toView, NSString *text, CGFloat duration) {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:toView animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = text;
    hud.labelColor = MAIN_BLUE;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES];
}

@end
