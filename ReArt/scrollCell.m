//
//  scrollCell.m
//  REArtistic
//
//  Created by xusea on 2017/10/20.
//  Copyright © 2017年 xusea. All rights reserved.
//

#import "scrollCell.h"

static void setBundleImageOnLayer(CALayer *layer, CFStringRef imageName)
{
    CGImageRef image = NULL;
    NSString *path = [[NSBundle mainBundle] pathForResource:((__bridge NSString *)imageName).stringByDeletingPathExtension ofType:((__bridge NSString *)imageName).pathExtension];
    if (!path)
    {
        return;
    }
    
    CGImageSourceRef imageSource = CGImageSourceCreateWithURL((CFURLRef)[NSURL fileURLWithPath:path], NULL);
    if (!imageSource)
    {
        return;
    }
    
    image = CGImageSourceCreateImageAtIndex(imageSource, 0, NULL);
    if (!image)
    {
        CFRelease(imageSource);
        return;
    }
    
    layer.contents = (__bridge id)image;
    
    CFRelease(imageSource);
    CFRelease(image);
}

@implementation scrollCell
@synthesize internalimageframe;
- (id) init
{
    if(self = [super init])
    {
        
        internalimageframe = self.frame;
        internalimageframe.origin.x += 3;
        internalimageframe.origin.y += 3;
        internalimageframe.size.width -= 6;
        internalimageframe.size.height -= 6;
    }
    return self;
}
- (NSRect)imageFrame
{
    /*NSRect frame = self.frame;
    frame.origin.x += 10;
    frame.origin.y += 10;
    frame.size.width -= 20;
    frame.size.height -= 20;
    return frame;
    //return internalimageframe;*/
    
    NSRect imageFrame = [super imageFrame];
    
    if (imageFrame.size.height == 0 || imageFrame.size.width == 0)
    {
        return NSZeroRect;
    }
    
    float aspectRatio =  imageFrame.size.width / imageFrame.size.height;
    
    // compute the rectangle included in container with a margin of at least 10 pixel at the bottom, 5 pixel at the top and keep a correct  aspect ratio
    NSRect container = [self imageContainerFrame];
    container = NSInsetRect(container, 8, 8);
    
    if (container.size.height <= 0)
    {
        return NSZeroRect;
    }
    
    float containerAspectRatio = container.size.width / container.size.height;
    
    if (containerAspectRatio > aspectRatio){
        imageFrame.size.height = container.size.height;
        imageFrame.origin.y = container.origin.y;
        imageFrame.size.width = imageFrame.size.height * aspectRatio;
        imageFrame.origin.x = container.origin.x + (container.size.width - imageFrame.size.width)*0.5;
    }
    else
    {
        imageFrame.size.width = container.size.width;
        imageFrame.origin.x = container.origin.x;
        imageFrame.size.height = imageFrame.size.width / aspectRatio;
        imageFrame.origin.y = container.origin.y + container.size.height - imageFrame.size.height;
    }
    
    // round it
    imageFrame.origin.x = floorf(imageFrame.origin.x);
    imageFrame.origin.y = floorf(imageFrame.origin.y);
    imageFrame.size.width = ceilf(imageFrame.size.width);
    imageFrame.size.height = ceilf(imageFrame.size.height);
    
    return imageFrame;
}
- (CALayer *)layerForType:(NSString *)type
{
    NSRect frame = [self frame];
    if( [type isEqualToString:IKImageBrowserCellBackgroundLayer] )
    {
        CALayer * backgroundlayer = [CALayer layer];
        backgroundlayer.delegate = self;
        NSRect frame = self.frame;
        frame.origin.x = -1;
        frame.origin.y = -1;
        frame.size.width += 2;
        frame.size.height += 2;
        backgroundlayer.frame = frame;
        [backgroundlayer setNeedsDisplay];
        return backgroundlayer;
    }
    if( [type isEqualToString:IKImageBrowserCellSelectionLayer] )
    {
        CALayer * backgroundlayer = [CALayer layer];
        backgroundlayer.delegate = self;
        NSRect frame = self.frame;
        frame.origin.x = -1;
        frame.origin.y = -1;
        frame.size.width += 2;
        frame.size.height += 2;
        backgroundlayer.frame = frame;
        CALayer *glossyLayer = [CALayer layer];
        NSRect glossylayerframe = frame;
        glossylayerframe.origin.x += (frame.size.width - [self imageFrame].size.width)/2;
        glossylayerframe.origin.y += (frame.size.height - [self imageFrame].size.height)/2;
        glossylayerframe.size = [self imageFrame].size;
        glossylayerframe.size.height += 10;
        glossylayerframe.size.width += 10;
        glossyLayer.frame = glossylayerframe;
        
        setBundleImageOnLayer(glossyLayer, CFSTR("background.png"));
        [backgroundlayer addSublayer:glossyLayer];
        [backgroundlayer setNeedsDisplay];
        return backgroundlayer;
    }
 
    return [super layerForType:type];
}
- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)context
{
    //NSLog(@"DRAW title???");
    // Set the current context.
    NSString * subtitle = [[self representedItem] subtitle];
    NSArray * strs = [subtitle componentsSeparatedByString:@"_"];
    [NSGraphicsContext saveGraphicsState];
    NSGraphicsContext *nscg = [NSGraphicsContext graphicsContextWithGraphicsPort:context flipped:NO];
    if(nscg != nil)
    {
        [NSGraphicsContext setCurrentContext:nscg];
       
        NSRect bound = [self frame];
        bound.origin.x = -1;
        bound.origin.y = -1;
        bound.size.width += 2;
        bound.size.height += 2;
        NSImage * borderimg = [NSImage imageNamed:@"save.png"];
       
            NSString * score = [strs objectAtIndex:0];
        
            NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[NSFont fontWithName:@"Helvetica light" size:15], NSFontAttributeName,[NSColor blackColor], NSForegroundColorAttributeName, nil];
            NSAttributedString * currentText =[[NSAttributedString alloc] initWithString:score attributes: attributes];
            [currentText drawAtPoint:bound.origin];
    
    }
    else
    {
        NSLog(@"currentContext is nil in cell");
    }
    
    [NSGraphicsContext restoreGraphicsState];
}
@end
