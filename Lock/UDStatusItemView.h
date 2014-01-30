//
//  UDStatusItemView.h
//  Lock
//
//  Created by Lutz Hören on 30.09.13.
//  Copyright (c) 2013 Lutz Hören. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#define STATUS_ITEM_VIEW_WIDTH 24.0

@interface UDStatusItemView : NSView <NSMenuDelegate>

- (id)initWithStatusItem:(NSStatusItem *)statusItem;

@property (nonatomic, strong, readonly) NSStatusItem* statusItem;
@property (nonatomic, strong) NSImage *image;
@property (nonatomic, strong) NSImage *alternateImage;
@property (nonatomic) SEL action;
@property (nonatomic, unsafe_unretained) id target;

@end
