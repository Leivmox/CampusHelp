# 校园IT互助系统 - 功能描述文档

## 一、用户功能模块

---

### 1. 用户认证功能

#### 1.1 用户注册

在注册页面填写学号、密码及学校信息后点击注册按钮，系统会调用UserController类的save()方法，该方法必须传入学号、密码和学校ID作为必要参数。系统首先调用UserService类的getOne()方法查询学号是否已被注册，若学号唯一则调用UserService类的save()方法创建用户账户，同时设置初始积分为100分。用户注册界面如图x所示。

**伪代码：**
```
FUNCTION 用户注册(学号, 密码, 学校ID)
    // 参数非空校验
    IF 学号、密码、学校ID存在空值 THEN
        RETURN 注册失败：信息不完整
    END IF

    // 校验学号是否重复
    existingUser = 查询用户(学号, 学校ID)
    IF existingUser 已存在 THEN
        RETURN 注册失败：学号已被注册
    END IF

    // 密码加密并创建用户
    加密密码 = MD5(密码)
    用户信息 = 构造用户(学号, 加密密码, 学校ID, 初始积分=100)
    插入用户数据至数据库

    RETURN 注册成功
END FUNCTION
```

---

#### 1.2 用户登录

在登录页面输入学号、密码及选择学校后点击登录按钮，系统会调用UserController类的login()方法，该方法必须传入学号、密码和学校ID作为参数。系统调用UserService类的getOne()方法查询用户信息，校验账号密码正确性及账户状态后，将用户信息存入Session并返回登录结果。用户登录界面如图x所示。

**伪代码：**
```
FUNCTION 用户登录(学号, 密码, 学校ID)
    // 查询用户信息
    加密密码 = MD5(密码)
    用户 = 查询用户(学号, 加密密码, 学校ID)

    // 校验用户存在性与账户状态
    IF 用户不存在 THEN
        RETURN 登录失败：账号或密码错误
    END IF
    IF 用户.状态 = 禁用 THEN
        RETURN 登录失败：账户已被冻结
    END IF

    // 建立会话并返回用户信息
    Session存储(用户信息)
    RETURN 登录成功，返回用户信息
END FUNCTION
```

---

### 2. 校园圈子功能

#### 2.1 发布帖子

在首页点击"发布论坛"按钮后，系统会调用PostController类的save()方法，该方法必须传入用户ID、学校ID、标题、内容作为必要参数，图片列表作为可选参数。系统调用PostService类的save()方法将帖子数据存储至数据库，发布成功后跳转至帖子列表页面。帖子发布界面如图x所示。

**伪代码：**
```
FUNCTION 发布帖子(用户ID, 学校ID, 标题, 内容, 图片列表)
    // 参数校验
    IF 标题或内容为空 THEN
        RETURN 发布失败：标题和内容不能为空
    END IF

    // 构造帖子对象
    图片URL = 图片列表拼接为字符串
    帖子信息 = 构造帖子(用户ID, 学校ID, 标题, 内容, 图片URL, 当前时间)

    // 存储帖子数据
    插入帖子数据至数据库

    RETURN 发布成功
END FUNCTION
```

---

#### 2.2 浏览帖子列表

在校园圈子页面，系统会调用PostController类的list()方法，该方法必须传入学校ID和用户ID作为参数，可选传入排序方式。系统调用PostMapper类的selectPostListWithLike()方法查询帖子列表及点赞状态，并调用CommentMapper类统计每篇帖子的评论数量。帖子列表页面布局如图x所示。

**伪代码：**
```
FUNCTION 获取帖子列表(学校ID, 用户ID, 排序方式)
    // 查询帖子及点赞状态
    帖子列表 = 查询帖子关联点赞记录(学校ID, 用户ID)

    // 填充帖子关联信息
    FOR EACH 帖子 IN 帖子列表
        帖子.发布者信息 = 查询用户(帖子.用户ID)
        帖子.评论列表 = 查询评论(帖子.ID)
        帖子.评论数 = 统计评论数量(帖子.ID)
    END FOR

    // 按指定方式排序
    帖子列表 = 排序(帖子列表, 排序方式)

    RETURN 帖子列表
END FUNCTION
```

---

#### 2.3 点赞帖子

