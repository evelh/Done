<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AddCompany.aspx.cs" Inherits="EMT.DoneNOW.Web.AddCompany" %>


<!DOCTYPE html>
<html>

<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>添加客户</title>
    <link rel="stylesheet" type="text/css" href="../Content/base.css" />
    <link rel="stylesheet" type="text/css" href="../Content/bootstrap.min.css" />
    <link rel="stylesheet" type="text/css" href="../Content/bootstrap-datetimepicker.min.css" />
    <link href="../Content/index.css" rel="stylesheet" />
    <link href="../Content/style.css" rel="stylesheet" />
    <style>

    </style>
</head>
<body runat="server">
    <form id="AddCompany" name="AddCompany" runat="server">
        <input type="hidden" id="isCheckCompanyName" value="yes" />
        <div class="header">添加客户</div>
        <div class="header-title">
            <ul>
                <li><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -32px 0;"></i>
                    <asp:Button ID="save_close" runat="server" Text="保存并关闭" OnClick="save_Click" BorderStyle="None" />
                </li>
                <li><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -48px 0;"></i>
                    <asp:Button ID="save_newAdd" runat="server" Text="保存并新建" OnClick="save_newAdd_Click" BorderStyle="None" /></li>
                <li><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -48px 0;"></i>
                    <asp:Button ID="save_create_opportunity" runat="server" Text="保存并创建商机" OnClick="save_create_opportunity_Click" BorderStyle="None" /></li>
                <li><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -96px 0;"></i>
                    <asp:Button ID="close" runat="server" Text="关闭" BorderStyle="None" /></li>
            </ul>
        </div>
        <div class="text">若要添加此帐户的第一个联系人，请提供名称和姓氏。如果此时您不希望添加新联系人，则可以将这些字段留空。所有标有“1”的字段只适用于联系人。</div>
        <div class="nav-title">
            <ul class="clear">
                <li class="boders" id="general">通用</li>
                <li id="Subsidiaries">子客户</li>
                <li id="accountUDF">站点信息</li>
            </ul>
        </div>

        <div class="content clear" >
            <div class="information clear">
                <p class="informationTitle"><i></i>基本信息</p>
                <div>
                    <table border="none" cellspacing="" cellpadding="" style="width: 500px; margin-left: 40px;">
                        <%--  <tr>
                    <th>
                        <h1>Client Portal Status</h1>
                        <p>Inactive</p>
                    </th>
                </tr>--%>
                        <tr>
                            <td>
                                <div class="clear">
                                    <label>客户名称<span class="red">*</span></label>
                                    <input type="text" name="company_name" id="company_name" value="" />
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <div class="clear">
                                    <label>称谓<span class="num">1</span></label>
                                    <asp:DropDownList ID="sufix" runat="server">
                                    </asp:DropDownList>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <div class="clear">
                                    <label>电话<span class=" red">*</span></label>
                                    <input type="text" name="Phone" id="Phone" value="" />
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <div class="clear">
                                    <label>国家<span class=" red">*</span></label>
                                    <%--<input id="country_idInit" value='1' type="hidden" runat="server" />--%>
                                    <select name="country_id" id="country_id">
                                        <option value="1">中国</option>
                                    </select>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <div class="clear">
                                    <label>省份<span class=" red">*</span></label>
                                    <%--<input id="province_idInit" value='5' type="hidden" runat="server" />--%>
                                    <select name="province_id" id="province_id">
                                    </select>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <div class="clear">
                                    <label>城市<span class=" red">*</span></label>
                                    <%--<input id="city_idInit" value='6' type="hidden" runat="server" />--%>
                                    <select name="city_id" id="city_id">
                                    </select>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <div class="clear">
                                    <label>区县<span class=" red">*</span></label>
                                    <input id="district_idInit" value='8' type="hidden" runat="server" />
                                    <select name="district_id" id="district_id">
                                    </select>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <div class="clear">
                                    <label>税区<span class="num"></span></label>
                                    <asp:DropDownList ID="TaxRegion" runat="server">
                                    </asp:DropDownList>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <div class="clear">
                                    <label>税号<span class="num"></span></label>
                                    <input type="text" name="TaxId" id="TaxId" value="" />
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <div class="clear">
                                    <label>是否免税</label>
                                    <input type="checkbox" name="TaxExempt" id="TaxExempt" value="" />
                                    <%--  <div style="clear: both; margin-top: -20px; margin-left: 200px;"></div>--%>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <div class="clear">
                                    <label>传真<span class="red"></span></label>
                                    <input type="text" name="Fax" id="Fax" value="" />
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <div class="clear">
                                    <label>分类类别<span class="red"></span></label>

                                    <asp:DropDownList ID="classification" runat="server" AutoPostBack="False">
                                    </asp:DropDownList>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <div class="clear">
                                    <label>销售区域<span class="red"></span></label>
                                    <asp:DropDownList ID="TerritoryName" runat="server"></asp:DropDownList>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <div class="clear">
                                    <label>竞争对手<span class="red"></span></label>
                                    <asp:DropDownList ID="Competitor" runat="server"></asp:DropDownList>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <div class="clear">
                                    <label>官网</label>
                                    <input type="text" name="WebSite" id="WebSite" value="" />
                                </div>
                            </td>
                        </tr>

                    </table>

                    <table border="none" cellspacing="" cellpadding="" style="width: 500px; margin-left: 40px;">


                        <tr>
                            <td>
                                <div class="clear">
                                    <label>联系人姓名<span class="num">1</span></label>
                                    <div class="inputTwo">
                                        <input type="text" name="first_name" id="first_name" value="" />
                                        <span>-</span>
                                        <input type="text" name="last_name" id="last_name" value="" />
                                    </div>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <div class="clear">
                                    <label>头衔<span class="num">1</span></label>
                                    <input type="text" name="Title" id="Title" value="" />
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <div class="clear">
                                    <label>Email<span class="num">1</span></label>
                                    <input type="text" name="Email" id="Email" value="" />
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <div class="clear">
                                    <label>邮编<span class="num"></span></label>
                                    <input type="text" name="postal_code" id="postal_code" value="" />
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <div class="clear">
                                    <label>
                                        地址
                                    </label>
                                    <input type="text" name="address" id="address" value="" />
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <div class="clear">
                                    <label>地址附加信息<span class="num"></span></label>
                                    <input type="text" name="AdditionalAddress" id="AdditionalAddress" value="" />
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <div class="clear">
                                    <label>备用电话1</label>
                                    <input type="text" name="AlternatePhone1" id="AlternatePhone1" value="" />
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <div class="clear">
                                    <label>备用电话2</label>
                                    <input type="text" name="AlternatePhone2" id="AlternatePhone2" value="" />
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <div class="clear">
                                    <label>移动电话<span class="num">1</span></label>
                                    <input type="text" name="MobilePhone" id="MobilePhone" value="" />
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <div class="clear">
                                    <label>公司类型</label>
                                    <asp:DropDownList ID="CompanyType" runat="server"></asp:DropDownList>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <div class="clear">
                                    <label>客户经理</label>
                                    <asp:DropDownList ID="AccountManger" runat="server"></asp:DropDownList>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <div class="clear">
                                    <label>市场领域</label>
                                    <asp:DropDownList ID="MarketSegment" runat="server"></asp:DropDownList>
                                </div>
                            </td>
                            <%if (parent_account != null) { %>
                                    <tr>
                                <td>
                                    <div class="clear">
                                        <label>父客户名称</label>
                                        <input type="text" name="ParentComoanyName" id="ParentComoanyName" value="" /><i onclick="chooseCompany();" style="width: 20px;height:20px; float: left; margin-left: -1px;margin-top:5px; background: url(../Images/data-selector.png) no-repeat;"></i>
                                        <input type="hidden" id="ParentComoanyNameHidden" name="parent_company_name" value="<%=parent_account.id %>" />
                                    </div>
                                </td>
                            </tr>
                            <%}else{ %>
                             <tr>
                                <td>
                                    <div class="clear">
                                        <label>父客户名称</label>
                                        <input type="text" name="ParentComoanyName" id="ParentComoanyName" value="" /><i onclick="chooseCompany();" style="width: 20px;height:20px; float: left; margin-left: 10px;margin-top:5px; background: url(../Images/data-selector.png) no-repeat;"></i>
                                        <input type="hidden" id="ParentComoanyNameHidden" name="parent_company_name" value="" />
                                    </div>
                                </td>
                            </tr>
                            <%} %>
                    
                        <tr>
                            <td>
                                <div class="clear">
                                    <label>客户编号</label>
                                    <input type="text" name="CompanyNumber" id="CompanyNumber" value="" />

                                </div>
                            </td>
                        </tr>



                    </table>
                </div>

            </div>
            <div class="information clear">
                <p class="informationTitle"><i></i>客户自定义</p>
                <div>
                    <div>
                        <table border="none" cellspacing="" cellpadding="" style="width: 650px; margin-left: 40px;">

                            <% if (company_udfList != null && company_udfList.Count > 0)
                                {
                                    foreach (var udf in company_udfList)
                                    {
                                        if (udf.data_type == (int)EMT.DoneNOW.DTO.DicEnum.UDF_DATA_TYPE.SINGLE_TEXT)    /* 单行文本*/
                                        {%>
                            <tr>
                                <td>
                                    <label><%=udf.col_name %></label>
                                    <input type="text" name="<%=udf.id %>" class="sl_cdt" />

                                </td>
                            </tr>
                            <%}
                                else if (udf.data_type == (int)EMT.DoneNOW.DTO.DicEnum.UDF_DATA_TYPE.MUILTI_TEXT)       /* 多行文本 */
                                {%>
                            <tr>
                                <td>
                                    <label><%=udf.col_name %></label>
                                    <textarea name="<%=udf.id %>" rows="2" cols="20"></textarea>

                                </td>
                            </tr>
                            <%}
                                else if (udf.data_type == (int)EMT.DoneNOW.DTO.DicEnum.UDF_DATA_TYPE.DATETIME)    /* 日期 */
                                {%><tr>
                                    <td>
                                        <label><%=udf.col_name %></label>

                                        <input type="text" name="<%=udf.id %>" class="form_datetime sl_cdt" />

                                    </td>
                                </tr>
                            <%}
                                else if (udf.data_type == (int)EMT.DoneNOW.DTO.DicEnum.UDF_DATA_TYPE.NUMBER)         /*数字*/
                                {%>
                            <tr>
                                <td>
                                    <label><%=udf.col_name %></label>

                                    <input type="text" name="<%=udf.id %>" class="form_datetime sl_cdt" maxlength="11" onkeyup="value=value.replace(/[^\d]/g,'') " onbeforepaste="clipboardData.setData('text',clipboardData.getData('text').replace(/[^\d]/g,''))" />
                                </td>
                            </tr>
                            <%}
                                else if (udf.data_type == (int)EMT.DoneNOW.DTO.DicEnum.UDF_DATA_TYPE.LIST)            /*列表*/
                                {%>

                            <%}
                                    }
                                } %>
                        </table>

                    </div>
                </div>

            </div>
            <div class="information clear">
                <p class="informationTitle"><i></i>联系人自定义</p>
                <div>
                    <div>

                             <table border="none" cellspacing="" cellpadding="" style="width: 650px; margin-left: 40px;">

                            <% if (contact_udfList != null && contact_udfList.Count > 0)
                                {
                                    foreach (var udf in contact_udfList)
                                    {
                                        if (udf.data_type == (int)EMT.DoneNOW.DTO.DicEnum.UDF_DATA_TYPE.SINGLE_TEXT)    /* 单行文本*/
                                        {%>
                            <tr>
                                <td>
                                    <label><%=udf.col_name %></label>
                                    <input type="text" name="<%=udf.id %>" class="sl_cdt" />

                                </td>
                            </tr>
                            <%}
                                else if (udf.data_type == (int)EMT.DoneNOW.DTO.DicEnum.UDF_DATA_TYPE.MUILTI_TEXT)       /* 多行文本 */
                                {%>
                            <tr>
                                <td>
                                    <label><%=udf.col_name %></label>
                                    <textarea name="<%=udf.id %>" rows="2" cols="20"></textarea>

                                </td>
                            </tr>
                            <%}
                                else if (udf.data_type == (int)EMT.DoneNOW.DTO.DicEnum.UDF_DATA_TYPE.DATETIME)    /* 日期 */
                                {%><tr>
                                    <td>
                                        <label><%=udf.col_name %></label>

                                        <input type="text" name="<%=udf.id %>" class="form_datetime sl_cdt" />

                                    </td>
                                </tr>
                            <%}
                                else if (udf.data_type == (int)EMT.DoneNOW.DTO.DicEnum.UDF_DATA_TYPE.NUMBER)         /*数字*/
                                {%>
                            <tr>
                                <td>
                                    <label><%=udf.col_name %></label>

                                    <input type="text" name="<%=udf.id %>" class="form_datetime sl_cdt" maxlength="11" onkeyup="value=value.replace(/[^\d]/g,'') " onbeforepaste="clipboardData.setData('text',clipboardData.getData('text').replace(/[^\d]/g,''))" />
                                </td>
                            </tr>
                            <%}
                                else if (udf.data_type == (int)EMT.DoneNOW.DTO.DicEnum.UDF_DATA_TYPE.LIST)            /*列表*/
                                {%>

                            <%}
                                    }
                                } %>
                        </table>
                 

                    </div>
                </div>

            </div>

            <div class="information clear">
                <p class="informationTitle"><i></i>备注</p>
                <div>


                    <table border="none" cellspacing="" cellpadding="" style="width: 650px; margin-left: 40px;">
                        <tr>
                            <th></th>

                        </tr>

                        <tr>
                            <td>
                                <div class="clear">
                                    <label>活动类型</label>
                                    <asp:DropDownList ID="note_action_type" runat="server"></asp:DropDownList>
                                </div>
                            </td>

                        </tr>
                        <tr>
                            <td>
                                <div class="clear">
                                    <label>开始时间</label>
                                    <input type="datetime-local" name="note_start_time" id="note_start_time" value="" />
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <div class="clear">
                                    <label>结束时间</label>
                                    <input type="datetime-local" name="note_end_time" id="note_end_time" value="" />
                                </div>
                            </td>
                            <td></td>
                        </tr>
                    </table>
                    <table border="none" cellspacing="" cellpadding="" style="width: 650px; margin-left: 40px;">
                        <tr>
                            <td>
                                <div class="clear">
                                    <label>备注描述</label>
                                    <textarea id="todo_description" name="todo_description" cols="20" rows="2"></textarea>
                                </div>
                            </td>
                        </tr>
                    </table>

                </div>

            </div>

            <div class="information clear">
                <p class="informationTitle"><i></i>待办</p>
                <div>
                    <div style="clear: both; margin-top: 20px;">
                        <table border="none" cellspacing="" cellpadding="" style="width: 650px; margin-left: 40px;">
                            <tr>
                                <th></th>

                            </tr>
                            <tr>
                                <td>
                                    <div class="clear">
                                        <label>活动类型</label>
                                        <asp:DropDownList ID="todo_action_type" runat="server"></asp:DropDownList>
                                    </div>

                                </td>

                            </tr>
                            <tr>
                                <td>
                                    <div class="clear">
                                        <label>负责人</label>
                                        <asp:DropDownList ID="assigned_to" runat="server">
                                            <asp:ListItem Value="1">测试</asp:ListItem>
                                            <asp:ListItem Value="0">    </asp:ListItem>
                                        </asp:DropDownList>
                                    </div>

                                </td>

                            </tr>
                            <tr>
                                <td>
                                    <div class="clear">
                                        <label>开始时间</label>
                                        <input type="datetime-local" name="todo_start_time" id="todo_start_time" value="" />
                                    </div>

                                </td>

                            </tr>
                            <tr>
                                <td>
                                    <div class="clear">
                                        <label>结束时间</label>
                                        <input type="datetime-local" name="todo_end_time" id="todo_end_time" value="" />
                                    </div>

                                </td>

                            </tr>
                        </table>
                        <table border="none" cellspacing="" cellpadding="" style="width: 650px; margin-left: 40px;">
                            <tr>
                                <td>
                                    <div class="clear">
                                        <label>活动描述</label>
                                        <textarea id="note_description" name="note_description" cols="20" rows="2"></textarea>
                                    </div>

                                </td>
                            </tr>
                        </table>
                    </div>
                </div>

            </div>

        </div>

        <div class="content clear" style="display:none;" >

        </div>
        <div class="content clear" style="display:none;" >

            <div class="left fl">
                <ul>
                    <% if (site_udfList != null && site_udfList.Count > 0)
                        {
                            foreach (var udf in site_udfList)
                            {
                                if (udf.data_type == (int)EMT.DoneNOW.DTO.DicEnum.UDF_DATA_TYPE.SINGLE_TEXT)    /* 单行文本*/
                                {%>
                    <li>
                        <label><%=udf.name %></label>
                        <input type="text" name="<%=udf.id %>" class="sl_cdt" />

                    </li>
                    <%}
                        else if (udf.data_type == (int)EMT.DoneNOW.DTO.DicEnum.UDF_DATA_TYPE.MUILTI_TEXT)       /* 多行文本 */
                        {%>
                    <li>
                        <label><%=udf.name %></label>
                        <textarea name="<%=udf.id %>" rows="2" cols="20"></textarea>

                    </li>
                    <%}
                        else if (udf.data_type == (int)EMT.DoneNOW.DTO.DicEnum.UDF_DATA_TYPE.DATETIME)    /* 日期 */
                        {%><li>
                            <label><%=udf.name %></label>
                            <input type="text" name="<%=udf.id %>" class="form_datetime sl_cdt" />
                        </li>
                    <%}
                        else if (udf.data_type == (int)EMT.DoneNOW.DTO.DicEnum.UDF_DATA_TYPE.NUMBER)         /*数字*/
                        {%>
                    <li>
                        <label><%=udf.name %></label>

                        <input type="text" name="<%=udf.id %>" class="form_datetime sl_cdt" maxlength="11" onkeyup="value=value.replace(/[^\d]/g,'') " onbeforepaste="clipboardData.setData('text',clipboardData.getData('text').replace(/[^\d]/g,''))" />
                    </li>
                    <%}
                        else if (udf.data_type == (int)EMT.DoneNOW.DTO.DicEnum.UDF_DATA_TYPE.LIST)            /*列表*/
                        {%>

                    <%}
                            }
                        } %>
                </ul>
            </div>

        </div>


    </form>
