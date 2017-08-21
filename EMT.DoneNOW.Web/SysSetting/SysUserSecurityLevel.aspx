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
                    <span class="Icon Save"></span>
                    <span class="Text">保存&关闭</span>
                </li>
                <li class="Button Cancel" id="CancelButton" tabindex="0">
                    <span class="Icon CancelButton"></span>
                    <span class="Text">取消</span>
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
                                    <label>Name</label>
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
                                        <input type="checkbox" checked="checked" /></div>
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
                        <span class="Text">Module Access</span>
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
                        <span class="Text">Contracts</span>
                        <span class="Right">
                            <span class="Text">Permission:</span>
                            <a class="Button ButtonIcon Link NormalState Full" tabindex="0">Full</a>
                            <span class="VerticalSeparator"></span>
                            <a class="Button ButtonIcon Link NormalState Empty" tabindex="0">None</a>
                        </span>
                    </div>
                    <div class="Content">
                        <div class="Large Column">
                            <div class="Normal Editor CheckBox">
                                <div class="InputField">
                                    <div>
                                        <asp:CheckBox ID="id1_check" runat="server" />
                                    </div>
                                    <div class="EditorLabelContainer">
                                        <div class="Label">
                                            <label>Can modify contract Internal Costs</label>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="Normal Editor CheckBox">
                                <div class="InputField">
                                    <div>
                                        <asp:CheckBox ID="id2_check" runat="server" />

                                    </div>
                                    <div class="EditorLabelContainer">
                                        <div class="Label">
                                            <label>Can modify Service/Bundle on contract charges</label>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="Normal Editor CheckBox">
                                <div class="InputField">
                                    <div>
                                        <asp:CheckBox ID="id3_check" runat="server" />
                                    </div>
                                    <div class="EditorLabelContainer">
                                        <div class="Label">
                                            <label>Can create invoices from Ticket and Won Quote Wizard</label>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="CustomLayoutContainer">
                                <div class="Edit_DropdownHeader">
                                    <div class="Edit_DropdownLabel">Can Approve & Post</div>
                                    <div>
                                        <asp:DropDownList ID="id4" runat="server"></asp:DropDownList>
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
                            <span class="Text">Permission:</span>
                            <a class="Button ButtonIcon Link NormalState Full" tabindex="0">Full</a>
                            <span class="VerticalSeparator"></span>
                            <a class="Button ButtonIcon Link NormalState Empty" tabindex="0">None</a>
                        </span>
                    </div>
                    <div class="Content">
                        <div class="Large Column">
                            <div class="CustomLayoutContainer">
                                <div class="Edit_LayoutBlock">
                                    <div class="Edit_TableTitle">Company & Contact Access</div>
                                    <div class="Edit_LayoutTable">
                                        <div class="Edit_TableHeaderRow"></div>
                                        <div class="Edit_Tablebody">
                                            <div class="Edit_TableBodyRow">
                                                <div class="Edit_FourCells Edit_RightBorder">Customer & Cancelation</div>
                                                <div class="Edit_OneCells">
                                                    <asp:DropDownList ID="id51" runat="server"></asp:DropDownList>
                                                </div>
                                            </div>
                                            <div class="Edit_TableBodyRow">
                                                <div class="Edit_FourCells Edit_RightBorder">Vendor & Partners</div>
                                                <div class="Edit_OneCells">
                                                    <asp:DropDownList ID="id52" runat="server"></asp:DropDownList>
                                                </div>
                                            </div>
                                            <div class="Edit_TableBodyRow">
                                                <div class="Edit_FourCells Edit_RightBorder">Prospects, Leads, & Dead</div>
                                                <div class="Edit_OneCells">
                                                    <asp:DropDownList ID="id53" runat="server"></asp:DropDownList>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="Edit_TableBottomRow"></div>
                                    </div>
                                    <div class="Edit_TableBottomDescription">The "Mine" setting for companies allows the user to see all companies where they are the account manager or a member of the account team.  The "My Territories" setting also includes "Mine".</div>
                                </div>
                                <div class="Edit_LayoutBlock">
                                    <div class="Edit_TableTitle">Object Permissions</div>
                                    <div class="Edit_TableTitleAnnotion">(for companies you have access to)</div>
                                    <div class="Edit_LayoutTable">
                                        <div class="Edit_TableHeaderRow">
                                            <div class="Edit_TwoCells Edit_RightBorder">Object</div>
                                            <div class="Edit_OneCells Edit_RightBorder">View</div>
                                            <div class="Edit_OneCells Edit_RightBorder">Add</div>
                                            <div class="Edit_OneCells Edit_RightBorder">Edit</div>
                                            <div class="Edit_OneCells">Delete</div>
                                        </div>
                                        <div class="Edit_Tablebody">
                                            <div class="Edit_TableBodyRow">
                                                <div class="Edit_TwoCells Edit_RightBorder">Companies</div>
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
                                                <div class="Edit_TwoCells Edit_RightBorder">Opportunities & Quotes</div>
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
                                                <div class="Edit_TwoCells Edit_RightBorder">Sales Orders</div>
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
                                                <div class="Edit_TwoCells Edit_RightBorder">Configuration Items & Subscriptions</div>
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
                                                <div class="Edit_TwoCells Edit_RightBorder">Notes</div>
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
                                                <div class="Edit_TwoCells Edit_RightBorder">To-Dos</div>
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
                                            <div class="Edit_TwoCells Edit_RightBorder">Attachments</div>
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
                                <div class="Edit_TableBottomDescription">The "Mine" setting for the "Companies: "Edit" and "Delete" permissions will also give the user Edit and Delete permissions for companies in their territories if they have the "My Territories" or "All" Company Access/Availability setting.</div>
                            </div>
                        </div>
                        <div class="CheckBoxGroupContainer">
                            <div class="CheckBoxGroupLabel">
                                <div>
                                    <span class="Label">Feature Access</span>
                                </div>
                            </div>
                            <div class="Normal Editor CheckBox">
                                <div class="InputField">
                                    <div>
                                        <asp:CheckBox ID="id79" runat="server" />

                                    </div>
                                    <div class="EditorLabelContainer">
                                        <div class="Label">
                                            <label>Contact Group Manager</label>
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
                                            <label>Reports > Export</label>
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
                                            <label>Device Discovery Wizard</label>
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
                                            <label>Can Manage Quote Templates and Quote Email Messages Outside of Admin</label>
                                        </div>
                                    </div>
                                </div>
                            </div>

                        </div>
                        <div class="CheckBoxGroupContainer">
                            <div class="CheckBoxGroupLabel">
                                <div>
                                    <span class="Label">Other Permissions</span>
                                </div>
                            </div>
                            <div class="Normal Editor CheckBox">
                                <div class="InputField">
                                    <div>
                                        <asp:CheckBox ID="id83" runat="server" />
                                    </div>
                                    <div class="EditorLabelContainer">
                                        <div class="Label">
                                            <label>Can modify Account Manager (reassign Companies)</label>
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
                                            <label>Can modify Opportunity Owner (reassign Opportunities)</label>
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
                                            <label>Display ALL companies in company pick lists and data selectors</label>
                                            <div class="SecondaryText">
                                                When checked, resources will be able to create and search items associated with companies that they do not have permission to view.
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="CustomLayoutContainer">
                            <div class="Edit_DropdownHeader">
                                <div class="Edit_DropdownLabel">Dashboard Display</div>
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
                    <span class="Text">Inventory</span>
                    <span class="Right">
                        <span class="Text">Permission:</span>
                        <a class="Button ButtonIcon Link NormalState" tabindex="0">Full</a>
                        <span class="VerticalSeparator"></span>
                        <a class="Button ButtonIcon Link NormalState" tabindex="0">None</a>
                    </span>
                </div>
                <div class="Content">
                        <div class="Large Column">
                            <div class="CustomLayoutContainer">
                                <div class="Edit_LayoutBlock">
                                    <div class="Edit_TableTitle">Object Permissions</div>
                                    <div class="Edit_TableTitleAnnotion"></div>
                                    <div class="Edit_LayoutTable">
                                        <div class="Edit_TableHeaderRow">
                                            <div class="Edit_TwoCells Edit_RightBorder">Object</div>
                                            <div class="Edit_OneCells Edit_RightBorder">View</div>
                                            <div class="Edit_OneCells Edit_RightBorder">Add</div>
                                            <div class="Edit_OneCells Edit_RightBorder">Edit</div>
                                            <div class="Edit_OneCells">Delete</div>
                                        </div>
                                        <div class="Edit_Tablebody">
                                            <div class="Edit_TableBodyRow">
                                                <div class="Edit_TwoCells Edit_RightBorder">Inventory Locations</div>
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
                                                <div class="Edit_TwoCells Edit_RightBorder">Items</div>
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
                                                <div class="Edit_TwoCells Edit_RightBorder">Products</div>
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
                                                <div class="Edit_TwoCells Edit_RightBorder">Purchase Orders</div>
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
                                        <span class="Label">Feature Access</span>
                                    </div>
                                </div>
                                <div class="Normal Editor CheckBox">
                                    <div class="InputField">
                                        <div>
										<asp:CheckBox ID="id113" runat="server" />
										</div>
                                        <div class="EditorLabelContainer">
                                            <div class="Label">
                                                <label>Approve/Reject Items</label>
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
                                                <label>Receive Items</label>
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
                                                <label>Deliver/Ship Items</label>
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
                                                <label>Transfer Items</label>
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
                    <span class="Text">Projects</span>
                    <span class="Right">
                        <span class="Text">Permission:</span>
                        <a class="Button ButtonIcon Link NormalState" tabindex="0">Full</a>
                        <span class="VerticalSeparator"></span>
                        <a class="Button ButtonIcon Link NormalState" tabindex="0">None</a>
                    </span>
                </div>
