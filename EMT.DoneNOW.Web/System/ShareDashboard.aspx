<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ShareDashboard.aspx.cs" Inherits="EMT.DoneNOW.Web.ShareDashboard" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>共享仪表板-<%=name %></title>
    <link rel="stylesheet" type="text/css" href="../Content/index.css" />
    <link rel="stylesheet" type="text/css" href="../Content/style.css" />
</head>
<body style="margin:0">
    <form id="form1" runat="server">
        <div class="header">共享仪表板-<%=name %></div>
        <div style="margin:10px;min-width:780px;position: fixed;top: 40px;left: 0;right: 0;bottom: 0;">
            <div style="overflow:hidden;">
                <div style="float:left;width:76px;">
                    <span>共享给</span>
                </div>
                <div style="overflow:hidden;width:210px;float:left;">
                    <label>安全等级</label><span style="position:absolute;"><i class="icon-dh" style="height:16px !important;margin-left:12px;margin-top:2px;" onclick='window.open("../Common/SelectCallBack.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.SECURITY_LEVEL_CALLBACK %>&field=slselect&muilt=1&callBack=ChangeShare", "_blank", "left=200,top=200,width=600,height=800", false);'></i></span>
                    <textarea rows="2" cols="20" style="resize:none;width:180px;height:210px;overflow-y:auto;" readonly="readonly"><%=seclvnames %></textarea>
                    <input type="hidden" id="slselect" />
                    <input type="hidden" id="slselectHidden" name="secs" value="<%=seclvids %>" />
                </div>
                <div style="overflow:hidden;width:210px;float:left;">
                    <label>部门</label><span style="position:absolute;"><i class="icon-dh" style="height:16px !important;margin-left:12px;margin-top:2px;" onclick='window.open("../Common/SelectCallBack.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.DEPARTMENT_CALLBACK %>&field=dptselect&muilt=1&callBack=ChangeShare", "_blank", "left=200,top=200,width=600,height=800", false);'></i></span>
                    <textarea rows="2" cols="20" style="resize:none;width:180px;height:210px;overflow-y:auto;" readonly="readonly"><%=dptnames %></textarea>
                    <input type="hidden" id="dptselect" />
                    <input type="hidden" id="dptselectHidden" name="dpts" value="<%=dptids %>" />
                </div>
                <div style="overflow:hidden;width:210px;float:left;">
                    <label>员工</label><span style="position:absolute;"><i class="icon-dh" style="height:16px !important;margin-left:12px;margin-top:2px;" onclick='window.open("../Common/SelectCallBack.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.RESOURCE_CALLBACK %>&field=rsselect&muilt=1&callBack=ChangeShare", "_blank", "left=200,top=200,width=600,height=800", false);'></i></span>
                    <textarea rows="2" cols="20" style="resize:none;width:180px;height:210px;overflow-y:auto;" readonly="readonly"><%=resnames %></textarea>
                    <input type="hidden" id="rsselect" />
                    <input type="hidden" id="rsselectHidden" name="res" value="<%=resids %>" />
                </div>
            </div>
            <div style="position: fixed;top: 300px;bottom: 0;left: 10px;right: 10px;">
                <iframe src="../Common/SearchBodyFrame?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.SHARED_DASHBOARD_RESOURCE %>&type=<%=(int)EMT.DoneNOW.DTO.QueryType.SharedDashboardResource %>&con4901=<%=id %>" style="overflow: scroll;width:100%;height:100%;border:0px;"></iframe>
            </div>
        </div>
    </form>
    <script src="../Scripts/jquery-3.1.0.min.js" type="text/javascript" charset="utf-8"></script>
    <script>
        function ChangeShare() {
            $("#form1").submit();
        }
    </script>
</body>
</html>
