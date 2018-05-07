//
//  Tool.h
//  iShopApp
//
//  Created by Maggie on 15/3/2.
//  Copyright (c) 2015年 fmning. All rights reserved.
//

#ifndef iShopApp_Tool_h
#define iShopApp_Tool_h

#define currentSystemVersion [[UIDevice currentDevice].systemVersion floatValue]

#define currentScreenHeight ((currentSystemVersion >= 7.0) ? ([UIScreen mainScreen].bounds.size.height) : ([UIScreen mainScreen].bounds.size.height - 20))

#define currentScreenWidth ([UIScreen mainScreen].bounds.size.width)

#define APPDELEGATE ((AppDelegate*)[[UIApplication sharedApplication] delegate])

#define file1 @"user.plist"

#endif



