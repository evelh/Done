<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AddRepository.aspx.cs" Inherits="EMT.DoneNOW.Web.ServiceDesk.AddRepository" ValidateRequest="false" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title><%=isAdd?"新增":"编辑" %>知识库</title>
    <link rel="stylesheet" type="text/css" href="../Content/repository.css" />
    <style>
        body{
                overflow-y: hidden;
        }
        .ViewATicket {
            font-size: 12px;
            text-decoration: none;
               color:#337ab7;
        }

        .CloseButton {
            background-image: url(../Images/delete.png);
            width: 16px;
            height: 16px;
            float: left;
        }

        #AttBigDiv {
            font-size: 12px;
        }

        .grid thead tr td {
            background-color: #cbd9e4;
            border-color: #98b4ca;
            color: #64727a;
        }

        .grid {
            font-size: 12px;
            background-color: #FFF;
        }

            .grid thead td {
                border-width: 1px;
                border-style: solid;
                font-size: 13px;
                font-weight: bold;
                height: 19px;
                padding: 4px 4px 4px 4px;
                word-wrap: break-word;
                vertical-align: top;
            }

            .grid table {
                border-collapse: collapse;
                width: 100%;
                border-bottom-width: 1px;
                /*border-bottom-style: solid;*/
            }

            .grid tbody td {
                border-width: 1px;
                border-style: solid;
                border-left-color: #F8F8F8;
                border-right-color: #F8F8F8;
                border-top-color: #e8e8e8;
                border-bottom-width: 0;
                padding: 4px 4px 4px 4px;
                vertical-align: top;
                word-wrap: break-word;
                font-size: 12px;
                color: #333;
            }

        textarea {
            resize: vertical;
        }
        .header {
    height: 40px;
    line-height: 40px;
    background: #346A95;
    padding: 0 10px;
    font-size: 18px;
    color: #FFFFFF;
}
    </style>
