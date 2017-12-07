//
//  NextViewController.m
//  PreventPop
//
//  Created by mac on 2017/12/4.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "NextViewController.h"
#import "UINavigationController+AJIsPop.h"

@interface NextViewController ()<UINavigationControllerShouldPop,UINavigationBarDelegate>

@end

@implementation NextViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Next";
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UINavigationControllerShouldPop
- (BOOL)navigationControllerShouldPop:(UINavigationController *)navigationController{
    [self presentAlert:navigationController];
    return false;
}

- (BOOL)navigationControllerShouldStartInteractivePopGestureRecognize:(UINavigationController *)navigationController{
    [self presentAlert:navigationController];
    return false;
}


#pragma mark - Action
- (void)presentAlert:(UINavigationController *)navigationController{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"规格还未保存，是否离开？" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popViewControllerAnimated:true];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [alert addAction:confirm];
    [alert addAction:cancel];
    [self presentViewController:alert animated:true completion:nil];
}

@end
