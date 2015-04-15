//
//  Person.h
//  03-CoreData的简单使用
//
//  Created by yake on 15/4/14.
//  Copyright (c) 2015年 yake. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Person : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * age;

@end
