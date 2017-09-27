<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Index.aspx.cs" Inherits="EMT.DoneNOW.Web.Index" %>

<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>DoneNOW</title>
		<link rel="stylesheet" type="text/css" href="Content/base.css"/>
		<link rel="stylesheet" type="text/css" href="Content/index.css"/>
	</head>
	<body>
        <!--导航栏-->
        <div id="SiteNavigationBar">
            <div class="Left">
                <div class="Logo Button ButtonIcon">
                    <div class="Icon"></div>
                </div>
                <div class="Search">
                    <input type="text" placeholder="搜索" maxlength="100">
                </div>
                <div class="ButtonGroup ExecuteSearch">
                    <div class="Search Button ButtonIcon">
                        <div class="Icon"></div>
                    </div>
                </div>
                <!--左边的6个图标-->
                <div class="ButtonGroup clear">
                    <div class="Dashboard Button ButtonIcon PrimaryActionEnabled">
                        <div class="Icon"></div>
                    </div>
                    <div class="New Button ButtonIcon PrimaryActionEnabled">
                        <div class="Icon"></div>
                    </div>
                    <div class="My Button ButtonIcon PrimaryActionEnabled">
                        <div class="Icon"></div>
                    </div>
                    <div class="Recent Button ButtonIcon PrimaryActionEnabled">
                        <div class="Icon"></div>
                    </div>
                    <div class="Bookmark Button ButtonIcon PrimaryActionEnabled">
                        <div class="Icon"></div>
                    </div>
                    <div class="Calendar Button ButtonIcon PrimaryActionEnabled">
                        <div class="Icon"></div>
                    </div>
                </div>
                <!--logo的下拉菜单-->
                <div class="ContextOverlayContainer">
                    <div class="GuideOverlay ContextOverlay" style="left: 30px; top: 39px;">
                        <div class="Content">
                            <div class="Guide">
                                <!--第一级菜单-->
                                <div class="ButtonContainer">
                                    <div class="GuideNavigation Button ButtonIcon SelectedState" id="HomePage">主页</div>
                                    <div class="GuideNavigation Button ButtonIcon NormalState">CRM</div>
                                    <div class="GuideNavigation Button ButtonIcon NormalState">目录</div>
                                    <div class="GuideNavigation Button ButtonIcon NormalState">合同</div>
                                    <div class="GuideNavigation Button ButtonIcon NormalState">项目</div>
                                    <div class="GuideNavigation Button ButtonIcon NormalState">服务台</div>
                                    <div class="GuideNavigation Button ButtonIcon NormalState">工时</div>
                                    <div class="GuideNavigation Button ButtonIcon NormalState">库存</div>
                                    <div class="GuideNavigation Button ButtonIcon NormalState">报表</div>
                                    <div class="GuideNavigation Button ButtonIcon NormalState">外包</div>
                                    <div class="GuideNavigation Button ButtonIcon NormalState">系统设置</div>
                                </div>
                                <!--第二级菜单-->
                                <div class="ModuleContainer">
                                    <!--第一个-->
                                    <div class="Module Active">
                                        <div class="Normal ContextOverlayColumn">
                                            <div>
                                                <div class="Group">
                                                    <div class="Heading">
                                                        <div class="Text">视图</div>
                                                    </div>
                                                    <div class="Content">
                                                        <a class="Button ButtonIcon NormalState">
                                                            <span class="Text">My Home Page</span>
                                                        </a>
                                                    </div>
                                                    <div class="Content">
                                                        <a class="Button ButtonIcon NormalState">
                                                            <span class="Text">Co-Workers</span>
                                                        </a>
                                                    </div>
                                                    <div class="Content">
                                                        <a class="Button ButtonIcon NormalState">
                                                            <span class="Text">Executive Dashboard</span>
                                                        </a>
                                                    </div>
                                                    <div class="Content">
                                                        <a class="Button ButtonIcon NormalState">
                                                            <span class="Text">Team Walls</span>
                                                        </a>
                                                    </div>
                                                    <div class="Content">
                                                        <a class="Button ButtonIcon NormalState">
                                                            <span class="Text">News Feed</span>
                                                        </a>
                                                    </div>
                                                    <div class="Content">
                                                        <a class="Button ButtonIcon NormalState">
                                                            <span class="Text">LiveLinks Designer</span>
                                                        </a>
                                                    </div>
                                                </div>
                                                <div class="Group">
                                                    <div class="Heading">
                                                        <div class="Text">搜索</div>
                                                    </div>
                                                    <div class="Content">
                                                        <a class="Button ButtonIcon NormalState">
                                                            <span class="Text">My Home Page</span>
                                                        </a>
                                                    </div>
                                                    <div class="Content">
                                                        <a class="Button ButtonIcon NormalState">
                                                            <span class="Text">Co-Workers</span>
                                                        </a>
                                                    </div>
                                                </div>
                                                <div class="Group">
                                                    <div class="Heading">
                                                        <div class="Text">Search</div>
                                                    </div>
                                                    <div class="Content">
                                                        <a class="Button ButtonIcon NormalState">
                                                            <span class="Text">My Home Page</span>
                                                        </a>
                                                    </div>
                                                    <div class="Content">
                                                        <a class="Button ButtonIcon NormalState">
                                                            <span class="Text">Co-Workers</span>
                                                        </a>
                                                    </div>
                                                    <div class="Content">
                                                        <a class="Button ButtonIcon NormalState">
                                                            <span class="Text">Co-Workers</span>
                                                        </a>
                                                    </div>
                                                    <div class="Content">
                                                        <a class="Button ButtonIcon NormalState">
                                                            <span class="Text">Co-Workers</span>
                                                        </a>
                                                    </div>
                                                    <div class="Content">
                                                        <a class="Button ButtonIcon NormalState">
                                                            <span class="Text">Co-Workers</span>
                                                        </a>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <!--第二个-->
                                    <div class="Module">
                                        <div class="Normal ContextOverlayColumn">
                                            <div>
                                                <div class="Group">
                                                    <div class="Heading">
                                                        <div class="Text">视图</div>
                                                    </div>
                                                    <div class="Content">
                                                        <a class="Button ButtonIcon NormalState">
                                                            <span class="Text">LiveLinks Designer</span>
                                                        </a>
                                                    </div>
                                                </div>
                                                <div class="Group">
                                                    <div class="Heading">
                                                        <div class="Text">查看</div>
                                                    </div>
                                                    <div class="Content">
                                                        <a class="Button ButtonIcon NormalState" href="Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.COMPANY %>" target="PageFrame">
                                                            <span class="Text">客户管理</span>
                                                        </a>
                                                    </div>
                                                    <div class="Content">
                                                        <a class="Button ButtonIcon NormalState" href="Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.CONTACT %>" target="PageFrame">
                                                            <span class="Text">联系人管理</span>
                                                        </a>
                                                    </div>
                                                    <div class="Content">
                                                        <a class="Button ButtonIcon NormalState" href="Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.OPPORTUNITY %>" target="PageFrame">
                                                            <span class="Text">商机管理</span>
                                                        </a>
                                                    </div>
                                                    <div class="Content">
                                                        <a class="Button ButtonIcon NormalState" href="Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.QUOTE %>" target="PageFrame">
                                                            <span class="Text">报价管理</span>
                                                        </a>
                                                    </div>
                                                    <div class="Content">
                                                        <a class="Button ButtonIcon NormalState" href="Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.QUOTE_TEMPLATE %>" target="PageFrame">
                                                            <span class="Text">报价模板管理</span>
                                                        </a>
                                                    </div>
                                                    <div class="Content">
                                                        <a class="Button ButtonIcon NormalState" href="Common/SearchFrameSet.aspx?isCheck=1&cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.INSTALLEDPRODUCT %>" target="PageFrame">
                                                            <span class="Text">配置项管理</span>
                                                        </a>
                                                    </div>
                                                    <div class="Content">
                                                        <a class="Button ButtonIcon NormalState" href="Common/SearchFrameSet.aspx?isCheck=1&cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.SUBSCRIPTION %>" target="PageFrame">
                                                            <span class="Text">订阅管理</span>
                                                        </a>
                                                    </div>
                                                    <div class="Content">
                                                        <a class="Button ButtonIcon NormalState" href="Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.SALEORDER %>" target="PageFrame">
                                                            <span class="Text">销售订单管理</span>
                                                        </a>
                                                    </div>
                                                </div>
                                                <div class="Group">
                                                    <div class="Heading">
                                                        <div class="Text">工具</div>
                                                    </div>
                                                    <div class="Content">
                                                        <a class="Button ButtonIcon NormalState">
                                                            <span class="Text">My Home Page</span>
                                                        </a>
                                                    </div>
                                                    <div class="Content">
                                                        <a class="Button ButtonIcon NormalState">
                                                            <span class="Text">Co-Workers</span>
                                                        </a>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <!--第三个-->
                                    <div class="Module">
                                        <div class="Normal ContextOverlayColumn">
                                            <div>
                                                <div class="Group">
                                                    <div class="Heading">
                                                        <div class="Text">视图3</div>
                                                    </div>
                                                    <div class="Content">
                                                        <a class="Button ButtonIcon NormalState">
                                                            <span class="Text">Team Walls</span>
                                                        </a>
                                                    </div>
                                                    <div class="Content">
                                                        <a class="Button ButtonIcon NormalState">
                                                            <span class="Text">News Feed</span>
                                                        </a>
                                                    </div>
                                                    <div class="Content">
                                                        <a class="Button ButtonIcon NormalState">
                                                            <span class="Text">LiveLinks Designer</span>
                                                        </a>
                                                    </div>
                                                </div>
                                                <div class="Group">
                                                    <div class="Heading">
                                                        <div class="Text">搜索</div>
                                                    </div>
                                                    <div class="Content">
                                                        <a class="Button ButtonIcon NormalState">
                                                            <span class="Text">My Home Page</span>
                                                        </a>
                                                    </div>
                                                    <div class="Content">
                                                        <a class="Button ButtonIcon NormalState">
                                                            <span class="Text">Co-Workers</span>
                                                        </a>
                                                    </div>
                                                </div>
                                                <div class="Group">
                                                    <div class="Heading">
                                                        <div class="Text">工具</div>
                                                    </div>
                                                    <div class="Content">
                                                        <a class="Button ButtonIcon NormalState">
                                                            <span class="Text">My Home Page</span>
                                                        </a>
                                                    </div>
                                                    <div class="Content">
                                                        <a class="Button ButtonIcon NormalState">
                                                            <span class="Text">Co-Workers</span>
                                                        </a>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <!--第四个-->
                                    <div class="Module">
                                        <div class="Normal ContextOverlayColumn">
                                            <div>
                                                <div class="Group">
                                                    <div class="Heading">
                                                        <div class="Text">视图4</div>
                                                    </div>
                                                    <div class="Content">
                                                        <a class="Button ButtonIcon NormalState">
                                                            <span class="Text">LiveLinks Designer</span>
                                                        </a>
                                                    </div>
                                                </div>
                                                <div class="Group">
                                                    <div class="Heading">
                                                        <div class="Text">搜索</div>
                                                    </div>
                                                    <div class="Content">
                                                        <a class="Button ButtonIcon NormalState" href="Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.CONTRACT %>" target="PageFrame">
                                                            <span class="Text">合同</span>
                                                        </a>
                                                    </div>
                                                    <div class="Content">
                                                        <a class="Button ButtonIcon NormalState">
                                                            <span class="Text">Co-Workers</span>
                                                        </a>
                                                    </div>
                                                </div>
                                                <div class="Group">
                                                    <div class="Heading">
                                                        <div class="Text">审批并提交</div>
                                                    </div>
                                                    <div class="Content">
                                                       <%-- <a class="Button ButtonIcon NormalState" href="Contract/ApproveAndPost.aspx" target="PageFrame"> 
                                                            <span class="Text">审批并提交</span>
                                                        </a>--%>
                                                         <a class="Button ButtonIcon NormalState" href="Common/SearchFrameSet.aspx?isCheck=1&cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.APPROVE_CHARGES %>" target="PageFrame"> 
                                                            <span class="Text">审批并提交</span>
                                                        </a>
                                                    </div>
                                                </div>
                                                   <div class="Group">
                                                    <div class="Heading">
                                                        <div class="Text">发票和工时调整</div>
                                                    </div>
                                                    <div class="Content">
                               <a class="Button ButtonIcon NormalState" href="Invoice/InvocieSearch.aspx?isCheck=1&cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.GENERATE_INVOICE %>" target="PageFrame"> 
                                                            <span class="Text">生成发票</span>
                                                        </a>
                                                    </div>
                                                </div>
                                                 <div class="Group">
                                                    <div class="Heading">
                                                        <div class="Text">Tools</div>
                                                    </div>
                                                    <div class="Content">
                                                        <a class="Button ButtonIcon NormalState" href="Common/SearchFrameSet.aspx?isCheck=1&cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.INVOICE_HISTORY %>" target="PageFrame"> 
                                                            <span class="Text">历史发票</span>
                                                        </a>
                                                    </div>
                                                    <div class="Content">
                                                        <a class="Button ButtonIcon NormalState" href="Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.INVOICE_TEMPLATE %>" target="PageFrame"> 
                                                            <span class="Text">发票模板</span>
                                                        </a>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <!--第五个-->
                                    <div class="Module">
                                        <div class="Normal ContextOverlayColumn">
                                            <div>
                                                <div class="Group">
                                                    <div class="Heading">
                                                        <div class="Text">视图5</div>
                                                    </div>
                                                    <div class="Content">
                                                        <a class="Button ButtonIcon NormalState">
                                                            <span class="Text">LiveLinks Designer</span>
                                                        </a>
                                                    </div>
                                                </div>
                                                <div class="Group">
                                                    <div class="Heading">
                                                        <div class="Text">搜索</div>
                                                    </div>
                                                    <div class="Content">
                                                        <a class="Button ButtonIcon NormalState">
                                                            <span class="Text">My Home Page</span>
                                                        </a>
                                                    </div>
                                                    <div class="Content">
                                                        <a class="Button ButtonIcon NormalState">
                                                            <span class="Text">Co-Workers</span>
                                                        </a>
                                                    </div>
                                                </div>
                                                <div class="Group">
                                                    <div class="Heading">
                                                        <div class="Text">工具</div>
                                                    </div>
                                                    <div class="Content">
                                                        <a class="Button ButtonIcon NormalState">
                                                            <span class="Text">Co-Workers</span>
                                                        </a>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <!--第六个-->
                                    <div class="Module">
                                        <div class="Normal ContextOverlayColumn">
                                            <div>
                                                <div class="Group">
                                                    <div class="Heading">
                                                        <div class="Text">视图6</div>
                                                    </div>
                                                    <div class="Content">
                                                        <a class="Button ButtonIcon NormalState">
                                                            <span class="Text">LiveLinks Designer</span>
                                                        </a>
                                                    </div>
                                                </div>
                                                <div class="Group">
                                                    <div class="Heading">
                                                        <div class="Text">搜索</div>
                                                    </div>
                                                    <div class="Content">
                                                        <a class="Button ButtonIcon NormalState">
                                                            <span class="Text">My Home Page</span>
                                                        </a>
                                                    </div>
                                                    <div class="Content">
                                                        <a class="Button ButtonIcon NormalState">
                                                            <span class="Text">Co-Workers</span>
                                                        </a>
                                                    </div>
                                                </div>
                                                <div class="Group">
                                                    <div class="Heading">
                                                        <div class="Text">工具</div>
                                                    </div>
                                                    <div class="Content">
                                                        <a class="Button ButtonIcon NormalState">
                                                            <span class="Text">Co-Workers</span>
                                                        </a>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <!--第七个-->
                                    <div class="Module">
                                        <div class="Normal ContextOverlayColumn">
                                            <div>
                                                <div class="Group">
                                                    <div class="Heading">
                                                        <div class="Text">视图7</div>
                                                    </div>
                                                    <div class="Content">
                                                        <a class="Button ButtonIcon NormalState">
                                                            <span class="Text">LiveLinks Designer</span>
                                                        </a>
                                                    </div>
                                                </div>
                                                <div class="Group">
                                                    <div class="Heading">
                                                        <div class="Text">搜索</div>
                                                    </div>
                                                    <div class="Content">
                                                        <a class="Button ButtonIcon NormalState">
                                                            <span class="Text">My Home Page</span>
                                                        </a>
                                                    </div>
                                                    <div class="Content">
                                                        <a class="Button ButtonIcon NormalState">
                                                            <span class="Text">Co-Workers</span>
                                                        </a>
                                                    </div>
                                                </div>
                                                <div class="Group">
                                                    <div class="Heading">
                                                        <div class="Text">工具</div>
                                                    </div>
                                                    <div class="Content">
                                                        <a class="Button ButtonIcon NormalState">
                                                            <span class="Text">Co-Workers</span>
                                                        </a>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <!--第八个-->
                                    <div class="Module">
                                        <div class="Normal ContextOverlayColumn">
                                            <div>
                                                <div class="Group">
                                                    <div class="Heading">
                                                        <div class="Text">视图8</div>
                                                    </div>
                                                    <div class="Content">
                                                        <a class="Button ButtonIcon NormalState">
                                                            <span class="Text">LiveLinks Designer</span>
                                                        </a>
                                                    </div>
                                                </div>
                                                <div class="Group">
                                                    <div class="Heading">
                                                        <div class="Text">搜索</div>
                                                    </div>
                                                    <div class="Content">
                                                        <a class="Button ButtonIcon NormalState">
                                                            <span class="Text">My Home Page</span>
                                                        </a>
                                                    </div>
                                                    <div class="Content">
                                                        <a class="Button ButtonIcon NormalState">
                                                            <span class="Text">Co-Workers</span>
                                                        </a>
                                                    </div>
                                                </div>
                                                <div class="Group">
                                                    <div class="Heading">
                                                        <div class="Text">工具</div>
                                                    </div>
                                                    <div class="Content">
                                                        <a class="Button ButtonIcon NormalState">
                                                            <span class="Text">Co-Workers</span>
                                                        </a>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <!--第九个-->
                                    <div class="Module">
                                        <div class="Normal ContextOverlayColumn">
                                            <div>
                                                <div class="Group">
                                                    <div class="Heading">
                                                        <div class="Text">视图9</div>
                                                    </div>
                                                    <div class="Content">
                                                        <a class="Button ButtonIcon NormalState">
                                                            <span class="Text">LiveLinks Designer</span>
                                                        </a>
                                                    </div>
                                                </div>
                                                <div class="Group">
                                                    <div class="Heading">
                                                        <div class="Text">搜索</div>
                                                    </div>
                                                    <div class="Content">
                                                        <a class="Button ButtonIcon NormalState">
                                                            <span class="Text">My Home Page</span>
                                                        </a>
                                                    </div>
                                                    <div class="Content">
                                                        <a class="Button ButtonIcon NormalState">
                                                            <span class="Text">Co-Workers</span>
                                                        </a>
                                                    </div>
                                                </div>
                                                <div class="Group">
                                                    <div class="Heading">
                                                        <div class="Text">工具</div>
                                                    </div>
                                                    <div class="Content">
                                                        <a class="Button ButtonIcon NormalState">
                                                            <span class="Text">Co-Workers</span>
                                                        </a>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <!--第10个-->
                                    <div class="Module">
                                        <div class="Normal ContextOverlayColumn">
                                            <div>
                                                <div class="Group">
                                                    <div class="Heading">
                                                        <div class="Text">视图10</div>
                                                    </div>
                                                    <div class="Content">
                                                        <a class="Button ButtonIcon NormalState">
                                                            <span class="Text">LiveLinks Designer</span>
                                                        </a>
                                                    </div>
                                                </div>
                                                <div class="Group">
                                                    <div class="Heading">
                                                        <div class="Text">搜索</div>
                                                    </div>
                                                    <div class="Content">
                                                        <a class="Button ButtonIcon NormalState">
                                                            <span class="Text">My Home Page</span>
                                                        </a>
                                                    </div>
                                                    <div class="Content">
                                                        <a class="Button ButtonIcon NormalState">
                                                            <span class="Text">Co-Workers</span>
                                                        </a>
                                                    </div>
                                                </div>
                                                <div class="Group">
                                                    <div class="Heading">
                                                        <div class="Text">工具</div>
                                                    </div>
                                                    <div class="Content">
                                                        <a class="Button ButtonIcon NormalState">
                                                            <span class="Text">Co-Workers</span>
                                                        </a>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <!--第11个-->
                                    <div class="Module">
                                        <div class="Normal ContextOverlayColumn">
                                            <div>
                                                <div class="Group">
                                                    <div class="Heading">
                                                        <div class="Text">视图</div>
                                                    </div>
                                                    <div class="Content">
                                                        <a class="Button ButtonIcon NormalState" href="SysSetting/SysAdmin" target="PageFrame">
                                                            <span class="Text">设置</span>
                                                        </a>
                                                    </div>
                                                </div>
                                                <div class="Group">
                                                    <div class="Heading">
                                                        <div class="Text">搜索</div>
                                                    </div>
                                                </div>
                                                <div class="Group">
                                                    <div class="Heading">
                                                        <div class="Text">工具</div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <!--搜索的下拉菜单-->
                <div class="ContextOverlayContainer">
                    <div class="SearchOverlay ContextOverlay" style="left: 77px; top: 39px;">
                        <div class="Content">
                            <div class="ColumnSet">
                                <div class="Normal ContextOverlayColumn">
                                    <div>
                                        <div class="Group">
                                            <div class="Content">
                                                <div class="SearchRadioButton">
                                                    <input checked="checked" type="radio" name="SearchTypeRadioButton">
                                                    <label>Company</label>
                                                </div>
                                                <div class="SearchRadioButton">
                                                    <input checked="checked" type="radio" name="SearchTypeRadioButton">
                                                    <label>Contact (Last Name)</label>
                                                </div>
                                                <div class="SearchRadioButton">
                                                    <input checked="checked" type="radio" name="SearchTypeRadioButton">
                                                    <label>Contact (First Name)</label>
                                                </div>
                                                <div class="SearchRadioButton">
                                                    <input checked="checked" type="radio" name="SearchTypeRadioButton">
                                                    <label>Contact (Email)</label>
                                                </div>
                                                <div class="SearchRadioButton">
                                                    <input checked="checked" type="radio" name="SearchTypeRadioButton">
                                                    <label>Co-worker</label>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div>
                                    <div class="Normal ContextOverlayColumn">
                                        <div>
                                            <div class="Group">
                                                <div class="Heading">
                                                    <div class="Text">历史纪录搜索</div>
                                                </div>
                                                <div class="Content">
                                                    <a class="Button ButtonIcon NormalState">
                                                        <span class="Text">My Home Page</span>
                                                    </a>
                                                </div>
                                                <div class="Content">
                                                    <a class="Button ButtonIcon NormalState">
                                                        <span class="Text">My Home Page</span>
                                                    </a>
                                                </div>
                                                <div class="Content">
                                                    <a class="Button ButtonIcon NormalState">
                                                        <span class="Text">My Home Page</span>
                                                    </a>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <!--新增的下拉菜单-->
                <div class="ContextOverlayContainer">
                    <div class="NewOverlay ContextOverlay" style="left: 318px; top: 39px;">
                        <div class="Content">
                            <div class="Title">新增...</div>
                            <div class="ColumnSet">
                                <div class="Normal ContextOverlayColumn">
                                    <div>
                                        <div class="Group">
                                            <div class="Heading">
                                                <div class="Text">Service Desk</div>
                                            </div>
                                            <div class="Content">
                                                <a class="Button ButtonIcon NormalState">
                                                    <span class="Text">My Home Page</span>
                                                </a>
                                            </div>
                                            <div class="Content">
                                                <a class="Button ButtonIcon NormalState">
                                                    <span class="Text">My Home Page</span>
                                                </a>
                                            </div>
                                            <div class="Content">
                                                <a class="Button ButtonIcon NormalState">
                                                    <span class="Text">My Home Page</span>
                                                </a>
                                            </div>
                                        </div>
                                        <div class="Group">
                                            <div class="Heading">
                                                <div class="Text">Service Desk</div>
                                            </div>
                                            <div class="Content">
                                                <a class="Button ButtonIcon NormalState">
                                                    <span class="Text">My Home Page</span>
                                                </a>
                                            </div>
                                            <div class="Content">
                                                <a class="Button ButtonIcon NormalState">
                                                    <span class="Text">My Home Page</span>
                                                </a>
                                            </div>
                                            <div class="Content">
                                                <a class="Button ButtonIcon NormalState">
                                                    <span class="Text">My Home Page</span>
                                                </a>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="Normal ContextOverlayColumn">
                                    <div>
                                        <div class="Group">
                                            <div class="Heading">
                                                <div class="Text">Service Desk</div>
                                            </div>
                                            <div class="Content">
                                                <a class="Button ButtonIcon NormalState">
                                                    <span class="Text">My Home Page</span>
                                                </a>
                                            </div>
                                        </div>
                                        <div class="Group">
                                            <div class="Heading">
                                                <div class="Text">Service Desk</div>
                                            </div>
                                            <div class="Content">
                                                <a class="Button ButtonIcon NormalState">
                                                    <span class="Text">My Home Page</span>
                                                </a>
                                            </div>
                                            <div class="Content">
                                                <a class="Button ButtonIcon NormalState">
                                                    <span class="Text">My Home Page</span>
                                                </a>
                                            </div>
                                        </div>
                                        <div class="Group">
                                            <div class="Heading">
                                                <div class="Text">Service Desk</div>
                                            </div>
                                            <div class="Content">
                                                <a class="Button ButtonIcon NormalState">
                                                    <span class="Text">My Home Page</span>
                                                </a>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!--历史纪录的下拉菜单-->
                <div class="ContextOverlayContainer">
                    <div class="RecentOverlay ContextOverlay" style="left: 390px; top: 39px;">
                        <div class="Content">
                            <div class="Title">历史</div>
                            <div class="RecentItemsContainer">
                                <div class="ColumnSet">
                                    <div class="Large ContextOverlayColumn">
                                        <div>
                                            <div class="Group">
                                                <div class="Content">
                                                    <a class="Button ButtonIcon NormalState">
                                                        <span class="Text">My Home Page</span>
                                                    </a>
                                                </div>
                                                <div class="Content">
                                                    <a class="Button ButtonIcon NormalState">
                                                        <span class="Text">My Home Page</span>
                                                    </a>
                                                </div>
                                                <div class="Content">
                                                    <a class="Button ButtonIcon NormalState">
                                                        <span class="Text">My Home Page</span>
                                                    </a>
                                                </div>
                                                <div class="Content">
                                                    <a class="Button ButtonIcon NormalState">
                                                        <span class="Text">My Home Page</span>
                                                    </a>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="SiteNavigationFooterSeparator"></div>
                                <div class="ColumnSet">
                                    <div class="Normal ContextOverlayColumn">
                                        <div>
                                            <div class="Group">
                                                <div class="Content">
                                                    <a class="Button ButtonIcon Link NormalState">
                                                        Clear
                                                    </a>
                                                </div>
                    
                                                <div class="Content">
                                                    <a class="Button ButtonIcon Link NormalState">
                                                        View More
                                                    </a>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="Right">
                <div class="User">
                    <div class="Name">
                        <a class="Button ButtonIcon Link"><%=(Session["dn_session_user_info"] as EMT.DoneNOW.Core.sys_user).name %></a>
                    </div>
                    <div class="Separator">
                        <div class="VerticalBar"></div>
                    </div>
                    <div class="SignOut">
                        <a class="Button ButtonIcon Link" onclick="javaScript:window.location.href='login?action=Logout'">退出</a>
                    </div>
                </div>
                <!--右边的三个图标-->
                <div class="ButtonGroup clear">
                    <div class="LiveLinks Button ButtonIcon PrimaryActionEnabled">
                        <div class="Icon"></div>
                    </div>
                    <div class="Community Button ButtonIcon PrimaryActionEnabled">
                        <div class="Icon"></div>
                    </div>
                    <div class="Help Button ButtonIcon PrimaryActionEnabled">
                        <div class="Icon"></div>
                    </div>
                </div>
            </div>
        </div>
        <!--背景布-->
        <div id="WorkspaceContainer">
             <div>
                <div id="DashboardContainer">
                    <div class="DashboardTitleBar ThemePrimaryColor">
                        <div class="DashboardButtonContainer">
                            <div class="DashboardTabButtonContainer">
                                 <div class="ButtonIcon Button SelectDashboardTab SelectedState">仪表盘1</div>
                                 <div class="ButtonIcon Button SelectDashboardTab">仪表盘2</div>
                                 <div class="ButtonIcon Button SelectDashboardTab">仪表盘3</div>
                                 <div class="ButtonIcon Button SelectDashboardTab">仪表盘4</div>
                                 <div class="ButtonIcon Button SelectDashboardTab">仪表盘5</div>
                                 <div class="ButtonIcon Button SelectDashboardTab">仪表盘6</div>
                            </div>
                            <div class="ButtonIcon Button CreateDashboardTab">
                                <div class="HorizontalLine"></div>
                                <div class="VerticalLine"></div>
                            </div>
                        </div>
                        <div class="DashboardContextMenuContainer"></div>
                    </div>
                    <div class="DashboardTabContainer" id="DashboardTabContainer">
                        <div class="ContentContainer">
                            <div id="DashboardTabContainerContent">
                                <div class="LivelyTheme AutoFlow DashboardTab">
                                    暂无（以后开发）
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="cont">
            <iframe id="PageFrame" name="PageFrame" style="width:100%;" src="Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.COMPANY %>"></iframe>
        </div>
	</body>
	<script src="Scripts/jquery-3.1.0.min.js" type="text/javascript" charset="utf-8"></script>
	<script src="Scripts/index.js" type="text/javascript" charset="utf-8"></script>
    <script>
        $(window).resize(function (){
        var Height = $(document).height()-66+"px";
        $("#PageFrame").css("height", Height);
        })
        var Height = $(document).height()-66 + "px";
        $("#PageFrame").css("height", Height);
    </script>
</html>
