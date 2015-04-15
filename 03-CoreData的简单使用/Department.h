//
//  Department.h
//  03-CoreData的简单使用
//
//  Created by yake on 15/4/15.
//  Copyright (c) 2015年 yake. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Department : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * departNo;

@end
