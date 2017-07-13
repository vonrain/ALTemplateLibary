//
//  ALHelper.m
//  ALTemplateLibary
//
//  Created by allen on 7/13/17.
//  Copyright © 2017 allen. All rights reserved.
//

#import "ALHelper.h"

@implementation ALHelper
+ (id)getJsonDataJsonname:(NSString *)jsonname
{
    NSString *path = [[NSBundle mainBundle] pathForResource:jsonname ofType:@""];
    NSData *jsonData = [[NSData alloc] initWithContentsOfFile:path];
    if(jsonData == nil) return nil;
    
    NSError *error;
    id jsonObj = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    if (!jsonData || error) {
        return nil;
    } else {
        return jsonObj;
    }
}
@end
