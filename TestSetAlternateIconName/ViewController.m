//
//  ViewController.m
//  TestSetAlternateIconName
//
//  Created by liuchong on 2017/6/5.
//  Copyright © 2017年 liuchong. All rights reserved.
//

#import "ViewController.h"
#import <objc/runtime.h>

// 设备的宽高
#define SCREENWIDTH  [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 利用runtime来替换展现弹出框的方法
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method presentM = class_getInstanceMethod(self.class, @selector(presentViewController:animated:completion:));
        Method presentSwizzlingM = class_getInstanceMethod(self.class, @selector(ox_presentViewController:animated:completion:));
        // 交换方法实现
        method_exchangeImplementations(presentM, presentSwizzlingM);
    });
    
    // 还原按钮
    UIButton *boyBtn = [[UIButton alloc] initWithFrame:CGRectMake((SCREENWIDTH-100)/2, 200, 100, 30)];
    [boyBtn setTitle:@"还原" forState:UIControlStateNormal];
    [boyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    boyBtn.backgroundColor = [UIColor darkGrayColor];
    [boyBtn addTarget:self action:@selector(toReset) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:boyBtn];
    
    // 换icon1按钮
    UIButton *girlBtn = [[UIButton alloc] initWithFrame:CGRectMake((SCREENWIDTH-100)/2, 300, 100, 30)];
    [girlBtn setTitle:@"换icon1" forState:UIControlStateNormal];
    [girlBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    girlBtn.backgroundColor = [UIColor darkGrayColor];
    [girlBtn addTarget:self action:@selector(toExchange1) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:girlBtn];
    
    // 换icon2按钮
    UIButton *girlBtn2 = [[UIButton alloc] initWithFrame:CGRectMake((SCREENWIDTH-100)/2, 400, 100, 30)];
    [girlBtn2 setTitle:@"换icon2" forState:UIControlStateNormal];
    [girlBtn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    girlBtn2.backgroundColor = [UIColor darkGrayColor];
    [girlBtn2 addTarget:self action:@selector(toExchange2) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:girlBtn2];
}

// 自己的替换展示弹出框的方法
- (void)ox_presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion {
    
    if ([viewControllerToPresent isKindOfClass:[UIAlertController class]]) {
        NSLog(@"title : %@",((UIAlertController *)viewControllerToPresent).title);
        NSLog(@"message : %@",((UIAlertController *)viewControllerToPresent).message);
        
        // 换图标时的提示框的title和message都是nil，由此可特殊处理
        UIAlertController *alertController = (UIAlertController *)viewControllerToPresent;
        if (alertController.title == nil && alertController.message == nil) {// 是换图标的提示
            return;
        } else {// 其他提示还是正常处理
            [self ox_presentViewController:viewControllerToPresent animated:flag completion:completion];
            return;
        }
    }
    
    [self ox_presentViewController:viewControllerToPresent animated:flag completion:completion];
}

// 换icon1
- (void)toExchange1 {
    if (![[UIApplication sharedApplication] supportsAlternateIcons]) {// 系统不支持换图标
        return;
    }
    
    [[UIApplication sharedApplication] setAlternateIconName:@"girl.jpg" completionHandler:^(NSError * _Nullable error) {
        if (error) {
            NSLog(@"更换app图标发生错误了 ： %@",error);
        }
    }];
}

// 换icon2
- (void)toExchange2 {
    if (![[UIApplication sharedApplication] supportsAlternateIcons]) {// 系统不支持换图标
        return;
    }
    
    [[UIApplication sharedApplication] setAlternateIconName:@"boy.jpg" completionHandler:^(NSError * _Nullable error) {
        if (error) {
            NSLog(@"更换app图标发生错误了 ： %@",error);
        }
    }];
}

-(void)toReset{
    if (![[UIApplication sharedApplication] supportsAlternateIcons]) {// 系统不支持换图标
        return;
    }
    
    [[UIApplication sharedApplication] setAlternateIconName:nil completionHandler:^(NSError * _Nullable error) {
        if (error) {
            NSLog(@"更换app图标发生错误了 ： %@",error);
        }
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
