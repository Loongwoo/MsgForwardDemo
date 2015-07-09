//
//  Person.m
//  MessageForwardDemo
//
//  Created by kiwik on 7/9/15.
//  Copyright (c) 2015 Kiwik. All rights reserved.
//

#import "Person.h"

@implementation Person

//=============================================Step 0=========================================================

//开始调用自己的实现方法，如果不存在则跳到Step 1
//-(void)run
//{
//    NSLog(@"%@ %s 1",self,__func__);
//}

//=============================================Step 1=========================================================

void run(id self, SEL sel)
{
    NSLog(@"%@ %s 2",self, sel_getName(sel));
}

+ (BOOL)resolveInstanceMethod:(SEL)sel
{
    NSLog(@"%s %@",__func__,NSStringFromSelector(sel));
    
    //动态添加一个方法，如果不添加跳到Step 2
//    if(sel == @selector(run))
//    {
//        class_addMethod(self, sel, (IMP)run, "v@:");
//        return YES;
//    }
    
    return [super resolveInstanceMethod:sel];
}

//当类的方法不存在时调用
+ (BOOL)resolveClassMethod:(SEL)sel
{
    NSLog(@"%s",__func__);
    
    return [super resolveClassMethod:sel];
}

//=============================================Step 2=========================================================

-(id)forwardingTargetForSelector:(SEL)aSelector
{
    NSLog(@"%s %@",__func__,NSStringFromSelector(aSelector));
    
    //转发给Car的实例，调用car的run方法，如果不转发则跳到Step 3
//    return [Car new];
    
    return [super forwardingTargetForSelector:aSelector];
}

//=============================================Step 3=========================================================

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
    NSLog(@"%s %@",__func__,NSStringFromSelector(aSelector));
    
    if(aSelector == @selector(run))
    {
        return [NSMethodSignature signatureWithObjCTypes:"v@:"];
    }
    
    return [super methodSignatureForSelector:aSelector];
}

- (void)forwardInvocation:(NSInvocation *)anInvocation
{
    NSLog(@"%s",__func__);
    
    SEL selector=[anInvocation selector];
    Car *car=[Car new];
    
    if([car respondsToSelector:selector])
    {
        [anInvocation invokeWithTarget:car];
    }
}

@end
