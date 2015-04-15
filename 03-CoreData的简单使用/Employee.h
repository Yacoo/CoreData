//
//  Employee.h
//  03-CoreData的简单使用
//
//  Created by yake on 15/4/15.
//  Copyright (c) 2015年 yake. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Department;

@interface Employee : NSManagedObject

@property (nonatomic, retain) NSDate * createDate;
@property (nonatomic, retain) NSNumber * height;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) Department *depart;

@end
