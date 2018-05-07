//
//  view.m
//  kongjian
//
//  Created by administrator on 15/8/18.
//  Copyright (c) 2015年 尚衣街. All rights reserved.
//

#import "Pickview.h"
@interface Pickview()<UIPickerViewDataSource,UIPickerViewDelegate>{
    NSArray *arr;
    NSArray *cityarr;
    NSDictionary *citydic;
    NSDictionary *dic;
    NSDictionary *onedic;
    NSArray *qu;
}
@end
@implementation Pickview
-(void)awakeFromNib{
    NSBundle *bundle=[NSBundle mainBundle];
    NSString *plistPath=[bundle pathForResource:@"area" ofType:@"plist"];
    arr=[NSArray arrayWithContentsOfFile:plistPath];
    citydic=[arr objectAtIndex:0];//取第一个福建默认的 所有的信息
    cityarr=[citydic objectForKey:@"cities"];//市的所有信息
    NSLog(@"%@",[citydic objectForKey:@"state"]);
    
    onedic=[cityarr objectAtIndex:0];//选到第一个市
    
    NSLog(@"%@",[onedic objectForKey:@"city"]);
    qu=[onedic objectForKey:@"areas"];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(cityy) name:@"city" object:nil];
        
    self.one.delegate=self;
    self.one.dataSource=self;
}
-(void)cityy{
    
        self.frame=CGRectMake(0, 650,[[UIScreen mainScreen]bounds].size.width, 300);
   
}
-(void)changanima{
    [UIView animateWithDuration:0.5 animations:^{
        self.frame=CGRectMake(0, 300, [[UIScreen mainScreen]bounds].size.width, 300);
    }];
}
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 3;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if(component==0){
        return arr.count;
    }
    if(component==1){
        return cityarr.count;
    }
    else  {
        return qu.count;
    }
    
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component==0) {
        return [[arr objectAtIndex:row] objectForKey:@"state"];
        
    }
    if(component==1){
        return [[cityarr objectAtIndex:row] objectForKey:@"city"];
    }
    else {
        if([qu count]>0){
            
            return [qu objectAtIndex:row];
        }
        else{
            return nil;
        }
    }
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if(component==0){
        citydic=[arr objectAtIndex:row];//取整个省,包括省和省字符串，两个字典一个字典存数组，另外一个存字符串
        self.sheng=[citydic objectForKey:@"state"];//取省字符串
        
        cityarr=[citydic objectForKey:@"cities"];//取所有的市，,他是数组和上面不一样，每一个市是一个数组对象
        [self.one selectRow:0 inComponent:1 animated:YES];
        [self.one reloadComponent:1];//要刷新两个组件，这是第二个
        onedic=[cityarr objectAtIndex:0];//取第一个市整个区。是字典要区分开，一个存数组急所有区的内容，另外一个是字符串
        self.city=[onedic objectForKey:@"city"];
        
        qu=[onedic objectForKey:@"areas"];
        if(qu.count>0){
        self.qu=[qu objectAtIndex:0];
        }
        [self.one selectRow:0 inComponent:2 animated:YES];
        [self.one reloadComponent:2];
        
        if([self.delegate respondsToSelector:@selector(pick:sheng:andcity:andqu:)]){
            [self.delegate pick:self sheng:self.sheng andcity:self.city andqu:self.qu];
        }
    }
    if(component==1){
        onedic=[cityarr objectAtIndex:row];
        self.city=[onedic objectForKey:@"city"];
        qu=[onedic objectForKey:@"areas"];
        if(qu.count>0){
        self.qu=[qu objectAtIndex:0];
        }
        [self.one selectRow:0 inComponent:2 animated:YES];
        [self.one reloadComponent:2];
        if([self.delegate respondsToSelector:@selector(pick:sheng:andcity:andqu:)]){
            [self.delegate pick:self sheng:self.sheng andcity:self.city andqu:self.qu];
        }
        
    }
  
    
    if (component==2) {
       
        self.qu=[qu objectAtIndex:row];
        if([self.delegate respondsToSelector:@selector(pick:sheng:andcity:andqu:)]){
            [self.delegate pick:self sheng:self.sheng andcity:self.city andqu:self.qu];
        }
    }
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    UILabel *picklable=(UILabel*)view;
    if(!picklable){
        picklable=[[UILabel alloc]init];
        [picklable setFont:[UIFont boldSystemFontOfSize:17]];
        
    }
    picklable.text=[self pickerView:self.one titleForRow:row forComponent:component];
    return picklable;
}


@end
