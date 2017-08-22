<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SysUserSecurityLevel.aspx.cs" Inherits="EMT.DoneNOW.Web.SysSetting.SysUserSecurityLevel" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <link href="../Content/SysUserSecurityLevel.css" rel="stylesheet" />
    <link href="../Content/reset.css" rel="stylesheet" />
    <title>安全等级<%=SLName%></title>
</head>
<body>
    <form id="form1" runat="server">
        <!--顶部-->
        <div class="TitleBar">
            <div class="Title">
                <span class="text1">角色权限</span>
                <span class="text2">
                    <!--权限模板名称-->
                    <%=SLName%></span>
                <a href="###" class="help"></a>
            </div>
        </div>
        <!--按钮-->
        <div class="ButtonContainer">
            <ul>
                <li class="Button Save" id="SaveButton" tabindex="0">
                    <asp:Button ID="SaveLevel" runat="server" Text="保存并关闭" BorderStyle="None" OnClick="SaveLevel_Click"/>
                </li>
                <li class="Button Cancel" id="CancelButton" tabindex="0">
                    <asp:Button ID="Cancle" runat="server" Text="取消"  BorderStyle="None"/>
                </li>
            </ul>
        </div>
        <div class="TabBar">
            <a class="Button ButtonIcon SelectedState">
                <span class="Text">一般</span>
            </a>
            <a class="Button ButtonIcon">
                <span class="Text">文件夹</span>
            </a>
            <a class="Button ButtonIcon">
                <span class="Text">资源</span>
            </a>
        </div>
        <div class="ScrollingContainer Active" style="top: 118px; bottom: 0;">
            <!--第一部分-->
            <div class="TabContainer Active">
                <div class="Section">
                    <div class="Heading">
                        <span class="Text">一般信息</span>
                    </div>
                    <div class="Content" style="overflow: hidden;">
                        <div class="Normal Column" style="float: left;">
                            <div class="EditorLabelContainer">
                                <div class="Label">
                                    <label>名称</label>
                                    <span class="Required">*</span>
                                </div>
                            </div>
                            <div class="Normal Editor TextBox LabeledValue">
                                <asp:TextBox ID="sys_security_level_name" runat="server"></asp:TextBox><!--角色 -->
                            </div>
                        </div>
                        <div class="Normal Column">
                            <div class="Normal Editor CheckBox">
                                <div class="InputField">
                                    <div>
                                        <asp:CheckBox ID="active" runat="server" />
                                    </div>
                                    <div class="EditorLabelContainer">
                                        <div class="Label">
                                            <label>激活</label>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="Section">
                    <div class="Heading">
                        <span class="Text">模块权限</span>
                    </div>
                    <div class="Content">
                        <div class="Large Column">
                            <div class="StandardText">Home, CRM, Directory, Contracts, Projects, Service Desk, Timesheets, Inventory, Reports, Outsource, Community, Help</div>
                        </div>
                    </div>
                </div>
                <div class="Section Collapsed">
                    <div class="Heading">
                        <div class="Toggle Expand Toggle1">
                            <div class="Vertical"></div>
                            <div class="Horizontal"></div>
                        </div>
                        <span class="Text">合同</span>
                        <span class="Right">
                            <span class="Text">权限设置:</span>
                            <a class="Button ButtonIcon Link NormalState Full CONTRACTSALL" tabindex="0">全部</a>
                            <span class="VerticalSeparator"></span>
                            <a class="Button ButtonIcon Link NormalState Empty CONTRACTSNO" tabindex="0">无</a>
                        </span>
                    </div>
                    <div class="Content">
                        <div class="Large Column">
                            <div class="Normal Editor CheckBox">
                                <div class="InputField">
                                    <div>
                                        <asp:CheckBox ID="id1" runat="server" class="contracts"/>
                                    </div>
                                    <div class="EditorLabelContainer">
                                        <div class="Label">
                                            <label>修改合同内部成本</label>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="Normal Editor CheckBox">
                                <div class="InputField">
                                    <div>
                                        <asp:CheckBox ID="id2" runat="server" class="contracts"/>

                                    </div>
                                    <div class="EditorLabelContainer">
                                        <div class="Label">
                                            <label>修改合同成本成本的服务/包</label>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="Normal Editor CheckBox">
                                <div class="InputField">
                                    <div>
                                        <asp:CheckBox ID="id3" runat="server" class="contracts"/>
                                    </div>
                                    <div class="EditorLabelContainer">
                                        <div class="Label">
                                            <label>从工单和关闭商机向导创建发票</label>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="CustomLayoutContainer">
                                <div class="Edit_DropdownHeader">
                                    <div class="Edit_DropdownLabel">审批并提交</div>
                                    <div>
                                        <asp:DropDownList ID="id4" runat="server" class="contractsdown"></asp:DropDownList>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="Section Collapsed">
                    <div class="Heading">
                        <div class="Toggle Expand Toggle2">
                            <div class="Vertical"></div>
                            <div class="Horizontal"></div>
                        </div>
                        <span class="Text">CRM</span>
                        <span class="Right">
                            <span class="Text">权限设置:</span>
                            <a class="Button ButtonIcon Link NormalState Full" tabindex="0">全部</a>
                            <span class="VerticalSeparator"></span>
                            <a class="Button ButtonIcon Link NormalState Empty" tabindex="0">无</a>
                        </span>
                    </div>
                    <div class="Content">
                        <div class="Large Column">
                            <div class="CustomLayoutContainer">
                                <div class="Edit_LayoutBlock">
                                    <div class="Edit_TableTitle">客户和联系人权限</div>
                                    <div class="Edit_LayoutTable">
                                        <div class="Edit_TableHeaderRow"></div>
                                        <div class="Edit_Tablebody">
                                            <div class="Edit_TableBodyRow">
                                                <div class="Edit_FourCells Edit_RightBorder">客户和取消客户</div>
                                                <div class="Edit_OneCells">
                                                    <asp:DropDownList ID="id51" runat="server"></asp:DropDownList>
                                                </div>
                                            </div>
                                            <div class="Edit_TableBodyRow">
                                                <div class="Edit_FourCells Edit_RightBorder">供应商和合作伙伴</div>
                                                <div class="Edit_OneCells">
                                                    <asp:DropDownList ID="id52" runat="server"></asp:DropDownList>
                                                </div>
                                            </div>
                                            <div class="Edit_TableBodyRow">
                                                <div class="Edit_FourCells Edit_RightBorder">预期客户、潜在客户和终止客户</div>
                                                <div class="Edit_OneCells">
                                                    <asp:DropDownList ID="id53" runat="server"></asp:DropDownList>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="Edit_TableBottomRow"></div>
                                    </div>
                                    <div class="Edit_TableBottomDescription">我的：客户经理、客户团队成员可以查看相关客户信息