</head>
<body style="min-width: 750px;">
    <form id="form1" runat="server">
        <div class="header"><%=isAdd?"新增":"编辑" %>知识库</div>
        <div class="heard">
            <ul>
                <li id="Save">
                    <img src="../Images/save.png" alt="" />
                    保存
                </li>
                <li id="SaveClose">
                    <img src="../Images/save.png" alt="" />
                    保存并关闭
                </li>
                <li onclick="AddAttch()">添加附件
                </li>
                <li onclick="javascript:window.close();">
                    <img src="../Images/cancel.png" alt="" />
                    取消
                </li>
            </ul>
        </div>
        <input id="SaveType" name="SaveType" type="hidden"/>
        <div class="Contents">
            <div class="GeneralCount">
                <div class="Additem">
                    <div class="title">一般信息</div>
                    <div class="Content">
                        <div class="item1 item" style="height: auto;">
                            <p>发布对象</p>
                            <select id="publish" style="width: 300px;" name="publish_to_type_id">
                                <%if (pubList != null && pubList.Count > 0)
                                    {
                                        foreach (var pub in pubList)
                                        {%>
                                <option value="<%=pub.id %>" <%if (thisArt != null && thisArt.publish_to_type_id == pub.id)
                                    { %>
                                    selected="selected" <%} %>><%=pub.name %> </option>
                                <%}
                                }%>
                            </select>
                            <div id="userbox" style="margin-top: 10px; position: relative;">
                                <select style="width: 300px; display: none;" name="classification_id" id="usercate">
                                    <%if (accClassList != null && accClassList.Count > 0)
                                        {
                                            foreach (var pub in accClassList)
                                            {%>
                                    <option value="<%=pub.id %>" <%if (thisArt != null && thisArt.classification_id == pub.id)
                                        { %>
                                        selected="selected" <%} %>><%=pub.name %> </option>
                                    <%}
                                    }%>
                                </select>
                                <select style="width: 300px; display: none;" name="territory_id" id="userregional">
                                    <%if (accTerrList != null && accTerrList.Count > 0)
                                        {
                                            foreach (var pub in accTerrList)
                                            {%>
                                    <option value="<%=pub.id %>" <%if (thisArt != null && thisArt.territory_id == pub.id)
                                        { %>
                                        selected="selected" <%} %>><%=pub.name %> </option>
                                    <%}
                                    }%>
                                </select>

                                <input id="accountId" style="width: 300px; display: none;" readonly="readonly" type="text" name="name" value="<%=thisAccount!=null?thisAccount.name.ToString():"" %>" />
                                <input id="accountIdHidden" type="hidden" name="account_id" value="<%=thisAccount!=null?thisAccount.id.ToString():"" %>"/>
                                <img id="usericon" style="position: absolute; bottom: 5px; right: -20px; display: none;" src="../Images/data-selector.png" alt="" onclick="ChooseAccount()" />
                            </div>
                        </div>
                        <div class="item2 item">
                            <input type="checkbox" name="Active" id="Active" <%if (isAdd || (thisArt != null && thisArt.is_active == 1))
                                { %>
                                checked="checked" <%} %> />
                            有效的（知识库中可见）
                        </div>
                        <div class="item3 item">
                            <p>标题<span>*</span></p>
                            <input type="text" name="title" id="title" value="<%=thisArt!=null?thisArt.title:"" %>" />
                        </div>
                        <div class="item4 item">
                            <p>目录<span>*</span></p>
                            <select name="kb_category_id" id="category">
                                <%foreach (var i in cateList)
                                    {
                                        var temp = "";
                                        for (int j = 0; j < i.leaval; j++)
                                        {
                                            temp += "&nbsp;&nbsp;&nbsp;";
                                        }
                                %>
                                <option value="<%=i.id%>" <%if (thisArt != null&&thisArt.kb_category_id==i.id)
                                        { %>
                                        selected="selected" <%} %> ><%=temp %><%=i.name+"&nbsp;("+i.articleCnt+")"%></option>
                                <%}%>
                            </select>
                            <div class="add">
                                <img onclick="AddCategory()" src="../Images/new.png" alt="" />
                            </div>
                        </div>
                        <div class="item5 item">
                            <p>关键字<a style="font-weight: normal;"> (单独用逗号)</a></p>
                            <textarea name="keywords" id="keywords" style="width: 300px; height: 40px;"><%=thisArt!=null?thisArt.keywords:"" %></textarea>
                        </div>
                        <div class="item6 item">
                            <p>错误码</p>
                            <textarea name="error_code" id="errorcode" style="width: 300px; height: 40px;"><%=thisArt!=null?thisArt.error_code:"" %></textarea>
                        </div>
                        <div class="item7 item">
                            <p>详情<span>*</span></p>
                            <input value="" type="hidden"  id="article_body" name="article_body"/>
                            <input value="" type="hidden"  id="article_body_no_markup" name="article_body_no_markup"/>
                            <div class="Content" style="margin-left:-30px;">
                                <script id="containerHead" name="content" type="text/plain"></script>
                            </div>
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
                    <input type="text" name="ticket" id="ticket" /><div class="add" onclick="AddPageTicket()">添加</div>
                </div>
                <div id="kbm_ticket_grid_row" style="padding-bottom: 12px;">
                    <input type="hidden" id="TicketIds" name="TicketIds" />
                    <table border="0" width="100%" cellpadding="0" cellspacing="0" style="margin-left: 25px;">
                        <tbody id="ChooseTicketTbody">
                            <%if (kbTicketList != null && kbTicketList.Count > 0)
                                {
                                    foreach (var kbTicket in kbTicketList)
                                    {
                                        var thisTicket = stDal.FindNoDeleteById(kbTicket.task_id);
                                        if (thisTicket == null)
                                            continue;
                            %>
                            <tr data-val="<%=kbTicket.task_id %>" id="<%=kbTicket.task_id %>" class="pageTicket">
                                <td style="width: 10px;">
                                    <img src="../Images/delete.png" style="cursor: pointer" onclick="DeleteTicket('<%=kbTicket.task_id %>')" /></td>
                                <td width="110" style="padding-left: 5px; padding-bottom: 6px;"><a class="ViewATicket" onclick="ViewTicket('<%=kbTicket.task_id %>')"><%=kbTicket.task_no %></a></td>
                                <td width="10" style="font-size: 8pt;"></td>
                                <td style="font-size: 8pt; font-family: Tahoma, Arial, Verdana;"><%=thisTicket.title %></td>
                            </tr>
                            <%      }
                            } %>
                        </tbody>
                    </table>
                </div>
            </div>
            <div class="RelatedTicketsSection" style="cursor: pointer;">
                <div class="relatedheard">
                    <div class="toogle">-</div>
                    <div class="title">附件</div>
                </div>
                <div class="relatedcontent" id="AttBigDiv">
                    <table width="100%" cellpadding="5" cellspacing="0">
                        <tbody>
                            <tr>
                                <td>

                                    <table width="100%" cellpadding="0" cellspacing="0">
                                        <tbody>
                                            <tr>
                                                <td>
                                                    <div class="workspace">
                                                        <table border="0" width="100%" cellpadding="3" cellspacing="0">
                                                            <tbody>
                                                                <tr>
                                                                    <td>
                                                                        <div style="padding-bottom: 10px; text-align: left;">
                                                                            <a class="PrimaryLink" id="AddAttachmentLink" onclick="AddAttch()">
                                                                                <img src="../Images/ContentAttachment.png" style="height: 15px; width: 15px; display: unset;" alt="" />&nbsp;&nbsp;新增附件</a>
                                                                        </div>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td style="text-align: left;">
                                                                        <div id="AttachmentPanel" class="AttachmentContainer" style="padding-bottom: 10px;">
                                                                        </div>
                                                                    </td>
                                                                </tr>
                                                            </tbody>
                                                        </table>
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="FieldLabels" style="text-align: left;">
                                                    <div class="grid">
                                                        <input type="hidden" name="attIds" id="attIds" />
                                                        <table width="100%" cellpadding="0" style="border-collapse: collapse; width: 600px;">
                                                            <thead>
                                                                <tr style="height: 21px;">
                                                                    <td width="1%" style="min-width: 22px;">&nbsp;</td>
                                                                    <td width="30%">名称</td>
                                                                    <td width="29%">文件</td>
                                                                    <td width="30%" align="center">日期</td>
                                                                    <td width="10%" align="right">大小</td>
                                                                </tr>
                                                            </thead>
                                                            <tbody>
                                                                <%if (thisNoteAtt != null && thisNoteAtt.Count > 0)
                                                                    {
                                                                        foreach (var thisAtt in thisNoteAtt)
                                                                        {%>

                                                                <tr class="thisAttTR" id="<%=thisAtt.id %>" data-val="<%=thisAtt.id %>">
                                                                    <td><a onclick="RemoveThistTr('<%=thisAtt.id %>')">
                                                                        <img src="../Images/delete.png" style="height: 15px; width: 15px; display: unset;" /></a></td>
                                                                    <td><%=thisAtt.filename %></td>
                                                                    <td><a onclick="OpenAttach('<%=thisAtt.id %>')"><%=thisAtt.title %></a></td>

                                                                    <td align="center"><span id="DisplayValueForDateTime"><%=EMT.Tools.Date.DateHelper.ConvertStringToDateTime(thisAtt.create_time).ToString("yyyy-MM-dd") %></span></td>
                                                                    <td align="right"><%=thisAtt.sizeinbyte!=null?HumanReadableFilesize((double)thisAtt.sizeinbyte):"" %></td>

                                                                </tr>
                                                                <%
                                                                        }
                                                                    } %>
                                                            </tbody>
                                                        </table>
                                                    </div>
                                                </td>

                                            </tr>
                                            <tr>
                                                <td></td>
                                            </tr>

                                        </tbody>
                                    </table>

                                </td>
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
                    <select style="width: 310px;" name="NotificationTemplate" id="NotificationTemplate">
                        <option selected="selected" value="">知识库文章——创建或编辑</option>
                    </select>
                    <p style="width: 100%; text-align: right; margin-top: 10px; font-weight: normal;">Recall Previous Recipients</p>
                    <div class="toccbcc">
                        <div class="items">
                            <p><a>发送对象:</a></p>
                            <input type="text" readonly="readonly" name="to" id="to" />
                        </div>
                        <div class="items">
                            <p><a>抄送对象:</a></p>
                            <input type="text" readonly="readonly" name="cc" id="cc" />
                        </div>
                        <div class="items">
                            <p><a>密送对象:</a></p>
                            <input type="text" readonly="readonly" name="bcc" id="bcc" />
                        </div>
                    </div>

                    <p style="margin-top: 10px;">主题</p>
                    <input type="text" name="subject" id="subject" style="width: 100%;" value="知识库文章杂项：事件：知识库：标题" />

                    <p style="margin-top: 40px;">额外的电子邮件文本</p>
                    <textarea name="EmailText" id="EmailText" style="width: 100%; height: 80px;"></textarea>
                </div>
            </div>
        </div>
    </form>
