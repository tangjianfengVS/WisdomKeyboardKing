# WisdomKeyboardKing
Intelligent keyboard manager:
Intelligent keyboard manager, handles position determination of keyboard and UITextField, UITextView responses,Process text input and output format conversion

—————WisdomKeyboardKing： The first phase of Framework function—————

一：Swift SDK, complete compatible OC call

二：Keyboard popup, auto dodge UITextField, UITextView class controls
           Note: a large number of UITextField and UITextView on the same page can be avoided accurately.

三：Toggle input, the keyboard exactly avoids UITextField, UITextView class controls

四：UITextField, UITextView's evading distance from the keyboard, supports settable
      Spacing setting property：   betweenKeyboardSpace
      There are spacing defaults： 10.0

五：UITextField, UITextView's wisdomTask task,
        ---------wisdomTask Analysis of the----------
           *beginTasks:   Callbacks when invoking the keyboard            
           *changeTasks:  Callback when changing text content                        
           *endTasks:     A callback when the keyboard is closed or the corresponding object is replaced
           
           Note: closure callbacks are convenient to use instead of proxies, 
           and there is no need to implement tasks to pass nill
   
     Use case:
       /**
        *  view   ：The parent view that does the move
        *  title  ：Written content
        *  rect   ：Frame is currently on the screen
        */
       bottomField.wisdomTask(beginTasks: { (view, title, rect) in
            //print(view,title,rect)

        }, changeTasks: { (view, title, rect) in
            //print(view,title,rect)

        }) { (view, title, rect) in
            //print(view,title,rect)
        }
 
 六：Support number type processing display
    enum：
    public enum WisdomTextOutputMode {
       case normal
       case PhoneNumber11_4
       case PhoneNumber11_3X4
       case BankcardNumber16_4
       case BankcardNumber19_4
    }

    Enumeration analysis (number delimited format display type) :
       PhoneNumber11_4:           1520 1218 189             (Restrictions on 11)
       PhoneNumber11_3X4:         152 0121 8189             (Restrictions on 11)
       BankcardNumber16_4:        1212 1212 1212 1212       (16-digit bank card number)
       BankcardNumber19_4:        1212 1212 1212 1212 121   (19-digit bank card number)

    Use case:
        let textField = UITextField()
        textField.text = "15201218189"
        textField.textOutputMode = .PhoneNumber11_3X4
        (According to the results：152 0121 8189 )

    Note: the WisdomTextOutputMode is set, the keyboard output type is mandatory digital output, 
         and the input process is displayed dynamically

七：Support processing display of expiration time (input time will be greater than current time)
    Application scenario: coupons and other date expiration tips are displayed

    enum：
    public enum WisdomInputTimeConvertType {
        case timestamp_10        //10位
        case timestamp_13        //13位        
        case input_joint        
        case input_N_Y_R_joint   
    }

    Enumeration analysis (raw data type for time processing) :
    timestamp_10             //10位时间戳
    timestamp_13             //13位时间戳
    input_joint              //Text "-" splicing
    input_N_Y_R_joint        //Text "year, month, day" are spliced together

    --------------过期输出显示样式说明：    
    /**
     *  The expiration time type that needs to be supported for display
     *  需要支持显示的过期时间类型
     *  使用规则：  1.默认值: expiredTomorrow， expiredAfterTomorrow
     *            2.精确度越高，级别越高:  expiredToday_hour > expiredToday
     *                                 expiredTomorrow_hour > expiredTomorrow
     *                                 expiredAfterTomorrow_hour > expiredAfterTomorrow
     *            3.设置了高级别，会过滤低级别样式，低级别样式不再显示
     *            4.高级别,低级别同时显示，只安装高级别样式显示
     *            5.expiredToday 和 expiredToday_hour都不设置，“今天过期”不显示
     */
    @objc public enum WisdomExpiredTimeType: NSInteger {
       case expiredToday=0                 //今天过期
       case expiredToday_hour=1            //今天8点过期
       case expiredTomorrow=2              //明天过期
       case expiredTomorrow_hour=3         //明天8点过期
       case expiredAfterTomorrow=4         //后天过期
       case expiredAfterTomorrow_hour=5    //后天8点过期
    }

    Use case:
    /**  Expiration time filter：  过期输出格式样式      [今天8点过期]   [明天过期]   [后天过期]
     *   timesText:                过期时间原始数据
     *   serverTimesText:          当前时间对比         (传nil默认与本地时间比对）
     *   type:                     输入处理的数据类型    (确认WisdomInputTimeConvertType)
     *   displayTypeList:          需要支持显示的过期时间类型数组，是WisdomExpiredTimeType类型数组
     *   expiredStr:               过期文字描述，传nill或者空，结尾默认拼接"过期"
     *   返回值:                    Bool: 是否过期     （true未过期，fales已经过期）
     */
     public class func expiredTimeOutput(timesText: String,
                                        serverTimesText: String?,
                                        type: WisdomInputTimeConvertType,
                                        displayTypeList: [WisdomExpiredTimeType.RawValue],
                                        expiredStr: String?) ->(Bool,String) {
                                        
     }
     
     OC调用：
     @objc public class func oc_ExpiredTimeOutput(timesText: String,
                                                 serverTimesText: String?,
                                                 type: WisdomInputTimeConvertType,
                                                 displayTypeList: [WisdomExpiredTimeType.RawValue],
                                                 expiredStr: String?) ->(String){
     }
     

     结果显示支持类型：1. 今天过期   今天8点过期  明天过期   明天8点过期   后天过期  后天8点过期
                    2. swift 方法BOOL值表示是否过期
          

