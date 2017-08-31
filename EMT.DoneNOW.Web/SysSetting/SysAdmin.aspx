<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SysAdmin.aspx.cs" Inherits="EMT.DoneNOW.Web.SysAdmin" %>
<%@ Import Namespace="EMT.DoneNOW.DTO" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <link href="../Content/Admin.css" rel="stylesheet" />
    <title>管理系统</title>
</head>
<body>
    <form id="form1" runat="server" method="post">
        <div>
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
                    <!--第一个框-->
                    <div class="Normal Section Collapsed Normal1" id="b1">
                        <div class="Heading">
                            <div class="Toggle Expand Toggle1" id="a1">
                                <div class="Vertical Vertical1"></div>
                                <div class="Horizontal"></div>
                            </div>
                            <span class="Text">应用范围（共享）功能</span>
                            <span></span>
                        </div>
                        <div class="Content Content1" id="c1">
                            <div class="Large Column">
                                <div class="PageNavigationLinkGroup">
                                    <div class="PageNavigationLinkColumn">
                                        <div class="PageNavigationLink">
                                            <a class="Button ButtonIcon Link NormalState">System Settings (formerly Workflow Policies)</a>
                                            <div class="StandardText">Manage all Autotask system settings.</div>
                                        </div>
                                        <div class="PageNavigationLink">
                                            <a class="Button ButtonIcon Link NormalState">System Settings (formerly Workflow Policies)</a>
                                            <div class="StandardText">Manage all Autotask system settings.</div>
                                        </div>
                                        <div class="PageNavigationLink">
                                            <a class="Button ButtonIcon Link NormalState">System Settings (formerly Workflow Policies)</a>
                                            <div class="StandardText">Manage all Autotask system settings.</div>
                                        </div>
                                        <div class="PageNavigationLink">
                                            <a class="Button ButtonIcon Link NormalState">System Settings (formerly Workflow Policies)</a>
                                            <div class="StandardText">Manage all Autotask system settings.</div>
                                        </div>
                                        <div class="PageNavigationLink">
                                            <a class="Button ButtonIcon Link NormalState">System Settings (formerly Workflow Policies)</a>
                                            <div class="StandardText">Manage all Autotask system settings.</div>
                                        </div>
                                        <div class="PageNavigationLink">
                                            <a class="Button ButtonIcon Link NormalState">System Settings (formerly Workflow Policies)</a>
                                            <div class="StandardText">Manage all Autotask system settings.</div>
                                        </div>
                                        <div class="PageNavigationLink">
                                            <a class="Button ButtonIcon Link NormalState">System Settings (formerly Workflow Policies)</a>
                                            <div class="StandardText">Manage all Autotask system settings.</div>
                                        </div>
                                    </div>
                                    <div class="PageNavigationLinkColumn">
                                        <div class="PageNavigationLink">
                                            <a class="Button ButtonIcon Link NormalState">System Settings (formerly Workflow Policies)</a>
                                            <div class="StandardText">Manage all Autotask system settings.</div>
                                        </div>
                                        <div class="PageNavigationLink">
                                            <a class="Button ButtonIcon Link NormalState">System Settings (formerly Workflow Policies)</a>
                                            <div class="StandardText">Manage all Autotask system settings.</div>
                                        </div>
                                        <div class="PageNavigationLink">
                                            <a class="Button ButtonIcon Link NormalState">System Settings (formerly Workflow Policies)</a>
                                            <div class="StandardText">Manage all Autotask system settings.</div>
                                        </div>
                                        <div class="PageNavigationLink">
                                            <a class="Button ButtonIcon Link NormalState">System Settings (formerly Workflow Policies)</a>
                                            <div class="StandardText">Manage all Autotask system settings.</div>
                                        </div>
                                    </div>
                                </div>
                                <div class="PageNavigationLinkGroup">
                                    <div class="Heading">
                                        <div class="Text">Surveys</div>
                                    </div>
                                    <div class="PageNavigationLinkColumn">
                                        <div class="PageNavigationLink">
                                            <a class="Button ButtonIcon Link NormalState">System Settings (formerly Workflow Policies)</a>
                                            <div class="StandardText">Manage all Autotask system settings.</div>
                                        </div>
                                        <div class="PageNavigationLink">
                                            <a class="Button ButtonIcon Link NormalState">System Settings (formerly Workflow Policies)</a>
                                            <div class="StandardText">Manage all Autotask system settings.</div>
                                        </div>
                                    </div>
                                    <div class="PageNavigationLinkColumn">
                                        <div class="PageNavigationLink">
                                            <a class="Button ButtonIcon Link NormalState">System Settings (formerly Workflow Policies)</a>
                                            <div class="StandardText">Manage all Autotask system settings.</div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <!--第二个框-->
                    <div class="Normal Collapsed Section Normal1" id="b2">
                        <div class="Heading">
                            <div class="Toggle Expand Toggle1" id="a2">
                                <div class="Vertical Vertical1"></div>
                                <div class="Horizontal"></div>
                            </div>
                            <span class="Text">你的组织</span>
                            <span></span>
                        </div>
                        <div class="Content Content1" id="c2">
                            <div class="Large Column">
                                <div class="PageNavigationLinkGroup">
                                    <div class="PageNavigationLinkColumn">
                                        <div class="PageNavigationLink">
                                            <a class="Button ButtonIcon Link NormalState">System Settings (formerly Workflow Policies)</a>
                                            <div class="StandardText">Manage all Autotask system settings.</div>
                                        </div>
                                        <div class="PageNavigationLink">
                                            <a class="Button ButtonIcon Link NormalState">System Settings (formerly Workflow Policies)</a>
                                            <div class="StandardText">Manage all Autotask system settings.</div>
                                        </div>
                                        <div class="PageNavigationLink">
                                            <a class="Button ButtonIcon Link NormalState">System Settings (formerly Workflow Policies)</a>
                                            <div class="StandardText">Manage all Autotask system settings.</div>
                                        </div>
                                    </div>
                                    <div class="PageNavigationLinkColumn">
                                        <div class="PageNavigationLink">
                                            <a class="Button ButtonIcon Link NormalState">System Settings (formerly Workflow Policies)</a>
                                            <div class="StandardText">Manage all Autotask system settings.</div>
                                        </div>
                                        <div class="PageNavigationLink">
                                            <a class="Button ButtonIcon Link NormalState">System Settings (formerly Workflow Policies)</a>
                                            <div class="StandardText">Manage all Autotask system settings.</div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <!--第三个框-->
                    <div class="Normal Section Collapsed Normal1" id="b3">
                        <div class="Heading">
                            <div class="Toggle Expand Toggle1" id="a3">
                                <div class="Vertical Vertical1"></div>
                                <div class="Horizontal"></div>
                            </div>
                            <span class="Text">资源/用户（HR）</span>
                            <span></span>
                        </div>
                        <div class="Content Content1" id="c3">
                            <div class="Large Column">
                                <div class="PageNavigationLinkGroup">
                                    <div class="PageNavigationLinkColumn">
                                        <div class="PageNavigationLink">
                                            <a class="Button ButtonIcon Link NormalState">资源/用户()</a>
                                            <div class="StandardText">Manage user accounts for people in your organization who have an Autotask login.</div>
                                        </div>
                                        <div class="PageNavigationLink">
                                            <a class="Button ButtonIcon Link NormalState">角色()</a>
                                            <div class="StandardText">Set up billing roles that determine the rate at which labour will be billed.</div>
                                        </div>
                                        <div class="PageNavigationLink">
                                            <a class="Button ButtonIcon Link NormalState">部门()</a>
                                            <div class="StandardText">Set up organizational entities in your company that are associated with resources and work types, and play a role in project security.</div>
                                        </div>
                                        <div class="PageNavigationLink">
                                            <a class="Button ButtonIcon Link NormalState">System Settings (formerly Workflow Policies)</a>
                                            <div class="StandardText">Manage all Autotask system settings.</div>
                                        </div>
                                        <div class="PageNavigationLink">
                                            <a class="Button ButtonIcon Link NormalState">System Settings (formerly Workflow Policies)</a>
                                            <div class="StandardText">Manage all Autotask system settings.</div>
                                        </div>
                                        <div class="PageNavigationLink">
                                            <a class="Button ButtonIcon Link NormalState">System Settings (formerly Workflow Policies)</a>
                                            <div class="StandardText">Manage all Autotask system settings.</div>
                                        </div>
                                        <div class="PageNavigationLink">
                                            <a class="Button ButtonIcon Link NormalState">System Settings (formerly Workflow Policies)</a>
                                            <div class="StandardText">Manage all Autotask system settings.</div>
                                        </div>
                                    </div>
                                    <div class="PageNavigationLinkColumn">
                                        <div class="PageNavigationLink">
                                            <a class="Button ButtonIcon Link NormalState">System Settings (formerly Workflow Policies)</a>
                                            <div class="StandardText">Manage all Autotask system settings.</div>
                                        </div>
                                        <div class="PageNavigationLink">
                                            <a class="Button ButtonIcon Link NormalState">System Settings (formerly Workflow Policies)</a>
                                            <div class="StandardText">Manage all Autotask system settings.</div>
                                        </div>
                                        <div class="PageNavigationLink">
                                            <a class="Button ButtonIcon Link NormalState">System Settings (formerly Workflow Policies)</a>
                                            <div class="StandardText">Manage all Autotask system settings.</div>
                                        </div>
                                        <div class="PageNavigationLink">
                                            <a class="Button ButtonIcon Link NormalState">System Settings (formerly Workflow Policies)</a>
                                            <div class="StandardText">Manage all Autotask system settings.</div>
                                        </div>
                                    </div>
                                </div>
                                <div class="PageNavigationLinkGroup">
                                    <div class="Heading">
                                        <div class="Text">安全</div>
                                    </div>
                                    <div class="PageNavigationLinkColumn">
                                        <div class="PageNavigationLink">
                                            <a class="Button ButtonIcon Link NormalState">安全等级()</a>
                                            <div class="StandardText">Configure the access levels to Autotask features that can be assigned to your resources.</div>
                                        </div>
                                        <div class="PageNavigationLink">
                                            <a href="SysDataPermission.aspx" class="Button ButtonIcon Link NormalState">保护数据权限</a>
                                            <div class="StandardText">Set up read/write/edit permissions for your resources for protected data in Site Configuration UDFs and Configuration Items.</div>
                                        </div>
                                    </div>
                                    <div class="PageNavigationLinkColumn">
                                        <div class="PageNavigationLink">
                                            <a class="Button ButtonIcon Link NormalState">System Settings (formerly Workflow Policies)</a>
                                            <div class="StandardText">Manage all Autotask system settings.</div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                     <!--第四个框-->
                    <div class="Normal Section Collapsed Normal1" id="b4">
                        <div class="Heading">
                            <div class="Toggle Expand Toggle1" id="a4">
                                <div class="Vertical Vertical1"></div>
                                <div class="Horizontal"></div>
                            </div>
                            <span class="Text">COMPANIES & CONTACTS</span>
                            <span></span>
                        </div>
                        <div class="Content Content1" id="c4">
                            <div class="Large Column">
                                <div class="PageNavigationLinkGroup">
                                    <div class="PageNavigationLinkColumn">
                                        <div class="PageNavigationLink">
                                            <a href="GeneralView.aspx?id=<%=(int)GeneralTableEnum.MARKET_SEGMENT %>" class="Button ButtonIcon Link NormalState">市场领域</a>
                                            <div class="StandardText">Manage user accounts for people in your organization who have an Autotask login.</div>
                                        </div>
                                        <div class="PageNavigationLink">
                                            <a href="GeneralView.aspx?id=<%=(int)GeneralTableEnum.TERRITORY %>" class="Button ButtonIcon Link NormalState">地域</a>
                                            <div class="StandardText">Set up billing roles that determine the rate at which labour will be billed.</div>
                                        </div>
                                        <div class="PageNavigationLink">
                                            <a href="GeneralView.aspx?id=<%=(int)GeneralTableEnum.REGION %>" class="Button ButtonIcon Link NormalState">区域</a>
                                            <div class="StandardText">Set up organizational entities in your company that are associated with resources and work types, and play a role in project security.</div>
                                        </div>
                                        <div class="PageNavigationLink">
                                            <a href="GeneralView.aspx?id=<%=(int)GeneralTableEnum.COMPETITOR %>" class="Button ButtonIcon Link NormalState">竞争对手</a>
                                            <div class="StandardText">Manage all Autotask system settings.</div>
                                        </div>
                                        <div class="PageNavigationLink">
                                            <a class="Button ButtonIcon Link NormalState">客户类别</a>
                                            <div class="StandardText">Manage all Autotask system settings.</div>
                                        </div>
                                        <div class="PageNavigationLink">
                                            <a class="Button ButtonIcon Link NormalState">System Settings (formerly Workflow Policies)</a>
                                            <div class="StandardText">Manage all Autotask system settings.</div>
                                        </div>
                                        <div class="PageNavigationLink">
                                            <a class="Button ButtonIcon Link NormalState">System Settings (formerly Workflow Policies)</a>
                                            <div class="StandardText">Manage all Autotask system settings.</div>
                                        </div>
                                    </div>
                                    <div class="PageNavigationLinkColumn">
                                        <div class="PageNavigationLink">
                                            <a class="Button ButtonIcon Link NormalState">System Settings (formerly Workflow Policies)</a>
                                            <div class="StandardText">Manage all Autotask system settings.</div>
                                        </div>
                                        <div class="PageNavigationLink">
                                            <a class="Button ButtonIcon Link NormalState">System Settings (formerly Workflow Policies)</a>
                                            <div class="StandardText">Manage all Autotask system settings.</div>
                                        </div>
                                        <div class="PageNavigationLink">
                                            <a class="Button ButtonIcon Link NormalState">System Settings (formerly Workflow Policies)</a>
                                            <div class="StandardText">Manage all Autotask system settings.</div>
                                        </div>
                                        <div class="PageNavigationLink">
                                            <a href="GeneralView.aspx?id=<%=(int)GeneralTableEnum.NAME_SUFFIX %>" class="Button ButtonIcon Link NormalState">姓名后缀</a>
                                            <div class="StandardText">Manage all Autotask system settings.</div>
                                        </div>
                                    </div>
                                </div>
                                <div class="PageNavigationLinkGroup">
                                    <div class="Heading">
                                        <div class="Text">aaa</div>
                                    </div>
                                    <div class="PageNavigationLinkColumn">
                                        <div class="PageNavigationLink">
                                            <a class="Button ButtonIcon Link NormalState">aaaa</a>
                                            <div class="StandardText">Configure the access levels to Autotask features that can be assigned to your resources.</div>
                                        </div>
                                        <div class="PageNavigationLink">
                                            <a class="Button ButtonIcon Link NormalState">aaaa</a>
                                            <div class="StandardText">Set up read/write/edit permissions for your resources for protected data in Site Configuration UDFs and Configuration Items.</div>
                                        </div>
                                    </div>
                                    <div class="PageNavigationLinkColumn">
                                        <div class="PageNavigationLink">
                                            <a class="Button ButtonIcon Link NormalState">System Settings (formerly Workflow Policies)</a>
                                            <div class="StandardText">Manage all Autotask system settings.</div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                     <!--第五个框-->
                    <div class="Normal Section Collapsed Normal1" id="b5">
                        <div class="Heading">
                            <div class="Toggle Expand Toggle1" id="a5">
                                <div class="Vertical Vertical1"></div>
                                <div class="Horizontal"></div>
                            </div>
                            <span class="Text">SALES & OPPORTUNITIES</span>
                            <span></span>
                        </div>
                        <div class="Content Content1" id="c5">
                            <div class="Large Column">
                                <div class="PageNavigationLinkGroup">
                                    <div class="PageNavigationLinkColumn">
                                        <div class="PageNavigationLink">
                                            <a href="GeneralView.aspx?id=<%=(int)GeneralTableEnum.ACTION_TYPE %>" class="Button ButtonIcon Link NormalState">活动类型</a>
                                            <div class="StandardText">Manage user accounts for people in your organization who have an Autotask login.</div>
                                        </div>
                                        <div class="PageNavigationLink">
                                            <a href="GeneralView.aspx?id=<%=(int)GeneralTableEnum.OPPORTUNITY_STAGE %>" class="Button ButtonIcon Link NormalState">商机阶段</a>
                                            <div class="StandardText">Set up billing roles that determine the rate at which labour will be billed.</div>
                                        </div>
                                        <div class="PageNavigationLink">
                                            <a href="GeneralView.aspx?id=<%=(int)GeneralTableEnum.OPPORTUNITY_SOURCE %>" class="Button ButtonIcon Link NormalState">商机来源</a>
                                            <div class="StandardText">Set up organizational entities in your company that are associated with resources and work types, and play a role in project security.</div>
                                        </div>
                                        <div class="PageNavigationLink">
                                            <a class="Button ButtonIcon Link NormalState">赢得商机的原因</a>
                                            <div class="StandardText">Manage all Autotask system settings.</div>
                                        </div>
                                        <div class="PageNavigationLink">
                                            <a class="Button ButtonIcon Link NormalState">丢失商机的原因</a>
                                            <div class="StandardText">Manage all Autotask system settings.</div>
                                        </div>
                                        <div class="PageNavigationLink">
                                            <a class="Button ButtonIcon Link NormalState">System Settings (formerly Workflow Policies)</a>
                                            <div class="StandardText">Manage all Autotask system settings.</div>
                                        </div>
                                        <div class="PageNavigationLink">
                                            <a class="Button ButtonIcon Link NormalState">System Settings (formerly Workflow Policies)</a>
                                            <div class="StandardText">Manage all Autotask system settings.</div>
                                        </div>
                                    </div>
                                    <div class="PageNavigationLinkColumn">
                                        <div class="PageNavigationLink">
                                            <a class="Button ButtonIcon Link NormalState">System Settings (formerly Workflow Policies)</a>
                                            <div class="StandardText">Manage all Autotask system settings.</div>
                                        </div>
                                        <div class="PageNavigationLink">
                                            <a class="Button ButtonIcon Link NormalState">System Settings (formerly Workflow Policies)</a>
                                            <div class="StandardText">Manage all Autotask system settings.</div>
                                        </div>
                                        <div class="PageNavigationLink">
                                            <a class="Button ButtonIcon Link NormalState">System Settings (formerly Workflow Policies)</a>
                                            <div class="StandardText">Manage all Autotask system settings.</div>
                                        </div>
                                        <div class="PageNavigationLink">
                                            <a href="GeneralView.aspx?id=<%=(int)GeneralTableEnum.OPPORTUNITY_ADVANCED_FIELD %>" class="Button ButtonIcon Link NormalState">销售指标度量</a>
                                            <div class="StandardText">Manage all Autotask system settings.</div>
                                        </div>
                                    </div>
                                </div>
                                <div class="PageNavigationLinkGroup">
                                    <div class="Heading">
                                        <div class="Text">报价</div>
                                    </div>
                                    <div class="PageNavigationLinkColumn">
                                        <div class="PageNavigationLink">
                                            <a class="Button ButtonIcon Link NormalState">报价模板</a>
                                            <div class="StandardText">Configure the access levels to Autotask features that can be assigned to your resources.</div>
                                        </div>
                                        </div>
                                    <div class="PageNavigationLinkColumn">
                                        <div class="PageNavigationLink">
                                            <a class="Button ButtonIcon Link NormalState">报价邮件模板</a>
                                            <div class="StandardText">Set up read/write/edit permissions for your resources for protected data in Site Configuration UDFs and Configuration Items.</div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
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
                                            <a class="Button ButtonIcon Link NormalState">System Settings (formerly Workflow Policies)</a>
                                            <div class="StandardText">Manage all Autotask system settings.</div>
                                        </div>
                                        <div class="PageNavigationLink">
                                            <a class="Button ButtonIcon Link NormalState">System Settings (formerly Workflow Policies)</a>
                                            <div class="StandardText">Manage all Autotask system settings.</div>
                                        </div>
                                        <div class="PageNavigationLink">
                                            <a class="Button ButtonIcon Link NormalState">System Settings (formerly Workflow Policies)</a>
                                            <div class="StandardText">Manage all Autotask system settings.</div>
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
                                            <a class="Button ButtonIcon Link NormalState">System Settings (formerly Workflow Policies)</a>
                                            <div class="StandardText">Manage all Autotask system settings.</div>
                                        </div>
                                        <div class="PageNavigationLink">
                                            <a class="Button ButtonIcon Link NormalState">System Settings (formerly Workflow Policies)</a>
                                            <div class="StandardText">Manage all Autotask system settings.</div>
                                        </div>
                                        <div class="PageNavigationLink">
                                            <a class="Button ButtonIcon Link NormalState">System Settings (formerly Workflow Policies)</a>
                                            <div class="StandardText">Manage all Autotask system settings.</div>
                                        </div>
                                        <div class="PageNavigationLink">
                                            <a class="Button ButtonIcon Link NormalState">System Settings (formerly Workflow Policies)</a>
                                            <div class="StandardText">Manage all Autotask system settings.</div>
                                        </div>
                                        <div class="PageNavigationLink">
                                            <a class="Button ButtonIcon Link NormalState">System Settings (formerly Workflow Policies)</a>
                                            <div class="StandardText">Manage all Autotask system settings.</div>
                                        </div>
                                    </div>
                                    <div class="PageNavigationLinkColumn">
                                        <div class="PageNavigationLink">
                                            <a class="Button ButtonIcon Link NormalState">System Settings (formerly Workflow Policies)</a>
                                            <div class="StandardText">Manage all Autotask system settings.</div>
                                        </div>
                                        <div class="PageNavigationLink">
                                            <a class="Button ButtonIcon Link NormalState">System Settings (formerly Workflow Policies)</a>
                                            <div class="StandardText">Manage all Autotask system settings.</div>
                                        </div>
                                        <div class="PageNavigationLink">
                                            <a class="Button ButtonIcon Link NormalState">System Settings (formerly Workflow Policies)</a>
                                            <div class="StandardText">Manage all Autotask system settings.</div>
                                        </div>
                                        <div class="PageNavigationLink">
                                            <a class="Button ButtonIcon Link NormalState">System Settings (formerly Workflow Policies)</a>
                                            <div class="StandardText">Manage all Autotask system settings.</div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </form>
    <script src="../Scripts/jquery-3.1.0.min.js"></script>
    <script src="../Scripts/Admin.js"></script>
</body>
</html>
