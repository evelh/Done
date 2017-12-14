<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="EntryDetail.aspx.cs" Inherits="EMT.DoneNOW.Web.Project.EntryDetail" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>工时详情</title>
    <style>
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
            .HeaderRow .SecondaryTitle {
    display: inline;
    text-transform: none;
    font-weight: 500;
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
            .helpLink {
    text-align: right;
    width: 25px;
    padding: 10px 10px 10px 0;
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

      .DivSection {
    border: 1px solid #d3d3d3;
    margin: 0 10px 10px 10px;
    padding: 12px 28px 4px 28px;
}

        .FieldLabels {
            font-size: 12px;
            color: #4F4F4F;
            font-weight: bold;
            line-height: 15px;
        }

            .FieldLabels .label {
                font-weight: normal;
            }
            .Content td[class='FieldLabels'] {
    padding: 2px 20px 2px 0px;
}
            .DivSection td[id="txtBlack8"], .DivSection td[class="FieldLabels"] {
    vertical-align: top;
}
            .FieldLabels, .workspace .FieldLabels {
    font-size: 12px;
    color: #4F4F4F;
    font-weight: bold;
    line-height: 15px;
}
            .DivSection td {
    padding: 0;
    text-align: left;
}
            .fieldLabels {
    color: #4f4f4f;
    font-weight: 500;
}
            td {
    font-size: 12px;
}
    </style>
</head>
<body style="margin-right:0px;">
    <div class="HeaderRow" style="margin-top: -8px;margin-left: -6px;width: 100%;">
        <table>
            <tbody>
                <tr>
                    <td><span>工时:
                        <div class="SecondaryTitle"><%=thisAccount==null?"":thisAccount.name+" - " %><%=thisTask==null?"":thisTask.title %></div>
                    </span></td>
                    <td align="right" class="helpLink"><a class="HelperLinkIcon" title="Autotask Help for this page" href="javascript:var a=window.open('/Help/default_csh.htm#1252','WebHelp','top=100,left=100,resizable=yes,height=650,width=960,scrollbars=yes',true);">
                        <img src="../Images/help.png" border="0"></a></td>
                </tr>
            </tbody>
        </table>
    </div>
    <div class="workspace">

        <div class="ButtonBar">
            <ul>
                <li>
                   
                    <a class="ImgLink"  id="HREF_btnCancel" name="HREF_btnCancel" title="Close" style="width: 52px;">
                        <span class="icon" style="background: url(../Images/ButtonBarIcons.png) no-repeat -96px 0; width: 16px; height: 16px; display: inline-block; margin: -2px 3px; margin-top: 3px;"></span>
                        <span class="Text" style="margin-top: 4px;font-weight:bold;">关闭</span>
                    </a>
                </li>
            </ul>
        </div>
        <div divscrollingcontainer="" general="">
            <table width="100%" cellspacing="0" cellpadding="0" border="0">
                <tbody>
                    <tr>
                        <td align="left" valign="top" width="55%">
                            <!-- left cell -->
                            <div class="DivSection">
                                <div class="Content">
                                    <table width="100%" cellspacing="0" cellpadding="0" border="0">
                                        <tbody>
                                            <tr>
                                                <td class="FieldLabels" width="35%" align="right">客户名称
                                                </td>
                                                <td width="5%"></td>
                                                <td class="fieldLabels" width="60%">
                                                    <div><%=thisAccount==null?"":thisAccount.name %>&nbsp;</div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="FieldLabels" align="right">员工名称
                                                </td>
                                                <td width="5%"></td>
                                                <td class="fieldLabels">
                                                    <div>Li, Hong&nbsp;</div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="FieldLabels" align="right">项目名称
                                                </td>
                                                <td width="5%"></td>
                                                <td class="fieldLabels">
                                                    <div><%=thisProject==null?"":thisProject.name %>&nbsp;</div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="FieldLabels" align="right" valign="top">合同
                                                </td>
                                                <td width="5%"></td>
                                                <td class="fieldLabels">
                                                    <div><%=thisContract==null?"":thisContract.name %>&nbsp;</div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="FieldLabels" align="right" valign="top">工作类型
                                                </td>
                                                <td width="5%"></td>
                                                <td class="fieldLabels"> <div>
                                                    <% if (thisEntry.cost_code_id != null) {
                                                            var thisCode = new EMT.DoneNOW.DAL.d_cost_code_dal().FindNoDeleteById((long)thisEntry.cost_code_id);
                                                            if (thisCode != null)
                                                            {%>
                                                   <%=thisCode.name %>
                                                           <% }
                                                        }  %>
                                                    &nbsp;</div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="FieldLabels" align="right" valign="top" style="white-space: nowrap">采购订单号
                                                </td>
                                                <td width="5%"></td>
                                                <td class="fieldLabels">
                                                    <div><%=thisTask==null?"":thisTask.purchase_order_no %>&nbsp;</div>
                                                </td>
                                            </tr>
                                            <tr height="30px"></tr>
                                            <tr>
                                                <td class="FieldLabels" align="right" valign="top">工时说明
                                                </td>
                                                <td width="5%"></td>
                                                <td class="fieldLabels">
                                                    <div><%=thisEntry.summary_notes %>&nbsp; </div>
                                                </td>
                                            </tr>
                                            <tr height="30px"></tr>
                                            <tr>
                                                <td class="FieldLabels" align="right" valign="top">内部说明
                                                </td>
                                                <td width="5%"></td>
                                                <td class="fieldLabels">
                                                    <div><%=thisEntry.internal_notes %>&nbsp;</div>
                                                </td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </td>
                        <td valign="top" width="45%">
                            <!-- right cell -->
                            <div class="DivSection">
                                <div class="Content">
                                    <table width="100%" cellspacing="0" cellpadding="0" border="0">
                                        <tbody>
                                            <tr>
                                                <td class="FieldLabels" align="right" width="60%" style="padding-right: 30px;">工作日期</td>
                                                <td width="8%"></td>
                                                <td class="fieldLabels">
                                                    <div><%=thisEntry.start_time!=null?EMT.Tools.Date.DateHelper.ConvertStringToDateTime((long)thisEntry.start_time).ToString("yyyy-MM-dd"):"" %></div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="FieldLabels" align="right" style="padding-right: 30px;">工作时长</td>
                                                <td></td>
                                                <td class="fieldLabels">
                                                    <div><%=thisEntry.hours_worked==null?"":((decimal)thisEntry.hours_worked).ToString("#0.00") %></div>
                                                </td>
                                            </tr>
                                            <tr height="20px"></tr>
                                            <tr>

                                                <td class="FieldLabels" align="right">计费时长</td>
                                                <td></td>
                                                <td class="fieldLabels">
                                                    <div>
                                                        <table cellpadding="0" cellspacing="0" border="0">
                                                            <tbody>
                                                                <tr>
                                                                    <td valign="top" style="position: relative; right: 2px;"><%=thisEntry.hours_billed==null?"":((decimal)thisEntry.hours_billed).ToString("#0.00") %>
                                                                    </td>
                                                                    <td valign="top"></td>
                                                                </tr>
                                                            </tbody>
                                                        </table>
                                                    </div>
                                                </td>

                                            </tr>
                                            <tr>
                                                <td colspan="3">
                                                    <table width="100%" cellpadding="0" cellspacing="0">
                                                        <tbody>
                                                            <tr>
                                                                <td width="8%"></td>
                                                                <td class="FieldLabels" style="white-space: nowrap; padding-right: 5px;" width="60%">最小计费</td>
                                                                <td class="fieldLabels" align="right">
                                                                    <div><%=thisCost!=null&&thisCost.min_hours!=null?((decimal)thisCost.min_hours).ToString("#0.00"):"0.00" %></div>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td></td>
                                                                <td class="FieldLabels" style="white-space: nowrap; padding-right: 5px;">最大计费</td>
                                                                <td class="fieldLabels" align="right">
                                                                    <div><%=thisCost!=null&&thisCost.max_hours!=null?((decimal)thisCost.max_hours).ToString("#0.00"):"0.00" %></div>
                                                                </td>
                                                            </tr>
                                                          <%--  <tr>
                                                                <td></td>
                                                                <td class="FieldLabels" style="white-space: nowrap; padding-right: 5px;">Block Hour Multiplier</td>
                                                                <td class="fieldLabels" align="right">
                                                                    <div>
                                                                        1.00
                                                                    </div>
                                                                </td>
                                                            </tr>--%>
                                                        </tbody>
                                                    </table>
                                                </td>
                                            </tr>
                                            <tr height="20px"></tr>
                                            <tr>
                                                <td class="FieldLabels" align="right" style="padding-right: 30px;">费率</td>
                                                <td></td>
                                                <td class="fieldLabels">
                                                    <div><%=thisRate==null?"":((decimal)thisRate).ToString("#0.00") %></div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td colspan="3">
                                                    <table width="100%" cellpadding="0" cellspacing="0">
                                                        <tbody>
                                                            <tr>
                                                                <td width="8%"></td>
                                                                <td class="FieldLabels" width="60%" style="padding-right: 5px;">角色费率</td>
                                                                <td class="fieldLabels" align="right">
                                                                    <div>
                                                                        <% var thisRole = new EMT.DoneNOW.DAL.sys_role_dal().FindNoDeleteById((long)thisEntry.role_id); %>
                                                                        <%=thisRole==null?"":thisRole.hourly_rate.ToString("#0.00") %>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td></td>
                                                                <td class="FieldLabels" style="white-space: nowrap; padding-right: 5px;">角色费率上下浮动</td>
                                                                <td class="fieldLabels" align="right">
                                                                    <div><%=thisCost!=null&&thisCost.rate_adjustment!=null?((decimal)thisCost.rate_adjustment).ToString("#0.00"):"0.00" %></div>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td></td>
                                                                <td class="FieldLabels" style="white-space: nowrap; padding-right: 5px;">Role Rate Multiplier</td>
                                                                <td class="fieldLabels" align="right">
                                                                     <div><%=thisCost!=null&&thisCost.rate_multiplier!=null?((decimal)thisCost.rate_multiplier).ToString("#0.00"):"0.00" %></div>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td></td>
                                                                <td class="FieldLabels" style="padding-right: 5px;">自定义费率</td>
                                                                <td class="fieldLabels" align="right">
                                                                    <div><%=thisCost!=null&&thisCost.custom_rate!=null?((decimal)thisCost.custom_rate).ToString("#0.00"):"0.00" %></div>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td></td>
                                                                <td class="FieldLabels" style="padding-right: 5px;">固定费率</td>
                                                                <td class="fieldLabels" align="right">
                                                                    <div><%=thisCost!=null&&thisCost.flat_rate!=null?((decimal)thisCost.flat_rate).ToString("#0.00"):"0.00" %></div>
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </td>
                                            </tr>
                                            <tr height="20px"></tr>
                                            <tr>
                                                <td class="FieldLabels" align="right" style="padding-right: 30px;">合同上时间</td>
                                                <td></td>
                                                <td class="fieldLabels">
                                                    <div></div>
                                                </td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </td>
                    </tr>
                </tbody>
            </table>

        </div>
    </div>


</body>
</html>
<script src="../Scripts/jquery-3.1.0.min.js"></script>
<script>
    $("#HREF_btnCancel").click(function () {
        window.close();
    })
</script>