</body>
<script src="../Scripts/jquery-3.1.0.min.js"></script>
<script src="../Scripts/common.js"></script>
<script src="../RichText/js/ueditor.config.js"></script>
<script src="../RichText/js/ueditor.all.js"></script>
<script>
    $(function () {
        $("#publish").trigger("change");
        GetTicketIds();
    })
    $.each($('.RelatedTicketsSection'), function (i) {
        var _this = $('.RelatedTicketsSection').eq(i).children('.relatedheard').children('.toogle');
        _this.click(function () {
            $('.RelatedTicketsSection').eq(i).children('.relatedcontent').toggle()
            if (_this.html() == '+') {
                _this.html('-')
                _this.parent().parent().css('background', '')
            } else {
                _this.html('+')
                _this.parent().parent().css('background', '#F2F2F2')
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
        if ($(this).val() ==<%=(int)EMT.DoneNOW.DTO.DicEnum.KB_PUBLISH_TYPE.ALL_USER %>||$(this).val() ==<%=(int)EMT.DoneNOW.DTO.DicEnum.KB_PUBLISH_TYPE.INTER_USER %> ) {
            $('#userbox').hide()
            $('#userbox').parent().css('height', 50)
        }
        if ($(this).val() == <%=(int)EMT.DoneNOW.DTO.DicEnum.KB_PUBLISH_TYPE.INTER_USER_ACCOUNT %>) {
            $('#userbox').show()
            $('#userbox').parent().css('height', 'auto')
            $('#accountId').show().siblings().hide()
            $('#usericon').show()
        }
        if ($(this).val() ==  <%=(int)EMT.DoneNOW.DTO.DicEnum.KB_PUBLISH_TYPE.INTER_USER_CLASS %>) {
            $('#userbox').show()
            $('#userbox').parent().css('height', 'auto')
            $('#usercate').show().siblings().hide()
        }
        if ($(this).val() ==  <%=(int)EMT.DoneNOW.DTO.DicEnum.KB_PUBLISH_TYPE.INTER_USER_TERR %>) {
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
    $("#SaveClose").click(function () {
        $("#SaveType").val("SaveClose");
        if (Submit()) {
            $("#form1").submit();
        }
    })
    $("#Save").click(function () {
        $("#SaveType").val("Save");
        if (Submit()) {
            $("#form1").submit();
        }
    })

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
        //if (!validateInput(inputControl.NotificationTemplate, "请选择模板")) {
        //    return false;
        //}
        GetOldAttList();
        $("#article_body").val($('<div/>').text(ue.getContent()).html());
        $("#article_body_no_markup").val(ue.getContentTxt());
        return true;
    }

    // 获取到工单的Id 集合
    function GetTicketIds() {
        // TicketIds  pageTicket
        var ids = "";
        $(".pageTicket").each(function () {
            var thisVal = $(this).data("val");
            if (thisVal != "") {
                ids += thisVal + ",";
            }
        })
        if (ids != "") {
            ids = ids.substring(0, ids.length - 1);
        }
        $("#TicketIds").val(ids);
    }

    function AddPageTicket() {
        var ticketNo = $("#ticket").val();
        if (ticketNo != "" && $.trim(ticketNo) != "") {
            var ticketId = "";
            $.ajax({
                type: "GET",
                async: false,
                url: "../Tools/TicketAjax.ashx?act=GetTicketByNo&no=" + ticketNo,
                dataType: "json",
                success: function (data) {
                    if (data != "") {
                        ticketId = data.id;
                        if (CanAdd(ticketId)) {
                            var thisHtml = "<tr data-val='" + ticketId + "' id='" + ticketId + "' class='pageTicket'><td style= 'width:10px;' ><img src='../Images/delete.png' style='cursor:pointer' onclick='DeleteTicket(" + ticketId + ")' /></td><td width= '110' style= 'padding-left:5px;padding-bottom: 6px;'> <a class='ViewATicket' onclick='ViewTicket(" + ticketId + ")'>" + data.no + "</a></td><td width='10' style='font-size:8pt;'></td><td style='font-size:8pt;font-family: Tahoma, Arial, Verdana;'>" + data.title + "</td></tr>";
                            $("#ChooseTicketTbody").append(thisHtml);
                            GetTicketIds();
                        }
                        else {
                            LayerMsg("列表中已经存在该工单");
                        }
                    }
                },
            });
            if (ticketId == "") {
                LayerMsg("未获取到相关工单");
            }
            else {

            }
        }
        else {
            LayerAlert("请先填写工单编号！");
        }
    }

    function ViewTicket(ticketId) {
        window.open("../ServiceDesk/TicketView?id=" + ticketId , windowType.blank, 'left=200,top=200,width=1280,height=800', false);
    }

    function DeleteTicket(ticketId) {
        $("#" + ticketId).remove();
        GetTicketIds();
    }
    // 新增的工单是否能添加
    function CanAdd(ticketId) {
        var ids = $("#TicketIds").val();
        if (ids != "") {
            var idArr = ids.split(',');
            var isHas = "";
            for (var i = 0; i < idArr.length; i++) {
                if (idArr[i] == ticketId) {
                    isHas = "1";
                    return false;
                }
            }
            if (isHas != "") {
                return false;
            }
        }
        return true;
    }
    function AddAttch() {
        window.open("../Project/AddTaskAttach.aspx?object_id=<%=objectId %>", '<%=(int)EMT.DoneNOW.DTO.OpenWindow.TASK_ATTACH %>', 'left=200,top=200,width=600,height=800', false);
    }
    // 重新显示session文件内容
    function ReloadSession() {
        // 重新加载session，显示新增文件
        
        $.ajax({
            type: "GET",
            async: false,
            url: "../Tools/ProjectAjax.ashx?act=GetTaskFileSes&object_id=<%=objectId %>",
            success: function (data) {
                if (data != "") {
                    $("#AttachmentPanel").html(data);
                }
            },
        });
    }
    // 移除session内容
    function RemoveSess(index) {
        $.ajax({
            type: "GET",
            async: false,
            url: "../Tools/ProjectAjax.ashx?act=RemoveSess&object_id=<%=objectId %>&index=" + index,
             success: function (data) {
                 $("#AttachmentPanel").html(data);
             },
        });
    }
    function RemoveThistTr(trId) {
        LayerConfirm("确定要删除这个文件吗？", "是", "否", function () { $("#" + trId).remove(); });
    }
    // 获取旧的task的id集合，修改时删除不必要附件
    function GetOldAttList() {
        // attIds
        var ids = "";
        $(".thisAttTR").each(function () {
            ids += $(this).attr("id") + ",";
        })
        if (ids != "") {
            ids = ids.substring(0, ids.length - 1);
        }
        $("#attIds").val(ids);
    }
    var ue = UE.getEditor('containerHead', {
        toolbars: [
            ['source', 'fontfamily', 'fontsize', 'bold', 'italic', 'underline', 'fontcolor', 'backcolor', 'justifyleft', 'justifycenter', 'justifyright', 'insertorderedlist', 'insertunorderedlist', 'insertimage', 'undo', 'redo']
        ],
        initialFrameHeight: 300,//设置编辑器高度
        initialFrameWidth: 650, //设置编辑器宽度
        wordCount: false,
        elementPathEnabled : false,
        autoHeightEnabled: false  //设置滚动条
    });
    ue.ready(function () {
        //获取html内容  返回：<p>内容</p>
            ue.setContent('<%=HttpUtility.HtmlDecode(thisArt!=null?thisArt.article_body:"")  %>');
            var html = ue.getContent();
            //获取纯文本内容  返回：内容
            var txt = ue.getContentTxt();
            $(".Dialog").on("click", function () {
                $("#BackgroundOverLay").show();
                $(".AlertBox").show();
            });
            $(".CancelDialogButton").on("click", function () {
                $("#BackgroundOverLay").hide();
                $(".AlertBox").hide();
            });
    });

    function ChooseAccount() {
        // accountId
        window.open("../Common/SelectCallBack.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.COMPANY_CALLBACK %>&field=accountId", "<%=(int)EMT.DoneNOW.DTO.OpenWindow.CompanySelect %>", 'left=200,top=200,width=600,height=800', false);
    }
    function OpenAttach(attId) {
        window.open("../Activity/OpenAttachment.aspx?id=" + attId, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.TASK_ATTACH %>', 'left=200,top=200,width=1080,height=800', false);

    }
</script>
</html>
