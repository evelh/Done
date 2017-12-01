<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ExpenseDetail.aspx.cs" Inherits="EMT.DoneNOW.Web.Project.ExpenseDetail" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>费用详情</title>
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

        .ExpenseDetail {
            padding: 10px;
            width: 100%;
        }

            .ExpenseDetail table {
                width: 100%;
            }

                .ExpenseDetail table .LeftTd {
                    width: 150px;
                    white-space: nowrap;
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
    </style>
</head>
<body>
    <form id="form1" runat="server">
           <div class="HeaderRow">
            <table>
                <tr>
                    <td><span>费用详情</span></td>
                    <td class="helpLink" style="text-align: right;"><a class="HelperLinkIcon">
                        <img src="/images/icons/context_help.png?v=41154" border="0" /></a></td>
                </tr>
            </table>
        </div>
        <div class="ButtonBar">
            <ul> 
                  <li><a class="ImgLink" id="HREF_btnCancel" name="HREF_btnCancel" title="Cancel">
                    <span class="icon" style="background: url(../Images/ButtonBarIcons.png) no-repeat -96px 0; width: 16px; height: 16px; display: inline-block; margin: -2px 3px; margin-top: 3px;"></span>
                    <span class="Text">取消</span></a></li>
            </ul>
        </div>
        <div class="ExpenseDetail">
		<table>
			<tbody><tr>
				<td class="LeftTd FieldLabels">
					创建人
				</td>
				<td>
					<span id="ctl00_mainContent_CreatedByLabel" class="Label">
                        <%if (thisExp != null) {
                                var thisRes = new EMT.DoneNOW.DAL.sys_resource_dal().FindNoDeleteById(thisExp.create_user_id);
                                %>
                        <%=thisRes!=null?thisRes.name:"" %>

                        <%} %>
					</span>
				</td>
			</tr>
			<tr>
				<td class="LeftTd FieldLabels">
					费用日期
				</td>
				<td>
					<span id="ctl00_mainContent_DateLabel" class="Label"><%=thisExp!=null?thisExp.add_date.ToString("yyyy-MM-dd"):"" %></span>
				</td>
			</tr>
			<tr>
				<td class="LeftTd FieldLabels">
					费用类别
				</td>
				<td>
					<span id="ctl00_mainContent_CategoryLabel" class="Label">
                        <%
                            var gDal = new EMT.DoneNOW.DAL.d_general_dal();
                            var dgDal = new EMT.DoneNOW.DAL.d_cost_code_dal();
                            %>

                        <%if (thisExp != null) {
                                var thisCate = dgDal.FindNoDeleteById(thisExp.expense_cost_code_id);
                                %>
                        <%=thisCate!=null?thisCate.name:"" %>
                        <%} %>
					</span>
				</td>
			</tr>
			<tr>
				<td class="LeftTd FieldLabels">
					工作类型
				</td>
				<td>
					<span id="ctl00_mainContent_WorkTypeLabel" class="Label">
                          <%if (thisExp != null&&thisExp.cost_code_id!=null) {
                                var thisType = dgDal.FindNoDeleteById((long)thisExp.cost_code_id);
                                %>
                        <%=thisType!=null?thisType.name:"" %>
                        <%} %>
					</span>
				</td>
			</tr>
			<tr>
				<td class="LeftTd FieldLabels">
					描述
				</td>
				<td>
					<span id="ctl00_mainContent_DescriptionLabel" class="Label"><%=thisExp!=null?thisExp.description:"" %></span>
				</td>
			</tr>
			<%--<tr>
				<td class="LeftTd FieldLabels">
					Currency
				</td>
				<td>
					<span id="ctl00_mainContent_CurrencyLabel" class="Label">USD</span>
				</td>
			</tr>--%>
			<tr>
				<td class="LeftTd FieldLabels">
					收据总额
				</td>
				<td>
					<span id="ctl00_mainContent_AmountLabel" class="Label"><%=thisExp!=null?thisExp.amount.ToString("#0.00"):"" %></span>
				</td>
			</tr>
			<tr>
				<td class="LeftTd FieldLabels">
					待报销
				</td>
				<td>
					<span id="ctl00_mainContent_ToBeReimbursedLabel" class="Label"><%=thisExp!=null?thisExp.amount.ToString("#0.00"):"" %></span>
				</td>
			</tr>
			<tr>
				<td class="LeftTd FieldLabels">
					付款类型
				</td>
				<td>
					<span id="ctl00_mainContent_PaymentTypeLabel" class="Label">
                        <% if (thisExp != null)
                            {
                                var thisWork = gDal.FindNoDeleteById(thisExp.payment_type_id);
                                %>
                        <%=thisWork!=null?thisWork.name:"" %>
                        <%} %>

					</span>
				</td>
			</tr>
			<tr>
				<td class="LeftTd FieldLabels">
					有收据
				</td>
				<td>
					<span id="ctl00_mainContent_ReceiptLabel" class="Label"><%=thisExp!=null?thisExp.has_receipt==1?"有":"没有":"" %></span>
				</td>
			</tr>
			<tr>
				<td class="LeftTd FieldLabels">
					计费
				</td>
				<td>
					<span id="ctl00_mainContent_BillableLabel" class="Label"><%=thisExp!=null?thisExp.is_billable==1?"是":"否":"" %></span>
				</td>
			</tr>
			<tr>
				<td class="LeftTd FieldLabels">
					已计费
				</td>
				<td>
					<span id="ctl00_mainContent_BilledLabel" class="Label"><%=thisExp!=null?thisExp.approve_and_post_date!=null&&thisExp.approve_and_post_user_id!=null?"是":"否":"" %></span>
				</td>
			</tr>
		</tbody></table>
	</div>
    </form>
</body>
</html>
<script src="../Scripts/jquery-3.1.0.min.js"></script>
