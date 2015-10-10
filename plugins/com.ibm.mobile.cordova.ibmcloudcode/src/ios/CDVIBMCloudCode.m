//-------------------------------------------------------------------------------
// Copyright 2014 IBM Corp. All Rights Reserved
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//-------------------------------------------------------------------------------

#import "CDVIBMCloudCode.h"

@interface CDVIBMCloudCode ()

@property (nonatomic) IBMCloudCode* cloudCode;

@end


@implementation CDVIBMCloudCode

- (void)initializeService:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* result = nil;
    
    [IBMCloudCode initializeService];
    result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK ];
    _cloudCode = [IBMCloudCode service];        
    
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void)setBaseUrl:(CDVInvokedUrlCommand*)command
{
    _cloudCode.baseUrl = [command.arguments objectAtIndex:0];
    CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void)get:(CDVInvokedUrlCommand*)command
{

    NSString* uri = [command.arguments objectAtIndex:0];
    
    NSMutableDictionary* headers = nil;
    
    if([command.arguments count] >1) {
        headers = [command.arguments objectAtIndex:1];
    }
    

    [[_cloudCode get:uri withHeaders:headers] continueWithBlock:^id(BFTask *task) {
        
        [self processTask:task forCommand:command];
        return nil;
        
    }];
}

- (void)post:(CDVInvokedUrlCommand*)command
{
    
    NSString* uri = [command.arguments objectAtIndex:0];
    
    NSMutableDictionary* headers = nil;
    
    if([command.arguments count] >1) {
        headers = [command.arguments objectAtIndex:1];
    }
    
    NSData *payload = [[NSMutableData alloc] init];
    
    if([command.arguments count] >2) {
        payload = [NSJSONSerialization dataWithJSONObject:[command.arguments objectAtIndex:2]
                                                  options:0
                                                    error:nil];
    }
    
    [[_cloudCode post:uri withDataPayload:payload withHeaders:headers] continueWithBlock:^id(BFTask *task) {
        
        [self processTask:task forCommand:command];
        return nil;
        
    }];
}

- (void)put:(CDVInvokedUrlCommand*)command
{
    
    NSString* uri = [command.arguments objectAtIndex:0];
    
    NSMutableDictionary* headers = nil;
    
    if([command.arguments count] >1) {
        headers = [command.arguments objectAtIndex:1];
    }
    
    NSData *payload = [[NSMutableData alloc] init];
    
    if([command.arguments count] >2) {
        payload = [NSJSONSerialization dataWithJSONObject:[command.arguments objectAtIndex:2]
                                                  options:0
                                                    error:nil];
    }
    
    [[_cloudCode put:uri withDataPayload:payload withHeaders:headers] continueWithBlock:^id(BFTask *task) {
        
        [self processTask:task forCommand:command];
        return nil;
        
    }];
}

- (void)delete:(CDVInvokedUrlCommand*)command
{
    
    NSString* uri = [command.arguments objectAtIndex:0];
    
    NSMutableDictionary* headers = nil;
    
    if([command.arguments count] >1) {
        headers = [command.arguments objectAtIndex:1];
    }
    
    
    [[_cloudCode delete:uri withHeaders:headers] continueWithBlock:^id(BFTask *task) {
        
        [self processTask:task forCommand:command];
        return nil;
        
    }];
}

-(void) processTask: (BFTask *) task forCommand: (CDVInvokedUrlCommand *) command
{
    
    CDVPluginResult* pluginResult = nil;
    
    if(task.error){


        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[[task error] debugDescription ]];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];

    } else{
        
        IBMHttpResponse *response = task.result;
        
        NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
        [result setObject:[NSNumber numberWithFloat:response.httpResponse.statusCode] forKey:@"code"];
        [result setObject:[NSString stringWithUTF8String:[[response responseData] bytes]] forKey:@"data"];
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:result];
        
    }
    
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

@end
