//
//  REproxy.h
//  REArtistic
//
//  Created by xusea on 2017/10/19.
//  Copyright © 2017年 xusea. All rights reserved.
//

#import <Foundation/Foundation.h>
#import"REproject.h"
@interface REproxy : NSObject
+(void)createLUAstartfile:(NSString *)filepath contentfilename:(NSString*)contentfilename stylefile:(NSString *)stylefilename filetype:(int)filetype reproject:(REproject*)reproject;
+(NSString *)getfilename;
+(NSString *)getrandstr;
@end
