//
//  ViewController.m
//  03-CoreData的简单使用
//
//  Created by yake on 15/4/13.
//  Copyright (c) 2015年 yake. All rights reserved.
//

#import "ViewController.h"
#import <CoreData/CoreData.h>
#import "Employee.h"

@interface ViewController ()
{
    NSManagedObjectContext * _context;
}
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    //使用CoreData保存数据
    
    //1.初始化上下文
    _context = [[NSManagedObjectContext alloc] init];
    
    //2.添加持久化存储库
    
    //2.1模型文件，描述表结构的文件，也就是（Company.xcdatamodeld）这个文件
#warning 补充，如果bundle传nil，会从主bundle加载所有的模型文件，把里面的表结构都放在一个数据库文件中。
    NSManagedObjectModel * companyModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    
    //2.2持久化存储调度器
    NSPersistentStoreCoordinator * store = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:companyModel];
    
    //保存一个sqlite文件的话，必须知道表结构和sqlite文件路径
    //2.3告诉coredata数据存储在一个sqlite文件
    NSString * doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    //数据库的完整文件路径
    NSString * sqlitePath = [doc stringByAppendingPathComponent:@"company.sqlite"];
    NSLog(@"path = %@",sqlitePath);
    NSError * error = nil;
    [store addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:[NSURL fileURLWithPath:sqlitePath] options:nil error:&error];
    if(error){
        NSLog(@"error = %@",error);
    }
    
    _context.persistentStoreCoordinator = store;
}

- (IBAction)addEmployee:(id)sender {
    //添加员工
    //1.创建一个员工对象
//    用coredata创建对象不能使用下面方法
//    Employee * emp = [[Employee alloc] init];
    
   
        Employee * emp = [NSEntityDescription insertNewObjectForEntityForName:@"Employee" inManagedObjectContext:_context];
        
        emp.name = @"wangwu";
        emp.height = @(1.5);
        emp.createDate = [NSDate date];
        
        //保存员工信息
        NSError * error = nil;
        [_context save:&error];
        
        if(error){
            NSLog(@"%@",error);
        }
    
    

    
//    for(int i = 0; i < 10; i++){
//        Employee * emp = [NSEntityDescription insertNewObjectForEntityForName:@"Employee" inManagedObjectContext:_context];
//        
//        emp.name = [NSString stringWithFormat:@"zhangsan%d",i];
//        emp.height = @(1.98);
//        emp.createDate = [NSDate date];
//        
//        //保存员工信息
//        NSError * error = nil;
//        [_context save:&error];
//        
//        if(error){
//            NSLog(@"%@",error);
//        }
//        [ NSThread sleepForTimeInterval:1];
//        NSLog(@"===========%d",i);
//    }
    
    
}
#pragma mark -- 查找员工信息
- (IBAction)findEmployee:(id)sender {
    //查找数据
    //1.创建请求对象，指定要查找的表
    NSFetchRequest * request = [NSFetchRequest fetchRequestWithEntityName:@"Employee"];
    
    //时间排序
    NSSortDescriptor * dateSort = [NSSortDescriptor sortDescriptorWithKey:@"createDate" ascending:YES]; //yes代表升序，no代表降序
    request.sortDescriptors = @[dateSort];
    
//    //过滤条件 只想查找 zhangsan8
//    NSPredicate * pre = [NSPredicate predicateWithFormat:@"name = %@",@"zhangsan8"];
//    request.predicate = pre;
    
    //分页语句 10 两页 （0，5），（5，10）
    request.fetchOffset = 5;
    request.fetchLimit = 4;
    
    
    //执行请求
    NSError * error = nil;
   NSArray * allEmployees = [_context executeFetchRequest:request error:&error];
    if(error){
        NSLog(@"%@",error);
    }
  //  NSLog(@"allEmployee = %@",allEmployees);
    for(Employee * emp in allEmployees){
        NSLog(@"name = %@,height = %@,createdate = %@",emp.name,emp.height,emp.createDate);
    }
}

