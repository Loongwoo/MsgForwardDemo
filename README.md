# MsgForwardDemo

A simple demo for indroducing the message forward mechanism of IOS. If no implementation then it will

1. call resolveInstanceMethod
2. call forwardingTargetForSelector 
3. call forwardInvocation

http://www.xulongwu.com/blog/2015/07/09/at-iosxiao-xi-zhuan-fa-ji-zhi/

    //=============================================Step 0=========================================================

    //Call the method implemented by itself, if no implementation jump to Step 1
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
    
        //Add a method automatically. if no jump to Step 2
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
    
        //Forward thid message to other instance if no jump to Step 3
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
    
        if([car respondsToSelector:selector]){
            [anInvocation invokeWithTarget:car];
        }
    }

