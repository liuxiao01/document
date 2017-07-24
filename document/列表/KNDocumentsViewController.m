//
//  KNDocumentsViewController.m
//  document
//
//  Created by liu xiao on 17/4/20.
//  Copyright © 2017年 liu. All rights reserved.
//

#import "KNDocumentsViewController.h"
#import "KNDocumentRouter.h"
#import "AFNetworking.h"
@interface KNDocumentsViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSArray * pathArray;

@end

@implementation KNDocumentsViewController
-(id)init
{
    self = [super init];
    if(self)
    {
        self.path = NSHomeDirectory();
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    self.pathArray = [KNDocumentRouter traversalDocumentPath:self.path];
    [self.tableView reloadData];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UITableView *)tableView
{
    if(!_tableView)
    {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, [UIScreen mainScreen].bounds.size.height - 64) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}



#pragma mark -tableview 代理 回调
-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  self.pathArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cellId";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];

    if(!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    NSString * str =self.pathArray[indexPath.row];
    NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:str error:NULL];
    NSLog(@"%@",attributes);
    str = [str lastPathComponent];
    //是否是文件夹
    NSString *fileType = attributes[@"NSFileType"];
    if([fileType isEqualToString:NSFileTypeDirectory])
    {
        //文件夹
        cell.textLabel.text = [NSString stringWithFormat:@"📁%@",str];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
    }
    else
    {
         cell.textLabel.text = [NSString stringWithFormat:@"📃%@",str];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }

//    NSLog(@"%@", str);
//
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * str =self.pathArray[indexPath.row];
    NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:str error:NULL];
    str = [str lastPathComponent];
    //是否是文件夹
    NSString *fileType = attributes[@"NSFileType"];
    if([fileType isEqualToString:NSFileTypeDirectory])
    {
        //文件夹
        KNDocumentsViewController * vc = [[KNDocumentsViewController alloc]init];
        vc.path = [NSString stringWithFormat:@"%@",self.pathArray[indexPath.row]];
        vc.title = [NSString stringWithFormat:@"📁%@",str];
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    else
    {
        //上传文件
        [self uploadFile:[NSString stringWithFormat:@"%@",self.pathArray[indexPath.row]]];
    }

}



- (void)uploadFile:(NSString *)path{
    /*
     此段代码如果需要修改，可以调整的位置
     1. 把upload.php改成网站开发人员告知的地址
     2. 把file改成网站开发人员告知的字段名
     */
    
    //AFN3.0+基于封住HTPPSession的句柄
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSDictionary *dict = @{@"username":@"Saup",@"fileName":@"fileName",@"deviceid":@"12345678",@"packageid":@"dddddddd"};
    
    //formData: 专门用于拼接需要上传的数据,在此位置生成一个要上传的数据体
    [manager POST:@"http://eigqa.58corp.com/upload/upload4" parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
       
        NSData *data = [NSData dataWithContentsOfFile:path];
        
        
        // 在网络开发中，上传文件时，是文件不允许被覆盖，文件重名
        // 要解决此问题，
        // 可以在上传时使用当前的系统事件作为文件名
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        // 设置时间格式
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.zip", str];
        
        //上传
        /*
         此方法参数
         1. 要上传的[二进制数据]
         2. 对应网站上[upload.php中]处理文件的[字段"file"]
         3. 要保存在服务器上的[文件名]
         4. 上传文件的[mimeType]
         */
        [formData appendPartWithFileData:data name:@"file" fileName:@"document.zip" mimeType:@"application/zip"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        //上传进度
        // @property int64_t totalUnitCount;     需要下载文件的总大小
        // @property int64_t completedUnitCount; 当前已经下载的大小
        //
        // 给Progress添加监听 KVO
        NSLog(@"%f",1.0 * uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
        // 回到主队列刷新UI,用户自定义的进度条
        dispatch_async(dispatch_get_main_queue(), ^{
            //            self.progressView.progress = 1.0 *
            //            uploadProgress.completedUnitCount / uploadProgress.totalUnitCount;
        });
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"上传成功 %@", responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"上传失败 %@", error);
    }];
    
}
@end
