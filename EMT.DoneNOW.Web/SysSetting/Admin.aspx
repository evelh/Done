<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Admin.aspx.cs" Inherits="EMT.DoneNOW.Web.SysSetting.Admin" %>

<%@ Import Namespace="EMT.DoneNOW.DTO" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <link href="../Content/Admin.css" rel="stylesheet" />
    <link href="../Content/ClassificationIcons.css" rel="stylesheet" />
    <title>管理系统</title>
  <style>
    .StandardText{display:none;}
    .Large{margin-top:15px;}
  </style>
</head>
<body>
    <form id="form1" runat="server" method="post">
        <div>
            <div id="body">
            <!--顶部-->
            <div class="TitleBar">
                <div class="Title">
                    <span class="text1">管理员</span>
                    <a href="###" class="collection"></a>
                    <a href="###" class="help"></a>
                </div>
            </div>
            <!--选择框-->
            <div class="TabBar">
                <a class="Button ButtonIcon SelectedState">
                    <span class="Text">功能和设置</span>
                </a>
                <a class="Button ButtonIcon">
                    <span class="Text">扩展和集成</span>
                </a>
            </div>
            <div class="ScrollingContainer Active" style="top: 82px; bottom: 0;">
                <!--第一部分-->
                <div class="TabContainer Active">
                    <div class="ButtonContainer">
                        <a class="Button ButtonIcon NormalState" tabindex="0" id="d1">
                            <span class="Text">展开所有</span>
                        </a>
                        <a class="Button ButtonIcon NormalState" tabindex="0" id="d2">
                            <span class="Text">折叠所有</span>
                        </a>
                    </div>
                    <!--第三个框-->
                  <%if (CheckAuth("SYS_FEATURES_RESOURCES")) { %>
                    <div class="Normal Section Collapsed Normal1" id="b3">
                        <div class="Heading">
                            <div class="Toggle Expand Toggle1" id="a3">
                                <div class="Vertical Vertical1"></div>
                                <div class="Horizontal"></div>
                            </div>
                            <span class="Text">员工/用户管理</span>
                            <span></span>
                        </div>
                        <div class="Content Content1" id="c3">
                            <div class="Large Column">
                                <div class="PageNavigationLinkGroup">
                                    <div class="PageNavigationLinkColumn">
                                      <%if (CheckAuth("SYS_FEATURES_RESOURCES_RESOURCE")) { %>
                                        <div class="PageNavigationLink">
                                            <a class="Button ButtonIcon Link NormalState chaxun" href="../Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.RESOURCE %>" target="PageFrame1">员工/用户管理</a>
                                            <div class="StandardText">介绍介绍</div>
                                        </div>
                                      <%}%>
                                      <%if (CheckAuth("SYS_FEATURES_RESOURCES_ROLES")) { %>
                                        <div class="PageNavigationLink">
                                            <a class="Button ButtonIcon Link NormalState chaxun" href="../Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.SYS_ROLE %>" target="PageFrame1">角色</a>
                                            <div class="StandardText">介绍介绍</div>
                                        </div>
                                      <%}%>
                                        </div>
                                        <div class="PageNavigationLinkColumn">
                                          <%if (CheckAuth("SYS_FEATURES_RESOURCES_DEPARTMENTS")) { %>
                                        <div class="PageNavigationLink">
                                            <a class="Button ButtonIcon Link NormalState chaxun" href="../Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.SYS_DEPARTMENT %>" target="PageFrame1">部门</a>
                                            <div class="StandardText">介绍介绍</div>
                                        </div>
                                          <%}%>
                                    </div>
                                </div>
                                <div class="PageNavigationLinkGroup">
                                    <div class="Heading">
                                        <div class="Text">安全</div>
                                    </div>
                                    <div class="PageNavigationLinkColumn">
                                      <%if (CheckAuth("SYS_FEATURES_RESOURCES_SECURITY_LEVEL")) { %>
                                        <div class="PageNavigationLink">
                                            <a class="Button ButtonIcon Link NormalState chaxun" href="../Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.SECURITY_LEVEL %>" target="PageFrame1">安全等级</a>
                                            <div class="StandardText">介绍介绍</div>
                                        </div>
                                      <%}%>
                                         </div>
                                        <div class="PageNavigationLinkColumn">
                                          <%if (CheckAuth("SYS_FEATURES_RESOURCES_PROTECTED_DATA")) { %>
                                        <div class="PageNavigationLink">
                                            <a href="SysDataPermission.aspx" class="Button ButtonIcon Link NormalState chaxun" target="PageFrame1">被保护数据权限设置</a>
                                            <div class="StandardText">介绍介绍</div>
                                        </div>
                                          <%}%>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                  <%}%>
                     <!--第四个框-->
                  <%if (CheckAuth("SYS_FEATURES_COMPANY_CONTACT")) { %>
                    <div class="Normal Section Collapsed Normal1" id="b4">
                        <div class="Heading">
                            <div class="Toggle Expand Toggle1" id="a4">
                                <div class="Vertical Vertical1"></div>
                                <div class="Horizontal"></div>
                            </div>
                            <span class="Text">客户与联系人</span>
                            <span></span>
                        </div>
                        <div class="Content Content1" id="c4">
                            <div class="Large Column">
                                <div class="PageNavigationLinkGroup">
                                    <div class="PageNavigationLinkColumn">
                                      <%if (CheckAuth("SYS_FEATURES_COMPANY_CONTACT_MARKET_SEGMENT")) { %>
                                        <div class="PageNavigationLink">
                                            <a href="../Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.MARKET %>" target="PageFrame1" class="Button ButtonIcon Link NormalState chaxun">市场领域</a>
                                            <div class="StandardText">介绍介绍</div>
                                        </div>
                                      <%}%>
                                      <%if (CheckAuth("SYS_FEATURES_COMPANY_CONTACT_TERRITORY")) { %>
                                        <div class="PageNavigationLink">
                                            <a href="../Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.TERRITORY %>" target="PageFrame1" class="Button ButtonIcon Link NormalState chaxun">地域</a>
                                            <div class="StandardText">介绍介绍</div>
                                        </div>
                                      <%}%>
                                      <%if (CheckAuth("SYS_FEATURES_COMPANY_CONTACT_REGION")) { %>
                                        <div class="PageNavigationLink">
                                            <a href="../Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.ACCOUNTREGION %>" target="PageFrame1" class="Button ButtonIcon Link NormalState chaxun">区域</a>
                                            <div class="StandardText">介绍介绍</div>
                                        </div>
                                      <%}%>
                                      <%if (CheckAuth("SYS_FEATURES_COMPANY_CONTACT_COUNTRY")) { %>
                                        <div class="PageNavigationLink">
                                            <a href="../Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.COUNTRY %>" target="PageFrame1" class="Button ButtonIcon Link NormalState chaxun">国家</a>
                                            <div class="StandardText">介绍介绍</div>
                                        </div>
                                      <%}%>
                                         </div>
                                        <div class="PageNavigationLinkColumn">
                                          <%if (CheckAuth("SYS_FEATURES_COMPANY_CONTACT_COMPETITOR")) { %>
                                        <div class="PageNavigationLink">
                                            <a href="../Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.COMPETITOR %>" target="PageFrame1" class="Button ButtonIcon Link NormalState chaxun">竞争对手</a>
                                            <div class="StandardText">介绍介绍</div>
                                        </div>
                                          <%}%>
                                          <%if (CheckAuth("SYS_FEATURES_COMPANY_CONTACT_CLASSIFICATION_ICON")) { %>
                                        <div class="PageNavigationLink">
                                            <a href="../Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.ACCOUNTTYPE %>" target="PageFrame1" class="Button ButtonIcon Link NormalState chaxun">客户类别</a>
                                            <div class="StandardText">介绍介绍</div>
                                        </div>
                                          <%}%>
                                          <%if (CheckAuth("SYS_FEATURES_COMPANY_CONTACT_NAME_PREFIX_SUFFIX")) { %>
                                        <div class="PageNavigationLink">
                                            <a href="../Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.SUFFIXES %>" target="PageFrame1" class="Button ButtonIcon Link NormalState chaxun">姓名后缀</a>
                                            <div class="StandardText">介绍介绍</div>
                                        </div>
                                          <%}%>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                  <%}%>
                     <!--第五个框-->
                  <%if (CheckAuth("SYS_FEATURES_SALES_OPPS")) { %>
                    <div class="Normal Section Collapsed Normal1" id="b5">
                        <div class="Heading">
                            <div class="Toggle Expand Toggle1" id="a5">
                                <div class="Vertical Vertical1"></div>
                                <div class="Horizontal"></div>
                            </div>
                            <span class="Text">销售和商机</span>
                            <span></span>
                        </div>
                        <div class="Content Content1" id="c5">
                            <div class="Large Column">
                                <div class="PageNavigationLinkGroup">
                                    <div class="PageNavigationLinkColumn">
                                      <%if (CheckAuth("SYS_FEATURES_SALES_OPPS_ACTION_TYPE")) { %>
                                        <div class="PageNavigationLink">
                                            <a href="../Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.ACTIONTYPE %>" target="PageFrame1" class="Button ButtonIcon Link NormalState chaxun">活动类型</a>
                                            <div class="StandardText">介绍介绍</div>
                                        </div>
                                      <%}%>
                                      <%if (CheckAuth("SYS_FEATURES_SALES_OPPS_OPP_STAGES")) { %>
                                        <div class="PageNavigationLink">
                                            <a href="../Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.OPPORTUNITYAGES %>" target="PageFrame1" class="Button ButtonIcon Link NormalState chaxun">商机阶段</a>
                                            <div class="StandardText">介绍介绍</div>
                                        </div>
                                      <%}%>
                                      <%if (CheckAuth("SYS_FEATURES_SALES_OPPS_OPP_SOURCE")) { %>
                                        <div class="PageNavigationLink">
                                            <a href="../Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.OPPORTUNITYSOURCE %>" target="PageFrame1" class="Button ButtonIcon Link NormalState chaxun">商机来源</a>
                                            <div class="StandardText">介绍介绍</div>
                                        </div>
                                       <%}%>
                                    </div>
                                    <div class="PageNavigationLinkColumn">
                                      <%if (CheckAuth("SYS_FEATURES_SALES_OPPS_OPP_WIN_REASON")) { %>
                                         <div class="PageNavigationLink">
                                            <a  href="../Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.OPPPORTUNITYWINREASON %>" target="PageFrame1" class="Button ButtonIcon Link NormalState chaxun">关闭商机的原因</a>
                                            <div class="StandardText">介绍介绍</div>
                                        </div>
                                      <%}%>
                                      <%if (CheckAuth("SYS_FEATURES_SALES_OPPS_OPP_LOSS_REASON")) { %>
                                        <div class="PageNavigationLink">
                                            <a href="../Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.OPPPORTUNITYLOSSREASON %>" target="PageFrame1" class="Button ButtonIcon Link NormalState chaxun">丢失商机的原因</a>
                                            <div class="StandardText">介绍介绍</div>
                                        </div>
                                      <%}%>
                                      <%if (CheckAuth("SYS_FEATURES_SALES_OPPS_SALES_QUOTA_METRICS")) { %>
                                        <div class="PageNavigationLink">
                                            <a href="OppoAdvancedField.aspx?id=<%=(int)GeneralTableEnum.OPPORTUNITY_ADVANCED_FIELD %>" class="Button ButtonIcon Link NormalState chaxun" target="PageFrame1">销售指标度量</a>
                                            <div class="StandardText">介绍介绍</div>
                                        </div>
                                      <%}%>
                                    </div>
                                </div>
                                <div class="PageNavigationLinkGroup">
                                    <div class="Heading">
                                        <div class="Text">报价</div>
                                    </div>
                                    <div class="PageNavigationLinkColumn">
                                      <%if (CheckAuth("SYS_FEATURES_SALES_OPPS_QUOTE_TEMPLATE")) { %>
                                        <div class="PageNavigationLink">
                                            <a class="Button ButtonIcon Link NormalState chaxun" href="../Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.QUOTE_TEMPLATE %>" target="PageFrame1">报价模板</a>
                                            <div class="StandardText">介绍介绍</div>
                                        </div>
                                      <%}%>
                                        </div>
                                </div>
                            </div>
                        </div>
                    </div>
                  <%}%>
                     <!--第六个框-->
                  <%if (CheckAuth("SYS_FEATURES_CONTRACT")) { %>
                    <div class="Normal Section Collapsed Normal1" id="b6">
                        <div class="Heading">
                            <div class="Toggle Expand Toggle1" id="a6">
                                <div class="Vertical Vertical1"></div>
                                <div class="Horizontal"></div>
                            </div>
                            <span class="Text">合同与撤销审批</span>
                            <span></span>
                        </div>
                        <div class="Content Content1" id="c6">
                            <div class="Large Column">
                                <div class="PageNavigationLinkGroup">
                                    <div class="PageNavigationLinkColumn">
                                      <%if (CheckAuth("SYS_FEATURES_CONTRACT_CATE")) { %>
                                        <div class="PageNavigationLink">
                                            <a href="../Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.CONTRACT_TYPE %>" target="PageFrame1" class="Button ButtonIcon Link NormalState chaxun">合同类别</a>
                                            <div class="StandardText">介绍介绍</div>
                                        </div>
                                      <%}%>
                                    </div>
                                    <div class="PageNavigationLinkColumn">
                                      <%if (CheckAuth("SYS_FEATURES_CONTRACT_BILLING_MILESTONE_STATUS")) { %>
                                        <div class="PageNavigationLink">
                                            <a href="../Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.CONTRACT_MILESTONE %>" target="PageFrame1" class="Button ButtonIcon Link NormalState chaxun">里程碑状态</a>
                                            <div class="StandardText">介绍介绍</div>
                                        </div>
                                      <%}%>
                                    </div>
                                </div>
                                <div class="PageNavigationLinkGroup">
                                    <div class="Heading">
                                        <div class="Text">撤销审批</div>
                                    </div>
                                    <div class="PageNavigationLinkColumn">
                                      <%if (CheckAuth("SYS_FEATURES_CONTRACT_UNPOST_RECURRING")) { %>
                                        <div class="PageNavigationLink">
                                            <a class="Button ButtonIcon Link NormalState chaxun" href="../Common/SearchFrameSet.aspx?isCheck=1&cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.REVOKE_RECURRING_SERVICES %>" target="PageFrame1">定期服务</a>
                                            <div class="StandardText">介绍介绍</div>
                                        </div>
                                      <%}%>
                                      <%if (CheckAuth("SYS_FEATURES_CONTRACT_UNPOST_CHARGES")) { %>
                                        <div class="PageNavigationLink">
                                            <a class="Button ButtonIcon Link NormalState chaxun" href="../Common/SearchFrameSet.aspx?isCheck=1&cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.REVOKE_CHARGES %>" target="PageFrame1">成本</a>
                                            <div class="StandardText">介绍介绍</div>
                                        </div>
                                      <%}%>
                                         <%if (CheckAuth("SYS_FEATURES_CONTRACT_UNPOST_LABOR")) { %>
                                        <div class="PageNavigationLink">
                                            <a class="Button ButtonIcon Link NormalState chaxun" href="../Common/SearchFrameSet.aspx?isCheck=1&cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.REVOKE_LABOUR %>" target="PageFrame1">工时</a>
                                            <div class="StandardText">介绍介绍</div>
                                        </div>
                                      <%}%>
                                    </div>

                                    <div class="PageNavigationLinkColumn"> 
                                      <%if (CheckAuth("SYS_FEATURES_CONTRACT_UNPOST_MILESTONE")) { %>
                                        <div class="PageNavigationLink">
                                            <a class="Button ButtonIcon Link NormalState chaxun" href="../Common/SearchFrameSet.aspx?isCheck=1&cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.REVOKE_MILESTONES %>" target="PageFrame1">里程碑</a>
                                            <div class="StandardText">介绍介绍</div>
                                        </div>
                                      <%}%>
                                      <%if (CheckAuth("SYS_FEATURES_CONTRACT_UNPOST_SUBSCRIPTION")) { %>
                                        <div class="PageNavigationLink">
                                            <a class="Button ButtonIcon Link NormalState chaxun" href="../Common/SearchFrameSet.aspx?isCheck=1&cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.REVOKE_SUBSCRIPTIONS %>" target="PageFrame1">订阅</a>
                                            <div class="StandardText">介绍介绍</div>
                                        </div>
                                      <%}%>
                                         <%if (CheckAuth("SYS_FEATURES_CONTRACT_UNPOST_EXPENSE")) { %>
                                        <div class="PageNavigationLink">
                                            <a class="Button ButtonIcon Link NormalState chaxun" href="../Common/SearchFrameSet.aspx?isCheck=1&cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.REVOKE_EXPENSE %>" target="PageFrame1">费用</a>
                                            <div class="StandardText">介绍介绍</div>
                                        </div>
                                      <%}%>
                                    </div>

                                    
                                </div>
                            </div>
                        </div>
                    </div>
                  <%}%>
                     <!--第七个框-->
                  <%if (CheckAuth("SYS_FEATURES_PRODUCT_SERVICE")) { %>
                     <div class="Normal Section Collapsed Normal1" id="b7">
                        <div class="Heading">
                            <div class="Toggle Expand Toggle1" id="a7">
                                <div class="Vertical Vertical1"></div>
                                <div class="Horizontal"></div>
                            </div>
                            <span class="Text">产品和服务</span>
                            <span></span>
                        </div>
                        <div class="Content Content1" id="c7">
                            <div class="Large Column">
                                <div class="PageNavigationLinkGroup">
                                    <div class="PageNavigationLinkColumn">
                                      <%if (CheckAuth("SYS_FEATURES_PRODUCT_SERVICE_PRODUCT")) { %>
                                        <div class="PageNavigationLink">
                                            <a class="Button ButtonIcon Link NormalState chaxun" href="../Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.PRODUCT %>" target="PageFrame1">产品</a>
                                            <div class="StandardText">介绍介绍</div>
                                        </div>
                                      <%}%>
                                    </div>
                                    <div class="PageNavigationLinkColumn">
                                        <div class="PageNavigationLink">
                                            <a class="Button ButtonIcon Link NormalState chaxun" href="../Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.SERVICE %>" target="PageFrame1">服务</a>
                                            <div class="StandardText">介绍介绍</div>
                                        </div>
                                    </div>
                                     <div class="PageNavigationLinkColumn">
                                        <div class="PageNavigationLink">
                                            <a class="Button ButtonIcon Link NormalState chaxun" href="../Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.SERVICE_BUNDLE %>" target="PageFrame1">服务包</a>
                                            <div class="StandardText">介绍介绍</div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                  <%}%>
                     <!--第八个框-->
                  <%if (CheckAuth("SYS_FEATURES_CONFIG_ITEM")) { %>
                     <div class="Normal Section Collapsed Normal1" id="b8">
                        <div class="Heading">
                            <div class="Toggle Expand Toggle1" id="a8">
                                <div class="Vertical Vertical1"></div>
                                <div class="Horizontal"></div>
                            </div>
                            <span class="Text">配置项</span>
                            <span></span>
                        </div>
                        <div class="Content Content1" id="c8">
                            <div class="Large Column">
                                <div class="PageNavigationLinkGroup">                                   
                                    <div class="PageNavigationLinkColumn">
                                      <%if (CheckAuth("SYS_FEATURES_CONFIG_ITEM_TYPE")) { %>
                                        <div class="PageNavigationLink">
                                            <a class="Button ButtonIcon Link NormalState chaxun" href="../Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.CONFIGITEMTYPE %>" target="PageFrame1">配置项类型</a>
                                            <div class="StandardText">介绍介绍</div>
                                        </div>
                                      <%}%>
                                    </div> 
                                </div>
                            </div>
                        </div>
                    </div>
                  <%}%>
                </div>
                <!--第二部分-->
                <div class="TabContainer">
                    <div class="ButtonContainer">
                        <a class="Button ButtonIcon NormalState" tabindex="0" id="d3">
                            <span class="Text">展开所有</span>
                        </a>
                        <a class="Button ButtonIcon NormalState" tabindex="0" id="d4">
                            <span class="Text">折叠所有</span>
                        </a>
                    </div>
                    <!--第一个框-->
                    <div class="Normal Collapsed Section Normal2" id="f1">
                        <div class="Heading">
                            <div class="Toggle Expand Toggle2" id="e1">
                                <div class="Vertical Vertical2"></div>
                                <div class="Horizontal"></div>
                            </div>
                            <span class="Text">自动任务加载项</span>
                            <span></span>
                        </div>
                        <div class="Content Content2" id="g1">
                            <div class="Large Column">
                                <div class="PageNavigationLinkGroup">
                                    <div class="PageNavigationLinkColumn">
                                        <div class="PageNavigationLink">
                                            <a class="Button ButtonIcon Link NormalState chaxun">占位</a>
                                            <div class="StandardText">介绍介绍</div>
                                        </div>
                                        <div class="PageNavigationLink">
                                            <a class="Button ButtonIcon Link NormalState chaxun">占位</a>
                                            <div class="StandardText">介绍介绍</div>
                                        </div>
                                        <div class="PageNavigationLink">
                                            <a class="Button ButtonIcon Link NormalState chaxun">占位</a>
                                            <div class="StandardText">介绍介绍</div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <!--第二个框-->
                    <div class="Normal Collapsed Section Normal2" id="f2">
                        <div class="Heading">
                            <div class="Toggle Expand Toggle2" id="e2">
                                <div class="Vertical Vertical2"></div>
                                <div class="Horizontal"></div>
                            </div>
                            <span class="Text">端点管理</span>
                            <span></span>
                        </div>
                        <div class="Content Content2" id="g2">
                            <div class="Large Column">
                                <div class="Resizable Instructions">
                                    <div class="InstructionItem oh">
                                        <p class="fl">如果您是当前端点管理用户，则必须从端点管理中启用自动任务集成。不使用端点管理了吗？</p>
                                        <a class="Button ButtonIcon Link NormalState fl">点击这里</a>
                                        <p class="fl">，了解它如何帮助您提高收入，同时更好地服务于客户最大限度地提高效率。</p>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <!--第三个框-->
                    <div class="Normal Collapsed Section Normal2" id="f3">
                        <div class="Heading">
                            <div class="Toggle Expand Toggle2" id="e3">
                                <div class="Vertical Vertical2"></div>
                                <div class="Horizontal"></div>
                            </div>
                            <span class="Text">客户端门户与TASKFIRE</span>
                            <span></span>
                        </div>
                        <div class="Content Content2" id="g3">
                            <div class="Large Column">
                                <div class="PageNavigationLinkGroup">
                                    <div class="PageNavigationLinkColumn">
                                        <div class="PageNavigationLink">
                                            <a class="Button ButtonIcon Link NormalState chaxun">占位</a>
                                            <div class="StandardText">介绍介绍</div>
                                        </div>
                                        <div class="PageNavigationLink">
                                            <a class="Button ButtonIcon Link NormalState chaxun">占位</a>
                                            <div class="StandardText">介绍介绍</div>
                                        </div>
                                        <div class="PageNavigationLink">
                                            <a class="Button ButtonIcon Link NormalState chaxun">占位</a>
                                            <div class="StandardText">介绍介绍</div>
                                        </div>
                                        <div class="PageNavigationLink">
                                            <a class="Button ButtonIcon Link NormalState chaxun">占位</a>
                                            <div class="StandardText">介绍介绍</div>
                                        </div>
                                        <div class="PageNavigationLink">
                                            <a class="Button ButtonIcon Link NormalState chaxun">占位</a>
                                            <div class="StandardText">介绍介绍</div>
                                        </div>
                                    </div>
                                    <div class="PageNavigationLinkColumn">
                                        <div class="PageNavigationLink">
                                            <a class="Button ButtonIcon Link NormalState chaxun">占位</a>
                                            <div class="StandardText">介绍介绍</div>
                                        </div>
                                        <div class="PageNavigationLink">
                                            <a class="Button ButtonIcon Link NormalState chaxun">占位</a>
                                            <div class="StandardText">介绍介绍</div>
                                        </div>
                                        <div class="PageNavigationLink">
                                            <a class="Button ButtonIcon Link NormalState chaxun">占位</a>
                                            <div class="StandardText">介绍介绍</div>
                                        </div>
                                        <div class="PageNavigationLink">
                                            <a class="Button ButtonIcon Link NormalState chaxun">占位</a>
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
            <div id="chaxun" style="display:none">
            <!--标题-->
            <div class="TitleBar">
            <div class="Title">
                <div class="TitleBarNavigationButton">
                    <a class="Button ButtonIcon NormalState" id="black"><img src="../Images/move-left.png"/></a>
                </div>
                <span class="text1" id="opname"></span>
                <a href="###" class="collection"></a>
                <a href="###" class="help"></a>
            </div>
        </div><!--背景布-->
        <div id="WorkspaceContainer"></div>
        <div class="cont">
            <iframe id="PageFrame1" style="width:100%;border:none;margin:0;" name="PageFrame1"></iframe>
        </div>
</div>
        </div>
    </form>
    <script src="../Scripts/jquery-3.1.0.min.js"></script>
    <script src="../Scripts/Admin.js"></script>
    <script src="Scripts/index.js" type="text/javascript" charset="utf-8"></script>
    <script>
        $(window).resize(function (){
        var Height = $(document).height()-66+"px";
        $("#PageFrame1").css("height", Height);
        })
        var Height = $(document).height()-66 + "px";
        $("#PageFrame1").css("height", Height);

        $(".chaxun").on("click", function () {
                $("#body").hide();
            var kk = $(this).text();
            $("#opname").text(kk);
            var kkk = $("#opname").text();
            setTimeout(function () {
            $("#chaxun").show();
            },300)
        });
        $("#black").click(function () {
            $("#chaxun").hide();           
            $("#body").show();
        });
        function black() {
            $("#chaxun").hide();
            $("#body").show();
        }
    </script>
</body>
</html>
