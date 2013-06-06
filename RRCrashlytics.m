//
//  RRCrashlytics.m
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

#import "RRCrashlytics.h"


NSString * const RRCrashlyticsErrorDomain = @"RRCrashlyticsErrorDomain";


@implementation RRCrashlytics {
    NSString    *_developerToken;
    NSString    *_accessToken;
}


#pragma mark -
#pragma mark NSObject


- (void)dealloc {
    [_developerToken release];
    [_accessToken release];
    
    [super dealloc];
}


#pragma mark -
#pragma mark RRCrashlytics


- (void)loginWithDeveloperToken:(NSString *)developerToken email:(NSString *)email password:(NSString *)password completionHandler:(void (^)(NSDictionary *session, NSError *error))completionHandler {
    [_developerToken release];
    _developerToken = [developerToken copy];

    email    = (NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)email, NULL, CFSTR("!*’();:@&=+$,/?%#[]"), kCFStringEncodingUTF8);
    password = (NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)password, NULL, CFSTR("!*’();:@&=+$,/?%#[]"), kCFStringEncodingUTF8);
    
    NSString *postBody = [NSString stringWithFormat:@"email=%@&password=%@", email, password];
    
    CFRelease(email);
    CFRelease(password);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: [NSURL URLWithString:@"https://api.crashlytics.com/api/v2/session.json"]];
    [request addValue:_developerToken forHTTPHeaderField:@"X-CRASHLYTICS-DEVELOPER-TOKEN"];
    [request setHTTPMethod:@"POST"];
    [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:[postBody dataUsingEncoding:NSUTF8StringEncoding]];

    [NSURLConnection sendAsynchronousRequest: request
                                       queue: [NSOperationQueue mainQueue]
                           completionHandler: ^(NSURLResponse *response, NSData *data, NSError *error) {
                               
                               if( error ){
                                   completionHandler(nil, error);
                                   return;
                               }
                               
                               NSError *serializationError = nil;
                               NSDictionary *responseData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments  error: &serializationError];
                               
                               if( serializationError ){
                                   completionHandler(nil, serializationError);
                                   return;
                               }

                               if( [responseData objectForKey:@"token"] ){
                                   [_accessToken release];
                                   _accessToken = [[responseData objectForKey:@"token"] copy];
                               }else{
                                   NSError *error = [NSError errorWithDomain: RRCrashlyticsErrorDomain
                                                                        code: 1
                                                                    userInfo: @{NSLocalizedDescriptionKey:@"Invalid toke/email/password"}];
                                   completionHandler(nil, error);
                                   return;
                               }

                               completionHandler(responseData, nil);
                           }];
    
}


- (void)organizationsWithCompletionHandler:(void (^)(NSDictionary *organizations, NSError *error))completionHandler {
    
    // Check if session is created
    if( !_developerToken || !_accessToken ){
        NSError *error = [NSError errorWithDomain: RRCrashlyticsErrorDomain
                                             code: 2
                                         userInfo: @{NSLocalizedDescriptionKey:@"Did you forgot to login?"}];
        completionHandler(nil, error);
        return;
    }
    
    // Pull data from server
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: [NSURL URLWithString:@"https://api.crashlytics.com/api/v2/session.json"]];
    [request addValue:_developerToken forHTTPHeaderField:@"X-CRASHLYTICS-DEVELOPER-TOKEN"];
    [request addValue:_accessToken forHTTPHeaderField:@"X-CRASHLYTICS-ACCESS-TOKEN"];

    [NSURLConnection sendAsynchronousRequest: request
                                       queue: [NSOperationQueue mainQueue]
                           completionHandler: ^(NSURLResponse *response, NSData *data, NSError *error) {
                               
                               if( error ){
                                   completionHandler(nil, error);
                                   return;
                               }
                               
                               NSError *serializationError = nil;
                               NSDictionary *responseData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments  error: &serializationError];
                               
                               if( serializationError ){
                                   completionHandler(nil, serializationError);
                                   return;
                               }

                               completionHandler(responseData, nil);
                           }];

}