当用户点击帖子下方的点赞按钮时，系统会调用UserLikeController类的toggleLike()方法，该方法传入用户ID、目标ID和目标类型(帖子为1)。系统调用UserLikeService类的save()或remove()方法切换点赞状态，同时调用PostService类更新帖子的点赞计数。点赞操作流程如图x所示。

**伪代码：**
```
FUNCTION 点赞操作(用户ID, 帖子ID)
    // 查询点赞记录
    点赞记录 = 查询点赞(用户ID, 帖子ID, 类型=帖子)

    // 切换点赞状态
    IF 点赞记录已存在 THEN
        删除点赞记录
        帖子.点赞数 = 帖子.点赞数 - 1
    ELSE
        创建点赞记录(用户ID, 帖子ID, 类型=帖子)
        帖子.点赞数 = 帖子.点赞数 + 1
    END IF

    更新帖子点赞数至数据库

    RETURN 操作成功
END FUNCTION
```

---

### 3. 求助中心功能

#### 3.1 发布求助

在求助中心页面点击"发布求助"按钮后，系统会调用TaskController类的save()方法，该方法必须传入用户ID、标题、内容和悬赏积分作为参数。系统首先调用UserService类的getById()方法查询用户积分余额，若积分充足则调用TaskService类的save()方法创建求助记录，同时调用UserService类的updateById()方法扣除悬赏积分。求助发布界面如图x所示。

**伪代码：**
```
FUNCTION 发布求助(用户ID, 标题, 内容, 悬赏积分)
    // 校验用户积分余额
    用户 = 查询用户(用户ID)
    IF 用户.积分 < 悬赏积分 THEN
        RETURN 发布失败：积分不足
    END IF

    // 扣除悬赏积分
    用户.积分 = 用户.积分 - 悬赏积分
    更新用户积分至数据库

    // 创建求助记录
    求助信息 = 构造求助(用户ID, 标题, 内容, 悬赏积分, 状态=待接取)
    插入求数据至数据库

    RETURN 发布成功
END FUNCTION
```

---

#### 3.2 接受求助

在求助广场页面点击"接受求助"按钮后，系统会调用TaskController类的accept()方法，该方法必须传入求助ID和接单用户ID作为参数。系统调用TaskService类的getById()方法查询求助详情，校验求助状态为待接取且发布者非本人后，调用TaskService类的updateById()方法更新求助状态为互助中并关联接单用户。求助接单流程如图x所示。

**伪代码：**
```
FUNCTION 接受求助(求助ID, 接单用户ID)
    // 查询求助信息
    求助 = 查询求助(求助ID)

    // 校验接单条件
    IF 求助.状态 != 待接取 THEN
        RETURN 接单失败：该求助已被接单或已完成
    END IF
    IF 求助.发布者ID = 接单用户ID THEN
        RETURN 接单失败：不能接自己发布的求助
    END IF

    // 更新求助状态
    求助.接单用户ID = 接单用户ID
    求助.状态 = 互助中
    更新求数据至数据库

    RETURN 接单成功
END FUNCTION
```

---

#### 3.3 完成求助

当求助完成后，发布者点击"确认完成"按钮，系统会调用TaskController类的complete()方法，该方法必须传入求助ID和发布者ID作为参数。系统校验操作权限后，调用UserService类的updateById()方法将悬赏积分转给帮助者，同时调用TaskService类的updateById()方法更新求助状态为已完成。求助完成界面如图x所示。

**伪代码：**
```
FUNCTION 完成求助(求助ID, 发布者ID)
    // 查询求助信息
    求助 = 查询求助(求助ID)

    // 校验操作权限
    IF 求助.发布者ID != 发布者ID THEN
        RETURN 操作失败：无权确认完成
    END IF

    // 积分转账并更新状态
    帮助者 = 查询用户(求助.接单用户ID)
    帮助者.积分 = 帮助者.积分 + 求助.悬赏积分
    更新用户积分至数据库

    求助.状态 = 已完成
    更新求数据至数据库

    RETURN 完成成功
END FUNCTION
```

---

### 4. 消息中心功能

#### 4.1 发送私信