我的地域：包含我的
</div>
                                </div>
                                <div class="Edit_LayoutBlock">
                                    <div class="Edit_TableTitle">对象权限</div>
                                    <div class="Edit_TableTitleAnnotion">(for companies you have access to)</div>
                                    <div class="Edit_LayoutTable">
                                        <div class="Edit_TableHeaderRow">
                                            <div class="Edit_TwoCells Edit_RightBorder">对象</div>
                                            <div class="Edit_OneCells Edit_RightBorder">查看</div>
                                            <div class="Edit_OneCells Edit_RightBorder">新建</div>
                                            <div class="Edit_OneCells Edit_RightBorder">编辑</div>
                                            <div class="Edit_OneCells">删除</div>
                                        </div>
                                        <div class="Edit_Tablebody">
                                            <div class="Edit_TableBodyRow">
                                                <div class="Edit_TwoCells Edit_RightBorder">客户</div>
                                                <div class="Edit_OneCells Edit_RightBorder Edit_ReadonlyPermission">see above</div>
                                                <div class="Edit_OneCells Edit_RightBorder Edit_Narrow">
                                                    <asp:DropDownList ID="id54" runat="server"></asp:DropDownList>
                                                </div>
                                                <div class="Edit_OneCells Edit_RightBorder Edit_Narrow">
                                                    <asp:DropDownList ID="id55" runat="server"></asp:DropDownList>
                                                </div>
                                                <div class="Edit_OneCells Edit_RightBorder Edit_Narrow">
                                                    <asp:DropDownList ID="id56" runat="server"></asp:DropDownList>
                                                </div>
                                            </div>
                                            <div class="Edit_TableBodyRow">
                                                <div class="Edit_TwoCells Edit_RightBorder">商机和报价</div>
                                                <div class="Edit_OneCells Edit_RightBorder Edit_Narrow">
                                                    <asp:DropDownList ID="id57" runat="server"></asp:DropDownList>
                                                </div>
                                                <div class="Edit_OneCells Edit_RightBorder Edit_Narrow">
                                                    <asp:DropDownList ID="id58" runat="server"></asp:DropDownList>
                                                </div>
                                                <div class="Edit_OneCells Edit_RightBorder Edit_Narrow">
                                                    <asp:DropDownList ID="id59" runat="server"></asp:DropDownList>
                                                </div>
                                                <div class="Edit_OneCells Edit_RightBorder Edit_Narrow">
                                                    <asp:DropDownList ID="id60" runat="server"></asp:DropDownList>
                                                </div>
                                            </div>
                                            <div class="Edit_TableBodyRow">
                                                <div class="Edit_TwoCells Edit_RightBorder">销售订单</div>
                                                <div class="Edit_OneCells Edit_RightBorder Edit_Narrow">
                                                    <asp:DropDownList ID="id61" runat="server"></asp:DropDownList>
                                                </div>
                                                <div class="Edit_OneCells Edit_RightBorder Edit_ReadonlyPermission">not applicable</div>
                                                <div class="Edit_OneCells Edit_RightBorder Edit_Narrow">
                                                    <asp:DropDownList ID="id62" runat="server"></asp:DropDownList>
                                                </div>
                                                <div class="Edit_OneCells Edit_RightBorder Edit_Narrow">
                                                    <asp:DropDownList ID="id63" runat="server"></asp:DropDownList>
                                                </div>
                                            </div>
                                            <div class="Edit_TableBodyRow">
                                                <div class="Edit_TwoCells Edit_RightBorder">配置项和订阅</div>
                                                <div class="Edit_OneCells Edit_RightBorder Edit_Narrow">
                                                    <asp:DropDownList ID="id64" runat="server"></asp:DropDownList>
                                                </div>
                                                <div class="Edit_OneCells Edit_RightBorder Edit_Narrow">
                                                    <asp:DropDownList ID="id65" runat="server"></asp:DropDownList>
                                                </div>

                                                <div class="Edit_OneCells Edit_RightBorder Edit_Narrow">
                                                    <asp:DropDownList ID="id66" runat="server"></asp:DropDownList>
                                                </div>
                                                <div class="Edit_OneCells Edit_RightBorder Edit_Narrow">
                                                    <asp:DropDownList ID="id67" runat="server"></asp:DropDownList>
                                                </div>
                                            </div>
                                            <div class="Edit_TableBodyRow">
                                                <div class="Edit_TwoCells Edit_RightBorder">备注</div>
                                                <div class="Edit_OneCells Edit_RightBorder Edit_Narrow">
                                                    <asp:DropDownList ID="id68" runat="server"></asp:DropDownList>
                                                </div>
                                                <div class="Edit_OneCells Edit_RightBorder Edit_Narrow">
                                                    <asp:DropDownList ID="id69" runat="server"></asp:DropDownList>
                                                </div>
                                                <div class="Edit_OneCells Edit_RightBorder Edit_Narrow">
                                                    <asp:DropDownList ID="id70" runat="server"></asp:DropDownList>
                                                </div>
                                                <div class="Edit_OneCells Edit_RightBorder Edit_Narrow">
                                                    <asp:DropDownList ID="id71" runat="server"></asp:DropDownList>
                                                </div>
                                            </div>
                                            <div class="Edit_TableBodyRow">
                                                <div class="Edit_TwoCells Edit_RightBorder">待办</div>
                                                <div class="Edit_OneCells Edit_RightBorder Edit_Narrow">
                                                    <asp:DropDownList ID="id72" runat="server"></asp:DropDownList>
                                                </div>
                                                <div class="Edit_OneCells Edit_RightBorder Edit_Narrow">
                                                    <asp:DropDownList ID="id73" runat="server"></asp:DropDownList>
                                                </div>
                                                <div class="Edit_OneCells Edit_RightBorder Edit_Narrow">
                                                    <asp:DropDownList ID="id74" runat="server"></asp:DropDownList>
                                                </div>
                                                <div class="Edit_OneCells Edit_RightBorder Edit_Narrow">
                                                    <asp:DropDownList ID="id75" runat="server"></asp:DropDownList>
                                                </div>
                                            </div>
                                        <div class="Edit_TableBodyRow">
                                            <div class="Edit_TwoCells Edit_RightBorder">附件</div>
                                            <div class="Edit_OneCells Edit_RightBorder Edit_Narrow">
                                                <asp:DropDownList ID="id76" runat="server"></asp:DropDownList>
                                            </div>
                                            <div class="Edit_OneCells Edit_RightBorder Edit_Narrow">
                                                <asp:DropDownList ID="id77" runat="server"></asp:DropDownList>
                                            </div>
                                            <div class="Edit_OneCells Edit_RightBorder Edit_ReadonlyPermission">not applicable</div>
                                            <div class="Edit_OneCells Edit_RightBorder Edit_Narrow">
                                                <asp:DropDownList ID="id78" runat="server"></asp:DropDownList>
                                            </div>
                                        </div>
                                        </div>
                                    <div class="Edit_TableBottomRow"></div>
                                </div>
                                <div class="Edit_TableBottomDescription">客户的编辑和删除设置为“我的”时，同时具有了“我的领域”全部客户的编辑和删除权限</div>
                            </div>
                        </div>
                        <div class="CheckBoxGroupContainer">
                            <div class="CheckBoxGroupLabel">
                                <div>
                                    <span class="Label">功能页面</span>
                                </div>
                            </div>
                            <div class="Normal Editor CheckBox">
                                <div class="InputField">
                                    <div>
                                        <asp:CheckBox ID="id79" runat="server" />

                                    </div>
                                    <div class="EditorLabelContainer">
                                        <div class="Label">
                                            <label>联系人组管理</label>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="Normal Editor CheckBox">
                                <div class="InputField">
                                    <div>
                                        <asp:CheckBox ID="id80" runat="server" />
                                    </div>
                                    <div class="EditorLabelContainer">
                                        <div class="Label">
                                            <label>报表导出</label>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="Normal Editor CheckBox">
                                <div class="InputField">
                                    <div>
                                        <asp:CheckBox ID="id81" runat="server" />
                                    </div>
                                    <div class="EditorLabelContainer">
                                        <div class="Label">
                                            <label>设备发现向导</label>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="Normal Editor CheckBox">
                                <div class="InputField">
                                    <div>
                                        <asp:CheckBox ID="id82" runat="server" />
                                    </div>
                                    <div class="EditorLabelContainer">
                                        <div class="Label">
                                            <label>管理报价模板和报价邮件模板</label>
                                        </div>
                                    </div>
                                </div>
                            </div>

                        </div>
                        <div class="CheckBoxGroupContainer">
                            <div class="CheckBoxGroupLabel">
                                <div>
                                    <span class="Label">其他权限</span>
                                </div>
                            </div>
                            <div class="Normal Editor CheckBox">
                                <div class="InputField">
                                    <div>
                                        <asp:CheckBox ID="id83" runat="server" />
                                    </div>
                                    <div class="EditorLabelContainer">
                                        <div class="Label">
                                            <label>重新指派客户经理</label>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="Normal Editor CheckBox">
                                <div class="InputField">
                                    <div>
                                        <asp:CheckBox ID="id84" runat="server" />
                                    </div>
                                    <div class="EditorLabelContainer">
                                        <div class="Label">
                                            <label>重新指派商机负责人</label>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="Normal Editor CheckBox">
                                <div class="InputField">
                                    <div>
                                        <asp:CheckBox ID="id85" runat="server" />
                                    </div>
                                    <div class="EditorLabelContainer">
                                        <div class="Label">
                                            <label>选择客户时，列出全部客户。</label>
                                            <div class="SecondaryText">
                                                如果选中，员工将能够创建和搜索出其没有权限查看的客户的条目
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="CustomLayoutContainer">
                            <div class="Edit_DropdownHeader">
                                <div class="Edit_DropdownLabel">仪表板显示</div>
                                <div>
                                    <asp:DropDownList ID="id86" runat="server"></asp:DropDownList>
                                </div>
                            </div>
                        </div>
                    </div>
                    </div>
                </div>


            <div class="Section Collapsed">
                <div class="Heading">
                    <div class="Toggle Expand Toggle3">
                        <div class="Vertical"></div>
                        <div class="Horizontal"></div>
                    </div>
                    <span class="Text">库存</span>
                    <span class="Right">
                        <span class="Text">权限配置:</span>
                        <a class="Button ButtonIcon Link NormalState Full" tabindex="0">全部</a>
                        <span class="VerticalSeparator"></span>
                        <a class="Button ButtonIcon Link NormalState Empty" tabindex="0">无</a>
                    </span>
                </div>
                <div class="Content">
                        <div class="Large Column">
                            <div class="CustomLayoutContainer">
                                <div class="Edit_LayoutBlock">
                                    <div class="Edit_TableTitle">对象权限</div>
                                    <div class="Edit_TableTitleAnnotion"></div>
                                    <div class="Edit_LayoutTable">
                                        <div class="Edit_TableHeaderRow">
                                            <div class="Edit_TwoCells Edit_RightBorder">对象</div>
                                            <div class="Edit_OneCells Edit_RightBorder">查看</div>
                                            <div class="Edit_OneCells Edit_RightBorder">新建</div>
                                            <div class="Edit_OneCells Edit_RightBorder">编辑</div>
                                            <div class="Edit_OneCells">删除</div>
                                        </div>
                                        <div class="Edit_Tablebody">
                                            <div class="Edit_TableBodyRow">
                                                <div class="Edit_TwoCells Edit_RightBorder">仓库</div>
                                                 <div class="Edit_OneCells Edit_RightBorder Edit_Narrow">
                                                   <asp:DropDownList ID="id101" runat="server"></asp:DropDownList>
                                                </div>
                                                <div class="Edit_OneCells Edit_RightBorder Edit_Narrow">
                                                   <asp:DropDownList ID="id102" runat="server"></asp:DropDownList>
                                                </div>
                                                <div class="Edit_OneCells Edit_RightBorder Edit_ReadonlyPermission">None</div>
                                                <div class="Edit_OneCells Edit_RightBorder Edit_Narrow">
                                                    <asp:DropDownList ID="id103" runat="server"></asp:DropDownList>
                                                </div>
                                            </div>											
                                          <div class="Edit_TableBodyRow">
                                                <div class="Edit_TwoCells Edit_RightBorder">仓库产品</div>
                                                 <div class="Edit_OneCells Edit_RightBorder Edit_Narrow">
                                                   <asp:DropDownList ID="id104" runat="server"></asp:DropDownList>
                                                </div>
                                                <div class="Edit_OneCells Edit_RightBorder Edit_Narrow">
                                                   <asp:DropDownList ID="id105" runat="server"></asp:DropDownList>
                                                </div>
                                                <div class="Edit_OneCells Edit_RightBorder Edit_ReadonlyPermission">None</div>
                                                <div class="Edit_OneCells Edit_RightBorder Edit_Narrow">
                                                    <asp:DropDownList ID="id106" runat="server"></asp:DropDownList>
                                                </div>
                                            </div>
											
											 <div class="Edit_TableBodyRow">
                                                <div class="Edit_TwoCells Edit_RightBorder">产品</div>
                                                 <div class="Edit_OneCells Edit_RightBorder Edit_Narrow">
                                                   <asp:DropDownList ID="id107" runat="server"></asp:DropDownList>
                                                </div>
                                                <div class="Edit_OneCells Edit_RightBorder Edit_Narrow">
                                                   <asp:DropDownList ID="id108" runat="server"></asp:DropDownList>
                                                </div>
                                                <div class="Edit_OneCells Edit_RightBorder Edit_ReadonlyPermission">None</div>
                                                <div class="Edit_OneCells Edit_RightBorder Edit_Narrow">
                                                    <asp:DropDownList ID="id109" runat="server"></asp:DropDownList>
                                                </div>
                                            </div>
											
											<div class="Edit_TableBodyRow">
                                                <div class="Edit_TwoCells Edit_RightBorder">订单</div>
                                                 <div class="Edit_OneCells Edit_RightBorder Edit_Narrow">
                                                   <asp:DropDownList ID="id110" runat="server"></asp:DropDownList>
                                                </div>
                                                <div class="Edit_OneCells Edit_RightBorder Edit_Narrow">
                                                   <asp:DropDownList ID="id111" runat="server"></asp:DropDownList>
                                                </div>
                                                <div class="Edit_OneCells Edit_RightBorder Edit_ReadonlyPermission">None</div>
                                                <div class="Edit_OneCells Edit_RightBorder Edit_Narrow">
                                                    <asp:DropDownList ID="id112" runat="server"></asp:DropDownList>
                                                </div>
                                            </div>
                                        </div>
                                    </div>                                    
                                </div>
                            </div>
                            <div class="CheckBoxGroupContainer">
                                <div class="CheckBoxGroupLabel">
                                    <div>
                                        <span class="Label">功能页面</span>
                                    </div>
                                </div>
                                <div class="Normal Editor CheckBox">
                                    <div class="InputField">
                                        <div>
										<asp:CheckBox ID="id113" runat="server" />
										</div>
                                        <div class="EditorLabelContainer">
                                            <div class="Label">
                                                <label>审批</label>
                                            </div>
                                        </div>
                                    </div>
                                </div>
								<div class="Normal Editor CheckBox">
                                    <div class="InputField">
                                        <div>
										<asp:CheckBox ID="id114" runat="server" />
										</div>
                                        <div class="EditorLabelContainer">
                                            <div class="Label">
                                                <label>接收</label>
                                            </div>
                                        </div>
                                    </div>
                                </div>
								<div class="Normal Editor CheckBox">
                                    <div class="InputField">
                                        <div>
										<asp:CheckBox ID="id115" runat="server" />
										</div>
                                        <div class="EditorLabelContainer">
                                            <div class="Label">
                                                <label>配送</label>
                                            </div>
                                        </div>
                                    </div>
                                </div>
								<div class="Normal Editor CheckBox">
                                    <div class="InputField">
                                        <div>
										<asp:CheckBox ID="id116" runat="server" />
										</div>
                                        <div class="EditorLabelContainer">
                                            <div class="Label">
                                                <label>转移</label>
                                            </div>
                                        </div>
                                    </div>
                                </div>						
								
                            </div>					
                            
                            
                        </div>
                    </div>
            </div>


            <div class="Section Collapsed">
                <div class="Heading">
                    <div class="Toggle Expand Toggle4">
                        <div class="Vertical"></div>
                        <div class="Horizontal"></div>
                    </div>
                    <span class="Text">项目</span>
                    <span class="Right">
                        <span class="Text">权限配置:</span>
                        <a class="Button ButtonIcon Link NormalState Full" tabindex="0">全部</a>
                        <span class="VerticalSeparator"></span>
                        <a class="Button ButtonIcon Link NormalState Empty" tabindex="0">无</a>
                    </span>
                </div>
