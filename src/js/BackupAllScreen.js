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

// Backup All Apps screen

@class _BackupAllScreen : UIActionSheet {}
 // What to do when a table row is selected
 - init {
  return [super init];
 }
@end
_BackupAllScreen.prototype.setup = function(gui) {
 if (this) {
  this.gui = gui;
  [this setTitle:_("all_apps")];
  [this setDelegate:[new BackupAllScreenDelegate init].setup(gui)];
  [this addButtonWithTitle:_("backup")];
  if (gui.appbackup.any_backed_up) {
   var prompt = _("backup_restore_all_apps");
   [this addButtonWithTitle:_("restore")];
   [this addButtonWithTitle:_("delete")];
  } else var prompt = _("backup_all_apps");
  [this setBodyText:prompt];
  [this setCancelButtonIndex:[this addButtonWithTitle:_("cancel")]];
 }
 return this;
}

@class _BackupAllScreenDelegate : NSObject <UIActionSheetDelegate> {}
 // What to do when you close the backup all apps prompt
 - actionSheet:sheet didDismissWithButtonIndex:index {
  var button_text = [sheet buttonTitleAtIndex:index];
  if (button_text == _("cancel") || button_text == _("ok")) return;
  self.modal = [new UIModalView init];
  [self.modal setTitle:_("please_wait")];
  for (i in ["backup", "delete", "ignore", "restore", "unignore"]) {
   if (button_text == _(i)) {
    self.action = i;
    break;
   }
  }
  self.str_prefix = "all_status_" + self.action + "_";
  var text = _(self.string_prefix + "doing");
  [self.modal setBodyText:text];
  [self.modal popupAlertAnimated:true];
  self.do_action(action);
 }
@end
_BackupAllScreenDelegate.prototype.setup = function(gui) {
 if (this) this.gui = gui;
 return this
}
_BackupAllScreenDelegate.prototype.do_action = function(app) {
 var done_title           = _(action + "done");
 var partially_done_title = _(action + "partially_done");
 var done_text            = _(this.str_prefix + "done");
 var failed_title         = _(action + "failed");
 var failed_text          = _(this.str_prefix + "failed");
 var corrupted_text       = _(this.str_prefix + "corrupted");
 var results_box          = true;
 var r = this.gui.appbackup.do_action(action);
 this.gui.update_app_list();
 if (r.success) {
  var title = done_title;
  var text  = done_text;
  //if (action == "ignore" || action == "unignore")
  // resutls_box = false;
 } else {
  // TODO: fix this to adjust to all apps failing or apps being unuseable
  // (requires changes in the CLI but it's 1:30 AM and I don't want to do it
  //  right now so instead I'm writing this silly TODO comment)
  var title = partially_done_title;
  var text  = failed_text + "\n\n" + r.data;
 }
 [this.modal dismiss];
 if (results_box) {
  this.alert = [new UIAlertView init];
  [this.alert setTitle:title];
  [this.alert setBodyText:text];
  [this.alert addButtonWithTitle:_("ok")];
  [this.alert show];
 }
}

var BackupAllScreen = _BackupAllScreen;