</body>
<script src="../Scripts/jquery-3.1.0.min.js" type="text/javascript" charset="utf-8"></script>

<script src="../Scripts/index.js"></script>
<script src="../Scripts/common.js"></script>
<script src="../Scripts/Common/Address.js" type="text/javascript" charset="utf-8"></script>
<script type="text/javascript">
    $(document).ready(function () {
        InitArea();
    });
</script>
</html>
<script type="text/javascript">
    $(function () {
        $("#TaxExempt").click(function () {
            debugger;
            if ($('#TaxExempt').is(':checked')) {
                // 禁用
                $("#TaxRegion").attr("disabled", "disabled");

            }
            else {
                // 解除禁用
                $("#TaxRegion").removeAttr("disabled");
            }
        });  // 选中免税，税区不可在进行编辑的事件处理

        $("#save_close").click(function () {
            if (!submitcheck()) {
                return false;
            }
        });   // 保存并关闭的事件

        $("#save_newAdd").click(function () {
            if (!submitcheck()) {
                return false;
            }
        });   // 保存并新建的事件

        $("#save_create_opportunity").click(function () {
            if (!submitcheck()) {
                return false;
            }
        });   // 保存并创建商机的事件

        $("#close").click(function () {
            if (navigator.userAgent.indexOf("MSIE") > 0) {
                if (navigator.userAgent.indexOf("MSIE 6.0") > 0) {
                    window.opener = null;
                    window.close();
                } else {
                    window.open('', '_top');
                    window.top.close();
                }
            }
            else if (navigator.userAgent.indexOf("Firefox") > 0) {
                window.location.href = 'about:blank ';
            } else {
                window.opener = null;
                window.open('', '_self', '');
                window.close();
            }
        });  // 直接关闭窗口

        $("#first_name").blur(function () {
            var firstName = $(this).val();
            var lastName = $("#last_name").val();
            if (firstName.length > 1 && lastName == "") {
                var subName = firstName.substring(1, firstName.length)
                $("#last_name").val(subName);
                $(this).val(firstName.substring(0,1));
            }
        });

        function submitcheck() {
            var companyName = $("#company_name").val();          //  公司名称--必填项校验
            if (companyName == null || companyName == '') {
                alert("请输入公司名称");
                // alert(companyName);
                return false;
            }
            var phone = $("#Phone").val();                        //  电话-- 必填项校验
            if (phone == null || phone == '') {
                alert("请输入电话名称");
                return false;
            }
            if (!checkPhone(phone)) {
                alert("请输入正确格式的电话！");
                return false;
            }
            var firstName = $("#first_name").val();                                  // 姓
            var lastName = $("#last_name").val();                                    // 名
            var country = $("#country_id").val();                                      // 国家
            var province = $("#province_id").val();                                    // 省份
            var city = $("#city_id").val();                                            // 城市
            var district = $("#district_id").val();
            if (country == "" || province == "" || city == "") {
                alert("请填写选择地址");                                           // 地址下拉框的必填校验
                return false;
            }
            var address = $("#address").val();                                      // 地址信息
            if (address == null || address == '') {
                alert("请完善地址信息");                                              // 地址的必填校验
                return false;
            }



            var email = $("#Email").val();
            //alert(Trim(email,'g'));
            if (email != '') {
                if (!checkEmail(email)) {
                    alert("请输入正确格式的邮箱！");
                    return false;
                }
            }

            // 邮编验证
            var postal_code = $("#postal_code").val();
            //alert(Trim(email, 'g'));
            if (postal_code != '') {
                if (!checkPostalCode(postal_code)) {
                    alert("请输入正确的邮编！");
                    return false;
                }
            }

            debugger;
            if ($("#isCheckCompanyName").val() == "yes") {
                var isPass = "pass";
                $.ajax({
                    type: "GET",
                    async: false,
                    url: "../Tools/CompanyAjax.ashx?act=name&companyName=" + companyName,
                    // data: { CompanyName: companyName },
                    success: function (data) {
                        //alert(data);
                        debugger;
                        if (data == "repeat") {
                            alert('客户名称重复');
                            isPass = "noPass";
                        }
                        else if (data != "") {
                            isPass = "noPass";
                            window.open("CompanyNameSimilar.aspx?ids=" + data + "&reason=name", "<%=EMT.DoneNOW.DTO.OpenWindow.CompanyNameSmilar %>", "height=600,width=800", "toolbar =no", "menubar=no", "scrollbars=no", "resizable=no", "location=no", "status=no"); 
                        }  //
                    },
                    error: function (XMLHttpRequest) {
                    },
                    
                });
                debugger;
                if (isPass == "noPass") {
                    return false;
                }    
            }
            return true;
        }

        var conteneClickTimes = 0;       // 定义tab页跳转点击次数，免得一直提醒
        $.each($(".nav-title li"), function (i) {
            $(this).click(function () {
                var firstName = $("#first_name").val();
                if ($(this).attr("id") != "general" && conteneClickTimes == 0) {
                    if (firstName == "") {
                        if (confirm("请输入姓。如果继续，则该联系人不会生成")) {
                            conteneClickTimes += 1;
                            $(this).addClass("boders").siblings("li").removeClass("boders");
                            $(".content").eq(i).show().siblings(".content").hide();
                        }
                        else {
                            return false;
                        }
                    }
                  
                }
              
                $(this).addClass("boders").siblings("li").removeClass("boders");
                $(".content").eq(i).show().siblings(".content").hide();
             

            })
        });
    })

    

    function chooseCompany() {
        window.open("../Common/SelectCallBack.aspx?type=查找客户&field=ParentComoanyName", '<%=EMT.DoneNOW.DTO.OpenWindow.CompanySelect %>', 'left=200,top=200,width=600,height=800', false);
        //window.open(url, "newwindow", "height=200,width=400", "toolbar =no", "menubar=no", "scrollbars=no", "resizable=no", "location=no", "status=no");
        //这些要写在一行
    }

</script>

