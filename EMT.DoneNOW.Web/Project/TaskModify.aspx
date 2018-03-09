<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="TaskModify.aspx.cs" Inherits="EMT.DoneNOW.Web.Project.TaskEdit" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <link href="../Content/reset.css" rel="stylesheet" />
    <link href="../Content/NewConfigurationItem.css" rel="stylesheet" />
    <link href="../Content/DynamicContent.css" rel="stylesheet" />
    <title>转发/修改</title>
    <style>
        .ProjectInfo_Inset {
            background-color: #F0F5FB;
            border: 1px solid #D7D7D7;
            padding: 10px;
        }

        table {
            display: table;
            border-collapse: separate;
            border-spacing: 2px;
            border-color: grey;
        }

        .ProjectInfo_TextBold {
            font-size: 12px;
            color: #4f4f4f;
            font-weight: 700;
        }

        .ProjectInfo_Button {
            color: #376597;
            font-size: 12px;
        }

        .ProjectInfo_Text {
            font-size: 12px;
            color: #333;
        }

        .ProjectInfo_Inset > table > tbody > tr > td {
            vertical-align: top;
        }
        #save{
            background-color: #f3f3f3;
            font-weight: 600;
            color: #4f4f4f;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="Active ThemePrimaryColor TitleBar">
            <div class="Title"><span class="Text">转发/修改</span><span class="SecondaryText"></span></div>
            <div class="TitleBarButton Star" id="za129bcc0139b41ea8e2f627eb64b9cd3" title="Bookmark this page">
                <div class="TitleBarIcon Star"></div>
            </div>
            <div class="ContextHelpButton" onclick=""></div>
        </div>
        <div class="PageContentContainer">
            <div class="PageHeadingContainer">
                <div class="ValidationSummary" id="za5428cdc14ae42d99d7dfb4b7578ff93">
                    <div class="CustomValidation Valid"></div>
                    <div class="FormValidation Valid">
                        <div class="ErrorContent">
                            <div class="TransitionContainer">
                                <div class="IconContainer">
                                    <div class="Icon"></div>
                                </div>
                                <div class="TextContainer"><span class="Count"></span><span class="Count Spacer"></span><span class="Message"></span></div>
                            </div>
                        </div>
                        <div class="ChevronContainer">
                            <div class="Up"></div>
                            <div class="Down"></div>
                        </div>
                    </div>
                </div>
                <div class="ButtonContainer">
                    <div class="DropDownButtonContainer f1">
                        <div class="Left">
                            <a class="NormalState Button ButtonIcon Save" id="SaveDropDownButton_LeftButton" tabindex="0"><span class="Icon" style="background: url(../Images/ButtonBarIcons.png) no-repeat -32px 0;"></span><span class="Text">
                                <asp:Button ID="save" runat="server" Text="保存" BorderStyle="None" OnClick="save_Click" /></span></a>
                        </div>
                    </div>
                    <a class="NormalState Button ButtonIcon Cancel" id="CancelButton" tabindex="0"><span class="Icon" style="background: url(../Images/ButtonBarIcons.png) no-repeat -96px 0;"></span><span class="Text">关闭</span></a>
                </div>
            </div>
            <div class="ScrollingContentContainer">
                <div class="ScrollingContainer" id="za7dce764d22b4572aaf851391e3b7f6f" style="left: 0; overflow-x: auto; overflow-y: auto; position: fixed; right: 0; bottom: 0; top: 85px;">

                    <div class="Normal Section">
                        <div class="Heading">
                            <div class="Left"><span class="Text">常规信息</span><span class="SecondaryText"></span></div>
                            <div class="Spacer"></div>
                        </div>
                        <div class="Content">
                            <div class="Normal Column">
                                <div class="EditorLabelContainer">
                                    <div class="Label">
                                        <label for="title">任务标题</label><span class="Required">*</span>
                                    </div>
                                </div>
                                <div class="Editor TextBox" data-editor-id="Title" data-rdp="Title">
                                    <div class="InputField">
                                        <input id="title" type="text" value="<%=titleValue %>" name="title" /><span class="CustomHtml"><a class="NormalState Button ButtonIcon IconOnly ProjectTask" id="TaskLibraryButton" tabindex="0" title="Task Library" onclick=""><span class="Icon" style="background: url(../Images/ButtonBarIcons.png) no-repeat -16px -79px;"></span><span class="Text"></span></a></span>
                                    </div>
                                </div>

                            </div>
                            <div class="Normal Column">
                                <div class="CustomLayoutContainer">

                                    <div class="ProjectInfo_Inset">
                                        <table>
                                            <tr>
                                                <td>
                                                    <span class="ProjectInfo_TextBold">项目:</span>
                                                </td>
                                                <td>
                                                    <div>
                                                        <a class="ProjectInfo_Button" href="#" onclick="OpenPro('<%=thisProject.id %>')"><%=thisProject.name %></a>
                                                    </div>
                                                    <div class="ProjectInfo_Text"><%=((DateTime)thisProject.start_date).ToString("yyyy-MM-dd") %> - <%=((DateTime)thisProject.end_date).ToString("yyyy-MM-dd") %></div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td><%
                                                        EMT.DoneNOW.Core.crm_account proAccount = new EMT.DoneNOW.DAL.crm_account_dal().FindNoDeleteById(thisProject.account_id);

                                                %>
                                                    <span class="ProjectInfo_TextBold">客户:</span>
                                                </td>
                                                <td>
                                                    <div>
                                                        <a class="ProjectInfo_Button" onclick="window.open('../Company/ViewCompany.aspx?id=<%=proAccount.id %>','<%=(int)EMT.DoneNOW.DTO.OpenWindow.CompanyView %>','left=200,top=200,width=900,height=750', false);"><%=proAccount.name %></a>
                                                    </div>
                                                    <% var defaultLocation = new EMT.DoneNOW.BLL.LocationBLL().GetLocationByAccountId(proAccount.id);



                                                    %>
                                                    <div class="ProjectInfo_Text">
                                                        <%
                                                            var country = dic.FirstOrDefault(_ => _.Key == "country").Value as List<EMT.DoneNOW.DTO.DictionaryEntryDto>;//district
                                                            var addressdistrict = dic.FirstOrDefault(_ => _.Key == "addressdistrict").Value as List<EMT.DoneNOW.DTO.DictionaryEntryDto>;
                                                        %>
                                                        <%=country.First(_=>_.val.ToString()==defaultLocation.country_id.ToString()).show  %>
                                                        <%=addressdistrict.First(_=>_.val.ToString()==defaultLocation.province_id.ToString()).show  %>
                                                        <%=addressdistrict.First(_=>_.val.ToString()==defaultLocation.city_id.ToString()).show  %>
                                                        <%=addressdistrict.First(_=>_.val.ToString()==defaultLocation.district_id.ToString()).show  %>
                                                    </div>
                                                    <div class="ProjectInfo_Text"><%=defaultLocation.address %> <%=defaultLocation.additional_address %></div>
                                                    <div class="ProjectInfo_Text"><%=proAccount.phone %></div>
                                                </td>
                                            </tr>
                                        </table>
                                    </div>
                                </div>
                            </div>


                            <div class="Normal Column" style="margin-top: -80px;">
                                <div class="EditorLabelContainer">
                                    <div class="Label">
                                        <label for="status_id">状态</label>
                                    </div>
                                </div>
                                <div class="Editor SingleSelect" data-editor-id="Status" data-rdp="Status">
                                    <div class="InputField">
                                        <asp:DropDownList ID="status_id" runat="server"></asp:DropDownList>

                                    </div>
                                </div>
                                <div class="Medium Column">
                                    <div class="EditorLabelContainer">
                                        <div class="Label">
                                            <label for="priority">优先级<span class="SecondaryText">保留空白以保留当前值</span></label>
                                        </div>
                                    </div>
                                    <div class="Editor IntegerBox" data-editor-id="Priority" data-rdp="Priority">
                                        <div class="InputField">
                                            <input id="priority" type="text" value="<%=priorityValue==null?"":priorityValue.ToString() %>" name="priority" maxlength="5" onkeyup="this.value=this.value.replace(/\D/g,'')" onafterpaste="this.value=this.value.replace(/\D/g,'')" />
                                        </div>
                                    </div>
                                </div>

                                <div class="RadioButtonGroupContainer">
                                    <div class="RadioButtonGroupLabel">
                                        <div><span class="Label">显示在客户端</span></div>
                                    </div>
                                    <div class="Editor RadioButton" data-editor-id="DisplayInCapYes" data-rdp="DisplayInCapYes">
                                        <div class="InputField">
                                            <div>
                                                <asp:RadioButton ID="DisplayInCapYes" runat="server" GroupName="DisplayInCap" />
                                            </div>
                                            <div class="EditorLabelContainer">
                                                <div class="Label">
                                                    <label for="DisplayInCapYes">是，允许客户端用户完成</label>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="Editor RadioButton" data-editor-id="DisplayInCapYesNoComplete" data-rdp="DisplayInCapYesNoComplete">
                                        <div class="InputField">
                                            <div>
                                                <asp:RadioButton ID="DisplayInCapYesNoComplete" runat="server" GroupName="DisplayInCap" />
                                            </div>
                                            <div class="EditorLabelContainer">
                                                <div class="Label">
                                                    <label for="DisplayInCapYesNoComplete">是，不允许客户端用户完成</label>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="Editor RadioButton" data-editor-id="DisplayInCapNone" data-rdp="DisplayInCapNone">
                                        <div class="InputField">
                                            <div>
                                                <asp:RadioButton ID="DisplayInCapNone" runat="server" GroupName="DisplayInCap" />

                                            </div>
                                            <div class="EditorLabelContainer">
                                                <div class="Label">
                                                    <label for="DisplayInCapNone">否</label>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <%if (!string.IsNullOrEmpty(displayWayValue))
                                        { %>
                                    <div class="Editor RadioButton" data-editor-id="DisplayInCapNone" data-rdp="DisplayInCapNone">
                                        <%}
                                        else
                                        { %>
                                        <div class="Editor RadioButton" data-editor-id="DisplayInCapNone" data-rdp="DisplayInCapNone" style="display:none">
                                        <%} %>
                                        <div class="InputField">
                                            <div>
                                                <asp:RadioButton ID="noChange" runat="server" GroupName="DisplayInCap" />

                                            </div>
                                            <div class="EditorLabelContainer">
                                                <div class="Label">
                                                    <label for="DisplayInCapNone">多个选择-保持不变</label>
                                                </div>
                                            </div>
                                        </div>
                                    </div>


                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="Normal Section">
                        <div class="Heading">
                            <div class="Left"><span class="Text">日程表</span><span class="SecondaryText"></span></div>
                            <div class="Spacer"></div>
                        </div>
                        <%--     <div class="DescriptionText"></div>--%>
                        <div class="Content">
                            <div class="Normal Column">
                                <div class="RadioButtonGroupContainer">
                                    <div class="RadioButtonGroupLabel">
                                        <div><span class="Label">任务类型</span></div>
                                    </div>
                                    <div class="Editor RadioButton" data-editor-id="TaskTypeFixedWork" data-rdp="TaskTypeFixedWork">
                                        <div class="InputField">
                                            <div>
                                                <asp:RadioButton ID="TaskTypeFixedWork" runat="server" GroupName="TaskType" />
                                            </div>
                                            <div class="EditorLabelContainer">
                                                <div class="Label">
                                                    <label for="TaskTypeFixedWork">固定工作</label>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="Editor RadioButton" data-editor-id="TaskTypeFixedDuration" data-rdp="TaskTypeFixedDuration">
                                        <div class="InputField">
                                            <div>
                                                <asp:RadioButton ID="TaskTypeFixedDuration" runat="server" GroupName="TaskType" />
                                            </div>
                                            <div class="EditorLabelContainer">
                                                <div class="Label">
                                                    <label for="TaskTypeFixedDuration">固定时间</label>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <%if (!string.IsNullOrEmpty(fixTypeValue))
                                        { %>
                                    <div class="Editor RadioButton" data-editor-id="TaskTypeFixedDuration" data-rdp="TaskTypeFixedDuration">
                                           <%}
    else
    { %>
 <div class="Editor RadioButton" data-editor-id="TaskTypeFixedDuration" data-rdp="TaskTypeFixedDuration" style="display:none;">
                                        <%} %>
                                        <div class="InputField">
                                            <div>
                                                <asp:RadioButton ID="typeNoChange" runat="server" GroupName="TaskType" />
                                            </div>
                                            <div class="EditorLabelContainer">
                                                <div class="Label">
                                                    <label for="TaskTypeFixedDuration">多个选择-保持不变</label>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                 
                                </div>
                                <div class="EditorLabelContainer">
                                    <div class="Label">
                                        <label for="EstimatedHours">预估时间<span class="SecondaryText"><%=estHoursValue==null?"保留空白以保留当前值":"" %></span></label>
                                    </div>
                                </div>
                                <div class="Editor DecimalBox">
                                    <div class="InputField">
                                        <input id="estimated_hours" type="text" value="<%=estHoursValue==null?"":((decimal)estHoursValue).ToString("#0.00") %>" name="estimated_hours" maxlength="10" class="To2Input" />
                                    </div>
                                </div>
                            </div>

                        </div>
                    </div>

                    <div class="Normal Section" id="AssignSectionHeader">
                        <div class="Heading" data-toggle-enabled="true">
                            <div class="Toggle Collapse Toggle1">
                                <div class="Vertical"></div>
                                <div class="Horizontal"></div>
                            </div>
                            <div class="Left"><span class="Text">分配</span><span class="SecondaryText"></span></div>
                            <div class="Spacer"></div>
                        </div>
                        <div class="Content">
                            <div class="Normal Column">
                                <div class="EditorLabelContainer">
                                    <div class="Label">
                                        <label for="department_id">部门</label>
                                    </div>
                                </div>
                                <div class="Editor SingleSelect" data-editor-id="Department" data-rdp="Department">
                                    <div class="InputField">
                                        <asp:DropDownList ID="department_id" runat="server"></asp:DropDownList>
                                        <span class="CustomHtml"><a class="NormalState Button ButtonIcon IconOnly Report" id="WorkloadReportButton" tabindex="0" title="Workload Report"><span class="Icon"></span><span class="Text"></span></a></span>
                                    </div>
                                </div>
                            </div>
                            <div class="Normal Column">
                                <div class="Editor CheckBox" data-editor-id="FilterResourcesByProjectBillingRoles" data-rdp="FilterResourcesByProjectBillingRoles">
                                    <div class="InputField">
                                        <div>
                                            <input id="FilterResByProBilRoles" type="checkbox" value="true" name="FilterResByProBilRoles" />
                                        </div>
                                        <div class="EditorLabelContainer">
                                            <div class="Label">
                                                <label for="FilterResourcesByProjectBillingRoles">通过项目计费角色过滤员工</label>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="Normal Column">
                                <div class="EditorLabelContainer">
                                    <div class="Label">
                                        <label for="WorkType">工作类型<span class="SecondaryText">(分配员工必填)</span></label>
                                    </div>
                                </div>
                                <div class="Editor SingleSelect" data-editor-id="WorkType" data-rdp="WorkType">
                                    <div class="InputField">
                                        <select id="WorkType" name="WorkType">
                                        </select>
                                    </div>
                                </div>
                            </div>
                            <div class="Normal Column">
                                <div class="EditorLabelContainer">
                                    <div class="Label">
                                        <label for="PrimaryResource">主负责人</label>
                                    </div>
                                </div>
                                <div class="Editor DataSelector" data-editor-id="PrimaryResource" data-rdp="PrimaryResource">
                                    <div class="InputField">
                                        <% EMT.DoneNOW.Core.sys_resource thisRes = null;
                                            if (priResValue != null)
                                            {
                                                if (priResValue != 0)
                                                {
                                                    thisRes = new EMT.DoneNOW.DAL.sys_resource_dal().FindNoDeleteById((long)priResValue);
                                                }
                                                else
                                                {
                                                    thisRes = new EMT.DoneNOW.Core.sys_resource();
                                                    thisRes.id = 0;
                                                    thisRes.name = "多个值-保持不变";
                                                }

                                            }
                                        %>
                                        <input id="owner_resource_id" type="text" value="<%=thisRes==null?"":thisRes.name %>" autocomplete="off" style="width: 250px;" />
                                        <input type="hidden" name="owner_resource_id" id="owner_resource_idHidden" value="<%=thisRes==null?"":thisRes.id.ToString() %>" />
                                        <a class="NormalState Button ButtonIcon IconOnly DataSelector" id="PrimaryResource_Button" tabindex="0" onclick="ChoosePriRes()"><span class="Icon" style="background: url(../Images/data-selector.png) no-repeat;"></span><span class="Text"></span></a>
                                        <div class="ContextOverlayContainer" id="PrimaryResource_ContextOverlay">
                                            <div class="AutoComplete ContextOverlay">
                                                <div class="Active LoadingIndicator"></div>
                                                <div class="Content"></div>
                                            </div>
                                            <div class="AutoComplete ContextOverlay">
                                                <div class="Active LoadingIndicator"></div>
                                                <div class="Content"></div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                          <%--      <div class="Editor CheckBox" data-editor-id="FilterResourcesByProjectBillingRoles" data-rdp="FilterResourcesByProjectBillingRoles">
                                    <div class="InputField">
                                        <div>
                                            <input id="AddThisRes" type="checkbox" value="true" name="FilterResByProBilRoles" />
                                        </div>
                                        <div class="EditorLabelContainer">
                                            <div class="Label">
                                                <label for="FilterResourcesByProjectBillingRoles">添加到上面选定的主要资源的工作列表</label>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="Editor CheckBox" data-editor-id="FilterResourcesByProjectBillingRoles" data-rdp="FilterResourcesByProjectBillingRoles">
                                    <div class="InputField">
                                        <div>
                                            <input id="RemoveThisRes" type="checkbox" value="true" name="FilterResByProBilRoles" />
                                        </div>
                                        <div class="EditorLabelContainer">
                                            <div class="Label">
                                                <label for="FilterResourcesByProjectBillingRoles">从旧的主资源的工作列表中删除</label>
                                            </div>
                                        </div>
                                    </div>
                                </div>--%>
                            </div>
                        </div>
                    </div>

                      <div class="Normal Section" id="UdfSectionHeader">
                        <div class="Heading" data-toggle-enabled="true">
                            <div class="Toggle Collapse Toggle2">
                                <div class="Vertical"></div>
                                <div class="Horizontal"></div>
                            </div>
                            <div class="Left"><span class="Text">用户自定义字段</span><span class="SecondaryText"></span></div>
                            <div class="Spacer"></div>
                        </div>
                        <div class="Content">
                            <%if (udfTaskPara != null && udfTaskPara.Count > 0)
                                {
                                    foreach (var udf in udfTaskPara)
                                    {

                                        if (udf.data_type == (int)EMT.DoneNOW.DTO.DicEnum.UDF_DATA_TYPE.SINGLE_TEXT)    /* 单行文本*/
                                        {%>
                            <div class="Normal Column">
                                <div class="Udf EditorLabelContainer">
                                    <div class="Label">
                                        <label><%=udf.name %></label>
                                    </div>
                                </div>
                                <div class="Editor DateBox Udf">
                                    <div class="InputField">
                                        <div class="Container">
                                            <input type="text" name="<%=udf.id %>" class="sl_cdt" value="<%=udfValue.FirstOrDefault(_ => _.id == udf.id)==null?"": udfValue.FirstOrDefault(_ => _.id == udf.id).value.ToString() %>" />
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <%}
                                else if (udf.data_type == (int)EMT.DoneNOW.DTO.DicEnum.UDF_DATA_TYPE.MUILTI_TEXT)       /* 多行文本 */
                                {
                            %>
                            <div class="Normal Column">
                                <div class="Udf EditorLabelContainer">
                                    <div class="Label">
                                        <label><%=udf.name %></label>
                                    </div>
                                </div>
                                <div class="Editor DateBox Udf">
                                    <div class="InputField">
                                        <div class="Container">
                                            <textarea name="<%=udf.id %>" rows="2" cols="20"><%=udfValue.FirstOrDefault(_ => _.id == udf.id).value  %></textarea>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <%}
                                else if (udf.data_type == (int)EMT.DoneNOW.DTO.DicEnum.UDF_DATA_TYPE.DATETIME)
                                {
                            %>
                            <div class="Normal Column">
                                <div class="Udf EditorLabelContainer">
                                    <div class="Label">
                                        <label><%=udf.name %></label>
                                    </div>
                                </div>
                                <div class="Editor DateBox Udf">
                                    <div class="InputField">
                                        <div class="Container">
                                            <%

                                                string val = "";

                                                object value = udfValue.FirstOrDefault(_ => _.id == udf.id).value;
                                                if (value != null && (!string.IsNullOrEmpty(value.ToString())))
                                                {
                                                    if (value.ToString() != "多个值-保持不变")
                                                    {
                                                        val = DateTime.Parse(value.ToString()).ToString("yyyy-MM-dd");
                                                    }
                                                    
                                                }

                                            %>
                                            <input type="text" onclick="WdatePicker()" name="<%=udf.id %>" class="sl_cdt" value="<%=val %>" />
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <% }
                                else if (udf.data_type == (int)EMT.DoneNOW.DTO.DicEnum.UDF_DATA_TYPE.NUMBER)
                                {
                            %>
                            <div class="Normal Column">
                                <div class="Udf EditorLabelContainer">
                                    <div class="Label">
                                        <label><%=udf.name %></label>
                                    </div>
                                </div>
                                <div class="Editor DateBox Udf">
                                    <div class="InputField">
                                        <div class="Container">
                                            <input type="text" name="<%=udf.id %>" class="sl_cdt" onkeyup="value=value.replace(/[^\d]/g,'') " onbeforepaste="clipboardData.setData('text',clipboardData.getData('text').replace(/[^\d]/g,''))" value="<%=udfValue.FirstOrDefault(_ => _.id == udf.id).value %>" />
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <%
                                        }
                                        else if (udf.data_type == (int)EMT.DoneNOW.DTO.DicEnum.UDF_DATA_TYPE.LIST)
                                        {

                                        }
                                    }
                                } %>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </form>