<div class="Content">
                        <div class="Large Column">
                            <div class="CustomLayoutContainer">
                                <div class="Edit_LayoutBlock">
                                    <div class="Edit_TableTitle">项目访问权限</div>
                                    <div class="Edit_TableTitleAnnotion">如果客户想查看项目，包括报表和仪表板中，可以分配查看权限，可以查看项目的用户也可以编辑和删除项目。如果想创建新项目，可以设置新建权限</div>
                                    <div class="Edit_LayoutTable">
                                        <div class="Edit_TableHeaderRow">
                                            <div class="Edit_TwoCells Edit_RightBorder">项目类型</div>
                                            <div class="Edit_OneCells Edit_RightBorder">查看</div>
                                            <div class="Edit_OneCells Edit_RightBorder">新建</div>
                                        </div>
                                        <div class="Edit_Tablebody">
                                            <div class="Edit_TableBodyRow">
                                                <div class="Edit_TwoCells Edit_RightBorder">1）	客户项目和内部项目</div>
                                                 <div class="Edit_OneCells Edit_RightBorder Edit_Narrow">
                                                   <asp:DropDownList ID="id151" runat="server"></asp:DropDownList>
                                                </div>
                                                <div class="Edit_OneCells Edit_RightBorder Edit_Narrow">
                                                   <asp:DropDownList ID="id152" runat="server"></asp:DropDownList>
                                                </div>                                 
                                           </div>
										   <div class="Edit_TableBodyRow">
                                                <div class="Edit_TwoCells Edit_RightBorder">项目提案</div>
                                                 <div class="Edit_OneCells Edit_RightBorder Edit_Narrow">
                                                   <asp:DropDownList ID="id153" runat="server"></asp:DropDownList>
                                                </div>
                                                <div class="Edit_OneCells Edit_RightBorder Edit_Narrow">
                                                   <asp:DropDownList ID="id154" runat="server"></asp:DropDownList>
                                                </div>                                 
                                           </div>
                                            <div class="Edit_TableBodyRow">
                                                <div class="Edit_TwoCells Edit_RightBorder">模板</div>
                                                 <div class="Edit_OneCells Edit_RightBorder Edit_Narrow">
                                                   <asp:DropDownList ID="id155" runat="server"></asp:DropDownList>
                                                </div>
                                                <div class="Edit_OneCells Edit_RightBorder Edit_Narrow">
                                                   <asp:DropDownList ID="id156" runat="server"></asp:DropDownList>
                                                </div>                                 
                                           </div>
                                        </div>
										<div class="Edit_TableBottomRow"></div>
                                    </div>                                    
								 <div class="Edit_TableBottomDescription">“我的”包括以下范围：员工为项目成员包括项目负责人，员工为项目所属部门的部门主管，员工为项目所属客户的客户经理或者为项目关联商机的商机负责人</div>
                            </div>
							</div>
                            <div class="CheckBoxGroupContainer">
                                <div class="CheckBoxGroupLabel">
                                    <div>
                                        <span class="Label">工时权限</span>
                                    </div>
                                </div>
                                <div class="Normal Editor CheckBox">
                                    <div class="InputField">
                                        <div>
										<asp:CheckBox ID="id157" runat="server" />
										</div>
                                        <div class="EditorLabelContainer">
                                            <div class="Label">
                                                <label>可以更改任务工时和问题工时的合同</label>
                                            </div>
                                        </div>
                                    </div>
                                </div>
								<div class="Normal Editor CheckBox">
                                    <div class="InputField">
                                        <div>
										<asp:CheckBox ID="id158" runat="server" />
										</div>
                                        <div class="EditorLabelContainer">
                                            <div class="Label">
                                                <label>客户更改任务工时和任务工时的“不收费的”设置</label>
                                            </div>
                                        </div>
                                    </div>
                                </div>
								<div class="Normal Editor CheckBox">
                                    <div class="InputField">
                                        <div>
										<asp:CheckBox ID="id159" runat="server" />
										</div>
                                        <div class="EditorLabelContainer">
                                            <div class="Label">
                                                <label>可以更改任务工时和问题工时的“在发票上显示”设置</label>
                                            </div>
                                        </div>
                                    </div>
                                </div>
								<div class="Normal Editor CheckBox">
                                    <div class="InputField">
                                        <div>
										<asp:CheckBox ID="id160" runat="server" />
										</div>
                                        <div class="EditorLabelContainer">
                                            <div class="Label">
                                                <label>可以更改任务工时和问题工时的工作类型</label>
                                            </div>
                                        </div>
                                    </div>
                                </div>						
								<div class="Normal Editor CheckBox">
                                    <div class="InputField">
                                        <div>
										<asp:CheckBox ID="id161" runat="server" />
										</div>
                                        <div class="EditorLabelContainer">
                                            <div class="Label">
                                                <label>可以更改任务工时、问题工时和项目成本的服务/包</label>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
							<div class="CustomLayoutContainer">
                                <div class="Edit_DropdownHeader">
                                    <div class="Edit_DropdownLabel">输入工时</div>
                                        <asp:DropDownList ID="id162" runat="server"></asp:DropDownList>
                                </div>
                            </div>					
                             <div class="CheckBoxGroupContainer">
                                <div class="CheckBoxGroupLabel">
                                    <div>
                                        <span class="Label">其他权限</span>
                                    </div>
                                </div>
                                <div class="Normal Editor CheckBox">
                                    <div class="InputField">
                                        <div>
										<asp:CheckBox ID="id163" runat="server" />
										</div>
                                        <div class="EditorLabelContainer">
                                            <div class="Label">
                                                <label>可以查看内部成本（项目模块）</label>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                        </div>
                    </div>
            </div>
