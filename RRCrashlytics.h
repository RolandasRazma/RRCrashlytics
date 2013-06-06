//
//  RRCrashlytics.h
//
//  Created by Rolandas Razma.
//  Copyright 2013 Rolandas Razma. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//

#import <Foundation/Foundation.h>


NSString * const RRCrashlyticsErrorDomain;


@interface RRCrashlytics : NSObject

- (void)loginWithDeveloperToken:(NSString *)developerToken email:(NSString *)email password:(NSString *)password completionHandler:(void (^)(NSDictionary *session, NSError *error))completionHandler;
- (void)organizationsWithCompletionHandler:(void (^)(NSDictionary *organizations, NSError *error))completionHandler;
- (void)appsForOrganizationID:(NSString *)organizationID completionHandler:(void (^)(NSDictionary *apps, NSError *error))completionHandler;
- (void)dataForAppID:(NSString *)appID organizationID:(NSString *)organizationID completionHandler:(void (^)(NSDictionary *data, NSError *error))completionHandler;
- (void)issuesForAppID:(NSString *)appID organizationID:(NSString *)organizationID completionHandler:(void (^)(NSDictionary *issues, NSError *error))completionHandler;

@end
