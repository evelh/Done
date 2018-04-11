<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AppointmentsManage.aspx.cs" Inherits="EMT.DoneNOW.Web.ServiceDesk.AppointmentsManage" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <link rel="stylesheet" type="text/css" href="../Content/base.css" />
    <link rel="stylesheet" type="text/css" href="../Content/bootstrap.min.css" />
    <link rel="stylesheet" href="../Content/index.css" />
    <link rel="stylesheet" href="../Content/style.css" />
    <title>约会</title>
    <style>
        td{
            text-align:left;
        }
        .errorSmallClass{
            color:red;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
         <div class="header">约会</div>
        <div class="header-title">
            <ul>
                <li>
                    <img src="../Images/save.png" alt="" />
                    <asp:Button ID="save_close" runat="server" Text="保存并关闭" OnClick="save_close_Click" OnClientClick="return SubmitCheck();" />
                </li>
                <li>
                    <img src="../Images/save.png" alt="" />
                    <asp:Button ID="save_add" runat="server" Text="保存并新建" OnClick="save_add_Click"  OnClientClick="return SubmitCheck();" />
                </li>
                <li onclick="javascript:window.close();">
                    <img src="../Images/cancel.png" alt="" />
                    关闭
                </li>
            </ul>
        </div>
        <div id="pnlResults" style="height:248px;">
	
			<table cellspacing="0" cellpadding="0">
				<tbody><tr>
					<td width="10" colspan="2" rowspan="11"></td>
				</tr>
				<tr>
					<td colspan="2">
						<span id="lblResource" class="FieldLabel" style="font-weight:bold;">员工</span><span id="lblResourceReq" class="errorSmallClass" style="font-weight:bold;">*</span>
						<div>
							<span id="ddlResource" style="display:inline-block;">
                                <select name="resource_id" id="resource_id" class="txtBlack8Class"  style="width:340px;">
                                    <%if (resList != null && resList.Count > 0)
                                        {foreach (var res in resList)
                                            {     %>
                                    <option value="<%=res.id %>" <%if (appo != null && appo.resource_id == res.id){ %> selected="selected" <%} %> ><%=res.name %></option>
                                    <%
                                            }} %>
                                </select>

							</span>
						</div>
					</td>
				</tr>
				<tr>
					<td colspan="2">
						<span id="lblSubject" class="FieldLabel" style="font-weight:bold;">约会标题</span><span id="lblSubReq" class="errorSmallClass" style="font-weight:bold;">*</span>
						<div>
							<span id="txtSubject" style="display:inline-block;">
                                <input name="name" type="text" value="<%=appo!=null?appo.name:"" %>" id="name" class="txtBlack8Class"  style="height:18px;width:340px;"  />
							</span>
						</div>
					</td>
				</tr>
				<tr>
					<td>
						<span id="lblDateStart" class="FieldLabel" style="font-weight:bold;">约会开始时间</span><span id="lblDateStartReq" class="errorSmallClass" style="font-weight:bold;">*</span>
						<div>
							<span  id="dtStart" style="display:inline-block;">
                                <input name="startTime" type="text" id="start_time" class="txtBlack8Class" style="width:140px;" value="<%=appo!=null?EMT.Tools.Date.DateHelper.ConvertStringToDateTime(appo.start_time).ToString("yyyy-MM-dd HH:mm"):(chooseDate.ToString("yyyy-MM-dd")+" 08:00") %>" onclick ="WdatePicker({ dateFmt: 'yyyy-MM-dd HH:mm' })" /></span>
						</div>
					</td>
					<td>
						<div>
							<span id="timStart" style="display:inline-block;">
                              </span>
						</div>
					</td>
				</tr>
				<tr>
					<td>
						<span id="lblDateEnd" class="FieldLabel" style="font-weight:bold;">约会结束时间</span><span id="lblDateEndReq" class="errorSmallClass" style="font-weight:bold;">*</span>
						<div>
							<span  id="dtEnd" style="display:inline-block;">
                                 <input name="endTime" type="text" id="end_time" class="txtBlack8Class"  style="height:18px;width:140px;" value="<%=appo!=null?EMT.Tools.Date.DateHelper.ConvertStringToDateTime(appo.end_time).ToString("yyyy-MM-dd HH:mm"):(chooseDate.ToString("yyyy-MM-dd")+" 09:00") %>" onclick ="WdatePicker({ dateFmt: 'yyyy-MM-dd HH:mm' })"/>
							</span>
						</div>
					</td>
					<td>
						<div>
							<span  id="timEnd" style="display:inline-block;"></span>
						</div>
					</td>
				</tr>
				<tr>
					<td colspan="2">
						<span id="lblDescription" class="FieldLabel" style="font-weight:bold;">约会描述</span>
						<div>
							<span id="txtDescription" style="display:inline-block;"><textarea name="description" id="description" class="txtBlack8Class" style="height:50px;width:340px;"><%=appo!=null?appo.description:"" %></textarea></span>
						</div>
					</td>
				</tr>
			</tbody></table>
		
</div>
    </form>
</body>
</html>
<script src="../Scripts/jquery-3.1.0.min.js"></script>
<script src="../Scripts/common.js"></script>
<script src="../Scripts/My97DatePicker/WdatePicker.js"></script>
<script>

    function SubmitCheck() {
        var resource_id = $("#resource_id").val();
        if (resource_id == "") {
            LayerMsg("请选择相关员工！");
            return false;
        }
        var name = $("#name").val();
        if (name == "") {
            LayerMsg("请填写约会名称！");
            return false;
        }
        var start_time = $("#start_time").val();
        if (start_time == "") {
            LayerMsg("请选择开始时间！");
            return false;
        }
        var end_time = $("#end_time").val();
        if (end_time == "") {
            LayerMsg("请选择结束时间！");
            return false;
        }
        if (compareTime(start_time,end_time)) {
            LayerMsg("开始时间不能大于结束时间！");
            return false;
        }
        var starArr = start_time.split(' ');
        var endArr = end_time.split(' ');
        var star = starArr[1].split(":");
        var end = endArr[1].split(":");
        if (Number(star[0] + star[1]) > Number(end[0] + end[1])) {
            LayerMsg("开始时间不能大于结束时间！");
            return false;
        }
        return true;
    } 

</script>
