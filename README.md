# GithubClient
# 基于Fork的Git开发流程  
首先Fork一份GithubClient这个项目到自己的仓库。如图。  
![]( http://ooo.0o0.ooo/2016/05/02/57280a18607f9.png)  
你会发现，Fork之后，自己的仓库已经多了一个仓库。 
![](http://ooo.0o0.ooo/2016/05/02/57280a3e23e7a.png) 
然后clone一份到自己的本地。
最好不要使用SourceTree之类的图形化Git工具，学习使用Git命令，使用Terminal来操作。  

## 如何提交Pull Request？  
很简单，当你觉得代码可以提交之后，先提交到自己Fork的那个仓库。  
然后在仓库主页点击`New Pull Request`  
![](http://ooo.0o0.ooo/2016/05/02/57280a5e43805.png)  
这时候会出现这个页面。  
![](http://ooo.0o0.ooo/2016/05/02/57280a6b8a653.png)  
注意左边的base fork,请选择自己对应的分支，而不是提交到master分支。比如，如果是郑学海提交的pr，他应该选择zhengxuehai这个分支。  
![](http://ooo.0o0.ooo/2016/05/02/57280a7d37cc7.png)  
这样，我就可以看到你提交的pr，从而审核你的代码。  



## 简单叙述Github认证流程  
因为这个OAuth2认证可能略复杂。我也调了很久才调通。在这里简单叙述一下流程。  

### 第一步 
第一步当然是[Register Application](https://github.com/settings/applications/new)了。   
这里需要注意的是`Authorization callback URL`这个东西。  
这个东西是什么意思呢？  
就是当用户打开Safari，获取用户授权之后，需要回调，回调到哪呢？  
当然是回到我们自己的App对吧，所以这里需要填你自己App的URL Scheme。  

### 第二步  
注册完毕之后，我们获取了一个client_id和client_secret.
我们后面会需要他。  

接下来，是通过我们的程序打开Safari并且传递一个url来打开github的授权页面。  
那么，这个url是什么样的呢？  
这个url应该长这样。  
`https://github.com/login/oauth/authorize?
  client_id=...&
  scope=user,public_repo&redirect_uri=...`  
 
这个url附带了三个参数。  

* client_id  
* scope  
* redirect_uri  

第一个，我们注册之后就能获取到  
第二个，scope是什么意思？很简单，代表着你想要获取的权限，比如，`scope=user,public_repo`就代表，你想获取两个权限，第一个权限是后去某个用户的个人信息也即`user`,第二个权限想获取github上公开的仓库信息,也即`public_repo`.scope还有很多权限，具体内容看`https://developer.github.com/v3/oauth/`  

创建了正确的url了之后，这时候你就应该在你的app里打开safari了，当然，也可以自己创建一个wkwebview，不过不推荐这么做。  
想想，怎么在自己的app里打开safari并且传递这个网址？  
然后，怎么给自己的App创建一个URL scheme 从而使的safari可以成功回调会我们的app
最后，怎么获取safari回调之后的结果？
## 第三步  
获取Token。  
Token是什么？简单来说，Token就是在获取用户授权之后，github会给你一个凭证，以后你每发送一个请求之后，都需要在HttpRequest的HttpHeader里附带这个凭证，这个东西就是Token。  

那么如何获取Token呢？  
在完成第二步的时候，safari回掉到我们的App里。  
这时候我们需要在AppDelegate的`- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options`方法里解析url，这个url包含一个叫做code的东西。
需要发送一个Post请求，这个Post请求的baseUrl是这个`https://github.com/login/oauth/access_token`  
他需要附带三个参数。  
  
  * client_id
  * client_secret
  * code  
 
 前两个也是注册Application之后就有了。
 code是我们在第二步拿到的。  
 
 发送完post请求之后，就可以拿到我们想要的token了，这时候应该存在userdefault里。  
 这时候容易出现的一个错误是，unrecognize content type。 
 是因为你需要将`[_manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];`
 ## 第四步  
 以后没法送一个请求，都需要在request的http header里添加一个键值对。  
 `Authorization:token 你的token`   
 OC代码是类似于这样的。  
 ` NSString *authorization = [NSString stringWithFormat:@"%@ %@",@"token", token];
        [_manager.requestSerializer setValue:authorization forHTTPHeaderField:@"Authorization"];`


  



