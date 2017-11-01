<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ProjectSchedule.aspx.cs" Inherits="EMT.DoneNOW.Web.Project.ProjectSchedule" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <link href="../Content/reset.css" rel="stylesheet" />
    <link href="../Content/NewConfigurationItem.css" rel="stylesheet" />
    <style>
        #useResource_daily_hours, #excludeHoliday, #excludeWeekend {
            vertical-align: middle;
        }

        #warnTime_off {
            vertical-align: middle;
            cursor: pointer;
        }
    </style>
    <title></title>
</head>
<body>
    <form id="form1">
        <div>

        </div>
          <div class="Dialog Large" style="margin-left: -442px; margin-top: -229px; z-index: 100;" id="Nav2">
            <div>
                <input type="hidden" id="DivChooseTaskIds" />
                <div class="DialogContentContainer">
                    <div class="CancelDialogButton"></div>
                    <div class="TitleBar">
                        <div class="Title">
                            <span class="text">保存为模板</span>
                        </div>
                    </div>
                    <%
                        var lineBusiness = dic.FirstOrDefault(_ => _.Key == "project_line_of_business").Value  as List<EMT.DoneNOW.DTO.DictionaryEntryDto>;

                        var departList = dic.FirstOrDefault(_ => _.Key == "department").Value  as List<EMT.DoneNOW.DTO.DictionaryEntryDto>;

                         var resList = dic.FirstOrDefault(_ => _.Key == "sys_resource").Value  as List<EMT.DoneNOW.DTO.DictionaryEntryDto>;


                        %>
                    <div class="ScrollingContentContainer">
                      
                        <!--通过模板新增-->
                        <div class="ScrollingContainer" style="height: 394px;" id="AddStep2">

                            <div class="WizardProgressBar">
                              
                                <div style="width: 25%;" class="Item Previous">
                                    <div class="Full">
                                        <div class="Left">
                                            <div class="Indicator">
                                                <div class="IndicatorCore"></div>
                                            </div>
                                        </div>
                                        <div class="Right">
                                            <div class="ConnectorContainer">
                                                <div class="Connector"></div>
                                            </div>
                                            <div class="Indicator">
                                                <div class="IndicatorCore"></div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="Label">常规信息</div>
                                </div>
                               
                                <div style="width: 25%;" class="Item">
                                    <div class="Full">
                                        <div class="Left">
                                            <div class="ConnectorContainer">
                                                <div class="Connector"></div>
                                            </div>
                                            <div class="Indicator">
                                                <div class="IndicatorCore"></div>
                                            </div>
                                        </div>
                                        <div class="Right">
                                            <div class="ConnectorContainer">
                                                <div class="Connector"></div>
                                            </div>
                                            <div class="Indicator">
                                                <div class="IndicatorCore"></div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="Label">选择日程表条目</div>
                                </div>
                                <div style="width: 25%;" class="Item">
                                    <div class="Full">
                                        <div class="Left">
                                            <div class="ConnectorContainer">
                                                <div class="Connector"></div>
                                            </div>
                                            <div class="Indicator">
                                                <div class="IndicatorCore"></div>
                                            </div>
                                        </div>
                                        <div class="Right">
                                            <div class="Indicator">
                                                <div class="IndicatorCore"></div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="Label">选择附加条目</div>
                                </div>
                            </div>
                            <div class="DivSectionWithHeader">
                                <div class="HeaderRow">
                                    <span class="lblNormalClass">常规信息</span>
                                </div>
                                <div class="Content">
                                    <div class="DescriptionText">此页面上值为当前项目的常规信息，您可以修改。</div>
                                    <table class="Neweditsubsection" style="width: 770px;" cellpadding="0" cellspacing="0">
                                        <tbody>
                                            <tr>
                                                <td>
                                                    <div style="height: 180px; overflow-y: auto;">
                                                        <table cellpadding="0" cellspacing="0" style="width: 100%;">
                                                            <tbody>
                                                                <tr>
                                                                       <td class="FieldLabel" width="50%">标题<span style="color: Red;">*</span>
                                                                        <div>
                                                                            <span style="display: inline-block;">
                                                                                <input type="text" style="width: 250px;" id="temp_name" value="<%=thisProject.name %>" /></span>
                                                                        </div>
                                                                    </td>
                                                                    <td class="FieldLabel">类型
                                                                        <div>
                                                                            
                                                                            <select style="width:264px;" id="temp_type_id">
                                                                                <option value="<%=(int)EMT.DoneNOW.DTO.DicEnum.PROJECT_TYPE.TEMP %>">模板</option>
                                                                            </select>
                                                                        </div>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td class="FieldLabel" width="50%">
                                                                        <span>开始日期<span style="color: Red;">*</span></span>
                                                                        <span style="margin-left: 31px;">结束日期<span style="color: Red;">*</span></span>
                                                                        <span style="margin-left: 29px;">持续时间<span style="color: Red;">*</span></span>
                                                                        <div>
                                                                            <span style="display: inline-block;">
                                                                                <input type="text" style="width: 72px;" onclick="WdatePicker()" class="Wdate" id="temp_start_date" value="<%=((DateTime)thisProject.start_date).ToString("yyyy-MM-dd") %>"/>
                                                                                <input type="text" style="width: 72px;" onclick="WdatePicker()" class="Wdate" id="temp_end_date" value="<%=((DateTime)thisProject.end_date).ToString("yyyy-MM-dd") %>" />
                                                                                <input type="text" style="width: 70px;" id="temp_duration" value="<%=thisProject.duration %>" />

                                                                            </span>
                                                                        </div>
                                                                    </td>
                                                                    <td class="FieldLabel">业务范围
                                                                        <div>
                                                                            <span style="display: inline-block;">
                                                                                
                                                                                <select class="txtBlack8Class" style="Width:264px" id="line_of_business_id">
                                                                                    <option value="0"> </option>
                                                                                    <% if (lineBusiness != null && lineBusiness.Count > 0)
                                                                                            {
                                                                                             foreach (var lb in lineBusiness)
                                                                                            {%>
                                                                                    <option value="<%=lb.val %>"><%=lb.show %></option>
                                                                                          <%  }

                                                                                    } %>
                                                                                </select>
                                                                                
                                                                            </span>
                                                                        </div>
                                                                    </td>
                                                                </tr>

                                                                <tr>
                                                                     <td class="FieldLabel" width="50%">项目主管
                                                                            <div>
                                                                                <span style="display: inline-block;">
                                                                                      <select class="txtBlack8Class" style="Width:264px" id="owner_resource_id" name="owner_resource_id">
                                                                                    <option value="0"> </option>
                                                                                    <% if (resList != null && resList.Count > 0)
                                                                                            {
                                                                                             foreach (var res in resList)
                                                                                            {%>
                                                                                    <option value="<%=res.val %>"><%=res.show %></option>
                                                                                          <%  }

                                                                                    } %>
                                                                                </select>

                                                                                </span>
                                                                            </div>
                                                                    </td>
                                                                    <td class="FieldLabel" width="50%">部门
                                                    <div>
                                                        <span style="display: inline-block;">
                                                              <select class="txtBlack8Class" style="Width:264px" id="department_id" name="department_id">
                                                                                    <option value="0"> </option>
                                                                                    <% if (departList != null && departList.Count > 0)
                                                                                            {
                                                                                             foreach (var de in departList)
                                                                                            {%>
                                                                                    <option value="<%=de.val %>"><%=de.show %></option>
                                                                                          <%  }

                                                                                    } %>
                                                                                </select>
                                                        </span>
                                                    </div>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td colspan="4" class="FieldLabel">描述
                                                                        <div>
                                                                            <textarea style="min-height: 100px; width: 625px;" id="temp_description"><%=thisProject.description %></textarea>
                                                                        </div>
                                                                        <div class="CharacterInformation"><span class="CurrentCount" id="tempTextNum"><%=(!string.IsNullOrEmpty(thisProject.description))?thisProject.description.Length:0 %></span>/<span class="Maximum">1000</span></div>
                                                                    </td>
                                                                </tr>
                                                            </tbody>
                                                        </table>
                                                    </div>
                                                </td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                            <input type="hidden" id="temp_resource_daily_hours"/>
                            <input type="hidden" id="temp_useResource_daily_hours"/>
                            <input type="hidden" id="temp_excludeWeekend"/>
                            <input type="hidden" id="temp_excludeHoliday"/>
                            <input type="hidden" id="temp_organization_location_id"/>
                            <input type="hidden" id="temp_warnTime_off"/>
                            <div class="ButtonContainer Footer Wizard">
                                <ul>
                                   
                                    <li class="Button ButtonIcon MoveRight PushRight" id="down2_2">
                                        <span class="Icon Next"></span>
                                        <span class="Text">下一步</span>
                                    </li>
                                </ul>
                            </div>
                        </div>
                        <div class="ScrollingContainer" style="height: 394px; display: none;" id="SecondStep2">

                            <div class="WizardProgressBar">
                               
                               
                                <div style="width: 25%;" class="Item Previous">
                                    <div class="Full">
                                        <div class="Left">
                                         
                                            <div class="Indicator">
                                                <div class="IndicatorCore"></div>
                                            </div>
                                        </div>
                                        <div class="Right">
                                            <div class="ConnectorContainer">
                                                <div class="Connector"></div>
                                            </div>
                                            <div class="Indicator">
                                                <div class="IndicatorCore"></div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="Label">常规信息</div>
                                </div>
                             
                                <div style="width: 25%;" class="Item Current">
                                    <div class="Full">
                                        <div class="Left">
                                            <div class="ConnectorContainer">
                                                <div class="Connector"></div>
                                            </div>
                                            <div class="Indicator">
                                                <div class="IndicatorCore"></div>
                                            </div>
                                        </div>
                                        <div class="Right">
                                            <div class="ConnectorContainer">
                                                <div class="Connector"></div>
                                            </div>
                                            <div class="Indicator">
                                                <div class="IndicatorCore"></div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="Label">选择日程表条目</div>
                                </div>
                                <div style="width: 25%;" class="Item">
                                    <div class="Full">
                                        <div class="Left">
                                            <div class="ConnectorContainer">
                                                <div class="Connector"></div>
                                            </div>
                                            <div class="Indicator">
                                                <div class="IndicatorCore"></div>
                                            </div>
                                        </div>
                                        <div class="Right">
                                            <div class="Indicator">
                                                <div class="IndicatorCore"></div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="Label">选择附加条目</div>
                                </div>
                            </div>
                            <div class="DivSectionWithHeader">
                                <div class="HeaderRow">
                                    <span class="lblNormalClass">选择日程表条目</span>
                                </div>
                                <div class="Content" style="padding-bottom: 12px;">
                                    <div class="DescriptionText">选择您要添加到此项目的任务/阶段</div>
                                    <table class="Neweditsubsection" style="width: 770px;" cellpadding="0" cellspacing="0">
                                        <tbody>
                                            <tr>
                                                <td>
                                                    <div class="HeaderContainer" style="padding-bottom: 0;">
                                                        <table cellpadding="0" cellspacing="0" style="width: 100%;">
                                                            <colgroup>
                                                                <col class="Interaction">
                                                                <col class="Nesting">
                                                                <col class="Text">
                                                            </colgroup>
                                                            <tbody>
                                                                <tr class="HeadingRow">
                                                                    <td class="Interaction">
                                                                        <input type="checkbox" style="vertical-align: middle;" id="CheckAll_2">
                                                                    </td>
                                                                    <td class="Nesting">
                                                                        <span>任务/阶段/问题</span>
                                                                    </td>
                                                                    <td class="Text">
                                                                        <span>前置条件</span>
                                                                    </td>
                                                                    <td style="width: 7px; border-right: none;"></td>
                                                                </tr>
                                                            </tbody>
                                                        </table>
                                                    </div>
                                                    <div class="RowContainer" style="padding-bottom: 0;">
                                                        <table cellpadding="0" cellspacing="0" style="width: 100%;">
                                                            <colgroup>
                                                                <col class="Interaction">
                                                                <col class="Nesting">
                                                                <col class="Text">
                                                            </colgroup>
                                                            <tbody id="choProTaskList">
                                                            </tbody>
                                                        </table>
                                                    </div>
                                                </td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </div>
                            </div>

                            <div class="ButtonContainer Footer Wizard">
                                <ul>
                                    <li class="Button ButtonIcon MoveRight PushLeft" id="prev3_2">
                                        <span class="Icon Prev"></span>
                                        <span class="Text">上一步</span>
                                    </li>
                                    <li class="Button ButtonIcon MoveRight PushRight" id="down3_2">
                                        <span class="Icon Next"></span>
                                        <span class="Text">下一步</span>
                                    </li>
                                </ul>
                            </div>
                        </div>
                        <input type="hidden" id="TempChooseTaskids"/>
                        <div class="ScrollingContainer" style="height: 394px; display: none;" id="ThirdStep2">

                            <div class="WizardProgressBar">
                               
                               
                                <div style="width: 25%;" class="Item Previous">
                                    <div class="Full">
                                        <div class="Left">
                                           
                                            <div class="Indicator">
                                                <div class="IndicatorCore"></div>
                                            </div>
                                        </div>
                                        <div class="Right">
                                            <div class="ConnectorContainer">
                                                <div class="Connector"></div>
                                            </div>
                                            <div class="Indicator">
                                                <div class="IndicatorCore"></div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="Label">常规信息</div>
                                </div>
                           
                                <div style="width: 25%;" class="Item Previous">
                                    <div class="Full">
                                        <div class="Left">
                                            <div class="ConnectorContainer">
                                                <div class="Connector"></div>
                                            </div>
                                            <div class="Indicator">
                                                <div class="IndicatorCore"></div>
                                            </div>
                                        </div>
                                        <div class="Right">
                                            <div class="ConnectorContainer">
                                                <div class="Connector"></div>
                                            </div>
                                            <div class="Indicator">
                                                <div class="IndicatorCore"></div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="Label">选择日程表条目</div>
                                </div>
                                <div style="width: 25%;" class="Item Current">
                                    <div class="Full">
                                        <div class="Left">
                                            <div class="ConnectorContainer">
                                                <div class="Connector"></div>
                                            </div>
                                            <div class="Indicator">
                                                <div class="IndicatorCore"></div>
                                            </div>
                                        </div>
                                        <div class="Right">
                                            <div class="Indicator">
                                                <div class="IndicatorCore"></div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="Label">选择附加条目</div>
                                </div>
                            </div>
                            <div class="DivSectionWithHeader">
                                <div class="HeaderRow">
                                    <span class="lblNormalClass">选择日程表条目</span>
                                </div>
                                <div class="Content">
                                    <div class="DescriptionText">您可以存储日历条目、项目成本、项目成员信息到模板中。</div>
                                    <table class="Neweditsubsection" style="width: 770px;" cellpadding="0" cellspacing="0">
                                        <tbody>
                                            <tr>
                                                <td>
                                                    <div>
                                                        <table cellpadding="0" cellspacing="0" style="width: 100%;">
                                                            <tbody>
                                                                <tr>
                                                                    <td class="FieldLabel" width="50%">从项目模板复制:
                                                                <div>
                                                                    <span style="display: inline-block;">
                                                                        <input type="checkbox" style="vertical-align: middle;" id="temp_CalendarItems" />
                                                                        <label for="CalendarItems">日历条目</label>
                                                                    </span>
                                                                </div>
                                                                        <div>
                                                                            <span style="display: inline-block;">
                                                                                <input type="checkbox" style="vertical-align: middle;" id="temp_ProjectCharges" />
                                                                                <label for="ProjectCharges">项目成本</label>
                                                                            </span>
                                                                        </div>
                                                                        <div>
                                                                            <span style="display: inline-block;">
                                                                                <input type="checkbox" style="vertical-align: middle;" id="temp_TeamMembers" />
                                                                                <label for="TeamMembers">项目成员</label>
                                                                            </span>
                                                                        </div>
                                                                      
                                                                    </td>
                                                                </tr>
                                                            </tbody>
                                                        </table>
                                                    </div>
                                                </td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </div>
                            </div>

                            <div class="ButtonContainer Footer Wizard">
                                <ul>
                                    <li class="Button ButtonIcon MoveRight PushLeft" id="prev4_2">
                                        <span class="Icon Prev"></span>
                                        <span class="Text">上一步</span>
                                    </li>
                                    <li class="Button ButtonIcon MoveRight PushRight" id="Finish_2">
                                        <span class="Icon" style="width: 0; margin: 0;"></span>
                                        <span class="Text">完成</span>
                                    </li>
                                </ul>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <!--黑色幕布-->
        <div id="BackgroundOverLay"></div>
    </form>