在聊天页面输入消息后点击发送按钮，系统会调用ChatController类的send()方法，该方法必须传入发送者ID、接收者ID、内容和消息类型作为参数。系统调用ChatMessageService类的save()方法将消息存储至数据库，消息支持文字、图片、表情三种类型。聊天对话界面如图x所示。

**伪代码：**
```
FUNCTION 发送消息(发送者ID, 接收者ID, 内容, 消息类型)
    // 参数校验
    IF 内容为空 THEN
        RETURN 发送失败：消息内容不能为空
    END IF

    // 创建消息记录
    消息信息 = 构造消息(发送者ID, 接收者ID, 内容, 消息类型, 当前时间)
    插入消息数据至数据库

    // 推送通知
    推送消息通知(接收者ID)

    RETURN 发送成功
END FUNCTION
```

---

#### 4.2 获取聊天记录

在消息中心点击联系人进入聊天页面时，系统会调用ChatController类的history()方法，该方法必须传入用户ID和对方用户ID作为参数。系统调用ChatMessageMapper类的selectChatHistory()方法查询双向消息记录，同时调用ChatMessageService类的markAsRead()方法将对方发送的消息标记为已读。聊天记录页面如图x所示。

**伪代码：**
```
FUNCTION 获取聊天记录(用户ID, 对方用户ID)
    // 查询双向消息记录
    消息列表 = 查询消息(
        发送者ID = 用户ID AND 接收者ID = 对方用户ID
        OR
        发送者ID = 对方用户ID AND 接收者ID = 用户ID
    )

    // 标记消息已读
    更新消息状态(发送者ID = 对方用户ID, 接收者ID = 用户ID, 已读 = 是)

    RETURN 消息列表
END FUNCTION
```

---

### 5. 评价功能

#### 5.1 提交评价

在求助完成后，用户可点击"评价"按钮，系统会调用RemarkController类的save()方法，该方法必须传入评价者ID、被评价者ID、求助ID、星级和评价内容作为参数。系统调用RemarkService类的save()方法将评价信息存储至数据库，评价记录关联至对应的求助记录。评价提交界面如图x所示。

**伪代码：**
```
FUNCTION 提交评价(评价者ID, 被评价者ID, 求助ID, 星级, 评价内容)
    // 校验是否已评价
    已有评价 = 查询评价(评价者ID, 求助ID)
    IF 已有评价存在 THEN
        RETURN 评价失败：该求助已评价
    END IF

    // 创建评价记录
    评价信息 = 构造评价(评价者ID, 被评价者ID, 求助ID, 星级, 评价内容)
    插入评价数据至数据库

    RETURN 评价成功
END FUNCTION
```

---

### 6. AI助手功能

#### 6.1 智能问答

在AI助手页面输入问题后，系统会调用AiController类的chat()方法，该方法必须传入用户问题作为参数。系统构建包含平台功能介绍、页面导航说明、常见问题FAQ的系统提示词，调用ChatService类的callAiApi()方法请求大语言模型API，返回智能回答内容。AI助手对话界面如图x所示。

**伪代码：**
```
FUNCTION AI智能问答(用户问题)
    // 构建系统提示词
    系统提示词 = 拼接(平台功能介绍, 页面导航说明, 常见问题FAQ)

    // 构建消息列表
    消息列表 = [
        {角色: 系统, 内容: 系统提示词},
        {角色: 用户, 内容: 用户问题}
    ]

    // 调用AI模型API
    AI响应 = HTTP请求(AI接口地址, 模型参数, 消息列表)

    RETURN AI响应内容
END FUNCTION
```

---

## 二、管理员功能模块

---

### 1. 数据统计功能

#### 1.1 获取统计数据

管理员登录后进入首页，系统会调用AdminStatsController类的getStats()方法，该方法无需传入参数。系统调用UserService、PostService、TaskService、RemarkService类的count()方法分别统计用户总数、帖子总数、求助总数、评价总数，同时统计今日新增数据。数据统计页面如图x所示。

**伪代码：**
```
FUNCTION 获取统计数据()
    // 统计基础数据
    用户总数 = 统计用户数量()
    帖子总数 = 统计帖子数量()
    求助总数 = 统计求数量()
    评价总数 = 统计评价数量()

    // 统计今日新增
    今日新增用户 = 统计今日注册用户()
    今日新增帖子 = 统计今日发布帖子()

    RETURN 统计结果集
END FUNCTION
```

