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

@interface WFAddNewGroupController ()

@property (weak, nonatomic) IBOutlet UITextField *groupName;

@property (strong, nonatomic) WFGroupEngine * groupEngine;

@end

@implementation WFAddNewGroupController

- (instancetype)init{
    if (self = [super init]) {
        _groupEngine = [[WFGroupEngine alloc]init];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"编辑群资料";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(sendRequest)];
    _groupName.text = @"群名称（2-15个字）";
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)sendRequest{
    
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