</body>
</html>
<script src="../Scripts/jquery-3.1.0.min.js"></script>
<script>
    $(function () {
        GetWorkTypeByDepId();
    })
    function ChoosePriRes() {
        var url = "../Common/SelectCallBack.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.RES_ROLE_DEP_CALLBACK %>&field=owner_resource_id";
        var department_id = $("#department_id").val();
        if (department_id != undefined && department_id != "" && department_id !== "0") {  // 根据部门过滤
            url += "&con961=" + department_id;
        }
        if ($("#FilterResByProBilRoles").is(":checked")) {                                   // 根据项目过滤
            url += "&con962=<%=thisProject.id %>";
        }

        window.open(url, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.CompanySelect %>', 'left=200,top=200,width=600,height=800', false);
    }
    function GetWorkTypeByDepId() {
        // department_id
        var department_id = $("#department_id").val();
        if (department_id != undefined && department_id != "") {
            $.ajax({
                type: "GET",
                async: false,
                url: "../Tools/DepartmentAjax.ashx?act=GetWorkType&department_id=" + department_id,
                success: function (data) {
                    if (data != "") {
                        $("#WorkType").html(data);
                    }
                },
            });
        }
        else {
            $("#WorkType").html("<option value='0'> <option>");
        }

    }
    $("#department_id").change(function () {
        GetWorkTypeByDepId(); // 过滤工作类型
        // 判断主负责人是否在该部门中  todo
        var res_id = $("#owner_resource_idHidden").val();
        var dId = $(this).val();
        if (res_id != "" && dId != "0") {
            $.ajax({
                type: "GET",
                url: "../Tools/DepartmentAjax.ashx?act=IsHasRes&department_id=" + dId + "&resource_id=" + res_id,
                async: false,
                // dataType: "json",
                success: function (data) {
                    debugger;
                    if (data == "True") {
                        $("#owner_resource_idHidden").val("");
                        $("#owner_resource_id").val("");
                    }
                }

            })
        }
        // 成员不用清除，查找带回需要添加部门过滤
    });

    // 项目查看
    function OpenPro(pro_id) {
        window.open("ProjectView?id=" + pro_id, '_blank', 'left=200,top=200,width=900,height=800', false);
    }
</script>
