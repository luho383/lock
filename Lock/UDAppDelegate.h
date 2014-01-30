//
//  UDAppDelegate.h
//  Lock
//
//  Created by Lutz Hören on 29.09.13.
//  Copyright (c) 2013 Lutz Hören. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SRRecorderControl.h"

@interface UDAppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow* preferencePane;
@property (assign) IBOutlet NSMenu* menu;
@property (weak) IBOutlet SRRecorderControl *shortcutRec;

- (IBAction)doLock:(id)sender;
- (IBAction)showPreferences:(id)sender;

// shortcut
- (BOOL)shortcutRecorder:(SRRecorderControl *)aRecorder isKeyCode:(NSInteger)keyCode andFlagsTaken:(NSUInteger)flags reason:(NSString **)aReason;
- (void)shortcutRecorder:(SRRecorderControl *)aRecorder keyComboDidChange:(KeyCombo)newKeyCombo;

@end
