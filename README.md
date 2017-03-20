# DWQRuntime_5_DictToModel
利用Runtime字典转模型，一级转化的简单使用
![DWQ-LOGO.jpeg](http://upload-images.jianshu.io/upload_images/2231137-1545493cd60adb2b.jpeg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

##引述
  对于每一个开发者来说，MVC对于我们来说在熟悉不过了，其中的M，也就是所谓的Model，数据模型。如下图所示：

![Model.png](http://upload-images.jianshu.io/upload_images/2231137-b105df87ea004861.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/400)

我不知道在过往的开发中，大家是怎么创建模型的。如果一个模型中只有简单的几个，通常我们手打敲上这些属性就可以了，但是如果是几十个呢？难道还要用手敲，或者一个个的复制黏贴吗？在介绍RUntime字典转模型之前，先给大家介绍下一个工具，自动创建模型。当然。。。这工具不是自动给你的模型创建代码，还是需要你复制黏贴的，不过只需要复制一次，黏贴一次。
##NSObject+autoGenerateProperty
  很明显，这是一个NSObject的分类，具体实现原理是：
- 1.声明并实现一个方法，传入一个字典

```objective-c
+ (void)createPropertyCodeWithDict:(NSDictionary *)dict;

```

- 2.具体实现的原理
1.先查看共有部分，然后共有部分的其中一些变量由字典的什么决定的

  2.assign，strong，等是由变量的类型决定的，那么可以通过value类型来确定

```objective-c
value isKindOfClass:NSClassFromString(@"__NSCFString")
```
  3.属性名就是遍历字典中给的key

```objective-c
[dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull propertyName, id  _Nonnull value, BOOL * _Nonnull stop) 

propertyName就是key
```
  4.然后在打印控制台复制代码黏贴到Model类里面即可

![属性.png](http://upload-images.jianshu.io/upload_images/2231137-65b5fa9afecc0cf8.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/400)
##字典转模型
字典转模型的方法，通常一般情况下可以使用KVC，但是KVC字典转模型有个不好的地方，那就是必须保证：
- a.模型中的属性和字典中的key一一对应。
- b.如果不一致，就会调用[<Status 0x7fa74b545d60> setValue:forUndefinedKey:] 报key找不到的错。
分析:模型中的属性和字典的key不一一对应，系统就会调用setValue:forUndefinedKey:报错。
- c.解决:重写对象的setValue:forUndefinedKey:,把系统的方法覆盖， 就能继续使用KVC，字典转模型了。


##Runtime字典转模型

思路：利用运行时，遍历模型中所有属性，根据模型的属性名，去字典中查找key，取出对应的值，给模型的属性赋值。
步骤：提供一个NSObject分类，专门字典转模型，以后所有模型都可以通过这个分类转。
具体步骤如下：
- 1.创建一个分类，声明并实现一个方法，传入一个字典

```objective-c
+ (instancetype)modelWithDict:(NSDictionary *)dict;
```
- 2.创建对应类的对象

- 3.遍历模型中所有成员变量属性

- 4.获取成员属性，成员名，成员属性类型，获取key，获取字典的value

- 5.KVC赋值  具体事例如下代码：

```objective-c
 unsigned int count = 0;
    Ivar *ivarList = class_copyIvarList(self, &count);
    for (int i = 0 ; i < count; i++) {
        // 获取成员属性
        Ivar ivar = ivarList[i];
        
        // 获取成员名
       NSString *propertyName = [NSString stringWithUTF8String:ivar_getName(ivar)];
        ;
        // 成员属性类型
        NSString *propertyType = [NSString stringWithUTF8String:ivar_getTypeEncoding(ivar)];

        // 获取key
        NSString *key = [propertyName substringFromIndex:1];
        
        // 获取字典的value
        id value = dict[key];
        // 给模型的属性赋值
        // value:字典的值
        // key:属性名
        
        if (value) {
            // KVC赋值:不能传空
            [objc setValue:value forKey:key];
            
        }
//        NSLog(@"%@",key);
//        NSLog(@"%@ %@",propertyType , propertyName);
    }

    return objc;
```
- 注意：
>ivar:成员属性
   class_copyIvarList:把成员属性列表复制一份给你
   Ivar *:指向Ivar指针
   Ivar *:指向一个成员变量数组
   class:获取哪个类的成员属性列表
    count:成员属性总数

##查看是否利用runtime转模型成功
打断点，进行查看，或者获取数组其中一个，输出打印。

