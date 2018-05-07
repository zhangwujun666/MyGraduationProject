//
//  SYJAnnotation.m
//  SYiJieAppClient
//
//  Created by administrator on 15/8/12.
//  Copyright (c) 2015年 韦忠添胡玉平钟成明. All rights reserved.
//

#import "SYJAnnotation.h"

@implementation SYJAnnotation
+(id)localAnnotationWith:(NSString *)newTitle subTitle:(NSString *)newSubtitle latitude:(float)newLatitude longitude:(float)newLongitude{
    SYJAnnotation *annotation=[[SYJAnnotation alloc] init];
    annotation.title=newTitle;
    annotation.subtitle=newSubtitle;
    annotation.coordinate=CLLocationCoordinate2DMake(newLatitude, newLongitude);
    return annotation;
}
@end