</div>



            <div class="Section Collapsed">
                <div class="Heading">
                    <div class="Toggle Expand Toggle5">
                        <div class="Vertical"></div>
                        <div class="Horizontal"></div>
                    </div>
                    <span class="Text">服务台</span>
                    <span class="Right">
                        <span class="Text">权限配置:</span>
                        <a class="Button ButtonIcon Link NormalState Full" tabindex="0">全部</a>
                        <span class="VerticalSeparator"></span>
                        <a class="Button ButtonIcon Link NormalState Empty" tabindex="0">无</a>
                    </span>
                </div>

          <div class="Content">
                        <div class="Large Column">
                            <div class="CustomLayoutContainer">                               
                                <div class="Edit_LayoutBlock">
                                    <div class="Edit_TableTitle">对象权限</div>
                                    <div class="Edit_TableTitleAnnotion">(for companies you have access to)</div>
                                    <div class="Edit_LayoutTable">
                                        <div class="Edit_TableHeaderRow">
                                            <div class="Edit_TwoCells Edit_RightBorder">对象</div>
                                            <div class="Edit_OneCells Edit_RightBorder">查看</div>
                                            <div class="Edit_OneCells Edit_RightBorder">新建</div>
                                            <div class="Edit_OneCells Edit_RightBorder">编辑</div>
                                            <div class="Edit_OneCells">删除</div>
                                        </div>
                                        <div class="Edit_Tablebody">
                                            <div class="Edit_TableBodyRow">
                                                <div class="Edit_TwoCells Edit_RightBorder">工单</div>
                                                <div class="Edit_OneCells Edit_RightBorder Edit_ReadonlyPermission"><asp:DropDownList ID="id201" runat="server"></asp:DropDownList></div>
                                                <div class="Edit_OneCells Edit_RightBorder Edit_Narrow">
                                                    <asp:DropDownList ID="id202" runat="server"></asp:DropDownList>
                                                </div>
                                                <div class="Edit_OneCells Edit_RightBorder Edit_Narrow">
                                                    <asp:DropDownList ID="id203" runat="server"></asp:DropDownList>
                                                </div>
                                                <div class="Edit_OneCells Edit_RightBorder Edit_Narrow">
                                                    <asp:DropDownList ID="id204" runat="server"></asp:DropDownList>
                                                </div>
                                            </div>
                                            <div class="Edit_TableBodyRow">
                                                <div class="Edit_TwoCells Edit_RightBorder">工单记录</div>
                                                <div class="Edit_OneCells Edit_RightBorder Edit_Narrow">
                                                    <asp:DropDownList ID="id205" runat="server"></asp:DropDownList>
                                                </div>
                                                <div class="Edit_OneCells Edit_RightBorder Edit_Narrow">
                                                    <asp:DropDownList ID="id206" runat="server"></asp:DropDownList>
                                                </div>
                                                <div class="Edit_OneCells Edit_RightBorder Edit_Narrow">
                                                    <asp:DropDownList ID="id207" runat="server"></asp:DropDownList>
                                                </div>
                                                <div class="Edit_OneCells Edit_RightBorder Edit_Narrow">
                                                    <asp:DropDownList ID="id208" runat="server"></asp:DropDownList>
                                                </div>
                                            </div>
                                            <div class="Edit_TableBodyRow">
                                                <div class="Edit_TwoCells Edit_RightBorder">服务请求</div>
                                                <div class="Edit_OneCells Edit_RightBorder Edit_Narrow">
                                                    <asp:DropDownList ID="id209" runat="server"></asp:DropDownList>
                                                </div>
                                                <div class="Edit_OneCells Edit_RightBorder Edit_ReadonlyPermission"><asp:DropDownList ID="id210" runat="server"></asp:DropDownList></div>
                                                <div class="Edit_OneCells Edit_RightBorder Edit_Narrow">
                                                    <asp:DropDownList ID="id211" runat="server"></asp:DropDownList>
                                                </div>
                                                <div class="Edit_OneCells Edit_RightBorder Edit_Narrow">
                                                    <asp:DropDownList ID="id212" runat="server"></asp:DropDownList>
                                                </div>
                                            </div>
                                           
                                            
                                           
                                       
                                        </div>
                                    <div class="Edit_TableBottomRow"></div>
                                </div>
                                <div class="Edit_TableBottomDescription">1)工单编辑权限设置为“无”，仍然可以在“转发和修改”模块修改工单的标题、内容、队列、主负责人、其他负责人等信息
