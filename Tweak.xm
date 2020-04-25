@interface FBSystemService : NSObject
  +(id)sharedInstance;
  -(void)exitAndRelaunch:(BOOL)arg1;
@end

static BOOL IsEnabled = YES;
static int HomeBarWidth = 134;
static int HomeBarHeight = 5;
static int HomeBarRadius = 3;

// %hook MTLumaDodgePillView
// //134
// //5
// +(CGSize)suggestedSizeForContentWidth:(double)arg1
// {
//   if (IsEnabled)
//   {
//     CGSize Tmp = CGSizeMake(HomeBarWidth,HomeBarHeight);
//     return Tmp;
//   }
//   else
//   {
//     return %orig;
//   }
//
// 	// NSString *msg = [NSString stringWithFormat:@"arg1 - %f ", arg1];
// 	// UIAlertView *lookWhatWorks = [[UIAlertView alloc] initWithTitle:@"suggestedSizeForContentWidth"
// 	// 	message:msg
// 	// 	delegate:self
// 	// 	cancelButtonTitle:@"OK"
// 	// 	otherButtonTitles:nil];
// 	// [lookWhatWorks show];
// }
//
// %end

%hook MTLumaDodgePillSettings

  -(void)setMinWidth:(double)arg1
  {
    if (IsEnabled)
    {
      arg1 = (int)HomeBarWidth;
    }
    %orig;
  }

  -(double)minWidth
  {
    if (IsEnabled)
      return (int)HomeBarWidth;
    else
      return %orig;
  }

  -(void)setMaxWidth:(double)arg1
  {
    if (IsEnabled)
    {
      arg1 = (int)HomeBarWidth;
    }
    %orig;
  }

  -(double)maxWidth
  {
    if (IsEnabled)
      return (int)HomeBarWidth;
    else
      return %orig;
  }

  -(void)setHeight:(double)arg1
  {
    if (IsEnabled)
    {
      arg1 = (int)HomeBarHeight;
    }
    %orig;
  }

  -(double)height
  {
    if (IsEnabled)
      return (int)HomeBarHeight;
    else
      return %orig;
  }

  -(void)setCornerRadius:(double)arg1
  {
    if (IsEnabled)
    {
      arg1 = (int)HomeBarRadius;
    }
    %orig;
  }

  -(double)cornerRadius
  {
    if (IsEnabled)
      return (int)HomeBarRadius;
    else
      return %orig;
  }

  -(void)setCornerMask:(long long)arg1
  {
    if (IsEnabled)
    {
      arg1 = (int)HomeBarRadius;
    }
    %orig;
  }

  -(long long)cornerMask
  {
    if (IsEnabled)
      return (int)HomeBarRadius;
    else
      return %orig;
  }
%end

static void reloadSettings() {
  static CFStringRef HomeBarSizerPrefsKey = CFSTR("com.imkpatil.homebarsizer");
  CFPreferencesAppSynchronize(HomeBarSizerPrefsKey);

  if (CFBridgingRelease(CFPreferencesCopyAppValue((CFStringRef)@"TwkEnabled", HomeBarSizerPrefsKey))) {
    IsEnabled = [(id)CFPreferencesCopyAppValue((CFStringRef)@"TwkEnabled", HomeBarSizerPrefsKey) boolValue];
  }

  if (CFBridgingRelease(CFPreferencesCopyAppValue((CFStringRef)@"BarWidth", HomeBarSizerPrefsKey))) {
    HomeBarWidth = [(id)CFPreferencesCopyAppValue((CFStringRef)@"BarWidth", HomeBarSizerPrefsKey) intValue];
  }

  if (CFBridgingRelease(CFPreferencesCopyAppValue((CFStringRef)@"BarHeight", HomeBarSizerPrefsKey))) {
    HomeBarHeight = [(id)CFPreferencesCopyAppValue((CFStringRef)@"BarHeight", HomeBarSizerPrefsKey) intValue];
  }

  if (CFBridgingRelease(CFPreferencesCopyAppValue((CFStringRef)@"BarRadius", HomeBarSizerPrefsKey))) {
    HomeBarRadius = [(id)CFPreferencesCopyAppValue((CFStringRef)@"BarRadius", HomeBarSizerPrefsKey) intValue];
  }

}

static void respring(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
  [[%c(FBSystemService) sharedInstance] exitAndRelaunch:YES];
}

%ctor {
  CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)reloadSettings, CFSTR("com.imkpatil.homebarsizer.settingschanged"), NULL, CFNotificationSuspensionBehaviorCoalesce);
  CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, respring, CFSTR("com.imkpatil.homebarsizer.respring"), NULL, CFNotificationSuspensionBehaviorCoalesce);
  reloadSettings();
}
