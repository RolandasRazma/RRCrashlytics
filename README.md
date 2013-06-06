RRCrashlytics
=============

Unofficial [Crashlytics](https://www.crashlytics.com/) API

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

I don't have blog so...
============
I had some thoughts how I could use Crashlytics data if only I could access them without server side. So I asked Crashlytics support if there is one. Unfortunately there is no at the moment so I thought that it should be easy to extract calls from app itself. And sure enough - it was. First I dumped headers from the app to see if there will be something interesting. From there I find out that they are using `NSURLConnection`. I tried to sniff traffic but it was SSL'ed. Then I tried to `DYLD_INSERT_LIBRARIES` for custom `free`, but for some reason Crashlytics app was crashing and I couldn't get any useful info… Then I decided to swizzle NSURLConnection methods because they definitely have private API calls. To inject my code into Crashlytics.app and swizzle methods on `NSURLConnection`  I wrote custom `SIMBL` plugin…