2）工单查看权限设置为“我的”，指用户作为派发对象的全部工单
3）工单查看权限设置为“我的+客户”，指用户作为派发对象的全部工单，以及用户能够查看的客户的全部工单
4）服务呼叫查看权限设置为“我的”，指用户作为派发对象的全部服务呼叫
5）服务呼叫查看权限设置为“我的+客户”，指用户作为派发对象的全部服务呼叫，以及用户能够查看的客户的全部服务呼叫
</div>
                            </div>
                        </div>
                        <div class="CheckBoxGroupContainer">
                            <div class="CheckBoxGroupLabel">
                                <div>
                                    <span class="Label">工时权限</span>
                                </div>
                            </div>
                            <div class="Normal Editor CheckBox">
                                <div class="InputField">
                                    <div>
                                        <asp:CheckBox ID="id213" runat="server" />

                                    </div>
                                    <div class="EditorLabelContainer">
                                        <div class="Label">
                                            <label>可以更改工单工时的合同</label>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="Normal Editor CheckBox">
                                <div class="InputField">
                                    <div>
                                        <asp:CheckBox ID="id214" runat="server" />
                                    </div>
                                    <div class="EditorLabelContainer">
                                        <div class="Label">
                                            <label>可以更改工单工时的“不收费”的设置</label>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="Normal Editor CheckBox">
                                <div class="InputField">
                                    <div>
                                        <asp:CheckBox ID="id215" runat="server" />
                                    </div>
                                    <div class="EditorLabelContainer">
                                        <div class="Label">
                                            <label>可以更改工单工时的“在发票上显示”设置</label>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="Normal Editor CheckBox">
                                <div class="InputField">
                                    <div>
                                        <asp:CheckBox ID="id216" runat="server" />
                                    </div>
                                    <div class="EditorLabelContainer">
                                        <div class="Label">
                                            <label>可以更改工单工时的工作类型</label>
                                        </div>
                                    </div>
                                </div>
                            </div>
							 <div class="Normal Editor CheckBox">
                                <div class="InputField">
                                    <div>
                                        <asp:CheckBox ID="id217" runat="server" />
                                    </div>
                                    <div class="EditorLabelContainer">
                                        <div class="Label">
                                            <label>可以更改工单工时、工单成本的服务/包</label>
                                        </div>
                                    </div>
                                </div>
                            </div>

                        </div>
                        <div class="CheckBoxGroupContainer">
                            <div class="CheckBoxGroupLabel">
                                <div>
                                    <span class="Label">其他权限</span>
                                </div>
                            </div>
                            <div class="Normal Editor CheckBox">
                                <div class="InputField">
                                    <div>
                                        <asp:CheckBox ID="id218" runat="server" />
                                    </div>
                                    <div class="EditorLabelContainer">
                                        <div class="Label">
                                            <label>可修改已完工工单状态</label>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="Normal Editor CheckBox">
                                <div class="InputField">
                                    <div>
                                        <asp:CheckBox ID="id219" runat="server" />
                                    </div>
                                    <div class="EditorLabelContainer">
                                        <div class="Label">
                                            <label>可查看已分发的日历</label>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="Normal Editor CheckBox">
                                <div class="InputField">
                                    <div>
                                        <asp:CheckBox ID="id220" runat="server" />
                                    </div>
                                    <div class="EditorLabelContainer">
                                        <div class="Label">
                                            <label>可查看内部成本（服务台模块）</label>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    </div>
            </div>




            <div class="Section Collapsed">
                <div class="Heading">
                    <div class="Toggle Expand Toggle6">
                        <div class="Vertical"></div>
                        <div class="Horizontal"></div>
                    </div>
                    <span class="Text">工时表</span>
                    <span class="Right">
                        <span class="Text">权限设置:</span>
                        <a class="Button ButtonIcon Link NormalState Full" tabindex="0">全部</a>
                        <span class="VerticalSeparator"></span>
                        <a class="Button ButtonIcon Link NormalState Empty" tabindex="0">无</a>
                    </span>
                </div>


                <div class="Content">
                    <div class="Large Column">
 <div class="CheckBoxGroupContainer">
                            <div class="CheckBoxGroupLabel">
                                <div>
                                    <span class="Label">功能页面</span>
                                </div>
                            </div>
                            <div class="Normal Editor CheckBox">
                                <div class="InputField">
                                    <div>
                                        <asp:CheckBox ID="id251" runat="server" />

                                    </div>
                                    <div class="EditorLabelContainer">
                                        <div class="Label">
                                            <label>可以访问工时表模块报表</label>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="Normal Editor CheckBox">
                                <div class="InputField">
                                    <div>
                                        <asp:CheckBox ID="id252" runat="server" />
                                    </div>
                                    <div class="EditorLabelContainer">
                                        <div class="Label">
                                            <label>可以访问休假和工资报表</label>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="Normal Editor CheckBox">
                                <div class="InputField">
                                    <div>
                                        <asp:CheckBox ID="id253" runat="server" />
                                    </div>
                                    <div class="EditorLabelContainer">
                                        <div class="Label">
                                            <label>可以访问支付和导出工时表</label>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="Normal Editor CheckBox">
                                <div class="InputField">
                                    <div>
                                        <asp:CheckBox ID="id254" runat="server" />
                                    </div>
                                    <div class="EditorLabelContainer">
                                        <div class="Label">
                                            <label>可以在工时表模块创建项目时间</label>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
