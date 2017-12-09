//
//  REproject.h
//  REArtistic
//
//  Created by xusea on 2017/10/19.
//  Copyright © 2017年 xusea. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface REproject : NSObject
{
    NSString * styleimagename;
    NSString * contentimagename;
    NSString * luapath;
    NSString * randprefix;
    NSString * savedir;
    NSImage * styleimage;
    NSImage * contentimage;
    int num_iterations;
    int save_iter;
    int cur_iter;
}
@property NSString * styleimagename;
@property NSString * contentimagename;
@property NSString * luapath;
@property NSString * randprefix;
@property NSString * savedir;
@property NSImage * styleimage;
@property NSImage * contentimage;
@property int num_iterations;
@property int save_iter;
@property int cur_iter;

@end
