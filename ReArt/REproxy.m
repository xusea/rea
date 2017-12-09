//
//  REproxy.m
//  REArtistic
//
//  Created by xusea on 2017/10/19.
//  Copyright © 2017年 xusea. All rights reserved.
//

#import "REproxy.h"

@implementation REproxy
+(void)createLUAstartfile:(NSString *)filepath contentfilename:(NSString*)contentfilename stylefile:(NSString *)stylefilename filetype:(int)filetype reproject:(REproject*)reproject
{
    
    NSFileManager *FileManager=[NSFileManager defaultManager];
    NSString * resourcedir = [[NSBundle mainBundle] resourcePath];
    NSString * frameworkdir = [[NSBundle mainBundle] privateFrameworksPath];
    
    NSRange prefix;
    prefix.length = filepath.length - 4;
    prefix.location = 0;
    
    //1.创建文件
    [FileManager createFileAtPath:filepath contents:nil attributes:nil];//创建内容为空得文件
    if(filetype == 1)
    {
        NSString * luacontentpath =[NSString stringWithFormat:@"%@/script/neural_style_f_2.lua",[[NSBundle mainBundle] resourcePath]];
        NSString * luacontent = [NSString stringWithContentsOfFile:luacontentpath encoding:NSUTF8StringEncoding error:nil];
        [luacontent writeToFile:filepath atomically:YES encoding:NSUTF8StringEncoding error:nil];
        return;
    }
    NSString * filecontent = @"";
    NSString * tpackagepath = [NSString stringWithFormat:@"package.path=\"%@/script/lua/5.1/?.lua;%@/script/lua/5.1/?/init.lua;\"\n", resourcedir,resourcedir];
    filecontent = [filecontent stringByAppendingString:tpackagepath];
    NSString * tpackagecpath = [NSString stringWithFormat:@"package.cpath=\"%@/dylib/?.so;%@/dylib/?.dylib;\"\n", frameworkdir,frameworkdir];
    filecontent = [filecontent stringByAppendingString:tpackagecpath];
    filecontent = [filecontent stringByAppendingString:@"local k,l,_=pcall(require,\"luarocks.loader\") _=k and l.add_context(\"trepl\",\"scm-1\")\n"];
    filecontent = [filecontent stringByAppendingString:@"arg={}\n"];
    //生成新的neural_sytle_f.lua文件
    NSString * luansfpath =[NSString stringWithFormat:@"%@/script/neural_style_f.lua",[[NSBundle mainBundle] resourcePath]];
    NSString * luansfcontent = [NSString stringWithContentsOfFile:luansfpath encoding:NSUTF8StringEncoding error:nil];
    
    //做函数名称替换
    NSString * replacestr = [[[filepath substringWithRange:prefix] componentsSeparatedByString:@"/"] lastObject];
    luansfcontent = [luansfcontent stringByReplacingOccurrencesOfString:@"TVLoss" withString:[NSString stringWithFormat:@"TVLoss%@", replacestr]];
    luansfcontent = [luansfcontent stringByReplacingOccurrencesOfString:@"ContentLoss" withString:[NSString stringWithFormat:@"ContentLoss%@", replacestr]];
    luansfcontent = [luansfcontent stringByReplacingOccurrencesOfString:@"Gram" withString:[NSString stringWithFormat:@"Gram%@", replacestr]];
    luansfcontent = [luansfcontent stringByReplacingOccurrencesOfString:@"StyleLoss" withString:[NSString stringWithFormat:@"StyleLoss%@", replacestr]];
    NSString * luansftmppath = [[filepath substringWithRange:prefix] stringByAppendingString:@"_nsf.lua"];
    [luansfcontent writeToFile:luansftmppath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    NSString * mainscript = [NSString stringWithFormat:@"arg[1]=\"%@\"\n", luansftmppath];
    if(filetype == 1)
    {
        mainscript = [NSString stringWithFormat:@"arg[1]=\"%@/script/neural_style_f_2.lua\"\n", resourcedir];
    }
    filecontent = [filecontent stringByAppendingString:mainscript];
    filecontent = [filecontent stringByAppendingString:@"arg[2]=\"-gpu\"\n"];
    filecontent = [filecontent stringByAppendingString:@"arg[3]=\"-1\"\n"];
    filecontent = [filecontent stringByAppendingString:@"arg[4]=\"-style_image\"\n"];
    NSString * styleimage = [NSString stringWithFormat:@"arg[5]=\"%@/script/starry_night.jpg\"\n",resourcedir];
    if([reproject styleimagename] != nil)
    {
        styleimage =  [NSString stringWithFormat:@"arg[5]=\"%@\"\n",[reproject styleimagename]];
    }
    filecontent = [filecontent stringByAppendingString:styleimage];
    filecontent = [filecontent stringByAppendingString:@"arg[6]=\"-content_image\"\n"];
    NSString * contentimage = [NSString stringWithFormat:@"arg[7]=\"%@/script/tam.jpg\"\n",resourcedir];
    if([reproject contentimagename] != nil)
    {
        contentimage = [NSString stringWithFormat:@"arg[7]=\"%@\"\n",[reproject contentimagename]];
    }
    filecontent = [filecontent stringByAppendingString:contentimage];
    filecontent = [filecontent stringByAppendingString:@"arg[8]=\"-output_image\"\n"];
    NSString * outfile = [NSString stringWithFormat:@"arg[9]=\"%@/out.png\"\n", NSTemporaryDirectory()];
    filecontent = [filecontent stringByAppendingString:outfile];
    
    filecontent = [filecontent stringByAppendingString:@"arg[10]=\"-proto_file\"\n"];
    //NSString * vgg19proto =  [NSString stringWithFormat:@"arg[11]=\"%@/script/VGG_ILSVRC_19_layers_deploy.prototxt\"\n", resourcedir];
    
    //生成proto
    NSString * protofile = [[filepath substringWithRange:prefix] stringByAppendingString:@".prototxt"];
    NSString * vgg19proto =  [NSString stringWithFormat:@"%@/script/VGG_ILSVRC_19_layers_deploy.prototxt", resourcedir];
    NSString * protofilecontent = [NSString stringWithContentsOfFile:vgg19proto encoding:NSUTF8StringEncoding error:nil];
    [protofilecontent writeToFile:protofile atomically:YES encoding:NSUTF8StringEncoding error:nil];
    //filecontent = [filecontent stringByAppendingString:protofile];
    filecontent = [filecontent stringByAppendingString:[NSString stringWithFormat:@"arg[11]=\"%@\"\n", protofile]];
    //修改prototxt.lua
    NSString * prototxtlua = [protofile stringByAppendingString:@".lua"];
    NSString * prototxtluaraw = [vgg19proto stringByAppendingString:@".lua"];
    NSString * prototxtluacontent = [NSString stringWithContentsOfFile:prototxtluaraw encoding:NSUTF8StringEncoding error:nil];
    [prototxtluacontent writeToFile:prototxtlua atomically:YES  encoding:NSUTF8StringEncoding error:nil];
    
    
    filecontent = [filecontent stringByAppendingString:@"arg[12]=\"-model_file\"\n"];
    //NSString * vgg19model =  [NSString stringWithFormat:@"arg[13]=\"%@/script/VGG_ILSVRC_19_layers.caffemodel\"\n", resourcedir];
    NSString * vgg19model =  [NSString stringWithFormat:@"arg[13]=\"%@/script/VGG_ILSVRC_19_layers.caffemodel\"\n", resourcedir];
    filecontent = [filecontent stringByAppendingString:vgg19model];
    //cmd:option('-num_iterations', 100)
    filecontent = [filecontent stringByAppendingString:@"arg[14]=\"-num_iterations\"\n"];
    filecontent = [filecontent stringByAppendingString:[NSString stringWithFormat:@"arg[15]=\"%d\"\n", [reproject num_iterations]]];
    
    //cmd:option('-save_iter', 10)
    filecontent = [filecontent stringByAppendingString:@"arg[16]=\"-save_iter\"\n"];
    filecontent = [filecontent stringByAppendingString:[NSString stringWithFormat:@"arg[17]=\"%d\"\n", [reproject save_iter]]];
    
    //cmd:option('-model_dir', XXX)
    filecontent = [filecontent stringByAppendingString:@"arg[18]=\"-model_path\"\n"];
    filecontent = [filecontent stringByAppendingString:[NSString stringWithFormat:@"arg[19]=\"%@\"\n", [[NSBundle mainBundle] resourcePath]]];
    ///////////////////////////////////////////////////
    NSString * luacontentpath =[NSString stringWithFormat:@"%@/script/thscript.lua",[[NSBundle mainBundle] resourcePath]];
    NSString * luacontent = [NSString stringWithContentsOfFile:luacontentpath encoding:NSUTF8StringEncoding error:nil];
    filecontent = [filecontent stringByAppendingString:luacontent];
    [filecontent writeToFile:filepath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    //NSLog(@"%@", filecontent);
}
+(NSString *)getrandstr
{
    int NUMBER_OF_CHARS = 10;
    char data[NUMBER_OF_CHARS];
    for (int x=0;x < NUMBER_OF_CHARS; x++)
    {
        data[x] = ('A' + (arc4random_uniform(26)));
    }
    NSString *dataPoint = [[NSString alloc] initWithBytes:data length:NUMBER_OF_CHARS encoding:NSUTF8StringEncoding];
    return dataPoint;
}
+(NSString *)getfilename
{
    NSString * dir = NSTemporaryDirectory();
    NSString * filename = [NSString stringWithFormat:@"%@/neLUA%@.lua", dir, [self getrandstr]];
    return filename;
}
@end

