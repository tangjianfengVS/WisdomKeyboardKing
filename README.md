# WisdomKeyboardKing
Intelligent keyboard manager:
Intelligent keyboard manager, handles position determination of keyboard and UITextField, UITextView responses,Process text input and output format conversion

—————WisdomKeyboardKing： The first phase of Framework function—————

一：Keyboard popup, auto dodge UITextField, UITextView class controls
           Note: a large number of UITextField and UITextView on the same page can be avoided accurately.

二：Toggle input, the keyboard exactly avoids UITextField, UITextView class controls

三：UITextField, UITextView's evading distance from the keyboard, supports settable
      Spacing setting property：   betweenKeyboardSpace
      There are spacing defaults： 10.0

四：UITextField, UITextView's wisdomTask task,
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
 
 五：Support number type processing display
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

六：Support processing display of expiration time (input time will be greater than current time)
    Application scenario: coupons and other date expiration tips are displayed

    enum：
    public enum WisdomInputTimeConvertType {
        case timestamp         
        case input_joint        
        case input_N_Y_R_joint   
    }

    Enumeration analysis (raw data type for time processing) :
    timestamp                //The time stamp
    input_joint              //Text "-" splicing
    input_N_Y_R_joint        //Text "year, month, day" are spliced together

    Use case:：
    /**                         
     *   timesText:              Expiration time raw data
     *   serverTimesText:        Current time comparison (no default and local time comparison)
     *   type:                   Input processing data types (WisdomInputTimeConvertType)
     */
     let res = WisdomTextOutput.expiredTimeOutput(timesText: "1535557797", serverTimesText: nil, type: .timestamp)

     The results show support types: 1.  [8 PM today] [tomorrow] [day after tomorrow] 3
                                     2.  The BOOL value indicates whether it is expired 
          

七：Support processing display of history time (input time is not greater than current time)
    Application scenario: chat history time prompt display

    enum：
    public enum WisdomInputTimeConvertType {
        case timestamp         
        case input_joint        
        case input_N_Y_R_joint   
    }

    Enumeration analysis (raw data type for time processing) :
    timestamp                //The time stamp
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




# WisdomKeyboardKing
智能键盘管家，处理键盘与UITextField，UITextView响应的位置判定，处理文字输入和输出格式转换

—————WisdomKeyboardKing 一期Framework功能，下面看一期7个功能—————---

一：键盘弹出，自动避让UITextField，UITextView类控件
   注：(同一个页面大量的UITextField与UITextView，可以准确避让)

二：切换输入，键盘准确避让UITextField，UITextView类控件

三：UITextField，UITextView的避让与keyboard的间距，支持可设置
   间距设置属性： betweenKeyboardSpace
   有间距默认值： 10.0
       
四：UITextField，UITextView的wisdomTask任务，
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
        
五：支持号码数字类型的处理显示
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


六：支持过期时间的处理显示（输入处理时间会大于当前时间）
   应用场景：优惠券等 日期过期提示显示

   枚举：
   public enum WisdomInputTimeConvertType {
       case timestamp         
       case input_joint        
       case input_N_Y_R_joint   
   }

   枚举分析(时间处理的原始数据类型)：
       timestamp              //时间戳
       input_joint            //"-"拼接
       input_N_Y_R_joint      //"年，月，日"拼接

   使用案例：
    /**                         
     *   timesText:               过期时间原始数据
     *   serverTimesText:         当前时间对比       (不传默认与本地时间比对）
     *   type:                    输入处理的数据类型  (WisdomInputTimeConvertType)
     */
   let res = WisdomTextOutput.expiredTimeOutput(timesText: "1535557797", serverTimesText: nil, type: .timestamp)

   结果显示支持类型：1.  [今天8点过期]   [明天过期]   [后天过期] 3种
                  2.  BOOL值表示是否过期
                  
                  
七：支持历史时间的处理显示（不会大于当前时间）

   应用场景：聊天 历史时间提示显示

   枚举：
   public enum WisdomInputTimeConvertType {
       case timestamp         
       case input_joint        
       case input_N_Y_R_joint   
   }

   枚举分析(时间处理的原始数据类型)：
       timestamp              //时间戳
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

 