八：Support processing display of history time (input time is not greater than current time)
    Application scenario: chat history time prompt display

    enum：
    public enum WisdomInputTimeConvertType {
        case timestamp_10        //10位
        case timestamp_13        //13位        
        case input_joint        
        case input_N_Y_R_joint    
    }

    Enumeration analysis (raw data type for time processing) :
    timestamp_10             //10位
    timestamp_13             //13位 
    input_joint              //Text "-" splicing
    input_N_Y_R_joint        //Text "year, month, day" are spliced together

    Use case:：
    /**
     *   timesText:         Historical time raw data
     *   serverTimesText:   当前时间对比                 （不传默认与本地时间比对）
     *   type:              Input processing data types (WisdomInputTimeConvertType)
     */
    let timeStr =  WisdomTextOutput.historyTimeOutput(timesText: "1535557797", serverTimesText: nil, type: .timestamp)

    The results show support types:    2017年08月12日 21:30      （非同年）
                                       09月12日 23:30            （同年）
                                       昨天 20:30                （昨天）
                                       上午 10:30，下午 13:30      (当天）
                                       

---------------------------------------------------------------------------------------


# WisdomKeyboardKing
智能键盘管家，处理键盘与UITextField，UITextView响应的位置判定，处理文字输入和输出格式转换

—————WisdomKeyboardKing 一期Framework功能，下面看一期7个功能—————---

一：Swift SDK,完成兼容OC调用

二：键盘弹出，自动避让UITextField，UITextView类控件
   注：(同一个页面大量的UITextField与UITextView，可以准确避让)

三：切换输入，键盘准确避让UITextField，UITextView类控件

四：UITextField，UITextView的避让与keyboard的间距，支持可设置

      间距设置属性： betweenKeyboardSpace
      有间距默认值： 10.0
       
五：支持 UITextField，UITextView的wisdomTask任务，

      --------------wisdomTask分析------------
      beginTasks:   唤起键盘时回调             
      changeTasks：  变化文字内容时回调                        
      endTasks:   关闭键盘或者更换相应对象时回调

      注：闭包回调代替代理，使用方便，不需要实现Task可传nill
   
     使用案例：
     /**
      *  view     ：做移动的父类视图
      *  title    ：文字内容
      *  rect     ：当前在屏幕中的frame
      */
      bottomField.wisdomTask(beginTasks: { (view, title, rect) in
          //print(view,title,rect)
          //唤起键盘时回调 
      }, changeTasks: { (view, title, rect) in
          //print(view,title,rect)
          //变化文字内容时回调      
      }) { (view, title, rect) in
          //print(view,title,rect)
          //关闭键盘或者更换相应对象时回调
      }
        
六：支持号码数字类型的处理显示

      枚举：
      public enum WisdomTextOutputMode {
         case normal
         case PhoneNumber11_4
         case PhoneNumber11_3X4
         case BankcardNumber16_4
         case BankcardNumber19_4
     }

     枚举分析(数字号码分隔格式显示类型)：
         PhoneNumber11_4:           1520 1218 189               (限制11位)
         PhoneNumber11_3X4:         152 0121 8189               (限制11位)
         BankcardNumber16_4:        1212 1212 1212 1212         (16位银行卡号)
         BankcardNumber19_4:        1212 1212 1212 1212 121     (19位银行卡号)

     使用案例：
        let textField = UITextField()
        textField.text = "15201218189"
        textField.textOutputMode = .PhoneNumber11_3X4
        (显示结果：152 0121 8189 )

    注：设置了WisdomTextOutputMode，键盘输出类型都是强制数字输出


七：支持过期时间的处理显示（输入处理时间会大于当前时间）
   应用场景：优惠券 和 活动 等日期过期提示显示

    枚举：
    public enum WisdomInputTimeConvertType {
        case timestamp_10        //10位时间戳
        case timestamp_13        //13位时间戳       
        case input_joint        
        case input_N_Y_R_joint   
    }

    枚举分析(时间处理的原始数据类型)：
        timestamp_10=0         //10位时间戳
        timestamp_13=1         //13位时间戳
        input_joint            //"-"拼接
        input_N_Y_R_joint      //"年，月，日"拼接
        
        
    --------------过期输出显示样式说明：    
    /**
     *  The expiration time type that needs to be supported for display
     *  需要支持显示的过期时间类型
     *  使用规则：  1.默认值: expiredTomorrow， expiredAfterTomorrow
     *            2.精确度越高，级别越高:  expiredToday_hour > expiredToday
     *                                 expiredTomorrow_hour > expiredTomorrow
     *                                 expiredAfterTomorrow_hour > expiredAfterTomorrow
     *            3.设置了高级别，会过滤低级别样式，低级别样式不再显示
     *            4.高级别,低级别同时显示，只安装高级别样式显示
     *            5.expiredToday 和 expiredToday_hour都不设置，“今天过期”不显示
     */
    @objc public enum WisdomExpiredTimeType: NSInteger {
       case expiredToday=0                 //今天过期
       case expiredToday_hour=1            //今天8点过期
       case expiredTomorrow=2              //明天过期
       case expiredTomorrow_hour=3         //明天8点过期
       case expiredAfterTomorrow=4         //后天过期
       case expiredAfterTomorrow_hour=5    //后天8点过期
    }

    使用案例：
    /**  Expiration time filter：  过期输出格式样式      [今天8点过期]   [明天过期]   [后天过期]
     *   timesText:                过期时间原始数据
     *   serverTimesText:          当前时间对比         (传nil默认与本地时间比对）
     *   type:                     输入处理的数据类型    (确认WisdomInputTimeConvertType)
     *   displayTypeList:          需要支持显示的过期时间类型数组，是WisdomExpiredTimeType类型数组
     *   expiredStr:               过期文字描述，传nill或者空，结尾默认拼接"过期"
     *   返回值:                    Bool: 是否过期     （true未过期，fales已经过期）
     */
     public class func expiredTimeOutput(timesText: String,
                                        serverTimesText: String?,
                                        type: WisdomInputTimeConvertType,
                                        displayTypeList: [WisdomExpiredTimeType.RawValue],
                                        expiredStr: String?) ->(Bool,String) {
                                        
     }
     
     OC调用：
     @objc public class func oc_ExpiredTimeOutput(timesText: String,
                                                 serverTimesText: String?,
                                                 type: WisdomInputTimeConvertType,
                                                 displayTypeList: [WisdomExpiredTimeType.RawValue],
                                                 expiredStr: String?) ->(String){
     }
     

     结果显示支持类型：1. 今天过期   今天8点过期  明天过期   明天8点过期   后天过期  后天8点过期
                    2. swift 方法BOOL值表示是否过期
                  
                  
八：支持历史时间的处理显示（不会大于当前时间）

   应用场景：聊天 历史时间提示显示

    枚举：
    public enum WisdomInputTimeConvertType {
       case timestamp_10        //10位时间戳
       case timestamp_13        //13位时间戳           
       case input_joint        
       case input_N_Y_R_joint   
    }

    枚举分析(时间处理的原始数据类型)：
       timestamp_10        //10位时间戳
       timestamp_13        //13位时间戳     
       input_joint            //"-"拼接
       input_N_Y_R_joint      //"年，月，日"拼接

    使用案例：
    /**
     *   timesText:            历史时间原始数据
     *   serverTimesText:      当前时间对比            （不传默认与本地时间比对）
     *   type:                 输入处理的数据类型        (WisdomInputTimeConvertType)
     */
    let timeStr =  WisdomTextOutput.historyTimeOutput(timesText: "1535557797", serverTimesText: nil, type: .timestamp)

    结果显示支持类型:      2017年08月12日 21:30      （非同年）
                        09月12日 23:30            （同年）
                        昨天 20:30                （昨天）
                        上午 10:30，下午 13:30      (当天）

 
