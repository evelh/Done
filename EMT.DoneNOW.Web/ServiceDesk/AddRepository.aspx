<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AddRepository.aspx.cs" Inherits="EMT.DoneNOW.Web.ServiceDesk.AddRepository" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
    <link rel="stylesheet" type="text/css" href="../Content/repository.css" />

</head>
<body  style="min-width: 750px;" >
    <form id="form1" runat="server">
            <div class="heard">
        <ul>
            <li onclick="Submit()">
                <img src="../Images/save.png" alt="" />
                保存
            </li>
            <li>
                <img src="../Images/save.png" alt="" />
                保存并关闭
            </li>
            <li onclick="AddFile()">
                添加附件
            </li>
            <li>
                <img src="../Images/cancel.png" alt="" />
                取消
            </li>
        </ul>
    </div>
    <div class="Contents">
        <div class="GeneralCount">
            <div class="Additem">
                <div class="title">一般信息</div>
                <div class="Content">
                    <div class="item1 item" style="height:auto;">
                        <p>发布对象</p>
                        <select id="publish" style="width:300px;" name="publish">
                            <option value="1" selected="selected" >全部用户</option>
                            <option value="2">客户</option>
                            <option value="3">客户类别</option>
                            <option value="4">客户地域</option>
                        </select>
                        <div id="userbox" style="margin-top:10px;position:relative;">
                            <select style="width:300px;display: none;" name="" id="usercate">

                           </select>
                           <select style="width:300px;display: none;" name="" id="userregional">

                           </select>
                            <input id="user" style="width:300px;display: none;" readonly="readonly" type="text" name="name" value="" />
                            <img id="usericon" style="position:absolute;bottom:5px; right:-20px;display: none;" src="../Images/data-selector.png" alt="" />
                        </div>
                    </div>
                    <div class="item2 item">
                        <input type="checkbox" / name="Active"  id="Active">
                        有效的（知识库中可见）
                    </div>
                    <div class="item3 item">
                        <p>标题<span>*</span></p>
                        <input type="text" / name="title" id="title">
                    </div>
                    <div class="item4 item">
                        <p>目录<span>*</span></p>
                        <select name="category" id="category">
                           <%foreach (var i in cateList) {%>
                            <option value="<%=i.id%>"><%=i.name+"&nbsp;("+i.articleCnt+")"%></option>
                           <%}%>
                          
                    </select>
                    <div class="add">
                        <img onclick="AddCategory()" src="../Images/new.png" alt="" />
                    </div>
                    </div>
                    <div class="item5 item">
                        <p>关键字<a style="font-weight: normal;"> (单独用逗号)</a></p>
                        <textarea name="keywords" id="keywords" style="width: 300px;height: 40px;"></textarea>
                    </div>
                    <div class="item6 item">
                        <p>错误码</p>
                        <textarea name="errorcode" id="errorcode" style="width: 300px;height: 40px;"></textarea>
                    </div>
                    <div class="item7 item">
                        <p>详情<span>*</span></p>
                        <textarea name="detail" id="detail" style="width: 100%;height: 300px;"></textarea>
                    </div>
                </div>
            </div>
        </div>
        <div class="RelatedTicketsSection" style="cursor: pointer;">
            <div class="relatedheard">
                <div class="toogle">-</div>
                <div class="title">关联工单</div>
            </div>
            <div class="relatedcontent">
                <p>工单编号</p>
                <input type="text" name="ticket" id="ticket"/><div class="add" >添加</div>    
            </div>        
        </div>
        <div class="RelatedTicketsSection" style="cursor: pointer;">
            <div class="relatedheard">
                <div class="toogle">-</div>
                <div class="title">附件</div>
            </div>
            <div class="relatedcontent">
                <!--<p>票数量</p>-->
                <div class="add"  onclick="AddFile()">添加附件</div>  
                <table class="dataGridBody" style="width:100%;border-collapse:collapse;" cellspacing='0' border="1">
                    <thead>
                        <tr class="dataGridHeader" style="height: 28px;">
                            <td align="center" style="width: 15px;"></td>
                            <td align="center">类型</td>
                            <td align="center"><span>附件名称</span>&nbsp;<img align="texttop" src="../Images/sort-ascending.png" border="0"></td>
                            <td align="center">文件名称</td>
                            <td align="center" style="width:1%;min-width:82px;">附上日期</td>
                            <td align="center">文件大小</td>
                            <td align="center">备注</td>
                        </tr>

                    </thead>
                    <tbody>
                        <tr class="" style="height: 28px;">
                            <td align="center" style="width: 15px;"></td>
                            <td align="center">doc</td>
                            <td align="center">newsasd</td>
                            <td align="center">sadasda.doc</td>
                            <td align="center" style="width:1%;min-width:82px;">2018/3/1</td>
                            <td align="center">126.kb</td>
                            <td align="center">创建人</td>
                        </tr>
                    </tbody>
                </table>
            </div>        
        </div>
        <div class="RelatedTicketsSection" style="cursor: pointer;">
            <div class="relatedheard">
                <div class="toogle">-</div>
                <div class="title">通知</div>
            </div>
            <div class="relatedcontent">
                <p>通知模板</p>
                <select style="width:310px;" name="NotificationTemplate" id="NotificationTemplate">
                    <option selected="selected" value="">知识库文章——创建或编辑</option>
                </select>
                <p style="width:100%;text-align: right;margin-top:10px;font-weight: normal;">Recall Previous Recipients</p>
                <div class="toccbcc">
                    <div class="items">
                        <p><a>发送对象:</a></p>
                        <input type="text" readonly="readonly"   name="to" id="to"/>
                    </div>
                    <div class="items">
                        <p><a>抄送对象:</a></p>
                        <input type="text" readonly="readonly"   name="cc" id="cc"/>
                    </div>
                    <div class="items">
                        <p><a>密送对象:</a></p>
                        <input type="text" readonly="readonly"  name="bcc" id="bcc"/>
                    </div>
                </div>

                <p style="margin-top:10px;">主题</p>
                <input type="text" name="subject" id="subject" style="width: 100%;" value="知识库文章杂项：事件：知识库：标题" />

                <p style="margin-top:40px;">额外的电子邮件文本</p>
                <textarea name="EmailText" id="EmailText" style="width:100%;height: 80px;"></textarea>
            </div>        
        </div>
    </div>
    </form>
