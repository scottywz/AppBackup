/* AppBackup
 * An iPhoneOS application that backs up and restores the saved data and
 * preferences of App Store apps.
 * 
 * Copyright (C) 2008-2011 Scott Zeid
 * http://me.srwz.us/iphone/appbackup
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 * 
 * Except as contained in this notice, the name(s) of the above copyright holders
 * shall not be used in advertising or otherwise to promote the sale, use or
 * other dealings in this Software without prior written authorization.
 * 
 */

// Backup One App screen

#import "util.h";
#import "AppBackup.h";
#import "AppBackupGUI.h";

@implementation BackupOneAppScreen
@synthesize gui;
@synthesize index;
@synthesize app;
@synthesize modal;
@synthesize alert;
@synthesize action;

- (id)initWithGUI:(AppBackupGUI *)gui_ appAtIndex:(NSInteger)index_ {
 self = [super init];
 if (self) {
  self.gui = gui_;
  self.index = index_;
  self.app = [gui.appbackup.apps objectAtIndex:index];
  self.title = [app objectForKey:@"friendly"];
  self.delegate = self;
  NSString *prompt = [app objectForKey:@"bundle"];
  if ([prompt length] > 30)
   prompt = [[prompt substringWithRange:NSMakeRange(0, 30)]
             stringByAppendingString:@"..."];
  prompt = [NSString stringWithFormat:@"(%s)", prompt];
  NSString *cancel_string = @"cancel";
  if (![app objectForKey:@"useable"]) {
   prompt = [NSString stringWithFormat:@"%s\n\n%s", prompt,
             _(@"app_corrupted_prompt")];
   cancel_string = _(@"ok");
  } else if ([app objectForKey:@"ignored"]) {
   prompt = [NSString stringWithFormat:@"%s\n\n%s", prompt,
             _(@"app_corrupted_prompt")];
   [self addButtonWithTitle:_(@"unignore")];
  } else if ([[app objectForKey:@"backup_time"] length]) {
   [self addButtonWithTitle:_(@"backup")];
   [self addButtonWithTitle:_(@"restore")];
   [self addButtonWithTitle:_(@"ignore")];
   [self addButtonWithTitle:_(@"delete")];
  } else {
   [self addButtonWithTitle:_(@"backup")];
   [self addButtonWithTitle:_(@"ignore")];
  }
  self.bodyText = prompt;
  [self setCancelButtonIndex:[self addButtonWithTitle:_(cancel_string)]];
 }
 return self;
}

- (void)actionSheet:(UIActionSheet *)sheet
        didDismissWithButtonIndex:(NSInteger)index {
 // What to do when you close the backup one app prompt
 NSString *button_text = [sheet buttonTitleAtIndex:index];
 if ([button_text isEqualToString:_(@"cancel")] ||
     [button_text isEqualToString:_(@"ok")]) return;
 self.modal = [[UIModalView alloc] init];
 modal.title = _(@"please_wait");
 if ([button_text isEqualToString:_(@"backup")])   self.action = @"backup";
 if ([button_text isEqualToString:_(@"delete")])   self.action = @"delete";
 if ([button_text isEqualToString:_(@"ignore")])   self.action = @"ignore";
 if ([button_text isEqualToString:_(@"restore")])  self.action = @"restore";
 if ([button_text isEqualToString:_(@"unignore")]) self.action = @"unignore";
 NSString *text_ = _([NSString stringWithFormat:@"1_status_%s_doing", action]);
 modal.bodyText = [NSString stringWithFormat:text_,
                   [app objectForKey:@"friendly"]];
 [modal popupAlertAnimated:YES];
 [self doAction];
}

- (void)doAction {
 NSString *done_title   = _([NSString stringWithFormat:@"%s_done", action]);
 NSString *done_text_   = _([NSString stringWithFormat:@"1_status_%s_done",
                             action]);
 NSString *done_text    = _([NSString stringWithFormat:done_text_,
                             [app objectForKey:@"friendly"]]);
 NSString *failed_title = _([NSString stringWithFormat:@"%s_failed", action]);
 NSString *failed_text_ = _([NSString stringWithFormat:@"1_status_%s_failed",
                             action]);
 NSString *failed_text  = _([NSString stringWithFormat:failed_text_,
                             [app objectForKey:@"friendly"]]);
 NSString *title;
 NSString *text;
 BOOL      results_box  = YES;
 *r = (NSMutableDictionary *)[gui.appbackup doAction:action onApp:app];
 [gui updateAppAtIndex:index];
 if ([r objectForKey:@"success"]) {
  title = done_title;
  text  = done_text;
  if ([action isEqualToString:@"ignore"] ||
      [action isEqualToString:@"unignore"])
   results_box = NO;
 } else {
  title = failed_title;
  text  = failed_text;
 }
 [modal dismiss];
 [modal release];
 if (results_box) {
  self.alert = [[UIAlertView alloc] init];
  alert.title = title;
  alert.bodyText = text;
  [alert addButtonWithTitle:_(@"ok")];
  [alert show];
  [alert release];
 }
}

- (void)dealloc {
 self.gui = nil;
 self.index = nil;
 self.app = nil;
 self.modal = nil;
 self.alert = nil;
 self.action = nil;
 [super dealloc];
}
@end