---

### 2. 用户管理功能

#### 2.1 查询用户列表

在用户管理页面，系统会调用StudentController类的list()方法，该方法可选传入搜索关键词作为参数。系统调用UserService类的list()方法查询用户列表，若传入搜索关键词则按学号或姓名模糊匹配，同时调用SchoolService、DeptService、ClassService类填充用户的学校、院系、班级信息。用户列表页面如图x所示。

**伪代码：**
```
FUNCTION 查询用户列表(搜索关键词)
    // 构建查询条件
    IF 搜索关键词不为空 THEN
        用户列表 = 查询用户(学号 LIKE 关键词 OR 姓名 LIKE 关键词)
    ELSE
        用户列表 = 查询全部用户()
    END IF

    // 填充关联信息
    FOR EACH 用户 IN 用户列表
        用户.学校 = 查询学校(用户.学校ID)
        用户.院系 = 查询院系(用户.院系ID)
        用户.班级 = 查询班级(用户.班级ID)
    END FOR

    RETURN 用户列表
END FUNCTION
```

---

#### 2.2 编辑用户信息

管理员点击"编辑"按钮后，系统会调用StudentController类的update()方法，该方法必须传入用户ID和更新数据作为参数。系统调用UserService类的getById()方法查询用户信息，校验用户存在后调用UserService类的updateById()方法更新用户字段并保存至数据库。用户编辑界面如图x所示。

**伪代码：**
```
FUNCTION 编辑用户(用户ID, 更新数据)
    // 查询用户信息
    用户 = 查询用户(用户ID)
    IF 用户不存在 THEN
        RETURN 编辑失败：用户不存在
    END IF

    // 更新用户字段
    用户.学号 = 更新数据.学号
    用户.姓名 = 更新数据.姓名
    用户.手机号 = 更新数据.手机号
    用户.积分 = 更新数据.积分

    更新用户数据至数据库

    RETURN 编辑成功
END FUNCTION
```

---

#### 2.3 禁用/启用用户

管理员点击"禁用/启用"按钮后，系统会调用StudentController类的toggleState()方法，该方法必须传入用户ID作为参数。系统调用UserService类的getById()方法查询用户当前状态，调用UserService类的updateById()方法切换用户状态(正常与禁用互转)。禁用后的用户无法登录系统。用户状态管理界面如图x所示。

**伪代码：**
```
FUNCTION 切换用户状态(用户ID)
    // 查询用户信息
    用户 = 查询用户(用户ID)

    // 切换状态
    IF 用户.状态 = 正常 THEN
        用户.状态 = 禁用
    ELSE
        用户.状态 = 正常
    END IF

    更新用户状态至数据库

    RETURN 操作成功
END FUNCTION
```

---

### 3. 帖子管理功能

#### 3.1 查询帖子列表

在帖子管理页面，系统会调用PostController类的list()方法，该方法可选传入学校ID、搜索关键词和排序方式作为参数。系统调用PostService类的list()方法查询帖子列表，若传入关键词则按标题或内容模糊匹配，同时调用UserService类填充帖子发布者信息。帖子管理页面如图x所示。

**伪代码：**
```
FUNCTION 查询帖子列表(学校ID, 搜索关键词, 排序方式)
    // 构建查询条件
    帖子列表 = 查询帖子(学校ID)

    IF 搜索关键词不为空 THEN
        帖子列表 = 筛选(帖子列表, 标题包含关键词 OR 内容包含关键词)
    END IF

    // 填充关联信息并排序
    FOR EACH 帖子 IN 帖子列表
        帖子.发布者 = 查询用户(帖子.用户ID)
    END FOR

    帖子列表 = 排序(帖子列表, 排序方式)

    RETURN 帖子列表
END FUNCTION
```

---

#### 3.2 置顶帖子

管理员点击"置顶"按钮后，系统会调用PostController类的setTop()方法，该方法必须传入帖子ID作为参数。系统调用PostService类的getById()方法查询帖子信息，校验帖子存在后调用PostService类的updateById()方法将帖子的置顶状态设为是。置顶帖子在列表中优先展示。帖子置顶操作如图x所示。

