# WisdomKeyboardKing
Intelligent keyboard manager:
Intelligent keyboard manager, handles position determination of keyboard and UITextField, UITextView responses

Func:
/*------------------Introduction to the---------------------
 * Function 1: auto dodge UITextField, UITextView
 
 * Function 2: no need to write code correlation, pod integration can be used
 
 * Function 3: support switching input method to avoid
 
 * Function 4: support settable, control UITextField, UITextView's hiding distance from the keyboard
 
 * Function 5: enable the hiding of a large number of UITextField and UITextView on the same page
 
 * Function 6: UITextField, UITextView supports wisdomTask tasks：
                beginTasks: a callback when invoking a keyboard
               changeTasks: a callback when changing text content
                  endTasks: a callback when the keyboard is closed or the appropriate object is replaced
                  
        Use case:
            textField.wisdomTask(beginTasks: { (view, title, rect) in
            print(view,title,rect)
        }, changeTasks: { (view, title, rect) in
            print(view,title,rect)
        }) { (view, title, rect) in
            print(view,title,rect)
        }
        
        textView.wisdomTask(beginTasks: { (view, title, rect) in
            print(view,title,rect)
        }, changeTasks: { (view, title, rect) in
            print(view,title,rect)
        }) { (view, title, rect) in
            print(view,title,rect)
        }                    
 */
 
 
 
 
# WisdomKeyboardKing
智能键盘管家，处理键盘与UITextField，UITextView响应的位置判定
 
功能一：自动避让UITextField，UITextView
功能二：无需写代码关联，pod集成即可用
功能三：支持切换输入法避让
功能四：支持可设置，可控制UITextField，UITextView的避让与keyboard的间距
功能五：支持识别同一个页面大量的UITextField与UITextView的避让
功能六：UITextField，UITextView支持wisdomTask任务，
                 beginTasks:   唤起键盘时回调             
                changeTasks：  变化文字内容时回调                        
                   endTasks:   关闭键盘或者更换相应对象时回调
                   
        使用案例：
        textField.wisdomTask(beginTasks: { (view, title, rect) in
            print(view,title,rect)
        }, changeTasks: { (view, title, rect) in
            print(view,title,rect)
        }) { (view, title, rect) in
            print(view,title,rect)
        }
        
        textView.wisdomTask(beginTasks: { (view, title, rect) in
            print(view,title,rect)
        }, changeTasks: { (view, title, rect) in
            print(view,title,rect)
        }) { (view, title, rect) in
            print(view,title,rect)
        }                   