</body>
<script src="../Scripts/jquery-3.1.0.min.js"></script>
<script src="../Scripts/common.js"></script>
<script>
    $.each($('.RelatedTicketsSection'),function(i){
        var _this = $('.RelatedTicketsSection').eq(i).children('.relatedheard').children('.toogle');
        _this.click(function(){
        $('.RelatedTicketsSection').eq(i).children('.relatedcontent').toggle()
        if(_this.html() == '+'){
            _this.html('-') 
            _this.parent().parent().css('background','')
        }else{
            _this.html('+')
            _this.parent().parent().css('background','#F2F2F2')              
        }
    })
})
    $('.Contents').css('height', $(window).height() - 60)
    function AddCategory() {
        window.open("Newsubcategory.aspx", "_blank", "toolbar=yes, location=yes, directories=no, status=no, menubar=yes, scrollbars=yes, resizable=no, copyhistory=yes, width=400,height=200")
    }
    function AddFile() {
        window.open("AddFileAttachment.aspx", "_blank", "toolbar=yes, location=yes, directories=no, status=no, menubar=yes, scrollbars=yes, resizable=no, copyhistory=yes, width=500,height=450")
    }
    //选择发布对象
    $('#publish').change(function () {
        if ($(this).val() == 1) {
            $('#userbox').hide()
            $('#userbox').parent().css('height',50)
        }
        if ($(this).val() == 2) {
            $('#userbox').show()
            $('#userbox').parent().css('height', 'auto')
            $('#user').show().siblings().hide()
            $('#usericon').show()
        }
        if ($(this).val() == 3) {
            $('#userbox').show()
            $('#userbox').parent().css('height', 'auto')
            $('#usercate').show().siblings().hide()
        }
        if ($(this).val() == 4) {
            $('#userbox').show()
            $('#userbox').parent().css('height', 'auto')
            $('#userregional').show().siblings().hide()
        }
    })
    //表单
    var inputControl = {
        publish: "publish",
        Active: "Active",
        title: "title",
        category: "category",
        keywords: "keywords",
        errorcode: "errorcode",
        detail: "detail",
        ticket: "ticket",
        NotificationTemplate: "NotificationTemplate",
        to: "to",
        cc: "cc",
        bcc: "bcc",
        subject: "subject",
        EmailText: "EmailText",
      
    }
    function validateInput(name, errorMsg) {
        if ($("#" + name).val() == "") {
            layer.msg(errorMsg);
            return false;
        }
        else {
            return true;
        }
    }

    function Submit() {
        if (!validateInput(inputControl.publish, "请选择发布对象")) {
            return false;
        }
        if (!validateInput(inputControl.Active, "请选择是否激活")) {
            return false;
        }
        if (!validateInput(inputControl.title, "请填写标题")) {
            return false;
        }
        if (!validateInput(inputControl.category, "请选择目录")) {
            return false;
        }
        if (!validateInput(inputControl.detail, "请填写详情")) {
            return false;
        }
        if (!validateInput(inputControl.NotificationTemplate, "请选择模板")) {
            return false;
        }
    }


</script>
</html>
