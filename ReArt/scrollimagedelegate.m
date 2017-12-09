//
//  scrollimagedelegate.m
//  REArtistic
//
//  Created by xusea on 2017/10/20.
//  Copyright © 2017年 xusea. All rights reserved.
//

#import "scrollimagedelegate.h"
@implementation MyScrollImageObject

@synthesize url;
@synthesize i;
@synthesize fontname;
@synthesize subtitle;
@synthesize title;
- (void)dealloc
{
    //[url release];
    //[super dealloc];
}
#pragma mark - Item data source protocol

- (NSString *)imageRepresentationType
{
    return IKImageBrowserNSImageRepresentationType;
}

- (id)imageRepresentation
{
    return  self.i;
    //return self.url;
}

- (NSString *)imageUID
{
    return [NSString stringWithFormat:@"%p", self];
}

- (id)imageTitle
{
    return [url lastPathComponent];
}
- (id)imageSubtitle
{
    return subtitle;
}
@end

@implementation scrollimagedelegate
@synthesize scrollimages;
- (id) init
{
    if(self = [super init])
    {
        scrollimages = [[NSMutableArray alloc] init];
        
        /* MyScrollImageObject * msi = [[MyScrollImageObject alloc]init];
         //[msi setUrl:@"http://111/111.html"];
         NSString * imagename = @"11234";
         NSImage * image =[[NSImage alloc]initWithContentsOfFile:@"/Users/xusea/sketch2photo/101.jpg"];
         [msi setI:image];
         [scrollimages addObject:msi];*/
        //为子类增加属性进行初始化
    }
    return self;
}
- (id)imageBrowser:(IKImageBrowserView *)view itemAtIndex:(NSUInteger)index
{
    //NSLog(@"%lu",(unsigned long)index);
    return [scrollimages objectAtIndex:index];
}
- (NSUInteger)numberOfItemsInImageBrowser:(IKImageBrowserView *)view
{
    return [scrollimages count];
}
- (void)imageBrowserSelectionDidChange:(IKImageBrowserView *)aBrowser
{
}
@end
