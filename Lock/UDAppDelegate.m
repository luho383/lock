//
//  UDAppDelegate.m
//  Lock
//
//  Created by Lutz Hören on 29.09.13.
//  Copyright (c) 2013 Lutz Hören. All rights reserved.
//

#import "UDAppDelegate.h"
#import "UDStatusItemView.h"
#import "DDHotKeyCenter.h"

@interface UDAppDelegate ()
{
    NSStatusItem* statusItem;
    UDStatusItemView* statusView;
    KeyCombo keyCombo;
}
@end


@implementation UDAppDelegate

-(void)awakeFromNib {
    
    keyCombo.flags = 0;
    keyCombo.code = -1;
    
    NSImage* active = [NSImage imageNamed:@"NSLockLockedTemplate"];
    
    statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:STATUS_ITEM_VIEW_WIDTH];
    
    statusView = [[UDStatusItemView alloc] initWithStatusItem:statusItem];
    
    statusView.image = active;
    statusView.alternateImage = active;
    statusView.menu = self.menu;
    statusView.action = @selector(doLock:);
}

-(void)dealloc
{
    KeyCombo combo = self.shortcutRec.keyCombo;
    DDHotKeyCenter * c = [[DDHotKeyCenter alloc] init];
	[c unregisterHotKeyWithKeyCode:combo.code modifierFlags:combo.flags];
	c = nil;
    
    [[NSStatusBar systemStatusBar] removeStatusItem:statusItem];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Load default defaults
    [[NSUserDefaults standardUserDefaults] registerDefaults:[NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"preferences" ofType:@"plist"]]];
    
    // setup recorder
    keyCombo.code = [[NSUserDefaults standardUserDefaults] integerForKey:@"HotkeyCode"];
    keyCombo.flags = [[NSUserDefaults standardUserDefaults] integerForKey:@"HotkeyFlags"];
    [self.shortcutRec setKeyCombo:keyCombo];
    
    // setup hotkey
    if( keyCombo.code != -1 || keyCombo.flags != 0 )
    {
        DDHotKeyCenter * c = [[DDHotKeyCenter alloc] init];
        if (![c registerHotKeyWithKeyCode:keyCombo.code modifierFlags:keyCombo.flags target:self action:@selector(doLock:) object:nil]) {
            NSLog(@"Unable to register hotkey for example 1");
            
        } else {
            NSLog(@"Registered hotkey for example 1");
            NSLog(@"Registered: %@", [c registeredHotKeys] );
        }
        c = nil;
    }
    
}

- (IBAction)doLock:(id)sender {

    NSTask *task;
    NSMutableArray *arguments = [NSArray arrayWithObject:@"-suspend"];
    
    task = [[NSTask alloc] init];
    [task setArguments: arguments];
    [task setLaunchPath: @"/System/Library/CoreServices/Menu Extras/User.menu/Contents/Resources/CGSession"];
    [task launch];
    NSLog(@"screen is Locked");
}

- (IBAction)showPreferences:(id)sender {
    
    [self.preferencePane makeKeyAndOrderFront:sender];
    
}


#pragma mark Shortcut Recorder

- (BOOL)shortcutRecorder:(SRRecorderControl *)aRecorder isKeyCode:(NSInteger)keyCode andFlagsTaken:(NSUInteger)flags reason:(NSString **)aReason {
    
    // accept
    return NO;
}

- (void)shortcutRecorder:(SRRecorderControl *)aRecorder keyComboDidChange:(KeyCombo)newKeyCombo {
    
    // save key combo
    NSInteger code = newKeyCombo.code;
    NSInteger flags = newKeyCombo.flags;
    
    [[NSUserDefaults standardUserDefaults] setInteger:code forKey:@"HotkeyCode"];
    [[NSUserDefaults standardUserDefaults] setInteger:flags forKey:@"HotkeyFlags"];
    
    // if it has changed
    if( keyCombo.code != newKeyCombo.code || keyCombo.flags != newKeyCombo.flags )
    {
        DDHotKeyCenter * c = [[DDHotKeyCenter alloc] init];
     
        // check if we want to remove old key combo (only if valid old key combo)
        if( keyCombo.code != -1 || keyCombo.flags != 0 )
        {
            // remove old key combo
            [c unregisterHotKeyWithKeyCode:keyCombo.code modifierFlags:keyCombo.flags];
        }
        
        // check if we want to register a new hot key‚
        if( newKeyCombo.code != -1 || newKeyCombo.flags != 0 )
        {
            if (![c registerHotKeyWithKeyCode:newKeyCombo.code modifierFlags:newKeyCombo.flags target:self action:@selector(doLock:) object:nil]) {
                NSLog(@"Unable to register hotkey for example 1");
                
            } else {
                NSLog(@"Registered hotkey for example 1");
                NSLog(@"Registered: %@", [c registeredHotKeys] );
            }
        }
        
        c = nil;
        
        // set key combo
        keyCombo.flags = newKeyCombo.flags;
        keyCombo.code = newKeyCombo.code;
    }
    
    
}

@end
