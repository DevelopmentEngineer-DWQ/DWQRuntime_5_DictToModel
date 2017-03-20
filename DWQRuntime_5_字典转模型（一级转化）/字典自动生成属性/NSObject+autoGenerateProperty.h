//
//  NSObject+Property.h
//  DWQRuntime_5_字典转模型（一级转化）
//
//  Created by 杜文全 on 17/3/18.
//  Copyright © 2017年 com.iOSDeveloper.duwenquan. All rights reserved.


#import <Foundation/Foundation.h>

@interface NSObject (autoGenerateProperty)

+ (void)createPropertyCodeWithDict:(NSDictionary *)dict;


@end
