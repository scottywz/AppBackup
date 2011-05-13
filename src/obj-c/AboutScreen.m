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

// About screen

#import "util.h";
#import "AppBackupGUI.h";

@implementation AboutScreen
@synthesize gui;
- (id)initWithGUI:(AppBackupGUI *)gui_ {
 self = [super init];
 if (self) {
  self.gui = gui_;
  self.title = [NSString stringWithFormat:_(@"about_title"), gui.app_name];
  self.delegate = self;
  self.body_text = [NSString stringWithContentsOfFile:gui.about_file
                    encoding:NSUTF8StringEncoding error:nil];
  [self addButtonWithTitle:_(@"web_site")];
  [self setCancelButtonIndex:[self addButtonWithTitle:_(@"ok")]];
 }
 return self;
}

- (void)actionSheet:(UIActionSheet *)sheet
        didDismissWithButtonIndex:(NSInteger)index {
 NSString *action = [sheet buttonTitleAtIndex:index];
 if ([action isEqualToString:_(@"web_site")]) {
  url = [NSURL URLWithString:gui.app_web_site];
  [[UIApplication sharedApplication] openURL:url];
 }
}

- (void)dealloc {
 self.gui = nil;
 [super dealloc];
}
@end