</body>
</html>
<script src="../Scripts/jquery-3.1.0.min.js"></script>
<script src="../Scripts/common.js"></script>
<script src="../Scripts/My97DatePicker/WdatePicker.js"></script>
<script>
  $(function () {
      $("#Nav2").hide();
      $("#BackgroundOverLay").hide();
      <% if (isTransTemp)
        { %>
      $("#Nav2").show();
      $("#BackgroundOverLay").show();
      <%}%>


    })

    $(".CancelDialogButton").on("click", function () {
        $("#Nav2").hide();
        $("#BackgroundOverLay").hide();
        $("#AddStep2").show();
        $("#SecondStep2").hide();
        $("#ThirdStep2").hide();
    });
    $("#prev2_2").on("click", function () {
        $.ajax({
            type: "GET",
            async: false,
            url: "../Tools/ProjectAjax.ashx?act=GetTaskList&project_id=<%=thisProject.id %>",
            success: function (data) {
                if (data != "") {
                    $("#choProTaskList").html(data);
                }
            },
        });

        $("#FirstStep2").show();
        $("#AddStep2").hide();
    });
    $("#down2_2").on("click", function () {

        var temp_name = $("#temp_name").val();
        if (temp_name == "") {
            LayerMsg("请填写标题！");
            return false;
        }
        var temp_start_date = $("#temp_start_date").val();
        if (temp_start_date == "") {
            LayerMsg("请填写开始时间！");
            return false;
        }
        var temp_end_date = $("#temp_end_date").val();
        if (temp_end_date == "") {
            LayerMsg("请填写结束时间！");
            return false;
        }
        var temp_duration = $("#temp_duration").val();
        if (temp_duration == "") {
            LayerMsg("请填写持续时间！");
            return false;
        }

        $("#AddStep2").hide();
        $("#SecondStep2").show();
    });
    $("#prev3_2").on("click", function () {
        $("#AddStep2").show();
        $("#SecondStep2").hide();
    });
    $("#down3_2").on("click", function () {
        // SecondStep2
        var ids = "";
        $("#SecondStep2 tr").each(function () {
            if ($(this).hasClass("Selected")) {
                ids += $(this).val() + ","
            }
        })
        if (ids == "") {
            LayerConfirm("未选择任何条目，是否继续", "确认", "取消", function () {
                debugger;

                $("#SecondStep2").hide();
                $("#ThirdStep2").show();
                $("#TempChooseTaskids").val("");
            }, function () { });
        } else {
            ids = ids.substring(0, ids.length - 1);
            $("#SecondStep2").hide();
            $("#ThirdStep2").show();
            $("#TempChooseTaskids").val(ids);
        }


    });
    $("#prev4_2").on("click", function () {
        $("#SecondStep2").show();
        $("#ThirdStep2").hide();
    });

    $("#Finish_2").on("click", function () {
        var temp_name = $("#temp_name").val();
        if (temp_name == "") {
            LayerMsg("请填写标题！");
            return false;
        }
        var temp_start_date = $("#temp_start_date").val();
        if (temp_start_date == "") {
            LayerMsg("请填写开始时间！");
            return false;
        }
        var temp_end_date = $("#temp_end_date").val();
        if (temp_end_date == "") {
            LayerMsg("请填写结束时间！");
            return false;
        }
        var temp_duration = $("#temp_duration").val();
        if (temp_duration == "") {
            LayerMsg("请填写持续时间！");
            return false;
        }
        var temp_type_id = $("#temp_type_id").val();
        var line_of_business_id = $("#line_of_business_id").val();
        var owner_resource_id = $("#owner_resource_id").val();
        var department_id = $("#department_id").val();
        var temp_description = $("#temp_description").val();
        var TempChooseTaskids = $("#TempChooseTaskids").val();
        var copyCalItem = $("#temp_CalendarItems").is(":checked");
        var copyProCha = $("#temp_ProjectCharges").is(":checked");
        var copyProTeam = $("#temp_TeamMembers").is(":checked");
        $.ajax({
            type: "GET",
            async: false,
            url: "../Tools/ProjectAjax.ashx?act=SaveTemp&TranProjectId=<%=thisProject.id %>&name=" + temp_name + "&startDate=" + temp_start_date + "&endDate=" + temp_end_date + "&duration=" + temp_duration + "&lineBuss=" + line_of_business_id + "&department_id=" + department_id + "&proLead=" + owner_resource_id + "&description=" + temp_description + "&TempChooseTaskids=" + TempChooseTaskids + "&copyCalItem=" + copyCalItem + "&copyProCha=" + copyProCha + "&copyProTeam=" + copyProTeam,
            success: function (data) {
                if (data != "") {
              
                }
                $("#Nav2").hide();
                $("#BackgroundOverLay").hide();
                $("#AddStep2").show();
                $("#SecondStep2").hide();
                $("#ThirdStep2").hide();
            },
         });
    })
</script>