- (IBAction)updateEmployee:(id)sender {
    //查找数据
    //1.创建请求对象，指定要查找的表
    NSFetchRequest * request = [NSFetchRequest fetchRequestWithEntityName:@"Employee"];
    
    //时间排序
    NSSortDescriptor * dateSort = [NSSortDescriptor sortDescriptorWithKey:@"createDate" ascending:YES]; //yes代表升序，no代表降序
    request.sortDescriptors = @[dateSort];
    
        //过滤条件 只想查找 zhangsan8
        NSPredicate * pre = [NSPredicate predicateWithFormat:@"name = %@",@"zhangsan8"];
        request.predicate = pre;
    
    
    //执行请求
    NSError * error = nil;
    NSArray * allEmployees = [_context executeFetchRequest:request error:&error];
    if(error){
        NSLog(@"%@",error);
    }
 //更新zhangsan8的身高为2米
    for(Employee * emp in allEmployees){
        emp.height = @(2);
    }
    
    //保存更改的信息
    [_context save:&error];
}
- (IBAction)deleteEmployee:(id)sender {
    //查找数据
    //1.创建请求对象，指定要查找的表
    NSFetchRequest * request = [NSFetchRequest fetchRequestWithEntityName:@"Employee"];
    
    //时间排序
    NSSortDescriptor * dateSort = [NSSortDescriptor sortDescriptorWithKey:@"createDate" ascending:YES]; //yes代表升序，no代表降序
    request.sortDescriptors = @[dateSort];
    
    //过滤条件 只想查找 zhangsan8
    NSPredicate * pre = [NSPredicate predicateWithFormat:@"name = %@",@"zhangsan8"];
    request.predicate = pre;
    
    
    //执行请求
    NSError * error = nil;
    NSArray * allEmployees = [_context executeFetchRequest:request error:&error];
    if(error){
        NSLog(@"%@",error);
    }
    //删除zhangsan8的身高为2米
    for(Employee * emp in allEmployees){
        [_context deleteObject:emp];
    }
    
}
- (IBAction)complexSearch:(id)sender {
    //查找数据
    //1.创建请求对象，指定要查找的表
    NSFetchRequest * request = [NSFetchRequest fetchRequestWithEntityName:@"Employee"];
    
    //时间排序
    NSSortDescriptor * dateSort = [NSSortDescriptor sortDescriptorWithKey:@"createDate" ascending:YES]; //yes代表升序，no代表降序
    request.sortDescriptors = @[dateSort];
    
    //过滤条件 只想查找 zhangsan8
    //a 查找名为zhangsan 并且身高大于1.9
   // NSPredicate * pre = [NSPredicate predicateWithFormat:@"name = %@ AND height >= %lf",@"zhangsan",1.30];
    
    //查找以zh开头，并且身高大于1.3
    //以什么开头 BRGINSWITH
    //c代表不区分大小写
//    NSPredicate * pre = [NSPredicate predicateWithFormat:@"name BEGINSWITH[c] %@ AND height >= %lf",@"abc",1.30];
    
    //查找名字以san结尾的，并且身高大于1.3
//    NSPredicate * pre = [NSPredicate predicateWithFormat:@"name ENDSWITH[c] %@ AND height >= %lf",@"cent",1.30];
    //模糊查询
    NSPredicate * pre = [NSPredicate predicateWithFormat:@"name like[c] %@",@"li*"];
    request.predicate = pre;
    
    
    
    
    //执行请求
    NSError * error = nil;
    NSArray * allEmployees = [_context executeFetchRequest:request error:&error];
    if(error){
        NSLog(@"%@",error);
    }
    //删除zhangsan8的身高为2米
    for(Employee * emp in allEmployees){
        NSLog(@"emp.name = %@,emp.height = %@",emp.name,emp.height);
    }
}
@end
