//
//  KNDocumentRouter.m
//  document
//
//  Created by liu xiao on 17/4/20.
//  Copyright © 2017年 liu. All rights reserved.
//

#import "KNDocumentRouter.h"

@implementation KNDocumentRouter
//+(NSArray *)traversalDocumentPath:(NSString *)dirName
//{
//    // 获得此程序的沙盒路径
//    NSArray *patchs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    
//    // 获取Documents路径
//    // [patchs objectAtIndex:0]
//    NSString *documentsDirectory = [patchs objectAtIndex:0];
//    NSString *fileDirectory = [documentsDirectory stringByAppendingPathComponent:dirName];
//    
//    NSArray *files = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:fileDirectory error:nil];
//    return files;
//
//}

+(NSArray *)traversalDocumentPath:(NSString *)dirName
{
    NSMutableArray *childPaths = [NSMutableArray array];
    NSArray *subpaths = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:dirName error:NULL];
    for (NSString *subpath in subpaths) {
        [childPaths addObject:[dirName stringByAppendingPathComponent:subpath]];
    }
    return childPaths;
}

//+ (NSMutableArray *)SeachAttachFileInDocumentDirctory{
//    
//   }
@end
