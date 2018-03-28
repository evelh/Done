<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Index.aspx.cs" Inherits="EMT.DoneNOW.Web.Index" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>DoneNOW</title>
    <link rel="stylesheet" type="text/css" href="Content/base.css" />
    <link rel="stylesheet" type="text/css" href="Content/index.css" />
</head>
<body>
    <!--导航栏-->
    <%="" %>
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
                                <%if (CheckAuth("MENU_CRM"))
                                { %>
                                <div class="GuideNavigation Button ButtonIcon NormalState">CRM</div>
                                <%} %>
                                <div class="GuideNavigation Button ButtonIcon NormalState">目录</div>
                                <%if (CheckAuth("MENU_CONTRACT"))
                                    { %>
                                <div class="GuideNavigation Button ButtonIcon NormalState">合同</div>
                                <%} %>
                                <%if (CheckAuth("MENU_PROJECT"))
                                { %>
                                <div class="GuideNavigation Button ButtonIcon NormalState">项目</div>
                                <%} %>
                                <div class="GuideNavigation Button ButtonIcon NormalState">服务台</div>
                                <div class="GuideNavigation Button ButtonIcon NormalState">工时</div>
                                <%if (CheckAuth("MENU_INVENTORY")) { %>
                                <div class="GuideNavigation Button ButtonIcon NormalState">库存</div>
                                <%} %>
                                <div class="GuideNavigation Button ButtonIcon NormalState">报表</div>
                                <div class="GuideNavigation Button ButtonIcon NormalState">外包</div>
                                <%if (CheckAuth("MENU_SETTING"))
                                { %>
                                <div class="GuideNavigation Button ButtonIcon NormalState">系统设置</div>
                                <%} %>
                            </div>
                            <!--第二级菜单-->
                            <div class="ModuleContainer">
                                <!--第一个-->
                                <div class="Module Active">
                                </div>
                                <!--第二个-->
                                <%if (CheckAuth("MENU_CRM"))
                                { %>
                                <div class="Module">
                                    <div class="Normal ContextOverlayColumn">
                                        <div>
                                            <div class="Group">
                                                <div class="Heading">
                                                    <div class="Text">视图</div>
                                                </div>
                                            </div>
                                            <div class="Group">
                                                <div class="Heading">
                                                    <div class="Text">查看</div>
                                                </div>
                                                <%if (CheckAuth("MENU_CRM_COMPANY"))
                                                { %>
                                                <div class="Content">
                                                    <a class="Button ButtonIcon NormalState" href="Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.COMPANY %>" target="PageFrame">
                                                        <span class="Text">客户管理</span>
                                                    </a>
                                                </div>
                                                <%}%>
                                                <%if (CheckAuth("MENU_CRM_CONTACT"))
                                                { %>
                                                <div class="Content">
                                                    <a class="Button ButtonIcon NormalState" href="Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.CONTACT %>" target="PageFrame">
                                                        <span class="Text">联系人管理</span>
                                                    </a>
                                                </div>
                                                <%}%>
                                                <%if (CheckAuth("MENU_CRM_CONFIGURATION_ITEM"))
                                                { %>
                                                <div class="Content">
                                                    <a class="Button ButtonIcon NormalState" href="Common/SearchFrameSet.aspx?isCheck=1&cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.INSTALLEDPRODUCT %>" target="PageFrame">
                                                        <span class="Text">配置项管理</span>
                                                    </a>
                                                </div>
                                                <%}%>
                                                <%if (CheckAuth("MENU_CRM_NOTES"))
                                                { %>
                                                <div class="Content">
                                                    <a class="Button ButtonIcon NormalState" href="Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.CRM_NOTE_SEARCH %>" target="PageFrame">
                                                        <span class="Text">备注管理</span>
                                                    </a>
                                                </div>
                                                <%}%>
                                                <%if (CheckAuth("MENU_CRM_OPPORTUNITY"))
                                                { %>
                                                <div class="Content">
                                                    <a class="Button ButtonIcon NormalState" href="Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.OPPORTUNITY %>" target="PageFrame">
                                                        <span class="Text">商机管理</span>
                                                    </a>
                                                </div>
                                                <%}%>
                                                <%if (CheckAuth("MENU_CRM_SALESORDER"))
                                                { %>
                                                <div class="Content">
                                                    <a class="Button ButtonIcon NormalState" href="Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.SALEORDER %>" target="PageFrame">
                                                        <span class="Text">销售订单管理</span>
                                                    </a>
                                                </div>
                                                <%}%>
                                                <%if (CheckAuth("MENU_CRM_QUOTE"))
                                                { %>
                                                <div class="Content">
                                                    <a class="Button ButtonIcon NormalState" href="Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.QUOTE %>" target="PageFrame">
                                                        <span class="Text">报价管理</span>
                                                    </a>
                                                </div>
                                                <%}%>
                                                <%if (CheckAuth("MENU_CRM_SUBSCRIPTION"))
                                                { %>
                                                <div class="Content">
                                                    <a class="Button ButtonIcon NormalState" href="Common/SearchFrameSet.aspx?isCheck=1&cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.SUBSCRIPTION %>" target="PageFrame">
                                                        <span class="Text">订阅管理</span>
                                                    </a>
                                                </div>
                                                <%}%>
                                                <%if (CheckAuth("MENU_CRM_TODOS"))
                                                { %>
                                                <div class="Content">
                                                    <a class="Button ButtonIcon NormalState" href="Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.TODOS %>" target="PageFrame">
                                                        <span class="Text">待办管理</span>
                                                    </a>
                                                </div>
                                                <%}%>
                                            </div>
                                            <div class="Group">
                                                <div class="Heading">
                                                    <div class="Text">工具</div>
                                                </div>
                                                <%if (CheckAuth("MENU_CRM_QUOTE_TEMPLATE"))
                                                { %>
                                                <div class="Content">
                                                    <a class="Button ButtonIcon NormalState" href="Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.QUOTE_TEMPLATE %>" target="PageFrame">
                                                        <span class="Text">报价模板管理</span>
                                                    </a>
                                                </div>
                                                <%}%>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <%} %>
                                <!--第三个-->
                                <div class="Module">
                                </div>
                                <!--第四个-->
                                <%if (CheckAuth("MENU_CONTRACT"))
                                    { %>
                                <div class="Module">
                                    <div class="Normal ContextOverlayColumn">
                                        <div>
                                            <div class="Group">
                                                <div class="Heading">
                                                    <div class="Text">视图</div>
                                                </div>
                                            </div>
                                            <div class="Group">
                                                <div class="Heading">
                                                    <div class="Text">搜索</div>
                                                </div>
                                                <%if (CheckAuth("MENU_CONTRACT_CONTRACT"))
                                                { %>
                                                <div class="Content">
                                                    <a class="Button ButtonIcon NormalState" href="Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.CONTRACT %>" target="PageFrame">
                                                        <span class="Text">合同管理</span>
                                                    </a>
                                                </div>
                                                <%} %>
                                            </div>
                                            <div class="Group">
                                                <div class="Heading">
                                                    <div class="Text">审批并提交</div>
                                                </div>
                                                <%if (CheckAuth("MENU_CONTRACT_APPROVE_CHARGES"))
                                                    { %>
                                                <div class="Content">
                                                    <a class="Button ButtonIcon NormalState" href="Common/SearchFrameSet.aspx?isCheck=1&cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.APPROVE_LABOUR %>" target="PageFrame">
                                                        <span class="Text">审批并提交</span>
                                                    </a>
                                                </div>
                                                <%} %>
                                            </div>
                                            <div class="Group">
                                                <div class="Heading">
                                                    <div class="Text">发票和工时调整</div>
                                                </div>
                                                <%if (CheckAuth("MENU_CONTRACT_GENERATE_INVOICE"))
                                                    { %>
                                                <div class="Content">
                                                    <a class="Button ButtonIcon NormalState" href="Invoice/InvocieSearch.aspx?isCheck=1&cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.GENERATE_INVOICE %>" target="PageFrame">
                                                        <span class="Text">生成发票</span>
                                                    </a>
                                                </div>
                                                <%} %>
                                            </div>
                                            <div class="Group">
                                                <div class="Heading">
                                                    <div class="Text">工具</div>
                                                </div>
                                                <%if (CheckAuth("MENU_CONTRACT_INVOICE_HISTORY"))
                                                    { %>
                                                <div class="Content">
                                                    <a class="Button ButtonIcon NormalState" href="Common/SearchFrameSet.aspx?isCheck=1&cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.INVOICE_HISTORY %>" target="PageFrame">
                                                        <span class="Text">历史发票</span>
                                                    </a>
                                                </div>
                                                <%} %>
                                                <%if (CheckAuth("MENU_CONTRACT_INVOICE_TEMPLATE"))
                                                    { %>
                                                <div class="Content">
                                                    <a class="Button ButtonIcon NormalState" href="Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.INVOICE_TEMPLATE %>" target="PageFrame">
                                                        <span class="Text">发票模板</span>
                                                    </a>
                                                </div>
                                                <%} %>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <%}%>
                                <!--第五个-->
                                <%if (CheckAuth("MENU_PROJECT"))
                                { %>
                                <div class="Module">
                                    <div class="Normal ContextOverlayColumn">
                                        <div>
                                            <div class="Group">
                                                <div class="Heading">
                                                    <div class="Text">视图</div>
                                                </div>
                                            </div>
                                            <div class="Group">
                                                <div class="Heading">
                                                    <div class="Text">搜索</div>
                                                </div>
                                                <%if (CheckAuth("SEARCH_PROJECT_PROJECT"))
                                                { %>
                                                <div class="Content">
                                                    <a class="Button ButtonIcon NormalState" href="Project/ProjectSearch.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.PROJECT_SEARCH %>" target="PageFrame">
                                                        <span class="Text">项目管理</span>
                                                    </a>
                                                </div>
                                                <%}%>

                                                <div class="Content">
                                                    <a class="Button ButtonIcon NormalState" href="Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.PROJECT_TEMP_SEARCH %>" target="PageFrame">
                                                        <span class="Text">项目模板管理</span>
                                                    </a>
                                                </div>

                                                <div class="Content">
                                                    <a class="Button ButtonIcon NormalState" href="Project/ProjectSearch.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.PROJECT_PROPOSAL_SEARCH %>" target="PageFrame">
                                                        <span class="Text">项目提案管理</span>
                                                    </a>
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
                                <%}%>
                                <!--第六个-->
                                <div class="Module">
                                    <div class="Normal ContextOverlayColumn">
                                        <div>
                                            
                                            <div class="Group">
                                                  <div class="Heading">
                                                    <div class="Text">查询</div>
                                                </div>
                                                <div class="Content">
                                                    <a class="Button ButtonIcon NormalState" href="Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.TICKET_SEARCH %>&isCheck=1" target="PageFrame">
                                                        <span class="Text">工单</span>
                                                    </a>
                                                </div>
                                                <div class="Content">
                                                    <a class="Button ButtonIcon NormalState" href="Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.KNOWLEDGEBASE_ARTICLE %>" target="PageFrame">
                                                        <span class="Text">知识库</span>
                                                    </a>
                                                </div>
                                                 <div class="Content">
                                                    <a class="Button ButtonIcon NormalState" href="Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.MASTER_TICKET_SEARCH %>" target="PageFrame">
                                                        <span class="Text">定期主工单</span>
                                                    </a>
                                                </div>
                                                 <div class="Content">
                                                    <a class="Button ButtonIcon NormalState" href="Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.SERVICE_CALL_SEARCH %>" target="PageFrame">
                                                        <span class="Text">服务预定</span>
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
                                                    <div class="Text">我的</div>
                                                </div>
                                              
                                                <%if (CheckAuth("MENU_INVENTORY_PRODUCT")) { %>
                                                <div class="Content">
                                                    <a class="Button ButtonIcon NormalState" href="Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.EXPENSE_REPORT %>" target="PageFrame">
                                                        <span class="Text">费用报表</span>
                                                    </a>
                                                </div>
                                                <%} %>
                                            </div>
                                            <div class="Group">
                                                  <div class="Heading">
                                                    <div class="Text">等待我审批的</div>
                                                </div>
                                                <div class="Content">
                                                    <a class="Button ButtonIcon NormalState" href="Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.MYAPPROVE_EXPENSE_REPORT %>&isCheck=1" target="PageFrame">
                                                        <span class="Text">费用报表</span>
                                                    </a>
                                                </div>
                                            </div>
                                            <div class="Group">
                                                  <div class="Heading">
                                                    <div class="Text">历史</div>
                                                </div>
                                                <div class="Content">
                                                    <a class="Button ButtonIcon NormalState" href="Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.APPROVED_REPORT %>" target="PageFrame">
                                                        <span class="Text">已审批费用报表</span>
                                                    </a>
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
                                <!--第八个--> 
                                <%if (CheckAuth("MENU_INVENTORY")) { %>
                                <div class="Module">
                                    <div class="Normal ContextOverlayColumn">
                                        <div>
                                            <div class="Group">
                                                <div class="Heading">
                                                    <div class="Text">库存</div>
                                                </div>
                                                <%if (CheckAuth("MENU_INVENTORY_ITEM")) { %>
                                                <div class="Content">
                                                    <a class="Button ButtonIcon NormalState" href="Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.INVENTORY_ITEM %>" target="PageFrame">
                                                        <span class="Text">库存产品管理</span>
                                                    </a>
                                                </div>
                                                <%} %>
                                                <%if (CheckAuth("MENU_INVENTORY_TRANSFER")) { %>
                                                <div class="Content">
                                                    <a class="Button ButtonIcon NormalState" href="Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.INVENTORY_TRANSFER %>" target="PageFrame">
                                                        <span class="Text">库存转移和更新</span>
                                                    </a>
                                                </div>
                                                <%} %>
                                                <%if (CheckAuth("MENU_INVENTORY_LOCATION")) { %>
                                                <div class="Content">
                                                    <a class="Button ButtonIcon NormalState" href="Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.INVENTORY_LOCATION %>" target="PageFrame">
                                                        <span class="Text">仓库管理</span>
                                                    </a>
                                                </div>
                                                <%} %>
                                                <%if (CheckAuth("MENU_INVENTORY_PRODUCT")) { %>
                                                <div class="Content">
                                                    <a class="Button ButtonIcon NormalState" href="Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.PRODUCT %>" target="PageFrame">
                                                        <span class="Text">产品管理</span>
                                                    </a>
                                                </div>
                                                <%} %>
                                            </div>
                                            <div class="Group">
                                                <div class="Heading">
                                                    <div class="Text">采购与交付</div>
                                                </div>
                                                <%if (CheckAuth("MENU_INVENTORY_PURCHASE_APPROVAL")) { %>
                                                <div class="Content">
                                                    <a class="Button ButtonIcon NormalState" href="Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.PURCHASE_APPROVAL %>&isCheck=1" target="PageFrame">
                                                        <span class="Text">采购审批</span>
                                                    </a>
                                                </div>
                                                <%} %>
                                                <%if (CheckAuth("MENU_INVENTORY_PURCHASING")) { %>
                                                <div class="Content">
                                                    <a class="Button ButtonIcon NormalState" href="Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.PURCHASING_FULFILLMENT %>&isCheck=1" target="PageFrame"> 
                                                        <span class="Text">待采购产品管理</span>
                                                    </a>
                                                </div>
                                                <%} %>
                                                <%if (CheckAuth("MENU_INVENTORY_PURCHASE_ORDER")) { %>
                                                <div class="Content">
                                                    <a class="Button ButtonIcon NormalState" href="Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.PURCHASE_ORDER %>" target="PageFrame"> 
                                                        <span class="Text">采购订单管理</span>
                                                    </a>
                                                </div>
                                                <%} %>
                                                <%if (CheckAuth("MENU_INVENTORY_RECEIVE")) { %>
                                                <div class="Content">
                                                    <a class="Button ButtonIcon NormalState" href="Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.PURCHASE_RECEIVE %>&isCheck=1" target="PageFrame"> 
                                                        <span class="Text">采购接收</span>
                                                    </a>
                                                </div>
                                                <%} %>
                                                <%if (CheckAuth("MENU_INVENTORY_SHIPPINT_LIST")) { %>
                                                <div class="Content">
                                                    <a class="Button ButtonIcon NormalState" href="Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.SHIPPING_LIST %>&isCheck=1" target="PageFrame"> 
                                                        <span class="Text">配送</span>
                                                    </a>
                                                </div>
                                                <%} %>
                                                <%if (CheckAuth("MENU_INVENTORY_SHIPED_LIST")) { %>
                                                <div class="Content">
                                                    <a class="Button ButtonIcon NormalState" href="Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.SHIPED_LIST %>&isCheck=1" target="PageFrame"> 
                                                        <span class="Text">已配送</span>
													                          </a>
                                                </div>
                                                <%} %>
                                                <%if (CheckAuth("MENU_INVENTORY_PUCHASE_ORDER_LIST")) { %>
                                                <div class="Content">
                                                    <a class="Button ButtonIcon NormalState" href="Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.PURCHASE_ORDER_HISTORY %>" target="PageFrame"> 
                                                        <span class="Text">采购订单历史</span>
                                                    </a>
                                                </div>
                                                <%} %>
                                            </div>
                                            <div class="Group">
                                                <div class="Heading">
                                                    <div class="Text">工具</div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <%} %>
                                <!--第九个-->
                                <div class="Module">
                                    <div class="Normal ContextOverlayColumn">
                                        <div>
                                            <div class="Group">
                                                <div class="Heading">
                                                    <div class="Text">报表种类</div>
                                                </div>
                                               
                                                <div class="Content">
                                                    <a class="Button ButtonIcon NormalState" href="Reports/ReportHomePage" target="PageFrame">
                                                        <span class="Text">CRM</span>
                                                    </a>
                                                </div>
                                               <div class="Content">
                                                    <a class="Button ButtonIcon NormalState" href="Reports/ReportHomePage?SearchType=Project" target="PageFrame">
                                                        <span class="Text">项目</span>
                                                    </a>
                                                </div>
                                                <div class="Content">
                                                    <a class="Button ButtonIcon NormalState" href="Reports/ReportHomePage?SearchType=ServiceDesk" target="PageFrame">
                                                        <span class="Text">服务台</span>
                                                    </a>
                                                </div>
                                                <div class="Content">
                                                    <a class="Button ButtonIcon NormalState" href="Reports/ReportHomePage?SearchType=ContractBill" target="PageFrame">
                                                        <span class="Text">合同计费</span>
                                                    </a>
                                                </div>
                                               <div class="Content">
                                                    <a class="Button ButtonIcon NormalState" href="Reports/ReportHomePage?SearchType=Other" target="PageFrame">
                                                        <span class="Text">其他</span>
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
                                <!--第10个-->
                                <div class="Module">
                                    
                                
                                </div>
                                <!--第11个-->
                                <%if (CheckAuth("MENU_SETTING"))
                                { %>
                                <div class="Module">
                                    <div class="Normal ContextOverlayColumn">
                                        <div>
                                            <div class="Group">
                                                <div class="Heading">
                                                    <div class="Text">视图</div>
                                                </div>
                                                <%if (CheckAuth("MENU_SETTING_SETTING"))
                                                { %>
                                                <div class="Content">
                                                    <a class="Button ButtonIcon NormalState" href="SysSetting/Admin" target="PageFrame">
                                                        <span class="Text">设置</span>
                                                    </a>
                                                </div>
                                                <%}%>
                                            </div>
                                            <div class="Group">
                                                <div class="Heading">
                                                    <div class="Text">常用</div>
                                                </div>
                                                <div class="Content">
                                                    <a class="Button ButtonIcon NormalState" href="Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.WORKFLOW_RULE %>" target="PageFrame">
                                                        <span class="Text">工作流规则</span>
                                                    </a>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <%}%>
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
            <!--我的下拉菜单-->
            <div class="ContextOverlayContainer">
                <div class="MyOverlay ContextOverlay" style="left: 355px; top: 39px;">
                    <div class="Content">
                        <div class="Title">我的...</div>
                        <div class="ColumnSet">
                            <div class="Normal ContextOverlayColumn">
                                <div>
                                    <div class="Group">
                                        <div class="Heading">
                                            <div class="Text">服务台</div>
                                        </div>
                                        <div class="Content">
                                            <a class="Button ButtonIcon NormalState" href="Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.MY_TASK_TICKET %>" target="PageFrame">
                                                <span class="Text">任务和工单</span>
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
                                                <a class="Button ButtonIcon Link NormalState">Clear
                                                </a>
                                            </div>

                                            <div class="Content">
                                                <a class="Button ButtonIcon Link NormalState">View More
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
                    <a class="Button ButtonIcon Link"><%=LoginUser.name %></a>
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
        <div id="yibiaopan" >
          <img src="Images/background.jpg" style="width:100%;height:100%;" />
            <div id="DashboardContainer" style="display:none;">
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
    <div class="cont" style="display: none;">
        <iframe id="PageFrame" name="PageFrame" style="width: 100%;"></iframe>
    </div>
</body>
<script src="Scripts/jquery-3.1.0.min.js" type="text/javascript" charset="utf-8"></script>
<script src="Scripts/index.js" type="text/javascript" charset="utf-8"></script>
<script>
    $(window).resize(function () {
        var Height = $(window).height() - 66 + "px";
        $("#PageFrame").css("height", Height);
    })
    var Height = $(window).height() - 66 + "px";
    $("#PageFrame").css("height", Height);
</script>
</html>
