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
        [[NSNotificationCenter defaultCenter]postNotificationName:WFAddNewGroupSuccessNotification object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:group,@"group",nil]];
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

@end
