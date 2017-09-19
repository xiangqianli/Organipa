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

@property (strong, nonatomic) WFGroupEngine * groupEngine;

@end

@implementation WFJoinCurrentGroupController

- (instancetype)init{
    if (self = [super init]) {
        _groupEngine = [[WFGroupEngine alloc]init];
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
    [self.groupEngine joinGroup:_user.uid groupName:_searchForGroupField.text completionHandler:^(WFGroup *group, NSError *error) {
        [[NSNotificationCenter defaultCenter]postNotificationName:WFJoinNewGroupSuccessNotification object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:group,@"group",nil]];
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