</div>
                </div>



            </div>





            <div class="Section Collapsed">
                <div class="Heading">
                    <div class="Toggle Expand Toggle7">
                        <div class="Vertical"></div>
                        <div class="Horizontal"></div>
                    </div>
                    <span class="Text">系统管理</span>
                    <span class="Right">
                        <span class="Text">权限设置:</span>
                        <a class="Button ButtonIcon Link NormalState Full" tabindex="0">全部</a>
                        <span class="VerticalSeparator"></span>
                        <a class="Button ButtonIcon Link NormalState Empty" tabindex="0">无</a>
                    </span>
                </div>
                <div class="Content">
                    <div class="Large Column">
 <div class="CheckBoxGroupContainer">
                            <div class="CheckBoxGroupLabel">
                                <div>
                                    <span class="Label">功能页面</span>
                                </div>
                            </div>
                            <div class="Normal Editor CheckBox">
                                <div class="InputField">
                                    <div>
                                        <asp:CheckBox ID="id301" runat="server" />

                                    </div>
                                    <div class="EditorLabelContainer">
                                        <div class="Label">
                                            <label>共享功能（访问）</label>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="Normal Editor CheckBox">
                                <div class="InputField">
                                    <div>
                                        <asp:CheckBox ID="id302" runat="server" />
                                    </div>
                                    <div class="EditorLabelContainer">
                                        <div class="Label">
                                            <label>组织</label>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="Normal Editor CheckBox">
                                <div class="InputField">
                                    <div>
                                        <asp:CheckBox ID="id303" runat="server" />
                                    </div>
                                    <div class="EditorLabelContainer">
                                        <div class="Label">
                                            <label>人力资源</label>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="Normal Editor CheckBox">
                                <div class="InputField">
                                    <div>
                                        <asp:CheckBox ID="id304" runat="server" />
                                    </div>
                                    <div class="EditorLabelContainer">
                                        <div class="Label">
                                            <label>客户和联系人</label>
                                        </div>
                                    </div>
                                </div>
                            </div>
							 <div class="Normal Editor CheckBox">
                                <div class="InputField">
                                    <div>
                                        <asp:CheckBox ID="id305" runat="server" />
                                    </div>
                                    <div class="EditorLabelContainer">
                                        <div class="Label">
                                            <label>服务台（工单）</label>
                                        </div>
                                    </div>
                                </div>
                            </div>
							 <div class="Normal Editor CheckBox">
                                <div class="InputField">
                                    <div>
                                        <asp:CheckBox ID="id306" runat="server" />
                                    </div>
                                    <div class="EditorLabelContainer">
                                        <div class="Label">
                                            <label>项目和任务</label>
                                        </div>
                                    </div>
                                </div>
                            </div>
							 <div class="Normal Editor CheckBox">
                                <div class="InputField">
                                    <div>
                                        <asp:CheckBox ID="id307" runat="server" />
                                    </div>
                                    <div class="EditorLabelContainer">
                                        <div class="Label">
                                            <label>销售和商机</label>
                                        </div>
                                    </div>
                                </div>
                            </div>
							 <div class="Normal Editor CheckBox">
                                <div class="InputField">
                                    <div>
                                        <asp:CheckBox ID="id308" runat="server" />
                                    </div>
                                    <div class="EditorLabelContainer">
                                        <div class="Label">
                                            <label>产品和服务</label>
                                        </div>
                                    </div>
                                </div>
                            </div>
							 <div class="Normal Editor CheckBox">
                                <div class="InputField">
                                    <div>
                                        <asp:CheckBox ID="id309" runat="server" />
                                    </div>
                                    <div class="EditorLabelContainer">
                                        <div class="Label">
                                            <label>配置项</label>
                                        </div>
                                    </div>
                                </div>
                            </div>
							 <div class="Normal Editor CheckBox">
                                <div class="InputField">
                                    <div>
                                        <asp:CheckBox ID="id310" runat="server" />
                                    </div>
                                    <div class="EditorLabelContainer">
                                        <div class="Label">
                                            <label>财务、会计和发票</label>
                                        </div>
                                    </div>
                                </div>
                            </div>
							 <div class="Normal Editor CheckBox">
                                <div class="InputField">
                                    <div>
                                        <asp:CheckBox ID="id311" runat="server" />
                                    </div>
                                    <div class="EditorLabelContainer">
                                        <div class="Label">
                                            <label>合同和撤销审批(contract & up-posting)</label>
                                        </div>
                                    </div>
                                </div>
                            </div>
							 <div class="Normal Editor CheckBox">
                                <div class="InputField">
                                    <div>
                                        <asp:CheckBox ID="id312" runat="server" />
                                    </div>
                                    <div class="EditorLabelContainer">
                                        <div class="Label">
                                            <label>实时报表（本期不提供）</label>
                                        </div>
                                    </div>
                                </div>
                            </div>
							 <div class="Normal Editor CheckBox">
                                <div class="InputField">
                                    <div>
                                        <asp:CheckBox ID="id313" runat="server" />
                                    </div>
                                    <div class="EditorLabelContainer">
                                        <div class="Label">
                                            <label>插件（本期不提供）</label>
                                        </div>
                                    </div>
                                </div>
                            </div>
							<div class="Normal Editor CheckBox">
                                <div class="InputField">
                                    <div>
                                        <asp:CheckBox ID="id314" runat="server" />
                                    </div>
                                    <div class="EditorLabelContainer">
                                        <div class="Label">
                                            <label>客户portal（本期不提供）</label>
                                        </div>
                                    </div>
                                </div>
                            </div>
							<div class="Normal Editor CheckBox">
                                <div class="InputField">
                                    <div>
                                        <asp:CheckBox ID="id315" runat="server" />
                                    </div>
                                    <div class="EditorLabelContainer">
                                        <div class="Label">
                                            <label>Microsoft扩展（本期不提供）</label>
                                        </div>
                                    </div>
                                </div>
                            </div>
							<div class="Normal Editor CheckBox">
                                <div class="InputField">
                                    <div>
                                        <asp:CheckBox ID="id316" runat="server" />
                                    </div>
                                    <div class="EditorLabelContainer">
                                        <div class="Label">
                                            <label>Quickbook扩展（本期不提供）</label>
                                        </div>
                                    </div>
                                </div>
                            </div>
							<div class="Normal Editor CheckBox">
                                <div class="InputField">
                                    <div>
                                        <asp:CheckBox ID="id317" runat="server" />
                                    </div>
                                    <div class="EditorLabelContainer">
                                        <div class="Label">
                                            <label>远程监控和管理扩展（本期不提供）</label>
                                        </div>
                                    </div>
                                </div>
                            </div>
							<div class="Normal Editor CheckBox">
                                <div class="InputField">
                                    <div>
                                        <asp:CheckBox ID="id318" runat="server" />
                                    </div>
                                    <div class="EditorLabelContainer">
                                        <div class="Label">
                                            <label>其他扩展和工具（本期不提供）</label>
                                        </div>
                                    </div>
                                </div>
                            </div>				
