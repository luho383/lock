//
//  UDStatusItemView.m
//  Lock
//
//  Created by Lutz Hören on 30.09.13.
//  Copyright (c) 2013 Lutz Hören. All rights reserved.
//

#import "UDStatusItemView.h"

@interface UDStatusItemView ()
{
    BOOL isMenuVisible;
}

@end

@implementation UDStatusItemView

- (id)initWithStatusItem:(NSStatusItem *)statusItem
{
    CGFloat itemWidth = [statusItem length];
    CGFloat itemHeight = [[NSStatusBar systemStatusBar] thickness];
    NSRect itemRect = NSMakeRect(0.0, 0.0, itemWidth, itemHeight);
    
    //
    self = [super initWithFrame:itemRect];
    
    if (self != nil) {
        _statusItem = statusItem;
        _statusItem.view = self;
    }
    
    return self;
}


- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
        isMenuVisible = NO;
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
	[super drawRect:dirtyRect];
	
    // Draw status bar background, highlighted if menu is showing
    [self.statusItem drawStatusBarBackgroundInRect:[self bounds]
                                withHighlight:isMenuVisible];
    
    
    
    NSImage *icon = isMenuVisible ? self.alternateImage : self.image;
    NSSize iconSize = [icon size];
    NSRect bounds = self.bounds;
    CGFloat iconX = roundf((NSWidth(bounds) - iconSize.width) / 2);
    CGFloat iconY = roundf((NSHeight(bounds) - iconSize.height) / 2);
    NSPoint iconPoint = NSMakePoint(iconX, iconY);
    
	[icon drawAtPoint:iconPoint fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0];
    
    
    // Drawing code here.
}


- (void)mouseDown:(NSEvent *)event {
    [NSApp sendAction:self.action to:self.target from:self];
}

- (void)rightMouseDown:(NSEvent *)event {
    
    [[self menu] setDelegate:self];
    [self.statusItem popUpStatusItemMenu:[self menu]];
    [self setNeedsDisplay:YES];
    
}

- (void)menuWillOpen:(NSMenu *)menu {
    isMenuVisible = YES;
    [self setNeedsDisplay:YES];
}

- (void)menuDidClose:(NSMenu *)menu {
    isMenuVisible = NO;
    [menu setDelegate:nil];
    [self setNeedsDisplay:YES];
}

#pragma mark -

- (void)setImage:(NSImage *)newImage
{
    if (_image != newImage) {
        _image = newImage;
        [self setNeedsDisplay:YES];
    }
}

- (void)setAlternateImage:(NSImage *)newImage
{
    if (_alternateImage != newImage) {
        _alternateImage = newImage;
        if (isMenuVisible) {
            [self setNeedsDisplay:YES];
        }
    }
}




@end