<div class="Content">
                        <div class="Large Column">
                            <div class="CustomLayoutContainer">
                                <div class="Edit_LayoutBlock">
                                    <div class="Edit_TableTitle">Permission Per Project Type</div>
                                    <div class="Edit_TableTitleAnnotion">To specify which projects a user can view in searches, reports, and on their Dashboard (Projects and Executive), assign a View value. Users who can view a project can also edit or delete it. To allow or restrict someone from creating a project, set the Add value.</div>
                                    <div class="Edit_LayoutTable">
                                        <div class="Edit_TableHeaderRow">
                                            <div class="Edit_TwoCells Edit_RightBorder">Project Type</div>
                                            <div class="Edit_OneCells Edit_RightBorder">View</div>
                                            <div class="Edit_OneCells Edit_RightBorder">Add</div>
                                        </div>
                                        <div class="Edit_Tablebody">
                                            <div class="Edit_TableBodyRow">
                                                <div class="Edit_TwoCells Edit_RightBorder">Client & Internal</div>
                                                 <div class="Edit_OneCells Edit_RightBorder Edit_Narrow">
                                                   <asp:DropDownList ID="id151" runat="server"></asp:DropDownList>
                                                </div>
                                                <div class="Edit_OneCells Edit_RightBorder Edit_Narrow">
                                                   <asp:DropDownList ID="id152" runat="server"></asp:DropDownList>
                                                </div>                                 
                                           </div>
										   <div class="Edit_TableBodyRow">
                                                <div class="Edit_TwoCells Edit_RightBorder">Proposals</div>
                                                 <div class="Edit_OneCells Edit_RightBorder Edit_Narrow">
                                                   <asp:DropDownList ID="id153" runat="server"></asp:DropDownList>
                                                </div>
                                                <div class="Edit_OneCells Edit_RightBorder Edit_Narrow">
                                                   <asp:DropDownList ID="id154" runat="server"></asp:DropDownList>
                                                </div>                                 
                                           </div>
                                            <div class="Edit_TableBodyRow">
                                                <div class="Edit_TwoCells Edit_RightBorder">Project Templates</div>
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
								 <div class="Edit_TableBottomDescription">The "Mine" setting for the "Companies: "Edit" and "Delete" permissions will also give the user Edit and Delete permissions for companies in their territories if they have the "My Territories" or "All" Company Access/Availability setting.</div>
                            </div>
							</div>
                            <div class="CheckBoxGroupContainer">
                                <div class="CheckBoxGroupLabel">
                                    <div>
                                        <span class="Label">Time Entry Permissions</span>
                                    </div>
                                </div>
                                <div class="Normal Editor CheckBox">
                                    <div class="InputField">
                                        <div>
										<asp:CheckBox ID="id157" runat="server" />
										</div>
                                        <div class="EditorLabelContainer">
                                            <div class="Label">
                                                <label>Can modify Contract on task and issue time entries</label>
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
                                                <label>Can modify Non-Billable setting on task and issue time entries</label>
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
                                                <label>Can modify Show on Invoice setting on task and issue time entries</label>
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
                                                <label>Can modify Work Type on task and issue time entries</label>
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
                                                <label>Can modify Service/Bundle on task/issue time entries and project charges</label>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
							<div class="CustomLayoutContainer">
                                <div class="Edit_DropdownHeader">
                                    <div class="Edit_DropdownLabel">Can enter time on</div>
                                        <asp:DropDownList ID="id162" runat="server"></asp:DropDownList>
                                </div>
                            </div>					
                             <div class="CheckBoxGroupContainer">
                                <div class="CheckBoxGroupLabel">
                                    <div>
                                        <span class="Label">Other Permissions</span>
                                    </div>
                                </div>
                                <div class="Normal Editor CheckBox">
                                    <div class="InputField">
                                        <div>
										<asp:CheckBox ID="id163" runat="server" />
										</div>
                                        <div class="EditorLabelContainer">
                                            <div class="Label">
                                                <label>Can view internal Cost data (in Projects module)</label>
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
                    <span class="Text">Contracts</span>
                    <span class="Right">
                        <span class="Text">Permission:</span>
                        <a class="Button ButtonIcon Link NormalState" tabindex="0">Full</a>
                        <span class="VerticalSeparator"></span>
                        <a class="Button ButtonIcon Link NormalState" tabindex="0">None</a>
                    </span>
                </div>
                <div class="Content"></div>
            </div>
            <div class="Section Collapsed">
                <div class="Heading">
                    <div class="Toggle Expand Toggle6">
                        <div class="Vertical"></div>
                        <div class="Horizontal"></div>
                    </div>
                    <span class="Text">Contracts</span>
                    <span class="Right">
                        <span class="Text">Permission:</span>
                        <a class="Button ButtonIcon Link NormalState" tabindex="0">Full</a>
                        <span class="VerticalSeparator"></span>
                        <a class="Button ButtonIcon Link NormalState" tabindex="0">None</a>
                    </span>
                </div>
                <div class="Content"></div>
            </div>
            <div class="Section Collapsed">
                <div class="Heading">
                    <div class="Toggle Expand Toggle7">
                        <div class="Vertical"></div>
                        <div class="Horizontal"></div>
                    </div>
                    <span class="Text">Contracts</span>
                    <span class="Right">
                        <span class="Text">Permission:</span>
                        <a class="Button ButtonIcon Link NormalState" tabindex="0">Full</a>
                        <span class="VerticalSeparator"></span>
                        <a class="Button ButtonIcon Link NormalState" tabindex="0">None</a>
                    </span>
                </div>
                <div class="Content"></div>
            </div>
            <div class="Section Collapsed">
                <div class="Heading">
                    <div class="Toggle Expand Toggle8">
                        <div class="Vertical"></div>
                        <div class="Horizontal"></div>
                    </div>
                    <span class="Text">Contracts</span>
                    <span class="Right">
                        <span class="Text">Permission:</span>
                        <a class="Button ButtonIcon Link NormalState" tabindex="0">Full</a>
                        <span class="VerticalSeparator"></span>
                        <a class="Button ButtonIcon Link NormalState" tabindex="0">None</a>
                    </span>
                </div>
                <div class="Content"></div>
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
</body>
</html>