</div>
</div>
                </div>
            </div>



            <div class="Section Collapsed">
                <div class="Heading">
                    <div class="Toggle Expand Toggle8">
                        <div class="Vertical"></div>
                        <div class="Horizontal"></div>
                    </div>
                    <span class="Text">其他</span>
                    <span class="Right">
                        <span class="Text">权限配置:</span>
                        <a class="Button ButtonIcon Link NormalState Full" tabindex="0">全部</a>
                        <span class="VerticalSeparator"></span>
                        <a class="Button ButtonIcon Link NormalState Empty" tabindex="0">无</a>
                    </span>
                </div>
                <div class="Content">

                    <div class="Large Column">
 <div class="CheckBoxGroupContainer">
                            <div class="CheckBoxGroupLabel">
                                <div>
                                    <span class="Label">问卷调查</span>
                                </div>
                            </div>
                            <div class="Normal Editor CheckBox">
                                <div class="InputField">
                                    <div>
                                        <asp:CheckBox ID="id351" runat="server" />

                                    </div>
                                    <div class="EditorLabelContainer">
                                        <div class="Label">
                                            <label>可以查看客户和联系人问卷调查分数</label>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="Normal Editor CheckBox">
                                <div class="InputField">
                                    <div>
                                        <asp:CheckBox ID="id352" runat="server" />
                                    </div>
                                    <div class="EditorLabelContainer">
                                        <div class="Label">
                                            <label>可以查看员工问卷调查分数</label>
                                        </div>
                                    </div>
                                </div>
                            </div>
							 <div class="CheckBoxGroupLabel">
                                <div>
                                    <span class="Label">实时报表</span>
                                </div>
                            </div>
                            <div class="Normal Editor CheckBox">
                                <div class="InputField">
                                    <div>
                                        <asp:CheckBox ID="id353" runat="server" />
                                    </div>
                                    <div class="EditorLabelContainer">
                                        <div class="Label">
                                            <label>可以访问实时报表设计</label>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="Normal Editor CheckBox">
                                <div class="InputField">
                                    <div>
                                        <asp:CheckBox ID="id354" runat="server" />
                                    </div>
                                    <div class="EditorLabelContainer">
                                        <div class="Label">
                                            <label>可以管理报表文件夹</label>
                                        </div>
                                    </div>
                                </div>
                            </div>
							 <div class="Normal Editor CheckBox">
                                <div class="InputField">
                                    <div>
                                        <asp:CheckBox ID="id355" runat="server" />
                                    </div>
                                    <div class="EditorLabelContainer">
                                        <div class="Label">
                                            <label>可以发布报表</label>
                                        </div>
                                    </div>
                                </div>
                            </div>
							 <div class="Normal Editor CheckBox">
                                <div class="InputField">
                                    <div>
                                        <asp:CheckBox ID="id356" runat="server" />
                                    </div>
                                    <div class="EditorLabelContainer">
                                        <div class="Label">
                                            <label>可以计划报表</label>
                                        </div>
                                    </div>
                                </div>
                            </div>
							 <div class="CheckBoxGroupLabel">
                                <div>
                                    <span class="Label">客户portal</span>
                                </div>
                            </div>
							 <div class="Normal Editor CheckBox">
                                <div class="InputField">
                                    <div>
                                        <asp:CheckBox ID="id357" runat="server" />
                                    </div>
                                    <div class="EditorLabelContainer">
                                        <div class="Label">
                                            <label>可以在联系人管理界面添加和修改联系人安全等级</label>
                                        </div>
                                    </div>
                                </div>
                            </div>
							<div class="CheckBoxGroupLabel">
                                <div>
                                    <span class="Label">其他</span>
                                </div>
                            </div>
							 <div class="Normal Editor CheckBox">
                                <div class="InputField">
                                    <div>
                                        <asp:CheckBox ID="id358" runat="server" />
                                    </div>
                                    <div class="EditorLabelContainer">
                                        <div class="Label">
                                            <label>Can access News Feed</label>
                                        </div>
                                    </div>
                                </div>
                            </div>
							 <div class="Normal Editor CheckBox">
                                <div class="InputField">
                                    <div>
                                        <asp:CheckBox ID="id359" runat="server" />
                                    </div>
                                    <div class="EditorLabelContainer">
                                        <div class="Label">
                                            <label>Can access public Team Walls</label>
                                        </div>
                                    </div>
                                </div>
                            </div>
							 <div class="Normal Editor CheckBox">
                                <div class="InputField">
                                    <div>
                                        <asp:CheckBox ID="id360" runat="server" />
                                    </div>
                                    <div class="EditorLabelContainer">
                                        <div class="Label">
                                            <label>Can access all private Team Walls</label>
                                        </div>
                                    </div>
                                </div>
                            </div>
							 <div class="Normal Editor CheckBox">
                                <div class="InputField">
                                    <div>
                                        <asp:CheckBox ID="id361" runat="server" />
                                    </div>
                                    <div class="EditorLabelContainer">
                                        <div class="Label">
                                            <label>Can access Co-Worker profile information(contract & up-posting)</label>
                                        </div>
                                    </div>
                                </div>
                            </div>
							 <div class="Normal Editor CheckBox">
                                <div class="InputField">
                                    <div>
                                        <asp:CheckBox ID="id362" runat="server" />
                                    </div>
                                    <div class="EditorLabelContainer">
                                        <div class="Label">
                                            <label>Can access Global Notes Search</label>
                                        </div>
                                    </div>
                                </div>
                            </div>
							 <div class="Normal Editor CheckBox">
                                <div class="InputField">
                                    <div>
                                        <asp:CheckBox ID="id363" runat="server" />
                                    </div>
                                    <div class="EditorLabelContainer">
                                        <div class="Label">
                                            <label>Can access Knowledgebase - Add, Edit, and Delete permissions are configured per resource on the
