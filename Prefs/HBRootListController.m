#include "HBRootListController.h"

//#define ezswipepath @"/User/Library/Preferences/com.imkpatil.ezswipe.plist"

@implementation HBRootListController

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"HomeBarSizer" target:self] retain];
	}

	return _specifiers;
}

- (void)respring {
		CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), CFSTR("com.imkpatil.homebarsizer.respring"), NULL, NULL, YES);
}

@end
