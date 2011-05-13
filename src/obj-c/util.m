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

// Utility functions

NSString *_(NSString *s) {
 return NSLocalizedString(s, @"");
}
NSString *bundled_file_path(NSString *path) {
 return [[NSBundle.mainBundle bundlePath] stringByAppendingPathComponent:path];
}
NSString *localize_date(NSString *date) {
 if (![date length]) return @"";
 NSDateFormatter *iso_8601_formatter = [[NSDateFormatter alloc] init];
 [iso_8601_formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
 NSDate *nsdate = [iso_8601_formatter dateFromString:date];
 [iso_8601_formatter release];
 NSString *out = [NSDateFormatter localizedStringFromDate:nsdate
                  dateStyle:NSDateFormatterMediumStyle
                  timeStyle:NSDateFormatterShortStyle];
 if (out == nil || ![out.length]) {
  var generic_formatter = [new NSDateFormatter init];
  [generic_formatter setDateFormat:@"MMM d, yyyy h:mm a"];
  out = [generic_formatter stringFromDate:nsdate];
  [generic_formatter release];
  if (out == nil) out = date;
 }
 return out;
}