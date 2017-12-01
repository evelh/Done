<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ProjectTeamManage.aspx.cs" Inherits="EMT.DoneNOW.Web.Project.ProjectTeamManage" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title><%=isAdd?"添加":"修改" %>团队成员</title>
    <link href="../Content/DynamicContent.css" rel="stylesheet" />
    <style>
        body {
            font-size: 12px;
            overflow: auto;
            background: white;
            left: 0;
            top: 0;
            position: relative;
            margin: 0;
        }

        .HeaderRow {
            background-color: #346a95;
            z-index: 100;
            height: 36px;
            padding-left: 10px;
            margin-bottom: 10px;
        }

            .HeaderRow table {
                width: 100%;
                border-collapse: collapse;
            }

            .HeaderRow span {
                color: #FFF;
                top: 10px;
                display: block;
                width: 85%;
                position: absolute;
                text-transform: uppercase;
                font-size: 15px;
                font-weight: bold;
                white-space: nowrap;
                overflow: hidden;
                text-overflow: ellipsis;
            }

        .ButtonBar {
            font-size: 12px;
            padding: 0 10px 10px 10px;
            width: auto;
            background-color: #FFF;
        }

            .ButtonBar ul {
                list-style-type: none;
                padding: 0;
                margin: 0;
                height: 26px;
                width: 100%;
            }

                .ButtonBar ul li {
                    display: block;
                    float: left;
                }

                    .ButtonBar ul li a, .ButtonBar ul li a:visited, .contentButton a, .contentButton a:link, .contentButton a:visited, a.buttons, input.button, .ButtonBar ul li a:visited {
                        background: #d7d7d7;
                        background: -moz-linear-gradient(top,#fff 0,#d7d7d7 100%);
                        background: -webkit-linear-gradient(top,#fff 0,#d7d7d7 100%);
                        background: -ms-linear-gradient(top,#fff 0,#d7d7d7 100%);
                        background: linear-gradient(to bottom,#fff 0,#d7d7d7 100%);
                        border: 1px solid #bcbcbc;
                        display: inline-block;
                        color: #4F4F4F;
                        cursor: pointer;
                        padding: 0 5px 0 3px;
                        position: relative;
                        text-decoration: none;
                        vertical-align: middle;
                        height: 24px;
                    }

        td {
            font-size: 12px;
        }

        #save_close,#save_new {
            border-style: none;
            background-color: #dddddd;
            background: linear-gradient(to bottom,#fff 0,#d7d7d7 100%);
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="HeaderRow">
            <table>
                <tr>
                    <td><span><%=isAdd?"添加":"修改" %>团队成员</span></td>
                    <td class="helpLink" style="text-align: right;"><a class="HelperLinkIcon">
                        <img src="/images/icons/context_help.png?v=41154" border="0" /></a></td>
                </tr>
            </table>
        </div>

        <!-- TOP BUTTONS -->
        <div class="ButtonBar">
            <ul>
                <li><a class="ImgLink" id="HREF_btnSaveClose" name="HREF_btnSaveClose">
                    <span class="icon" style="background: url(../Images/ButtonBarIcons.png) no-repeat -32px 0; width: 16px; height: 16px; display: inline-block; margin: -2px 3px; margin-top: 3px;"></span><span class="Text">
                        <asp:Button ID="save_close" runat="server" Text="保存并关闭" OnClick="save_close_Click" /></span></a></li>
                  <li  style="margin-left: 20px;"><a class="ImgLink" id="" name="HREF_btnSaveClose">
                    <span class="icon" style="background: url(../Images/ButtonBarIcons.png) no-repeat -32px 0; width: 16px; height: 16px; display: inline-block; margin: -2px 3px; margin-top: 3px;"></span><span class="Text">
                        <asp:Button ID="save_new" runat="server" Text="保存并新建" OnClick="save_new_Click"  /></span></a></li>
                <li style="margin-left: 20px;"><a class="ImgLink" id="HREF_btnCancel" name="HREF_btnCancel" title="Cancel">
                    <span class="icon" style="background: url(../Images/ButtonBarIcons.png) no-repeat -96px 0; width: 16px; height: 16px; display: inline-block; margin: -2px 3px; margin-top: 3px;"></span>
                    <span class="Text">取消</span></a></li>

            </ul>
        </div>
        <div style="left: 10px; overflow-x: auto; overflow-y: auto; position: fixed; right: 0; bottom: 0; top: 85px;">
            <div class="Normal Section" style="min-height: 300px">
                <div class="Heading">
                    <div class="Left"><span class="Text">团队成员</span><span class="SecondaryText">(员工或联系人必选且只能选一个)</span></div>
                    <div class="Spacer"></div>
                </div>
                <div class="DescriptionText">团队成员可以是项目成员或者联系人。如果该团队成员是项目组成员，在此项目中需要为分配的任务和问题分配计费角色。通过过滤员工的角色可以更快地分配任务和任务。</div>
                <div class="Content">
                    <div class="Normal Column" style="float: left;">
                        <div class="EditorLabelContainer">
                            <div class="Label">
                                <label for="Resources">项目成员</label>
                            </div>
                        </div>
                        <div class="Editor DataSelector" data-editor-id="Resources" data-rdp="Resources">
                            <div class="InputField">
                                <input id="resource_id" type="text" value="<%=thisRes!=null?thisRes.name:"" %>" />
                                <a class="Button ButtonIcon IconOnly DataSelector NormalState" id="Resources_Button" tabindex="0" onclick="ChooseRes()">
                                    <span class="Icon" style="background: url(../Images/data-selector.png) no-repeat;"></span>
                                    <span class="Text"></span>

                                </a>
                                <input id="resource_idHidden" name="resource_id" type="hidden" value="<%=thisRes!=null?thisRes.id.ToString():"" %>" />
                                <div class="ContextOverlayContainer" id="Resources_ContextOverlay">
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
                        <div class="EditorLabelContainer">
                            <div class="Label">
                                <label for="BillingRoles">计费角色</label>
                            </div>
                        </div>
                        <div class="Editor MultipleSelect" data-editor-id="BillingRoles" data-rdp="BillingRoles">
                            <div class="InputField">
                                <select id="roles" multiple="multiple" name="roles"></select>
                            </div>
                        </div>
                    </div>
                    <div class="Normal Column" style="float: left;">
                        <div class="EditorLabelContainer">
                            <div class="Label">
                                <label for="Contacts">联系人<span class="SecondaryText">(<%=thisAccount!=null?thisAccount.name:"" %>)</span></label>
                            </div>
                        </div>
                        <div class="Editor DataSelector" data-editor-id="Contacts" data-rdp="Contacts">
                            <div class="InputField">
                                <input id="contact_id" type="text" value="<%=thisCon!=null?thisCon.name:"" %>" />
                                <a class="Button ButtonIcon IconOnly DataSelector NormalState" id="Contacts_Button" tabindex="0" onclick="ChooseContact()">
                                    <span class="Icon" style="background: url(../Images/data-selector.png) no-repeat;"></span>
                                    <span class="Text"></span>
                                </a>
                                <input id="contact_idHidden" name="contact_id" type="hidden" value="<%=thisCon!=null?thisCon.id.ToString():"" %>" />
                                <div class="ContextOverlayContainer" id="Contacts_ContextOverlay">
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
                    </div>
                </div>
            </div>
            <div class="Normal Section">
                <div class="Heading">
                    <div class="Left"><span class="Text">项目详细信息</span><span class="SecondaryText"></span></div>
                    <div class="Spacer"></div>
                </div>
                <div class="DescriptionText">指定此员工每天在该项目中为其角色可用的最大时间.</div>
                <div class="Content">
                    <div class="Normal Column">
                        <div class="EditorLabelContainer">
                            <div class="Label">
                                <label for="DailyCapacity">日工作量</label><span class="Required">*</span>
                            </div>
                        </div>
                        <div class="Editor DecimalBox" data-editor-id="DailyCapacity" data-rdp="DailyCapacity">
                            <div class="InputField">
                                <input id="resource_daily_hours" type="text" value="<%=thisProTeam!=null?thisProTeam.resource_daily_hours.ToString("#0.00"):"" %>" name="resource_daily_hours"  maxlength="5"  onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')" />
                                <span class="CustomHtml">
                                    <div class="TeamMember_DailyCapacityTextHours">
                                        小时
                                    </div>
                                </span>
                            </div>
                        </div>
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

        <%if (!isAdd)
        { %>
        $("#Resources_Button").removeAttr("onclcik");
        $("#resource_id").prop("disabled", true);
        //$("#roles").prop("disabled", true);
        $("#Contacts_Button").removeAttr("onclcik");
        $("#contact_id").prop("disabled", true);


        GetRoleByResId();
        var roleIdAr = new Array();
        <%if (thisProTeamRoleList != null && thisProTeamRoleList.Count > 0)
    {
       
        foreach (var thisProTeamRole in thisProTeamRoleList)
        {
            if (thisProTeamRole.role_id == null)
            {
                continue;
            }%>
        roleIdAr.push('<%=thisProTeamRole.role_id %>');
        <%
        }%>
        $("#roles").val(roleIdAr);
        <% }%>
       
        <%}%>

    })



    // 查找带回员工
    function ChooseRes() {
        window.open("../Common/SelectCallBack.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.RESOURCE_CALLBACK %>&callBack=GetRoleByResId&field=resource_id", '<%=(int)EMT.DoneNOW.DTO.OpenWindow.RESOURCE_CALLBACK %>', 'left=200,top=200,width=600,height=800', false);
    }
    function ChooseContact() {
        window.open("../Common/SelectCallBack.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.CONTACT_CALLBACK %>&field=contact_id&callBack=ClearRes&con628=<%=thisProject.account_id %>", '<%=(int)EMT.DoneNOW.DTO.OpenWindow.ContactCallBack %>', 'left=200,top=200,width=600,height=800', false);
    }

    function GetRoleByResId() {
        ClearContact();
        var resId = $("#resource_idHidden").val();
        if (resId != null) {
            $.ajax({
                type: "GET",
                async: false,
                // dataType: "json",
                url: "../Tools/RoleAjax.ashx?act=GetRoleList&showNull=1&source_id=" + resId,
                success: function (data) {
                    
                        $("#roles").html(data);
                    
                },
            });

        } else {
            $("#roles").html("");
        }
    }

    function ClearRes() {
        $("#resource_id").val("");
        $("#resource_idHidden").val("");
        $("#roles").html("");
    }
    function ClearContact() {
        $("#contact_id").val("");
        $("#contact_idHidden").val("");
    }


    $("#save_new").click(function () {
        if (!SubmitCheck())
        {
            return false;
        }
        return true;
    })
    $("#save_new").click(function () {
        if (!SubmitCheck()) {
            return false;
        }
        return true;
    })
    $("#save_close").click(function () {
        if (!SubmitCheck()) {
            return false;
        }
        return true;
    })
    

    function SubmitCheck() {
        var resource_idHidden = $("#resource_idHidden").val();
        var contact_idHidden = $("#contact_idHidden").val();
        if (resource_idHidden == "" && contact_idHidden == "") {
            LayerMsg("员工或联系人必选。且只能选一个");
            return false;
        }
        if (resource_idHidden != "" && contact_idHidden != "") {
            LayerMsg("员工或联系人必选。且只能选一个");
            return false;
        }
  
        if (resource_idHidden != "") {
            // 员工如果已经存在，不可重复添加，不同角色也不可以
                  <%if (isAdd)
    { %>
            var isHas = "";
            $.ajax({
                type: "GET",
                async: false,
                // dataType: "json",
                url: "../Tools/ProjectAjax.ashx?act=ResInPro&project_id=<%=thisProject==null?"":thisProject.id.ToString() %>&resource_id=" + resource_idHidden,
                success: function (data) {
                    if (data == "True") {
                        isHas = "1";
                    }
                },
            });
            if (isHas != "") {
                LayerMsg("该员工已经在项目中出现，不可进行重复添加");
                return false;
            }
                 <%}%>

            var roles = $("#roles").val();
            if (roles == "") {
                LayerMsg("请为项目选择相关角色");
                return false;
            }
            
        }
   
        var resource_daily_hours = $("#resource_daily_hours").val();
        if (resource_daily_hours == "") {
            LayerMsg("请填写员工日工作量");
            return false;
        }
        if (isNaN(resource_daily_hours)) {
            LayerMsg("员工日工作量必须是数字");
            return false;
        }
        if (Number(resource_daily_hours) <= 0 || Number(resource_daily_hours) >= 24) {
            LayerMsg("员工日工作量必须在0-24之间");
            return false;
        }
        return true;
    }

    $("#HREF_btnCancel").click(function () {
        window.close();
    })
</script>
