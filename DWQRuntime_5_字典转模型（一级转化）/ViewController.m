//
//  ViewController.m
//  DWQRuntime_5_字典转模型（一级转化）
//
//  Created by 杜文全 on 17/3/18.
//  Copyright © 2017年 com.iOSDeveloper.duwenquan. All rights reserved.
//

#import "ViewController.h"
#import "NSObject+autoGenerateProperty.h"
#import "NSObject+Model.h"
#import "weibo.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self autoGenerateProperty];//自动生成属性
    
    [self runtimeDictToModel];//利用runtime转模型
    
    
}
-(void)autoGenerateProperty{

    // 解析Plist
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"weibo" ofType:@"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:filePath];
    NSArray *dictArr = dict[@"weibo"];
    
    // 设计模型属性代码
    [NSObject createPropertyCodeWithDict:dictArr[0]];
    
    /*将打印台中输出的属性列表复制黏贴到Model类即可*/


}

-(void)runtimeDictToModel{

    // Do any additional setup after loading the view, typically from a nib.
    // 解析Plist
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"weibo" ofType:@"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:filePath];
    NSArray *dictArr = dict[@"weibo"];
    
    NSMutableArray *weiboArray = [NSMutableArray array];
    // 遍历字典数组
    for (NSDictionary *dict in dictArr) {
        weibo *wb = [weibo modelWithDict:dict];
        [weiboArray addObject:wb];
    }
    
    NSLog(@"%@",weiboArray);

}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
