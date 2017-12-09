//
//  scrollCell.h
//  REArtistic
//
//  Created by xusea on 2017/10/20.
//  Copyright © 2017年 xusea. All rights reserved.
//

#import <Quartz/Quartz.h>
@interface scrollCell : IKImageBrowserCell
{
    NSRect internalimageframe;
}
@property (readwrite)NSRect internalimageframe;
@end