**伪代码：**
```
FUNCTION 置顶帖子(帖子ID)
    // 查询帖子信息
    帖子 = 查询帖子(帖子ID)
    IF 帖子不存在 THEN
        RETURN 操作失败：帖子不存在
    END IF

    // 设置置顶状态
    帖子.是否置顶 = 是
    更新帖子数据至数据库

    RETURN 置顶成功
END FUNCTION
```

---

#### 3.3 删除帖子

管理员点击"删除"按钮后，系统会调用PostController类的delete()方法，该方法必须传入帖子ID作为参数。系统调用CommentService类的deleteByPostId()方法删除该帖子的所有评论，调用UserLikeService类的deleteByTargetId()方法删除点赞记录，最后调用PostService类的removeById()方法删除帖子主表数据。帖子删除流程如图x所示。

**伪代码：**
```
FUNCTION 删除帖子(帖子ID)
    // 删除关联数据
    删除评论记录(帖子ID)
    删除点赞记录(帖子ID)

    // 删除帖子主表数据
    删除帖子记录(帖子ID)

    RETURN 删除成功
END FUNCTION
```

---

### 4. 求助管理功能

#### 4.1 查询求助列表

在求助管理页面，系统会调用TaskController类的list()方法，该方法可选传入状态筛选作为参数。系统调用TaskService类的list()方法查询求助列表，若传入状态参数则按状态过滤，同时调用UserService类填充发布者和接单者信息。求助管理页面如图x所示。

**伪代码：**
```
FUNCTION 查询求助列表(状态筛选)
    // 构建查询条件
    IF 状态筛选不为空 THEN
        求助列表 = 查询求助(状态 = 状态筛选)
    ELSE
        求助列表 = 查询全部求助()
    END IF

    // 填充关联信息
    FOR EACH 求助 IN 求助列表
        求助.发布者 = 查询用户(求助.用户ID)
        IF 求助.接单用户ID存在 THEN
            求助.接单者 = 查询用户(求助.接单用户ID)
        END IF
    END FOR

    RETURN 求助列表
END FUNCTION
```

---

### 5. 学校管理功能

#### 5.1 管理学校

在学校管理页面，管理员可进行学校的新增、编辑、删除操作。删除时系统会调用SchoolController类的delete()方法，该方法必须传入学校ID作为参数。系统调用UserService类的countBySchoolId()方法统计该学校下的用户数量，若存在用户则禁止删除，否则调用SchoolService类的removeById()方法删除学校及关联的院系班级数据。学校管理界面如图x所示。

**伪代码：**
```
FUNCTION 删除学校(学校ID)
    // 校验关联数据
    关联用户数 = 统计用户(学校ID)
    IF 关联用户数 > 0 THEN
        RETURN 删除失败：该学校下存在用户
    END IF

    // 删除学校及关联院系班级
    删除班级(学校ID)
    删除院系(学校ID)
    删除学校记录(学校ID)

    RETURN 删除成功
END FUNCTION
```

---

### 6. 图片管理功能

#### 6.1 查询图片列表

在图片管理页面，系统会调用ImageController类的list()方法，该方法无需传入参数。系统扫描上传目录获取所有图片文件，同时调用UserService、PostService、TaskService类收集使用中的图片URL集合，通过比对判断每张图片的使用状态。图片管理页面如图x所示。

**伪代码：**
```
FUNCTION 查询图片列表()
    // 扫描上传目录
    所有图片 = 遍历目录获取图片文件()

    // 收集使用中的图片URL
    使用中URL集合 = 合并(
        查询用户头像URL(),
        查询帖子图片URL(),
        查询求助图片URL()
    )

    // 标记使用状态
    FOR EACH 图片 IN 所有图片
        图片.是否使用 = 图片.URL 存在于 使用中URL集合
    END FOR

    RETURN 所有图片
END FUNCTION
```

---

#### 6.2 清理未使用图片

管理员点击"清理未使用图片"按钮后，系统会调用ImageController类的deleteUnused()方法，该方法无需传入参数。系统首先调用ImageController类的list()方法获取图片列表，筛选出未使用的图片，遍历删除文件并统计删除数量和释放空间。图片清理操作如图x所示。

