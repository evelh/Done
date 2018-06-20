<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SystemSetting.aspx.cs" Inherits="EMT.DoneNOW.Web.SysSetting.SystemSetting" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title></title>
    <link href="../Content/reset.css" rel="stylesheet" />
    <link href="../Content/SysSettingRoles.css" rel="stylesheet" />
    <link rel="stylesheet" type="text/css" href="../Content/style.css" />
    <link href="../Content/index.css" rel="stylesheet" />
    <link href="../Content/SystemSet.css" rel="stylesheet" />
    <style>
        .MoudleTr{

        }
        a{
            color:#376597;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="ButtonContainer header-title">
            <ul id="btn">
                <li id="SaveClose"><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -32px 0;" class="icon-1"></i>
                    <asp:Button ID="save_close" runat="server" Text="保存并关闭" BorderStyle="None" OnClick="save_close_Click" />

                </li>
                <li onclick="javascript:window.close();"><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -96px 0;margin-top:5px;" class="icon-1"></i>
                    取消
                </li>
                <li onclick="ExpandAll()">展开全部</li>
                <li onclick="CollapseAll()">折叠全部</li>
            </ul>
        </div>
        <div style="left: 0; overflow-x: auto; overflow-y: auto; position: fixed; right: 0; bottom: 0; top: 50px;">
            <table class="unScrollControl GridBottomBorder dataGridBody" id="CollapsableList_divdata" style="width:100%;">

                <tr class="dataGridHeader" style="background-color: rgb(241, 242, 231);">
                    <td>设置名称</td>
                    <td style="width: 360px;">设置值</td>
                </tr>

                <% if (setDic != null && setDic.Count > 0)
                    {
                        foreach (var thisDic in setDic)
                        {
                            var thisMoudle = moduleList?.FirstOrDefault(_ => _.id == thisDic.Key);
                            if (thisMoudle != null)
                            {%>
                <tr class="MoudleTr ShowTr dataGridGroupBreak" data-val="<%=thisDic.Key %>" style="">
                    <td style="padding:3px 0px 3px 10px;"><span class="informationTitle" style="margin-right:-10px;"><i></i></span><%=thisMoudle.name %></td>
                    <td></td>
                </tr>
                <%
                    if (thisDic.Value != null && thisDic.Value.Count > 0)
                    {
                        foreach (var thisSet in thisDic.Value)
                        {
                            
                %>
                <tr class="<%=thisDic.Key %>Tr">
                    <td><%=thisSet.setting_name %></td>
                    <% if (thisSet.data_type_id == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_PARA_TYPE.SINGLE_LINE) {
                            %>
                    <td><input type="text" name="<%=thisSet.id %>" value="<%=thisSet.setting_value %>" style="width:200px;padding:0px;"/></td>
                    <%
                            }
                            else if (thisSet.data_type_id == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_PARA_TYPE.NUMBER)
                            {
                               %>
                    <td><input type="text" name="<%=thisSet.id %>Number" onkeyup="this.value=this.value.replace(/\D/g,'')" onafterpaste="this.value=this.value.replace(/\D/g,'')" value="<%=thisSet.setting_value %>"  style="width:200px;padding:0px;"/></td>
                    <%
                            }
                            else if (thisSet.data_type_id == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_PARA_TYPE.DROPDOWN)
                            {
                            var dtoList = setBll.GetDtoList(thisSet.ref_sql);
                            %>
                    <td><select id="" name="<%=thisSet.id %>"  style="width:200px;">
                        <option></option>
                        <%if (dtoList != null && dtoList.Count > 0) {
                                foreach (var dto in dtoList)
                                {%>
                        <option value="<%=dto.val %>" <%if (dto.val == thisSet.setting_value) {%> selected="selected" <%} %> ><%=dto.show %></option>
                               <% }
                            } %>
                        </select></td>
                    <%
                            }
                            else if (thisSet.data_type_id == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_PARA_TYPE.MULTI_DROPDOWN)
                            {   var dtoList = setBll.GetDtoList(thisSet.ref_sql);
                                   %>
                     <td><select id="" name="<%=thisSet.id %>" multiple="multiple" style="height:100px;width:200px;">
                        <%if (dtoList != null && dtoList.Count > 0) {
                                foreach (var dto in dtoList)
                                {%>
                        <option value="<%=dto.val %>" <%if (!string.IsNullOrEmpty(thisSet.setting_value)&&thisSet.setting_value.Split(',').Contains(dto.val)) {%> selected="selected" <%} %> ><%=dto.show %></option>
                               <% }
                            } %>
                        </select></td>

                    <%
                            }
                            else if (thisSet.data_type_id == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_PARA_TYPE.CALLBACK)
                            {
                                   %>
                 <td><a onclick="ShowUrl('<%=thisSet.ref_url %>')">点击编辑</a></td>
                    <%
                            }
                            else if (thisSet.data_type_id == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_PARA_TYPE.BOOLEAN)
                            {
                                   %>
                       <td><input type="checkbox" name="<%=thisSet.id %>Check" <%if (thisSet.setting_value == "1") {%> checked="checked" <% } %>/></td>
                    <%
                            }
                            else if (thisSet.data_type_id == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_PARA_TYPE.MUILT_CALLBACK)
                            {
                                   %>
                <td><a onclick="ShowUrl('<%=thisSet.ref_url %>')">点击编辑</a></td>

                    <%
                            }
                            else if (thisSet.data_type_id == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_PARA_TYPE.MUILT_LINE)
                            {
                                   %>
                    <td><textarea id="" name="<%=thisSet.id %>"  style="width:200px;padding:0px;"><%=thisSet.setting_value %></textarea></td>
                    <%
                            }
                            else if (thisSet.data_type_id == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_PARA_TYPE.NUMBER_EQUAL)
                            {
                                   %>
                     <td><input type="text" name="<%=thisSet.id %>Number" onkeyup="this.value=this.value.replace(/\D/g,'')" onafterpaste="this.value=this.value.replace(/\D/g,'')" value="<%=thisSet.setting_value %>"  style="width:200px;padding:0px;"/></td>
                    <%
                            } %>
                    
                </tr>
                <% }
                                }

                            }
                        }
                    } %>
            </table>
        </div>
    </form>
</body>
</html>
<script src="../Scripts/jquery-3.1.0.min.js"></script>
<script src="../Scripts/common.js"></script>
<script>
    $(".MoudleTr").click(function () {
        var thisValue = $(this).data("val");
        if ($(this).hasClass("ShowTr")) {
            $("." + thisValue + "Tr").hide();
            $(this).removeClass("ShowTr");
            if ($(this).children().find(".informationTitle") != undefined) {
                $(this).children().find(".informationTitle").children().first().addClass("jia");
            }
        }
        else {
            $("." + thisValue + "Tr").show();
            $(this).addClass("ShowTr");
            if ($(this).children().find(".informationTitle") != undefined) {
                $(this).children().find(".informationTitle").children().first().removeClass("jia");
            }
        }
        
    });
    // 展开全部
    function ExpandAll() {
        $(".MoudleTr").each(function () {
            if (!$(this).hasClass("ShowTr")) {
                $(this).trigger("click");
            }
        })
    }
    // 折叠全部
    function CollapseAll() {
        $(".MoudleTr").each(function () {
            if ($(this).hasClass("ShowTr")) {
                $(this).trigger("click");
            }
        })
    }
    // url 跳转
    function ShowUrl(url) {
        if (url == "" || url == undefined || url == null) {
            return;
        }
        window.open(url, '_blank', 'left=200,top=200,width=900,height=800', false);
    }
  
</script>
