<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ChangeBoardManage.aspx.cs" Inherits="EMT.DoneNOW.Web.SysSetting.ChangeBoardManage" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <link rel="stylesheet" type="text/css" href="../Content/base.css" />
    <link rel="stylesheet" type="text/css" href="../Content/bootstrap.min.css" />
    <link href="../Content/index.css" rel="stylesheet" />
    <link href="../Content/style.css" rel="stylesheet" />
    <title><%=isAdd?"添加":"编辑" %>变更委员会</title>
</head>
<body>
    <form id="form1" runat="server">
        <div class="header"><%=isAdd?"新增":"编辑" %>变更委员会</div>
        <div class="header-title">
            <ul>
                <li><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -32px 0;" class="icon-1"></i>
                    <asp:Button ID="save_close" runat="server" Text="保存并关闭" BorderStyle="None" OnClick="save_close_Click" />
                </li>
                <li onclick="javascript:window.close();"><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -96px 0;" class="icon-1"></i>关闭</li>
            </ul>
        </div>
        <div style="left: 0; overflow-x: auto; overflow-y: auto; position: fixed; right: 0; bottom: 0; top: 85px;">
            <div class="content clear" id="GeneralDiv">
                <div class="information clear">
                    <div>
                        <table border="none" cellspacing="" cellpadding="" style="width: 400px;">
                            <tr>
                                <td>
                                    <div class="clear">
                                        <label>名称<span class="red">*</span></label>
                                        <input type="text" name="name" id="name" value="<%=board!=null?board.name:"" %>" />

                                    </div>
                                </td>
                            </tr>
                             <tr>
                                <td>
                                    <div class="clear">
                                        <label>描述<span class="red"></span></label>
                                        <textarea name="description" id="description" style="resize: vertical;"><%=board!=null?board.description:"" %></textarea>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <div class="clear">
                                        <label>激活<span class="red"></span></label>
                                        <input type="checkbox" name="isActive" id="isActive" <%if (isAdd || (board != null && board.is_active == 1))
                                            {%>
                                            checked="checked" <%} %> />
                                    </div>
                                </td>
                            </tr>
                        </table>
                    </div>
                </div>

                      <div class="information clear">
                    <div>
                        <table border="none" cellspacing="" cellpadding="" style="width: 400px;">
                            <tr>
                                <td>
                                    <div class="clear">
                                        <label>员工成员<span class="red"></span></label>
                                        <input type="hidden" id="resId"/>
                                        <input type="hidden" id="resIdHidden" name="resIds" value="<%=resIds %>"/>
                                        
                                        <input readonly=""/>
                                        <a class="Button ButtonIcon IconOnly Swap DisabledState" onclick="OtherResCallBack()" tabindex="0" style="display: inline-grid; width: 22px;background: linear-gradient(to bottom,#fbfbfb 0,#fbfbfb 100%);border:0px;"><span class="Icon" style="background: url(../Images/ButtonBarIcons.png) no-repeat -80px 0;height: 16px;"></span><span class="Text"></span></a>
                                    </div>
                                    <div>
                                        <label></label>
                                         <select multiple="multiple" id="otherRes" style="height: 110px; width: 200px;">
                            </select>
                                    </div>
                                </td>
                            </tr>
                             <tr>
                                <td>
                                    <div class="clear">
                                       
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td>  
                                    <label>其他成员<span class="red"></span></label>
                                    <div class="clear">
                                        <input type="checkbox" name="isContact" id="" <%if ((board != null && board.include_ticket_contact == 1))
                                            {%>
                                            checked="checked" <%} %> />
                                        <span style="float: left;margin-top: 6px;">工单联系人</span>
                                    </div>
                                    <div class="clear">
                                        <input type="checkbox" name="isPriContact" id="" <%if ((board != null && board.include_primary_contact == 1))
                                            {%>
                                            checked="checked" <%} %> />
                                        <span style="float: left;margin-top: 6px;">工单客户主联系人</span>
                                    </div>
                                                                            <label></label>
                                    <div class="clear">
                                        <input type="checkbox" name="isParPriContact" id="" <%if ((board != null && board.include_parent_account_primary_contact == 1))
                                            {%>
                                            checked="checked" <%} %> />
                                        <span style="float: left;margin-top: 6px;">工单父客户主联系人</span>
                                    </div>
                                    <div class="clear">
                                        <input type="checkbox" name="isAccMan" id="" <%if ((board != null && board.include_account_resource == 1))
                                            {%>
                                            checked="checked" <%} %> />
                                        <span style="float: left;margin-top: 6px;">工单客户的客户经理</span>
                                    </div>
                                </td>
                            </tr>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </form>
</body>
</html>
<script src="../Scripts/jquery-3.1.0.min.js"></script>
<script src="../Scripts/common.js"></script>
<script>
    $(function () {
        GetOtherResData();
    })
    $("#save_close").click(function () {
        var name = $("#name").val();
        if (name == "") {
            LayerMsg("请填写名称！");
            return false;
        }
        var isRepeat = "";
        $.ajax({
            type: "GET",
            url: "../Tools/SysSettingAjax.ashx?act=CheckBoardName&name=" + name+"&id=<%=board!=null?board.id.ToString():"" %>",
            async: false,
            dataType: "json",
            success: function (data) {
                if (!data) {
                    isRepeat = '1';
                }
            }
        })
        if (isRepeat == "1") {
            LayerMsg("名称重复，请重新填写！");
            return false;
        }
        return true;
    })

    function OtherResCallBack() {
        var url = "../Common/SelectCallBack.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.RESOURCE_CALLBACK %>&muilt=1&field=resId&callBack=GetOtherResData";
           window.open(url, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.CompanySelect %>', 'left=200,top=200,width=600,height=800', false);
    }
    // 
    function GetOtherResData() {
        $("#otherRes").html("");
        var OtherResId = $("#resIdHidden").val();
        if (OtherResId != "") {
            $.ajax({
                type: "GET",
                url: "../Tools/ResourceAjax.ashx?act=GetResByIds&resIds=" + OtherResId,
                async: false,
                dataType:"json",
                success: function (data) {
                    if (data != "") {
                        var thisHtml = "";
                        for (var i = 0; i < data.length; i++) {

                            thisHtml += "<option value='" + data[i].id + "'>" + data[i].name + (data[i].is_active==1?"":"(未激活)")+"</option>";
                        }
                        $("#otherRes").html(thisHtml);

                        $("#otherRes option").dblclick(function () {
                            RemoveResDep(this);
                        })
                    }
                }

            })
        }
    }

    function RemoveResDep(val) {
        $(val).remove();
        var ids = "";
        $("#otherRes option").each(function () {
            ids += $(this).val() + ',';
        })
        if (ids != "") {
            ids = ids.substr(0, ids.length - 1);
        }
        $("#resIdHidden").val(ids);
    }
</script>