**伪代码：**
```
FUNCTION 清理未使用图片()
    // 获取未使用图片
    图片列表 = 查询图片列表()
    未使用图片 = 筛选(图片列表, 是否使用 = 否)

    // 批量删除文件
    删除数量 = 0
    FOR EACH 图片 IN 未使用图片
        删除文件(图片.路径)
        删除数量 = 删除数量 + 1
    END FOR

    RETURN 清理完成，删除数量
END FUNCTION
```

---

### 7. 公告管理功能

#### 7.1 发布公告

管理员点击"发布公告"按钮后，系统会调用NoticeController类的save()方法，该方法必须传入标题、内容和管理员ID作为参数。系统调用NoticeService类的save()方法将公告信息存储至数据库，公告发布后展示给所有用户查看。公告发布界面如图x所示。

**伪代码：**
```
FUNCTION 发布公告(标题, 内容, 管理员ID)
    // 参数校验
    IF 标题或内容为空 THEN
        RETURN 发布失败：标题和内容不能为空
    END IF

    // 创建公告记录
    公告信息 = 构造公告(标题, 内容, 管理员ID, 当前时间)
    插入公告数据至数据库

    RETURN 发布成功
END FUNCTION
```

---

## 三、公共功能模块

---

### 1. 文件上传功能

用户上传图片时，系统会调用CommonController类的upload()方法，该方法必须传入文件和上传类型作为参数。系统校验文件类型为图片且大小未超限后，生成UUID文件名并按类型和日期分类存储，返回图片访问URL。文件上传流程如图x所示。

**伪代码：**
```
FUNCTION 文件上传(文件, 上传类型)
    // 校验文件
    IF 文件类型不是图片 THEN
        RETURN 上传失败：仅支持图片文件
    END IF
    IF 文件大小超过限制 THEN
        RETURN 上传失败：文件大小超过限制
    END IF

    // 生成存储路径并保存
    文件名 = UUID生成() + 文件扩展名
    存储路径 = 上传目录 + 上传类型 + 当前日期 + 文件名
    保存文件(文件, 存储路径)

    RETURN 图片访问URL
END FUNCTION
```

---

### 2. 积分系统

积分扣除时，系统会调用UserController类的deductBalance()方法，该方法必须传入用户ID、积分数量和扣除原因作为参数。系统调用UserService类的getById()方法查询用户积分余额，校验充足后调用UserService类的updateById()方法扣除积分。积分增加时调用UserController类的addBalance()方法，流程类似。积分流转流程如图x所示。

**伪代码：**
```
FUNCTION 积分扣除(用户ID, 积分数量, 扣除原因)
    // 查询用户积分
    用户 = 查询用户(用户ID)
    IF 用户.积分 < 积分数量 THEN
        RETURN 扣除失败：积分不足
    END IF

    // 扣除积分
    用户.积分 = 用户.积分 - 积分数量
    更新用户积分至数据库

    RETURN 扣除成功
END FUNCTION

FUNCTION 积分增加(用户ID, 积分数量, 增加原因)
    // 查询用户
    用户 = 查询用户(用户ID)

    // 增加积分
    用户.积分 = 用户.积分 + 积分数量
    更新用户积分至数据库

    RETURN 增加成功
END FUNCTION
```

---

## 四、数据库表关系

```
school (学校)
    ├── dept (院系) - school_id
    │    └── class (班级) - dept_id
    │         └── user (用户) - class_id, school_id
    │              ├── post (帖子) - user_id
    │              │    └── comment (评论) - post_id, user_id
    │              ├── task (求助) - user_id
    │              │    └── remark (评价) - task_id, user_id
    │              ├── chat_message (消息) - sender_id, receiver_id
    │              └── user_like (点赞) - user_id, target_id
    └── admin (管理员) - school_id
```

---

## 五、状态码定义

| 状态类型 | 状态值 | 说明 |
|----------|--------|------|
| 求助状态 | 0 | 待接取 |
| 求助状态 | 1 | 互助中 |
| 求助状态 | 2 | 已完成 |
| 用户状态 | 0 | 正常 |
| 用户状态 | 1 | 禁用 |
| 消息类型 | 0 | 文字消息 |
| 消息类型 | 1 | 图片消息 |
| 消息类型 | 2 | 表情包消息 |
| 点赞目标 | 1 | 帖子 |
| 点赞目标 | 2 | 评论 |
