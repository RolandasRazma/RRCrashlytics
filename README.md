RRCrashlytics
=============

Unofficial Crashlytics API

### How to get Developer Token:
This is a bit tricky. It is baked into the Crashlytics app itself... I'm disappointed... Still, what you can do is open /Crashlytics.app/Contents/MacOS/Crashlytics in vim and look for X-CRASHLYTICS-DEVELOPER-TOKEN. Hash between SUAutomaticallyInstall and X-CRASHLYTICS-DEVELOPER-TOKEN is developers token. Anyone want to write script to extract that? :)

### Usage
```objc
RRCrashlytics *crashlytics = [[RRCrashlytics alloc] init];
[crashlytics loginWithDeveloperToken: @"..."
                               email: @"..."
                            password: @"..."
                   completionHandler: ^(NSDictionary *session, NSError *error) {
                       if( error ){
                           NSLog(@"%@", error);
                           return;
                       }
                       
                       NSLog(@"Logged in, now you can do other calls");
                       
                       /*
                        [crashlytics organizationsWithCompletionHandler: ^(NSDictionary *organizations, NSError *error) {
                        NSLog(@"organizations: %@", organizations);
                        }];
                        */
                       
                       /*
                        [crashlytics appsForOrganizationID:@"..." completionHandler:^(NSDictionary *apps, NSError *error) {
                        NSLog(@"apps: %@", apps);
                        }];
                        */
                       
                       /*
                        [crashlytics dataForAppID:@"..." organizationID:@"..." completionHandler:^(NSDictionary *data, NSError *error) {
                        NSLog(@"app data: %@", data);
                        }];
                        */
                       
                       /*
                        [crashlytics issuesForAppID:@"..." organizationID:@"..." completionHandler:^(NSDictionary *issues, NSError *error) {
                        NSLog(@"issues: %@", issues);
                        }];
                        */
                   }];
```
