<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="WorkType.aspx.cs" Inherits="EMT.DoneNOW.Web.SysSetting.WorkType" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <link href="../Content/reset.css" rel="stylesheet" />
    <link href="../Content/WorkType.css" rel="stylesheet" />
    <title>工作类型</title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
             <!--顶部-->
    <div class="TitleBar">
        <div class="Title">
            <span class="text1">新的工作类型</span>
            <a href="###" class="help"></a>
        </div>
    </div>
    <!--按钮-->
    <div class="ButtonContainer">
        <ul id="btn">
            <li class="Button ButtonIcon NormalState" id="SaveAndCloneButton" tabindex="0">
                <span class="Icon SaveAndClone"></span>
                <span class="Text">保存并关闭</span>
            </li>
            <li class="Button ButtonIcon NormalState" id="SaveAndNewButton" tabindex="0">
                <span class="Icon SaveAndNew"></span>
                <span class="Text">保存并新建</span>
            </li>
            <li class="Button ButtonIcon NormalState" id="CancelButton" tabindex="0">
                <span class="Icon Cancel"></span>
                <span class="Text">取消</span>
            </li>
        </ul>
    </div>
    <!--内容-->
    <div class="DivScrollingContainer General">
        <div class="DivSectionWithHeader">
            <div class="HeaderRow">
                <span>General Information</span>
            </div>
            <div class="Content">
                <table width="100%">
                    <tbody>
                        <tr>
                            <td align="left" style="width: 120px">
                                <span class="lblNormalClass">Name</span>
                                <span class="errorSmallClass">*</span>
                                <div>
                                    <span style="display: inline-block">
                                        <input type="text" style="width:300px;" class="txtBlack8Class">
                                    </span>
                                    <span class="FieldLabel">
                                        <span class="txtBlack8Class">
                                            <input type="checkbox" style="vertical-align:middle;" checked>
                                            <label>Active</label>
                                        </span>
                                    </span>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td align="left">
                                <span class="lblNormalClass">Department</span>
                                <div>
                                    <span style="display: inline-block">
                                        <select class="txtBlack8Class" style="width:314px;">
                                            <option value=""></option>
                                            <option value="" selected>sadsad</option>
                                            <option value="">fdgfdg</option>
                                        </select>
                                    </span>
                                </div>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
        <div class="DivSectionWithHeader">
            <div class="HeaderRow">
                <span>BILLING/ACCOUNTING</span>
            </div>
            <div class="Content">
                <table width="100%">
                    <tbody>
                        <tr>
                            <td align="left" style="width: 120px">
                                <span class="lblNormalClass">External Number</span>
                                <div>
                                    <span style="display: inline-block">
                                        <input type="text" style="width:300px;" class="txtBlack8Class">
                                    </span>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td align="left">
                                <span class="lblNormalClass">General Ledger Account</span>
                                <div>
                                    <span style="display: inline-block">
                                        <select class="txtBlack8Class" style="width:314px;">
                                            <option value=""></option>
                                            <option value="" selected>sadsad</option>
                                            <option value="">fdgfdg</option>
                                        </select>
                                    </span>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td align="left">
                                <span class="lblNormalClass">General Ledger Account</span>
                                <div>
                                    <span style="display: inline-block">
                                        <select class="txtBlack8Class" style="width:314px;">
                                            <option value=""></option>
                                            <option value="" selected>sadsad</option>
                                            <option value="">fdgfdg</option>
                                        </select>
                                    </span>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <span class="FieldLabel">
                                    <span class="txtBlack8Class">
                                        <input type="checkbox" style="vertical-align:middle;">
                                        <label style="vertical-align:middle;">Excluded from New Contracts</label>
                                    </span>
                                </span>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
        <div class="DivSectionWithHeader">
            <div class="HeaderRow">
                <span>BILLING RATE AND HOURS MODIFIERS</span>
            </div>
            <div class="Content">
                <table width="100%" style="border-spacing: 0px;">
                    <tbody>
                        <tr>
                            <td align="left" style="width: 247px;">
                                <span class="lblNormalClass">Billing Method</span>
                            </td>
                            <td></td>
                        </tr>
                        <tr style="height: 28px">
                            <td align="left">
                                <span class="FieldLabel">
                                    <span>
                                        <input type="radio" checked="checked" name="BillingMethod">
                                        <label>Use Role Rate</label>
                                    </span>
                                </span>
                            </td>
                            <td></td>
                        </tr>
                        <tr style="height: 28px">
                            <td align="left">
                                <span class="FieldLabel">
                                    <span>
                                        <input type="radio" name="BillingMethod">
                                        <label>Use Role Rate adjusted by (+/-):</label>
                                    </span>
                                </span>
                            </td>
                            <td>
                                <span class="FieldLabel">
									¥
                                    <span>
                                        <input type="text" style="text-align:right;" class="txtBlack8Class" disabled>
                                    </span>
                                </span>
                            </td>
                        </tr>
                        <tr style="height: 28px">
                            <td align="left">
                                <span class="FieldLabel">
                                    <span>
                                        <input type="radio" name="BillingMethod">
                                        <label>Use Role Rate multiplied by:</label>
                                    </span>
                                </span>
                            </td>
                            <td>
                                <span class="FieldLabel">
                                    <span style="margin-left: 10px;">
                                        <input type="text" style="text-align:right;" class="txtBlack8Class" disabled value="1.00">
                                    </span>
                                </span>
                            </td>
                        </tr>
                        <tr>
                            <td align="left" style="padding-left: 20px;">
                                <span class="FieldLevelInstruction">
								    Note: this multiplier will also be used in block hour calculations
                                </span>
                            </td>
                        </tr>
                        <tr style="height: 28px">
                            <td align="left">
                                <span class="FieldLabel">
                                    <span>
                                        <input type="radio" name="BillingMethod">
                                        <label>Use Custom Rate:</label>
                                    </span>
                                </span>
                            </td>
                            <td>
                                <span class="FieldLabel">
									¥
                                    <span>
                                        <input type="text" style="text-align:right;" class="txtBlack8Class" disabled>
                                    </span>
                                </span>
                            </td>
                        </tr>
                        <tr style="height: 28px">
                            <td align="left">
                                <span class="FieldLabel">
                                    <span>
                                        <input type="radio" name="BillingMethod">
                                        <label>Use Flat Rate (per time entry):</label>
                                    </span>
                                </span>
                            </td>
                            <td>
                                <span class="FieldLabel">
									¥
                                    <span>
                                        <input type="text" style="text-align:right;" class="txtBlack8Class" disabled>
                                    </span>
                                </span>
                            </td>
                        </tr>
                        <tr>
                            <td style="height:20px;"></td>
                            <td></td>
                        </tr>
                        <tr style="height: 28px">
                            <td align="left">
                                <span class="FieldLabel">
                                    <span>
                                        <input type="checkbox" name="neverBillLessThanCheckBox:ATCheckBox">
                                        <label>Never Bill Less than</label>
                                    </span>
                                </span>
                            </td>
                            <td>
                                <span class="FieldLabel">
                                    <span style="margin-left: 10px;">
                                        <input type="text" style="text-align:right;" class="txtBlack8Class" disabled>
                                    </span>
								    Hours
                                </span>
                            </td>
                        </tr>
                        <tr style="height: 28px">
                            <td align="left">
                                <span class="FieldLabel">
                                    <span>
                                        <input type="checkbox" name="neverBillLessThanCheckBox:ATCheckBox">
                                        <label>Never Bill More than</label>
                                    </span>
                                </span>
                            </td>
                            <td>
                                <span class="FieldLabel">
                                    <span style="margin-left: 10px;">
                                        <input type="text" style="text-align:right;" class="txtBlack8Class" disabled>
                                    </span>
                                    Hours
                                </span>
                            </td>
                        </tr>
                        <tr>
                            <td style="height:20px;"></td>
                            <td></td>
                        </tr>
                        <tr>
                            <td align="left" colspan="2" class="BillableRadioList">
                                <span class="FieldLabel">
                                    <table>
                                        <tbody>
                                            <tr>
                                                <td>
                                                    <input type="radio" name="billableRadioButtonList" checked="checked">
                                                    <label>Non-Billable - Do not show on invoice</label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <input type="radio" name="billableRadioButtonList">
                                                    <label>Non-Billable - Show on invoice as "No charge"</label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <input type="radio" name="billableRadioButtonList">
                                                    <label>Billable</label>
                                                </td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </span>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
        </div>
    </form>
    <script src="../Scripts/jquery-3.1.0.min.js"></script>
     <script src="../Scripts/WorkType.js"></script>
</body>
</html>