Manage Knowledgebase > Security tab
</label>
                                        </div>
                                    </div>
                                </div>
                            </div>
							<div class="Normal Editor CheckBox">
                                <div class="InputField">
                                    <div>
                                        <asp:CheckBox ID="id364" runat="server" />
                                    </div>
                                    <div class="EditorLabelContainer">
                                        <div class="Label">
                                            <label>Can export Grid Data</label>
                                        </div>
                                    </div>
                                </div>
                            </div>
							<div class="Normal Editor CheckBox">
                                <div class="InputField">
                                    <div>
                                        <asp:CheckBox ID="id365" runat="server" />
                                    </div>
                                    <div class="EditorLabelContainer">
                                        <div class="Label">
                                            <label>Can login to Web Services API</label>
                                        </div>
                                    </div>
                                </div>
                            </div>
							<div class="Normal Editor CheckBox">
                                <div class="InputField">
                                    <div>
                                        <asp:CheckBox ID="id366" runat="server" />
                                    </div>
                                    <div class="EditorLabelContainer">
                                        <div class="Label">
                                            <label>Can manage Shared Dashboard Tabs</label>
                                        </div>
                                    </div>
                                </div>
                            </div>
							<div class="Normal Editor CheckBox">
                                <div class="InputField">
                                    <div>
                                        <asp:CheckBox ID="id367" runat="server" />
                                    </div>
                                    <div class="EditorLabelContainer">
                                        <div class="Label">
                                            <label>Can offer Dashboard widgets to other Resources</label>
                                        </div>
                                    </div>
                                </div>
                            </div>
							<div class="Normal Editor CheckBox">
                                <div class="InputField">
                                    <div>
                                        <asp:CheckBox ID="id368" runat="server" />
                                    </div>
                                    <div class="EditorLabelContainer">
                                        <div class="Label">
                                            <label>Can access Executive Dashboard</label>
                                        </div>
                                    </div>
                                </div>
                            </div>	
<div class="Normal Editor CheckBox">
                                <div class="InputField">
                                    <div>
                                        <asp:CheckBox ID="id369" runat="server" />
                                    </div>
                                    <div class="EditorLabelContainer">
                                        <div class="Label">
                                            <label>Can access Billing Portal</label>
                                        </div>
                                    </div>
                                </div>
                            </div>								
</div>
</div>

                </div>
            </div>
        </div>
        <!--第二部分-->
        <div class="TabContainer"></div>
        <!--第三部分-->
        <div class="TabContainer">
            <div class="Grid Small">
                <div class="HeaderContainer">
                    <table cellpadding="0">
                        <tbody>
                            <tr class="HeadingRow">
                                <td class="Command" style="width: 30px;">
                                    <div class="Standard">
                                        <div></div>
                                    </div>
                                </td>
                                <td class="Text Dynamic">
                                    <div class="Standard">
                                        <div class="Heading">Name</div>
                                    </div>
                                </td>
                                <td class="Boolean" style="width: 80px;">
                                    <div class="Standard">
                                        <div class="Heading">Active</div>
                                    </div>
                                </td>
                                <td class="ScrollBarSpacer" style="width: 17px;"></td>
                            </tr>
                        </tbody>
                    </table>
                </div>
                <div class="RowContainer BodyContainer Active" style="top: 23px; bottom: 0;">
                    <table cellpadding="0">
                        <tbody>
                            <tr class="NoDataRow">
                                <td></td>
                                <td></td>
                                <td></td>
                            </tr>
                        </tbody>
                    </table>
                    <div class="ContextOverlayContainer">
                        <div class="ContextOverlay">
                            <div class="Outline Arrow"></div>
                            <div class="Arrow"></div>
                            <div class="Active LoadingIndicator"></div>
                            <div class="Content"></div>
                        </div>
                        <div class="ContextOverlay">
                            <div class="Outline Arrow"></div>
                            <div class="Arrow"></div>
                            <div class="Active LoadingIndicator"></div>
                            <div class="Content"></div>
                        </div>
                    </div>
                    <div class="DragIndicator">
                        <div class="Bar"></div>
                        <div class="LeftArrow"></div>
                        <div class="RightArrow"></div>
                    </div>
                    <div class="DragStatus"></div>
                </div>
                <div class="NoDataMessage Active">There are no records.</div>
            </div>
        </div>
        </div>

    </form>
    <script src="../Scripts/jquery-3.1.0.min.js"></script>
    <script src="../Scripts/SysUserSecurityLevel.js"></script>
    <script type="text/javascript">
        //$(".CONTRACTSALL").click(function () {

            //$(".contractsdown").find("option[value='986']").attr("selected", "selected");
        //});
       // $(".CONTRACTSNO").click(function () {
           // $(".contractsdown").find("option[value='989']").attr("selected",  "selected");
           
        //});
        
    </script>
</body>
</html>
