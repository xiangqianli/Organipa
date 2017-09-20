//
//  WFJoinCurrentGroupController.m
//  Organipa
//
//  Created by 李向前 on 2017/9/19.
//  Copyright © 2017年 李向前. All rights reserved.
//

#import "WFJoinCurrentGroupController.h"
#import "WFGroupEngine.h"
#import "WFUser.h"

static NSString * const WFJoinNewGroupSuccessNotification = @"WFJoinNewGroupSuccessNotification";

@interface WFJoinCurrentGroupController ()

@property (weak, nonatomic) IBOutlet UITextField *searchForGroupField;

@end

@implementation WFJoinCurrentGroupController

- (instancetype)init{
    if (self = [super init]) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _searchForGroupField.placeholder = @"输入群ID";
    _searchForGroupField.autocorrectionType = UITextAutocorrectionTypeNo;
     self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(sendRequest)];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)sendRequest{
    [[WFGroupEngine sharedGroupEngine] joinGroup:_user.uid groupName:_searchForGroupField.text completionHandler:^(WFGroup *group, NSError *error) {
        if (error == nil) {
            [[NSNotificationCenter defaultCenter]postNotificationName:WFJoinNewGroupSuccessNotification object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:group,@"group",nil]];
            wf_showHud(self.view, @"入群成功", 1);
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