- (void)appsForOrganizationID:(NSString *)organizationID completionHandler:(void (^)(NSDictionary *apps, NSError *error))completionHandler {
    
    // Check if session is created
    if( !_developerToken || !_accessToken ){
        NSError *error = [NSError errorWithDomain: RRCrashlyticsErrorDomain
                                             code: 2
                                         userInfo: @{NSLocalizedDescriptionKey:@"Did you forgot to login?"}];
        completionHandler(nil, error);
        return;
    }
    
    // Pull data from server
    NSString *urlString = [NSString stringWithFormat:@"https://api.crashlytics.com/api/v2/organizations/%@/apps.json", organizationID];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: [NSURL URLWithString:urlString]];
    [request addValue:_developerToken forHTTPHeaderField:@"X-CRASHLYTICS-DEVELOPER-TOKEN"];
    [request addValue:_accessToken forHTTPHeaderField:@"X-CRASHLYTICS-ACCESS-TOKEN"];
    
    [NSURLConnection sendAsynchronousRequest: request
                                       queue: [NSOperationQueue mainQueue]
                           completionHandler: ^(NSURLResponse *response, NSData *data, NSError *error) {
                               
                               if( error ){
                                   completionHandler(nil, error);
                                   return;
                               }
                               
                               NSError *serializationError = nil;
                               NSDictionary *responseData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments  error: &serializationError];
                               
                               if( serializationError ){
                                   completionHandler(nil, serializationError);
                                   return;
                               }
                               
                               completionHandler(responseData, nil);
                           }];
    
}


- (void)dataForAppID:(NSString *)appID organizationID:(NSString *)organizationID completionHandler:(void (^)(NSDictionary *data, NSError *error))completionHandler {
    
    // Check if session is created
    if( !_developerToken || !_accessToken ){
        NSError *error = [NSError errorWithDomain: RRCrashlyticsErrorDomain
                                             code: 2
                                         userInfo: @{NSLocalizedDescriptionKey:@"Did you forgot to login?"}];
        completionHandler(nil, error);
        return;
    }
    
    // Pull data from server
    NSString *urlString = [NSString stringWithFormat:@"https://api.crashlytics.com/api/v2/organizations/%@/apps/%@.json", organizationID, appID];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: [NSURL URLWithString:urlString]];
    [request addValue:_developerToken forHTTPHeaderField:@"X-CRASHLYTICS-DEVELOPER-TOKEN"];
    [request addValue:_accessToken forHTTPHeaderField:@"X-CRASHLYTICS-ACCESS-TOKEN"];
    
    [NSURLConnection sendAsynchronousRequest: request
                                       queue: [NSOperationQueue mainQueue]
                           completionHandler: ^(NSURLResponse *response, NSData *data, NSError *error) {
                               
                               if( error ){
                                   completionHandler(nil, error);
                                   return;
                               }
                               
                               NSError *serializationError = nil;
                               NSDictionary *responseData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments  error: &serializationError];
                               
                               if( serializationError ){
                                   completionHandler(nil, serializationError);
                                   return;
                               }
                               
                               completionHandler(responseData, nil);
                           }];

}


- (void)issuesForAppID:(NSString *)appID organizationID:(NSString *)organizationID completionHandler:(void (^)(NSDictionary *issues, NSError *error))completionHandler {
    
    // Check if session is created
    if( !_developerToken || !_accessToken ){
        NSError *error = [NSError errorWithDomain: RRCrashlyticsErrorDomain
                                             code: 2
                                         userInfo: @{NSLocalizedDescriptionKey:@"Did you forgot to login?"}];
        completionHandler(nil, error);
        return;
    }
    
    // Pull data from server
    NSString *urlString = [NSString stringWithFormat:@"https://api.crashlytics.com/api/v2/organizations/%@/apps/%@/issues.json", organizationID, appID];

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: [NSURL URLWithString:urlString]];
    [request addValue:_developerToken forHTTPHeaderField:@"X-CRASHLYTICS-DEVELOPER-TOKEN"];
    [request addValue:_accessToken forHTTPHeaderField:@"X-CRASHLYTICS-ACCESS-TOKEN"];
    
    [NSURLConnection sendAsynchronousRequest: request
                                       queue: [NSOperationQueue mainQueue]
                           completionHandler: ^(NSURLResponse *response, NSData *data, NSError *error) {
                               
                               if( error ){
                                   completionHandler(nil, error);
                                   return;
                               }
                               
                               NSError *serializationError = nil;
                               NSDictionary *responseData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments  error: &serializationError];
                               
                               if( serializationError ){
                                   completionHandler(nil, serializationError);
                                   return;
                               }
                               
                               completionHandler(responseData, nil);
                           }];
}


@end
