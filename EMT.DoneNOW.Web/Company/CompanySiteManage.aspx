<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="CompanySiteManage.aspx.cs" Inherits="EMT.DoneNOW.Web.Company.CompanySiteManage" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>修改站点配置</title>
    <link rel="stylesheet" type="text/css" href="../Content/base.css" />
    <link rel="stylesheet" type="text/css" href="../Content/bootstrap.min.css" />
    <link rel="stylesheet" type="text/css" href="../Content/NewContact.css" />
</head>
<body>
    <form id="form1" runat="server">
        <div class="header">站点配置-<%=account.name %></div>
        <div class="header-title">
            <ul>
                <li><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -32px 0;"></i>
                    <asp:Button ID="edit" runat="server" Text="修改" BorderStyle="None" OnClick="edit_Click" />
                </li>
                <li>打印</li>
            </ul>
        </div>
        <div class="content clear" style="display: none;" id="view">
            <table border="none" cellspacing="" cellpadding="" style="width: 650px; margin-left: 40px;">


                <% if (site_udfList != null && site_udfList.Count > 0)
                    {

                        foreach (var udf in site_udfList)
                        {
                            if (udf.data_type == (int)EMT.DoneNOW.DTO.DicEnum.UDF_DATA_TYPE.SINGLE_TEXT)    /* 单行文本*/
                            {%>
                <tr>
                    <td>
                        <div class="clear">
                            <label><%=udf.name %></label>
                            <label><%=site_udfValueList.FirstOrDefault(_=>_.id==udf.id)!=null?site_udfValueList.FirstOrDefault(_=>_.id==udf.id).value:"" %></label>

                        </div>
                    </td>
                </tr>
                <%}
                    else if (udf.data_type == (int)EMT.DoneNOW.DTO.DicEnum.UDF_DATA_TYPE.MUILTI_TEXT)       /* 多行文本 */
                    {%>
                <tr>
                    <td>
                        <div class="clear">
                            <label><%=udf.name %></label>
                            <textarea id="<%=udf.id %>" rows="2" cols="20" disabled="disabled"><%=site_udfValueList.FirstOrDefault(_=>_.id==udf.id)!=null?site_udfValueList.FirstOrDefault(_=>_.id==udf.id).value:"" %></textarea>
                        </div>
                    </td>
                </tr>
                <%}
                    else if (udf.data_type == (int)EMT.DoneNOW.DTO.DicEnum.UDF_DATA_TYPE.DATETIME)    /* 日期 */
                    {%>
                <tr>
                    <td>
                        <div class="clear">
                            <label><%=udf.name %></label>

                            <input onclick="WdatePicker()" type="text" name="<%=udf.id %>" class="sl_cdt" value="<%=site_udfValueList.FirstOrDefault(_=>_.id==udf.id)!=null?site_udfValueList.FirstOrDefault(_=>_.id==udf.id).value:"" %>" disabled="disabled" />

                        </div>
                    </td>
                </tr>
                <%}
                    else if (udf.data_type == (int)EMT.DoneNOW.DTO.DicEnum.UDF_DATA_TYPE.NUMBER)         /*数字*/
                    {%>
                <tr>
                    <td>
                        <div class="clear">
                            <label><%=udf.name %></label>
                            <input onclick="WdatePicker()" type="text" name="<%=udf.id %>" class="sl_cdt" value="<%=site_udfValueList.FirstOrDefault(_=>_.id==udf.id)!=null?site_udfValueList.FirstOrDefault(_=>_.id==udf.id).value:"" %>" maxlength="11" onkeyup="value=value.replace(/[^\d]/g,'') " onbeforepaste="clipboardData.setData('text',clipboardData.getData('text').replace(/[^\d]/g,''))" ondblclick="" disabled="disabled" />
                        </div>
                    </td>
                </tr>
                <%}
                    else if (udf.data_type == (int)EMT.DoneNOW.DTO.DicEnum.UDF_DATA_TYPE.LIST)            /*列表*/
                    {%>
                  <tr>
                                <td>
                                    <div class="FieldLabels">
                                        <label><%=udf.name %></label>
                                        <select disabled="disabled">
                                            <%if (udf.required != 1)
                                            { %>
                                            <option></option>
                                            <%} %>
                                            <% if (udf.value_list != null && udf.value_list.Count > 0)
                                                {
                                                    var thisValue = "";
                                                    if (site_udfValueList!=null&&site_udfValueList.Count>0&&site_udfValueList.FirstOrDefault(_ => _.id == udf.id) != null)
                                                    {
                                                        thisValue = site_udfValueList.FirstOrDefault(_ => _.id == udf.id).value.ToString();
                                                    }
                                                   
                                                foreach (var thisValeList in udf.value_list)
                                                {%>
                                            <option value="<%=thisValeList.val %>" <%=thisValue==thisValeList.val?"selected='selected'":"" %>><%=thisValeList.show %></option>
                                            <%
                                                    }
                                                } %>
                                        </select>
                                    </div>
                                </td>
                            </tr>
                <%}
                        }
                    } %>
            </table>

        </div>
        <div id="show" class="content clear" style="display: none;">
            <table border="none" cellspacing="" cellpadding="" style="width: 650px; margin-left: 40px;">


                <% if (site_udfList != null && site_udfList.Count > 0)
                    {

                        foreach (var udf in site_udfList)
                        {
                            if (udf.data_type == (int)EMT.DoneNOW.DTO.DicEnum.UDF_DATA_TYPE.SINGLE_TEXT)    /* 单行文本*/
                            {%>
                <tr>
                    <td>
                        <div class="clear">
                            <label><%=udf.name %></label>
                            <input type="text" name="<%=udf.id %>" class="sl_cdt" value="<%=site_udfValueList.FirstOrDefault(_=>_.id==udf.id)!=null?site_udfValueList.FirstOrDefault(_=>_.id==udf.id).value:"" %>" />

                        </div>
                    </td>
                </tr>
                <%}
                    else if (udf.data_type == (int)EMT.DoneNOW.DTO.DicEnum.UDF_DATA_TYPE.MUILTI_TEXT)       /* 多行文本 */
                    {%>
                <tr>
                    <td>
                        <div class="clear">
                            <label><%=udf.name %></label>
                            <textarea id="<%=udf.id %>" rows="2" cols="20">
                                <%=site_udfValueList.FirstOrDefault(_=>_.id==udf.id)!=null?site_udfValueList.FirstOrDefault(_=>_.id==udf.id).value:"" %>

                            </textarea>

                        </div>
                    </td>
                </tr>
                <%}
                    else if (udf.data_type == (int)EMT.DoneNOW.DTO.DicEnum.UDF_DATA_TYPE.DATETIME)    /* 日期 */
                    {%>
                <tr>
                    <td>
                        <div class="clear">
                            <label><%=udf.name %></label>
                            <input onclick="WdatePicker()" type="text" name="<%=udf.id %>" class="sl_cdt" value="<%=site_udfValueList.FirstOrDefault(_=>_.id==udf.id)!=null?site_udfValueList.FirstOrDefault(_=>_.id==udf.id).value:"" %>" />
                        </div>
                    </td>
                </tr>
                <%}
                    else if (udf.data_type == (int)EMT.DoneNOW.DTO.DicEnum.UDF_DATA_TYPE.NUMBER)         /*数字*/
                    {%>
                <tr>
                    <td>
                        <div class="clear">
                            <label><%=udf.name %></label>
                            <input onclick="WdatePicker()" type="text" name="<%=udf.id %>" class="sl_cdt" value="<%=site_udfValueList.FirstOrDefault(_=>_.id==udf.id)!=null?site_udfValueList.FirstOrDefault(_=>_.id==udf.id).value:"" %>" maxlength="11" onkeyup="value=value.replace(/[^\d]/g,'') " onbeforepaste="clipboardData.setData('text',clipboardData.getData('text').replace(/[^\d]/g,''))" ondblclick="" />
                        </div>
                    </td>
                </tr>
                <%}
                    else if (udf.data_type == (int)EMT.DoneNOW.DTO.DicEnum.UDF_DATA_TYPE.LIST)            /*列表*/
                    {%>
                  <tr>
                                <td>
                                    <div class="FieldLabels">
                                        <label><%=udf.name %></label>
                                        <select  name="<%=udf.id %>" class="sl_cdt" >
                                            <%if (udf.required != 1)
                                            { %>
                                            <option></option>
                                            <%} %>
                                            <% if (udf.value_list != null && udf.value_list.Count > 0)
                                                {
                                                    var thisValue = "";
                                                    if (site_udfValueList!=null&&site_udfValueList.Count>0&&site_udfValueList.FirstOrDefault(_ => _.id == udf.id) != null)
                                                    {
                                                        thisValue = site_udfValueList.FirstOrDefault(_ => _.id == udf.id).value.ToString();
                                                    }
                                                   
                                                foreach (var thisValeList in udf.value_list)
                                                {%>
                                            <option value="<%=thisValeList.val %>" <%=thisValue==thisValeList.val?"selected='selected'":"" %>><%=thisValeList.show %></option>
                                            <%
                                                    }
                                                } %>
                                        </select>
                                    </div>
                                </td>
                            </tr>
                <%}
                        }
                    } %>
            </table>
        </div>
    </form>
</body>
</html>
<script src="../Scripts/jquery-3.1.0.min.js" type="text/javascript" charset="utf-8"></script>
<%--<script src="../Scripts/NewContact.js" type="text/javascript" charset="utf-8"></script>--%>
<script src="../Scripts/index.js"></script>
<script src="../Scripts/common.js"></script>
<script src="../Scripts/Common/Address.js" type="text/javascript" charset="utf-8"></script>
    <script type="text/javascript" charset="utf-8" src="../Scripts/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript">

    $(function () {
        $("#show").hide();
        $("#view").show();

        $("#edit").click(function () {
            var type = $("#edit").val();
          
            if (type == "修改") {
                $("#view").hide();
                $("#show").show();
                $(this).val("保存");
                return false;
            }
        });


    })
 </script>
