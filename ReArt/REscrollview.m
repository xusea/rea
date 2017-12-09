//
//  REscrollview.m
//  REArtistic
//
//  Created by xusea on 2017/10/20.
//  Copyright © 2017年 xusea. All rights reserved.
//

#import "REscrollview.h"

@implementation REscrollview

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
}
- (IKImageBrowserCell *)newCellForRepresentedItem:(id)cell
{
    return [[scrollCell alloc] init];
}

@end
