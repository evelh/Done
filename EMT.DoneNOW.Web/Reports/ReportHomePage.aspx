<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ReportHomePage.aspx.cs" Inherits="EMT.DoneNOW.Web.Reports.ReportHomePage" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <link href="../Content/Admin.css" rel="stylesheet" />
    <link href="../Content/ClassificationIcons.css" rel="stylesheet" />
    <title></title>
    <style>
        .StandardText {
            display: none;
        }

        .Large {
            margin-top: 15px;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <div id="body">
                <!--顶部-->
                <div class="TitleBar">
                    <div class="Title">
                        <span class="text1">报表</span>
                        <a href="###" class="collection"></a>
                        <a href="###" class="help"></a>
                    </div>
                </div>
                <!--选择框-->
                <div class="TabBar">
                    <a class="Button ButtonIcon SelectedState" id="TabButtonCrm">
                        <span class="Text">CRM</span>
                    </a>
                    <a class="Button ButtonIcon" id="TabButtonProject">
                        <span class="Text">项目</span>
                    </a>
                    <a class="Button ButtonIcon" id="TabButtonServiceDesk">
                        <span class="Text">服务台</span>
                    </a>
                    <a class="Button ButtonIcon" id="TabButtonContractBill">
                        <span class="Text">合同计费</span>
                    </a>
                    <a class="Button ButtonIcon" id="TabButtonResource">
                        <span class="Text">员工</span>
                    </a>
                    <a class="Button ButtonIcon" id="TabButtonLabourExpense">
                        <span class="Text">工时和费用</span>
                    </a>
                    <a class="Button ButtonIcon" id="TabButtonExecutive">
                        <span class="Text">执行</span>
                    </a>
                    <a class="Button ButtonIcon" id="TabButtonOther">
                        <span class="Text">其他</span>
                    </a>
                </div>
                <div class="ScrollingContainer Active" style="top: 82px; bottom: 0;">
                    <!--第一部分-->
                    <div class="TabContainer TabContainer1 Active">
                        <div class="ButtonContainer">
                            <a class="Button ButtonIcon NormalState" tabindex="0" id="d1">
                                <span class="Text">展开所有</span>
                            </a>
                            <a class="Button ButtonIcon NormalState" tabindex="0" id="d2">
                                <span class="Text">折叠所有</span>
                            </a>
                        </div>
                        <!--第三个框-->
                        <%if (CheckAuth("SYS_FEATURES_RESOURCES"))
                            { %>
                        <div class="Normal Section Collapsed Normal1 col" id="b3">
                            <div class="Heading">
                                <div class="Toggle Expand Toggle1" id="a3">
                                    <div class="Vertical Vertical1"></div>
                                    <div class="Horizontal"></div>
                                </div>
                                <span class="Text">客户</span>
                                <span></span>
                            </div>
                            <div class="Content Content1" id="c3">
                                <div class="Large Column">
                                    <div class="PageNavigationLinkGroup">
                                        <div class="PageNavigationLinkColumn">
                                            <div class="PageNavigationLink">
                                                <a href="../Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.REPORT_CRM_ACCOUNT_LABOURBYMONTH %>" target="PageFrame1" class="Button ButtonIcon Link NormalState chaxun">按照员工和月份统计工时</a>
                                                <div class="StandardText">介绍介绍</div>
                                            </div>


                                            <div class="PageNavigationLink">
                                                <a href="../Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.REPORT_CRM_MY_ACCOUNT_TICKET %>" target="PageFrame1" class="Button ButtonIcon Link NormalState chaxun">我的客户的工单</a>
                                                <div class="StandardText">介绍介绍</div>
                                            </div>
                                        </div>
                                         <div class="PageNavigationLinkColumn">
                                             <div class="PageNavigationLink">
                                                <a href="../Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.REPORT_CRM_ACCOUNT_LABOURBYACCOUNT %>" target="PageFrame1" class="Button ButtonIcon Link NormalState chaxun">按照客户统计工时</a>
                                                <div class="StandardText">介绍介绍</div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <%}%>
                        <!--第四个框-->
                        <%if (CheckAuth("SYS_FEATURES_COMPANY_CONTACT"))
                            { %>
                        <div class="Normal Section Collapsed Normal1 col" id="b4">
                            <div class="Heading">
                                <div class="Toggle Expand Toggle1" id="a4">
                                    <div class="Vertical Vertical1"></div>
                                    <div class="Horizontal"></div>
                                </div>
                                <span class="Text">配置项</span>
                                <span></span>
                            </div>
                            <div class="Content Content1" id="c4">
                                <div class="Large Column">
                                    <div class="PageNavigationLinkGroup">
                                        <div class="PageNavigationLinkColumn">

                                            <div class="PageNavigationLink">
                                                <a href="../Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.REPORT_CRM_INSPRO_DETAIL %>" target="PageFrame1" class="Button ButtonIcon Link NormalState chaxun">配置项详情</a>
                                                <div class="StandardText">介绍介绍</div>
                                            </div>

                                        </div>
                                          <div class="PageNavigationLinkColumn">
                                               <div class="PageNavigationLink">
                                                <a href="../Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.REPORT_CRM_INSTALLPRODUCT_EXPIRE %>" target="PageFrame1" class="Button ButtonIcon Link NormalState chaxun">合同和配置项到期情况</a>
                                                <div class="StandardText">介绍介绍</div>
                                            </div>
                                          </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <%}%>
                        <!--第五个框-->
                        <%if (CheckAuth("SYS_FEATURES_SALES_OPPS"))
                            { %>
                        <div class="Normal Section Collapsed Normal1 col" id="b5">
                            <div class="Heading">
                                <div class="Toggle Expand Toggle1" id="a5">
                                    <div class="Vertical Vertical1"></div>
                                    <div class="Horizontal"></div>
                                </div>
                                <span class="Text">商机</span>
                                <span></span>
                            </div>
                            <div class="Content Content1" id="c5">
                                <div class="Large Column">
                                    <div class="PageNavigationLinkGroup">
                                        <div class="PageNavigationLinkColumn">
                                            <div class="PageNavigationLink">
                                                <a href="../Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.REPORT_CRM_OPPORTUNITY_DETAILS %>" target="PageFrame1" class="Button ButtonIcon Link NormalState chaxun">商机详情</a>
                                                <div class="StandardText">介绍介绍</div>
                                            </div>
                                            <div class="PageNavigationLink">
                                                <a href="../Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.REPORT_CRM_OPPORTUNITY_CRM_NOTE %>" target="PageFrame1" class="Button ButtonIcon Link NormalState chaxun">CRM备注</a>
                                                <div class="StandardText">介绍介绍</div>
                                            </div>
                                            <div class="PageNavigationLink">
                                                <a href="../Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.REPORT_CRM_OPPORTUNITY_ACCOUNTNOTEBYRESOURCE %>" target="PageFrame1" class="Button ButtonIcon Link NormalState chaxun">客户备注按员工汇总</a>
                                                <div class="StandardText">介绍介绍</div>
                                            </div>
                                            <div class="PageNavigationLink">
                                                <a href="../Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.REPORT_CRM_OPPORTUNITY_STAGE %>" target="PageFrame1" class="Button ButtonIcon Link NormalState chaxun">商机阶段报表</a>
                                                <div class="StandardText">介绍介绍</div>
                                            </div>
                                            <div class="PageNavigationLink">
                                                <a href="../Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.REPORT_CRM_OPPORTUNITY_SHOWNOTE_BYUSER %>" target="PageFrame1" class="Button ButtonIcon Link NormalState chaxun">按员工展示客户备注</a>
                                                <div class="StandardText">介绍介绍</div>
                                            </div>
                                            <div class="PageNavigationLink">
                                                <a href="../Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.REPORT_CRM_OPPORTUNITY_FORRCAST_BYUSER %>" target="PageFrame1" class="Button ButtonIcon Link NormalState chaxun">商机预估收入按员工汇总</a>
                                                <div class="StandardText">介绍介绍</div>
                                            </div>
                                            <div class="PageNavigationLink">
                                                <a href="../Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.REPORT_CRM_OPPORTUNITY_FORRCAST_BYTERRITY %>" target="PageFrame1" class="Button ButtonIcon Link NormalState chaxun">商机预估收入按地域汇总</a>
                                                <div class="StandardText">介绍介绍</div>
                                            </div>
                                        </div>
                                        <div class="PageNavigationLinkColumn">
                                            <div class="PageNavigationLink">
                                                <a href="../Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.REPORT_CRM_OPPORTUNITY_STATUS %>" target="PageFrame1" class="Button ButtonIcon Link NormalState chaxun">商机状态</a>
                                                <div class="StandardText">介绍介绍</div>
                                            </div>
                                            <div class="PageNavigationLink">
                                                <a href="../Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.REPORT_CRM_OPPORTUNITY_OVERGROUP_BYUSER %>" target="PageFrame1" class="Button ButtonIcon Link NormalState chaxun">过期商机按员工分组展示</a>
                                                <div class="StandardText">介绍介绍</div>
                                            </div>
                                            <div class="PageNavigationLink">
                                                <a href="../Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.REPORT_CRM_OPPORTUNITY_MONTH_FORRCAST %>" target="PageFrame1" class="Button ButtonIcon Link NormalState chaxun">商机每月预估收入</a>
                                                <div class="StandardText">介绍介绍</div>
                                            </div>
                                            <div class="PageNavigationLink">
                                                <a href="../Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.REPORT_CRM_OPPORTUNITY_STAGE_ANALYSIS %>" target="PageFrame1" class="Button ButtonIcon Link NormalState chaxun">商机阶段分析</a>
                                                <div class="StandardText">介绍介绍</div>
                                            </div>
                                            <div class="PageNavigationLink">
                                                <a href="../Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.REPORT_CRM_OPPORTUNITY_STAGE_ANALYSIS_DETAIL %>" target="PageFrame1" class="Button ButtonIcon Link NormalState chaxun">商机阶段分析详情</a>
                                                <div class="StandardText">介绍介绍</div>
                                            </div>
                                            <div class="PageNavigationLink">
                                                <a href="../Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.REPORT_CRM_OPPORTUNITY_QUOTA %>" target="PageFrame1" class="Button ButtonIcon Link NormalState chaxun">销售指标</a>
                                                <div class="StandardText">介绍介绍</div>
                                            </div>
                                            <div class="PageNavigationLink">
                                                <a href="../Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.REPORT_CRM_OPPORTUNITY_QUOTA_SUMMARY %>" target="PageFrame1" class="Button ButtonIcon Link NormalState chaxun">销售指标汇总</a>
                                                <div class="StandardText">介绍介绍</div>
                                            </div>
                                        </div>
                                    </div>

                                </div>
                            </div>
                        </div>
                        <%}%>
                        <!--第六个框-->
                        <%if (CheckAuth("SYS_FEATURES_CONTRACT"))
                            { %>
                        <div class="Normal Section Collapsed Normal1 col" id="b6">
                            <div class="Heading">
                                <div class="Toggle Expand Toggle1" id="a6">
                                    <div class="Vertical Vertical1"></div>
                                    <div class="Horizontal"></div>
                                </div>
                                <span class="Text">导出</span>
                                <span></span>
                            </div>
                            <div class="Content Content1" id="c6">
                                <div class="Large Column">
                                    <div class="PageNavigationLinkGroup">
                                        <div class="PageNavigationLinkColumn">

                                            <div class="PageNavigationLink">
                                                <a href="../Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.REPORT_CRM_EXPORT_COMPANY %>" target="PageFrame1" class="Button ButtonIcon Link NormalState chaxun">导出客户</a>
                                                <div class="StandardText">介绍介绍</div>
                                            </div>

                                        </div>
                                        <div class="PageNavigationLinkColumn">

                                            <div class="PageNavigationLink">
                                                <a href="../Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.REPORT_CRM_EXPORT_CONTACT %>" target="PageFrame1" class="Button ButtonIcon Link NormalState chaxun">导出联系人</a>
                                                <div class="StandardText">介绍介绍</div>
                                            </div>

                                        </div>
                                    </div>

                                </div>
                            </div>
                        </div>
                        <%}%>
                    </div>
                    <!--第二部分-->
                    <div class="TabContainer TabContainer2">
                        <div class="ButtonContainer">
                            <a class="Button ButtonIcon NormalState" tabindex="0" id="d3">
                                <span class="Text">展开所有</span>
                            </a>
                            <a class="Button ButtonIcon NormalState" tabindex="0" id="d4">
                                <span class="Text">折叠所有</span>
                            </a>
                        </div>
                        <!--第一个框-->
                        <div class="Normal Collapsed Section Normal2 col" id="f1">
                            <div class="Heading">
                                <div class="Toggle Expand Toggle2" id="e1">
                                    <div class="Vertical Vertical2"></div>
                                    <div class="Horizontal"></div>
                                </div>
                                <span class="Text">项目</span>
                                <span></span>
                            </div>
                            <div class="Content Content2" id="">
                                <div class="Large Column">
                                    <div class="PageNavigationLinkGroup">
                                        <div class="PageNavigationLinkColumn">
                                            <div class="PageNavigationLink">
                                                <a class="Button ButtonIcon Link NormalState chaxun" href="../Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.REPORT_PROJECT_PROJECT_LIST %>" target="PageFrame1">项目清单</a>
                                                <div class="StandardText">介绍介绍</div>
                                            </div>
                                            <div class="PageNavigationLink">
                                                <a class="Button ButtonIcon Link NormalState chaxun" href="../Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.REPORT_PROJECT_LABOUR_SUMMARY_BYTASK %>" target="PageFrame1">工时和费用按任务汇总</a>
                                                <div class="StandardText">介绍介绍</div>
                                            </div>
                                            <div class="PageNavigationLink">
                                                <a class="Button ButtonIcon Link NormalState chaxun" href="../Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.REPORT_PROJECT_LABOUR_SUMMARY_BYWORKTYPE %>" target="PageFrame1">按工作类型汇总工时收入</a>
                                                <div class="StandardText">介绍介绍</div>
                                            </div>
                                            <div class="PageNavigationLink">
                                                <a class="Button ButtonIcon Link NormalState chaxun" href="../Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.REPORT_PROJECT_LABOUR_SUMMARY_BYWORKTYPERES %>" target="PageFrame1">按工作类型员工汇总工时收入</a>
                                                <div class="StandardText">介绍介绍</div>
                                            </div>
                                        </div>
                                          <div class="PageNavigationLinkColumn">
                                               <div class="PageNavigationLink">
                                                <a class="Button ButtonIcon Link NormalState chaxun" href="../Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.REPORT_PROJECT_LABOUR_SUMMARY_BYMONTHRES %>" target="PageFrame1">按员工和月份汇总工时</a>
                                                <div class="StandardText">介绍介绍</div>
                                            </div>
                                          </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                       <!--第二个框-->
                        <div class="Normal Collapsed Section Normal2 col" id="f2">
                            <div class="Heading">
                                <div class="Toggle Expand Toggle2" id="e2">
                                    <div class="Vertical Vertical2"></div>
                                    <div class="Horizontal"></div>
                                </div>
                                <span class="Text">项目组合</span>
                                <span></span>
                            </div>
                            <div class="Content Content2" id="g2">
                                <div class="Large Column">
                                    <div class="PageNavigationLinkGroup">
                                        <div class="PageNavigationLinkColumn">
                                            <div class="PageNavigationLink">
                                                <a class="Button ButtonIcon Link NormalState chaxun" href="../Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.PROJECT_DASHBOARD_PROJECT_STATUS %>&param1=HiddenHeader" target="PageFrame1">项目组合状态报表</a>
                                                <div class="StandardText">介绍介绍</div>
                                            </div>
                                        </div>
                                          <div class="PageNavigationLinkColumn">
                                               <div class="PageNavigationLink">
                                                <a class="Button ButtonIcon Link NormalState chaxun" href="../Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.REPORT_PROJECT_PORTFOLIO_REVENCE %>" target="PageFrame1">项目组合收入</a>
                                                <div class="StandardText">介绍介绍</div>
                                            </div>
                                          </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <!--第三个框-->
                          <div class="Normal Collapsed Section Normal2 col" id="f3">
                            <div class="Heading">
                                <div class="Toggle Expand Toggle2" id="e3">
                                    <div class="Vertical Vertical2"></div>
                                    <div class="Horizontal"></div>
                                </div>
                                <span class="Text">任务</span>
                                <span></span>
                            </div>
                            <div class="Content Content2" id="g3">
                                <div class="Large Column">
                                    <div class="PageNavigationLinkGroup">
                                        <div class="PageNavigationLinkColumn">
                                            <div class="PageNavigationLink">
                                                <a class="Button ButtonIcon Link NormalState chaxun" href="../Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.PROJECT_DASHBOARD_OVER_TASK %>" target="PageFrame1">过期任务</a>
                                                <div class="StandardText">介绍介绍</div>
                                            </div>
                                            <div class="PageNavigationLink">
                                                <a class="Button ButtonIcon Link NormalState chaxun" href="../Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.REPORT_PROJECT_TASK_RES_ACHIEVEMENTS %>&param1=HiddenHeader" target="PageFrame1">任务员工绩效分析</a>
                                                <div class="StandardText">介绍介绍</div>
                                            </div>
                                        </div>
                                          <div class="PageNavigationLinkColumn">
                                              
                                          </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <!--第三部分-->
                    <div class="TabContainer TabContainer3">
                        <div class="ButtonContainer">
                            <a class="Button ButtonIcon NormalState" tabindex="0" id="d5">
                                <span class="Text">展开所有</span>
                            </a>
                            <a class="Button ButtonIcon NormalState" tabindex="0" id="d6">
                                <span class="Text">折叠所有</span>
                            </a>
                        </div>
                        <!--第一个框-->
                        <div class="Normal Collapsed Section Normal3 col" id="">
                            <div class="Heading">
                                <div class="Toggle Expand Toggle3" id="">
                                    <div class="Vertical Vertical3"></div>
                                    <div class="Horizontal"></div>
                                </div>
                                <span class="Text">常规</span>
                                <span></span>
                            </div>
                            <div class="Content Content3" id="g1">
                                <div class="Large Column">
                                    <div class="PageNavigationLinkGroup">
                                         <div class="PageNavigationLinkColumn">
                                             <div class="PageNavigationLink">
                                                <a href="../Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.REPORT_TICKET_GENERAL_SUMMARY_BYQUEUE %>" target="PageFrame1" class="Button ButtonIcon Link NormalState chaxun">按队列汇总工单</a>
                                                <div class="StandardText">介绍介绍</div>
                                            </div>
                                              <div class="PageNavigationLink">
                                                <a href="../Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.REPORT_TICKET_GENERAL_SUMMARY_BYRESOURCE %>" target="PageFrame1" class="Button ButtonIcon Link NormalState chaxun">按员工汇总工单</a>
                                                <div class="StandardText">介绍介绍</div>
                                            </div>
                                           
                                         </div>
                                        <div class="PageNavigationLinkColumn">
                                              <div class="PageNavigationLink">
                                                <a href="../Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.REPORT_TICKET_GENERAL_LABOURNOTE %>" target="PageFrame1" class="Button ButtonIcon Link NormalState chaxun">工单工时和备注</a>
                                                <div class="StandardText">介绍介绍</div>
                                            </div>
                                              <div class="PageNavigationLink">
                                                <a href="../Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.REPORT_SERVICEDESK_TICKETBYACCOUNT %>" target="PageFrame1" class="Button ButtonIcon Link NormalState chaxun">按客户和月份汇总工单</a>
                                                <div class="StandardText">介绍介绍</div>
                                            </div>
                                              <div class="PageNavigationLink">
                                                <a href="../Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.REPORT_TICKET_GENERAL_NOCLOSE %>" target="PageFrame1" class="Button ButtonIcon Link NormalState chaxun">未关闭工单</a>
                                                <div class="StandardText">介绍介绍</div>
                                            </div>
                                            <div class="PageNavigationLink">
                                                <a href="../Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.REPORT_SERVICEDESK_TICKETBYACCOUNT %>" target="PageFrame1" class="Button ButtonIcon Link NormalState chaxun">工单和任务按客户</a>
                                                <div class="StandardText">介绍介绍</div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                         <!--第二个框-->
                        <div class="Normal Collapsed Section Normal3 col" id="">
                            <div class="Heading">
                                <div class="Toggle Expand Toggle3" id="">
                                    <div class="Vertical Vertical3"></div>
                                    <div class="Horizontal"></div>
                                </div>
                                <span class="Text">工单处理效率</span>
                                <span></span>
                            </div>
                            <div class="Content Content3" id="">
                                <div class="Large Column">
                                    <div class="PageNavigationLinkGroup">
                                         <div class="PageNavigationLinkColumn">
                                             <div class="PageNavigationLink">
                                                <a href="../Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.REPORT_TICKET_METRICS_QUEUE %>" target="PageFrame1" class="Button ButtonIcon Link NormalState chaxun">队列处理工单效率</a>
                                                <div class="StandardText">介绍介绍</div>
                                            </div>
                                              <div class="PageNavigationLink">
                                                <a href="../Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.REPORT_TICKET_METRICS_RESOURCE %>" target="PageFrame1" class="Button ButtonIcon Link NormalState chaxun">员工处理工单效率</a>
                                                <div class="StandardText">介绍介绍</div>
                                            </div>
                                              <div class="PageNavigationLink">
                                                <a href="../Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.REPORT_TICKET_METRICS_SUMMARY_BYISSUE %>" target="PageFrame1" class="Button ButtonIcon Link NormalState chaxun">按问题类型汇总工单</a>
                                                <div class="StandardText">介绍介绍</div>
                                            </div>
                                           
                                         </div>
                                        <div class="PageNavigationLinkColumn">
                                              <div class="PageNavigationLink">
                                                <a href="../Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.REPORT_TICKET_METRICS_SUMMARY_BYSOURCE %>" target="PageFrame1" class="Button ButtonIcon Link NormalState chaxun">按来源汇总工单</a>
                                                <div class="StandardText">介绍介绍</div>
                                            </div>
                                              <div class="PageNavigationLink">
                                                <a href="../Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.REPORT_TICKET_METRICS_SLA_COMPLETE %>" target="PageFrame1" class="Button ButtonIcon Link NormalState chaxun">SLA指标完成情况</a>
                                                <div class="StandardText">介绍介绍</div>
                                            </div>
                                              <div class="PageNavigationLink">
                                                <a href="../Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.REPORT_TICKET_METRICS_SLA_COMPLETE_DETAIL %>" target="PageFrame1" class="Button ButtonIcon Link NormalState chaxun">SLA指标完成详情</a>
                                                <div class="StandardText">介绍介绍</div>
                                            </div>
                                            
                                           
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <!--第四部分-->
                    <div class="TabContainer TabContainer4">
                        <div class="ButtonContainer">
                            <a class="Button ButtonIcon NormalState" tabindex="0" id="d7">
                                <span class="Text">展开所有</span>
                            </a>
                            <a class="Button ButtonIcon NormalState" tabindex="0" id="d8">
                                <span class="Text">折叠所有</span>
                            </a>
                        </div>
                        <!--第一个框-->
                        <div class="Normal Collapsed Section Normal4 col">
                            <div class="Heading">
                                <div class="Toggle Expand Toggle4">
                                    <div class="Vertical Vertical4"></div>
                                    <div class="Horizontal"></div>
                                </div>
                                <span class="Text">合同</span>
                                <span></span>
                            </div>
                            <div class="Content Content4">
                                <div class="Large Column">
                                    <div class="PageNavigationLinkGroup">
                                        <div class="PageNavigationLinkColumn">
                                             <div class="PageNavigationLink">
                                                <a href="../Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.REPORT_CONTRACTBILL_CONTRACT_PREPAID_COST %>" target="PageFrame1" class="Button ButtonIcon Link NormalState chaxun">预付费用扣除</a>
                                                <div class="StandardText">介绍介绍</div>
                                            </div>
                                             <div class="PageNavigationLink">
                                                <a href="../Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.REPORT_CONTRACTBILL_CONTRACT_PREPAID_TIME %>" target="PageFrame1" class="Button ButtonIcon Link NormalState chaxun">预付时间扣除</a>
                                                <div class="StandardText">介绍介绍</div>
                                            </div>
                                        </div>
                                           <div class="PageNavigationLinkColumn">
                                             <div class="PageNavigationLink">
                                                <a href="../Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.REPORT_CONTRACTBILL_CONTRACT_OVER %>" target="PageFrame1" class="Button ButtonIcon Link NormalState chaxun">过期合同和配置项</a>
                                                <div class="StandardText">介绍介绍</div>
                                            </div>
                                             <div class="PageNavigationLink">
                                                <a href="../Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.REPORT_CONTRACTBILL_CONTRACT_EVENT %>" target="PageFrame1" class="Button ButtonIcon Link NormalState chaxun">事件扣除</a>
                                                <div class="StandardText">介绍介绍</div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <!--第二个框-->
                        <div class="Normal Collapsed Section Normal4 col">
                            <div class="Heading">
                                <div class="Toggle Expand Toggle4">
                                    <div class="Vertical Vertical4"></div>
                                    <div class="Horizontal"></div>
                                </div>
                                <span class="Text">计费</span>
                                <span></span>
                            </div>
                            <div class="Content Content4">
                                <div class="Large Column">
                                    <div class="PageNavigationLinkGroup">
                                        <div class="PageNavigationLinkColumn">
                                            <div class="PageNavigationLink">
                                                <a href="../Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.REPORT_CONTRACT_BILL_TOBILL %>" target="PageFrame1" class="Button ButtonIcon Link NormalState chaxun">待计费详情报表</a>
                                                <div class="StandardText">介绍介绍</div>
                                            </div>
                                            <div class="PageNavigationLink">
                                                <a href="../Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.REPORT_CONTRACT_BILLED %>" target="PageFrame1" class="Button ButtonIcon Link NormalState chaxun">已计费信息</a>
                                                <div class="StandardText">介绍介绍</div>
                                            </div>
                                            <div class="PageNavigationLink">
                                                <a href="../Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.REPORT_CONTRACTBILL_BILL_MILSTONE %>" target="PageFrame1" class="Button ButtonIcon Link NormalState chaxun">里程碑</a>
                                                <div class="StandardText">介绍介绍</div>
                                            </div>
                                        </div>
                                         <div class="PageNavigationLinkColumn">
                                            <div class="PageNavigationLink">
                                                <a href="../Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.REPORT_CONTRACTBILL_BILL_PROJECT_FINANCIAL %>" target="PageFrame1" class="Button ButtonIcon Link NormalState chaxun">项目总账财务信息</a>
                                                <div class="StandardText">介绍介绍</div>
                                            </div>
                                            <div class="PageNavigationLink">
                                                <a href="../Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.REPORT_CONTRACTBILL_BILL_TIME %>" target="PageFrame1" class="Button ButtonIcon Link NormalState chaxun">预付时间</a>
                                                <div class="StandardText">介绍介绍</div>
                                            </div>
                                            <div class="PageNavigationLink">
                                                <a href="../Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.REPORT_CONTRACTBILL_BILL_TO_BILL_ITEM %>" target="PageFrame1" class="Button ButtonIcon Link NormalState chaxun">本公司待计费条目</a>
                                                <div class="StandardText">介绍介绍</div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <!--第三个框-->
                     <%--   <div class="Normal Collapsed Section Normal4" id="">
                            <div class="Heading">
                                <div class="Toggle Expand Toggle4" id="">
                                    <div class="Vertical Vertical4"></div>
                                    <div class="Horizontal"></div>
                                </div>
                                <span class="Text">客户端门户与TASKFIRE</span>
                                <span></span>
                            </div>
                            <div class="Content Content4" id="">
                                <div class="Large Column">
                                    <div class="PageNavigationLinkGroup">
                                        <div class="PageNavigationLinkColumn">
                                        </div>
                                        <div class="PageNavigationLinkColumn">
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>--%>
                    </div>

                       <!--第五部分-->
                    <div class="TabContainer TabContainer5">
                        <div class="ButtonContainer">
                            <a class="Button ButtonIcon NormalState" tabindex="0" id="d9">
                                <span class="Text">展开所有</span>
                            </a>
                            <a class="Button ButtonIcon NormalState" tabindex="0" id="d10">
                                <span class="Text">折叠所有</span>
                            </a>
                        </div>
                        <!--第一个框-->
                        <div class="Normal Collapsed Section Normal5 col" id="">
                            <div class="Heading">
                                <div class="Toggle Expand Toggle5" id="">
                                    <div class="Vertical Vertical5"></div>
                                    <div class="Horizontal"></div>
                                </div>
                                <span class="Text">常规</span>
                                <span></span>
                            </div>
                            <div class="Content Content5">
                                <div class="Large Column">
                                    <div class="PageNavigationLinkGroup">
                                        <div class="PageNavigationLinkColumn">
                                            <div class="PageNavigationLink">
                                                <a href="../Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.REPORT_RESOURCE_GENERAL_INTERNAL_LABOUR %>" target="PageFrame1" class="Button ButtonIcon Link NormalState chaxun">内部工时汇总</a>
                                                <div class="StandardText">介绍介绍</div>
                                            </div>
                                             <div class="PageNavigationLink">
                                                <a href="../Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.REPORT_RESOURCE_GENERAL_TASKTICEKT %>" target="PageFrame1" class="Button ButtonIcon Link NormalState chaxun">员工任务和工单</a>
                                                <div class="StandardText">介绍介绍</div>
                                            </div>
                                             <div class="PageNavigationLink">
                                                <a href="../Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.REPORT_RESOURCE_GENERAL_RESOURCE_MONTH_WORKTIME_NUM %>" target="PageFrame1" class="Button ButtonIcon Link NormalState chaxun">按月统计员工工作时间</a>
                                                <div class="StandardText">介绍介绍</div>
                                            </div>
                                             <div class="PageNavigationLink">
                                                <a href="../Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.REPORT_RESOURCE_GENERAL_RESOURCE_YEAR_WORKTIME_NUM %>" target="PageFrame1" class="Button ButtonIcon Link NormalState chaxun">按年统计员工工作时间</a>
                                                <div class="StandardText">介绍介绍</div>
                                            </div>
                                             <div class="PageNavigationLink">
                                                <a href="../Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.REPORT_RESOURCE_GENERAL_RESOURCE_PROJECT_LABOUR %>" target="PageFrame1" class="Button ButtonIcon Link NormalState chaxun">员工项目工时</a>
                                                <div class="StandardText">介绍介绍</div>
                                            </div>
                                             <div class="PageNavigationLink">
                                                <a href="../Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.REPORT_RESOURCE_GENERAL_LABOUR_SUMMARY_BYTYPE %>" target="PageFrame1" class="Button ButtonIcon Link NormalState chaxun">按类型汇总工时</a>
                                                <div class="StandardText">介绍介绍</div>
                                            </div>
                                        </div>

                                          <div class="PageNavigationLinkColumn">
                                             <div class="PageNavigationLink">
                                                <a href="../Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.REPORT_RESOURCE_GENERAL_RESOURCE_WEEK_LABOUR %>" target="PageFrame1" class="Button ButtonIcon Link NormalState chaxun">员工一周工时</a>
                                                <div class="StandardText">介绍介绍</div>
                                            </div>
                                             <div class="PageNavigationLink">
                                                <a href="../Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.REPORT_RESOURCE_GENERAL_RESOURCE_UTILIZATION %>" target="PageFrame1" class="Button ButtonIcon Link NormalState chaxun">员工利用率</a>
                                                <div class="StandardText">介绍介绍</div>
                                            </div>
                                             <div class="PageNavigationLink">
                                                <a href="../Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.REPORT_RESOURCE_GENERAL_LABOUR_REPORT %>" target="PageFrame1" class="Button ButtonIcon Link NormalState chaxun">分类工时报表</a>
                                                <div class="StandardText">介绍介绍</div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                         <!--第六部分-->
                    <div class="TabContainer TabContainer6">
                        <div class="ButtonContainer">
                            <a class="Button ButtonIcon NormalState" tabindex="0" id="d11">
                                <span class="Text">展开所有</span>
                            </a>
                            <a class="Button ButtonIcon NormalState" tabindex="0" id="d12">
                                <span class="Text">折叠所有</span>
                            </a>
                        </div>
                        <!--第一个框-->
                        <div class="Normal Collapsed Section Normal6 col" id="">
                            <div class="Heading">
                                <div class="Toggle Expand Toggle6" id="">
                                    <div class="Vertical Vertical6"></div>
                                    <div class="Horizontal"></div>
                                </div>
                                <span class="Text">系统</span>
                                <span></span>
                            </div>
                            <div class="Content Content6">
                                <div class="Large Column">
                                    <div class="PageNavigationLinkGroup">
                                        <div class="PageNavigationLinkColumn">
                                            <div class="PageNavigationLink">
                                                <a href="../Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.REPORT_OTHER_SYSTEM_LOGINLOG %>" target="PageFrame1" class="Button ButtonIcon Link NormalState chaxun">登录日志</a>
                                                <div class="StandardText">介绍介绍</div>
                                            </div>
                                           
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                         <!--第七部分-->
                    <div class="TabContainer TabContainer7">
                        <div class="ButtonContainer">
                            <a class="Button ButtonIcon NormalState" tabindex="0" id="d13">
                                <span class="Text">展开所有</span>
                            </a>
                            <a class="Button ButtonIcon NormalState" tabindex="0" id="d14">
                                <span class="Text">折叠所有</span>
                            </a>
                        </div>
                        <!--第一个框-->
                        <div class="Normal Collapsed Section Normal7 col" id="">
                            <div class="Heading">
                                <div class="Toggle Expand Toggle7" id="">
                                    <div class="Vertical Vertical7"></div>
                                    <div class="Horizontal"></div>
                                </div>
                                <span class="Text">系统</span>
                                <span></span>
                            </div>
                            <div class="Content Content7">
                                <div class="Large Column">
                                    <div class="PageNavigationLinkGroup">
                                        <div class="PageNavigationLinkColumn">
                                            <div class="PageNavigationLink">
                                                <a href="../Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.REPORT_OTHER_SYSTEM_LOGINLOG %>" target="PageFrame1" class="Button ButtonIcon Link NormalState chaxun">登录日志</a>
                                                <div class="StandardText">介绍介绍</div>
                                            </div>
                                            
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!--第八部分-->
                    <div class="TabContainer TabContainer8">
                        <div class="ButtonContainer">
                            <a class="Button ButtonIcon NormalState" tabindex="0" id="d15">
                                <span class="Text">展开所有</span>
                            </a>
                            <a class="Button ButtonIcon NormalState" tabindex="0" id="d16">
                                <span class="Text">折叠所有</span>
                            </a>
                        </div>
                        <!--第一个框-->
                        <div class="Normal Collapsed Section Normal8 col" id="">
                            <div class="Heading">
                                <div class="Toggle Expand Toggle8" id="">
                                    <div class="Vertical Vertical8"></div>
                                    <div class="Horizontal"></div>
                                </div>
                                <span class="Text">系统</span>
                                <span></span>
                            </div>
                            <div class="Content Content8">
                                <div class="Large Column">
                                    <div class="PageNavigationLinkGroup">
                                        <div class="PageNavigationLinkColumn">
                                            <div class="PageNavigationLink">
                                                <a href="../Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.REPORT_OTHER_SYSTEM_LOGINLOG %>" target="PageFrame1" class="Button ButtonIcon Link NormalState chaxun">登录日志</a>
                                                <div class="StandardText">介绍介绍</div>
                                            </div>
                                            <div class="PageNavigationLink">
                                                <a class="Button ButtonIcon Link NormalState chaxun" href="../Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.REPORT_OTHER_SYSTEM_OPERLOG %>" target="PageFrame1">操作日志</a>
                                                <div class="StandardText">介绍介绍</div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div id="chaxun" style="display: none">
                <!--标题-->
                <div class="TitleBar">
                    <div class="Title">
                        <div class="TitleBarNavigationButton">
                            <a class="Button ButtonIcon NormalState" id="black">
                                <img src="../Images/move-left.png" /></a>
                        </div>
                        <span class="text1" id="opname"></span>
                        <a href="###" class="collection"></a>
                        <a href="###" class="help"></a>
                    </div>
                </div>
                <!--背景布-->
                <div id="WorkspaceContainer"></div>
                <div class="cont">
                    <iframe id="PageFrame1" style="width: 100%; border: none; margin: 0;" name="PageFrame1"></iframe>
                </div>
            </div>
        </div>
    </form>
    <script src="../Scripts/jquery-3.1.0.min.js"></script>
    <script src="../Scripts/Report.js"></script>
    <script src="Scripts/index.js" type="text/javascript" charset="utf-8"></script>
    <script>
        $(window).resize(function () {
            var Height = $(document).height() - 66 + "px";
            $("#PageFrame1").css("height", Height);
        })
        var Height = $(document).height() - 66 + "px";
        $("#PageFrame1").css("height", Height);

        $(".chaxun").on("click", function () {
            $("#body").hide();
            var kk = $(this).text();
            $("#opname").text(kk);
            var kkk = $("#opname").text();
            setTimeout(function () {
                $("#chaxun").show();
            }, 300)
        });
        $("#black").click(function () {
            $("#chaxun").hide();
            $("#body").show();
        });
        function black() {
            $("#chaxun").hide();
            $("#body").show();
        }

        $(function () {
            var queryPanel = '<%=Request.QueryString["SearchType"] %>';
            if (queryPanel == "Project") {
                $("#TabButtonProject").trigger("click");
            }
            else if (queryPanel == "ServiceDesk") {
                $("#TabButtonServiceDesk").trigger("click");
            }
            else if (queryPanel == "ContractBill") {
                $("#TabButtonContractBill").trigger("click");
            }
            else if (queryPanel == "Other") {
                $("#TabButtonOther").trigger("click");
            }
            else {
                $("#TabButtonCrm").trigger("click");
            }
        })

    </script>
</body>
</html>
