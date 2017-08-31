<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ContractAdd.aspx.cs" Inherits="EMT.DoneNOW.Web.Contract.ContractAdd" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>合同向导</title>
    <link rel="stylesheet" href="../Content/reset.css"/>
    <link rel="stylesheet" href="../Content/LostOpp.css"/>
</head>
<body>
    <div class="TitleBar">
        <div class="Title">
            <span class="text1">合同向导(<%=contractTypeName %>)</span>
        </div>
    </div>
    <form id="form1" runat="server">
        <!--第零页-->
        <div class="Workspace Workspace0" style="display: none;">
            <div class="PageInstructions">Please provide type information for the new contract. The contract type cannot be changed once the contract is created.</div>
            <div class="WizardSection">
                <table cellspacing="0" cellpadding="0" width="100%">
                    <tbody>
                    <tr height="85%">
                        <td width="90%">
                            <table cellspacing="1" cellpadding="0" width="100%">
                                <tr>
                                    <td class="FieldLabels">
                                        Contract Type
                                        <div style="position:relative; visibility:visible; display:block;width:100%;">
                                            <select name="" style="width:190px;">
                                                <option value="">(Select)</option>
                                                <option value="">Manually</option>
                                                <option value="">On timesheet approval</option>
                                                <option value="">Immediately without review</option>
                                            </select>
                                        </div>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    </tbody>
                </table>
            </div>
            <div class="ButtonBar WizardButtonBar" style="width:97%;">
                <ul>
                    <!--上一层-->
                    <li style="display: none;" id="a0">
                        <a class="ImgLink">
                            <img class="ButtonImg" src="img/move-left.png">
                            <span class="Text">Back</span>
                        </a>
                    </li>
                    <!--下一层-->
                    <li class="right" id="b0">
                        <a class="ImgLink">
                            <span class="Text">Next</span>
                            <img class="ButtonRightImg" src="img/move-right.png">
                        </a>
                    </li>
                    <!--完成-->
                    <li style="display: none;" class="right" id="c0">
                        <a class="ImgLink">
                            <span class="Text">Finish</span>
                        </a>
                    </li>
                    <!--关闭-->
                    <li class="right" style="display: none;" id="d0">
                        <a class="ImgLink">
                            <img class="ButtonRightImg" src="img/cancel.png">
                            <span class="Text">Close</span>
                        </a>
                    </li>
                </ul>
            </div>
        </div>
        <!--第一页-->
        <div class="Workspace Workspace1" style="display: none;">
            <div class="PageInstructions">Please provide information for the new contract. Be certain to include start and end dates for the contract.</div>
            <div class="WizardSection">
                <table cellspacing="0" cellpadding="0" width="100%">
                    <tbody>
                        <tr height="85%">
                            <td width="90%" valign="top">
                                <!--第一页主体-->
                                <table cellspacing="0" cellpadding="0" width="100%" style="min-width: 722px;">
                                    <tbody>
                                        <tr>
                                            <td class="FieldLabels">
                                                公司<span class="errorSmall">*</span>
                                                <div>
                                                    <input type="text" style="width: 278px; margin-right: 4px;">
                                                </div>
                                            </td>
                                            <td class="FieldLabels">
                                                Contract Description
                                                <div>
                                                    <input type="text" style="width: 342px;">
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="FieldLabels">
                                                Company Name<span class="errorSmall">*</span>
                                                <div>
                                                    <input type="text"style="width: 278px;">
                                                    <img src="img/data-selector.png" style="vertical-align: middle;cursor: pointer;">
                                                </div>
                                            </td>
                                            <td class="FieldLabels">
                                                Contract Category
                                                <div>
                                                    <select class="step2LeftSelectWidth" style="width:356px;">
                                                        <option value=""></option>
                                                        <option value="">Need</option>
                                                        <option value="">Timing</option>
                                                        <option value="">Price</option>
                                                        <option value="">Competition</option>
                                                        <option value="">Feature</option>
                                                    </select>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="FieldLabels">
                                                <input type="checkbox" origchecked="true">
                                                <span>Default Service Desk Contract</span>
                                            </td>
                                            <td class="FieldLabels">
                                                <div>
                                                    <table style="padding:0px;margin:0px; border:0px; border-spacing:0px;">
                                                        <tbody>
                                                            <tr>
                                                                <td class="FieldLabels">
                                                                    External Contract Number
                                                                    <br>
                                                                    <input type="text" style="width: 155px;">
                                                                </td>
                                                                <td class="FieldLabels" style=" padding-left :16px;">
                                                                    Purchase Order Number
                                                                    <br>
                                                                    <input type="text" style="width: 156px;">
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                     </table>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="FieldLabels">
                                                Contact Name
                                                <div>
                                                    <select class="step2LeftSelectWidth" style="width:134px;">
                                                        <option value=""></option>
                                                        <option value="">xiaodangjia</option>
                                                        <option value="">asdsa</option>
                                                        <option value="">fgdngjia</option>
                                                    </select>
                                                </div>
                                            </td>
                                            <td class="FieldLabels">
                                                Service Level Agreement
                                                <div>
                                                    <select style="width:356px;">
                                                        <option value=""></option>
                                                        <option value="">asdsad</option>
                                                    </select>
                                                    <img src="img/add.png" style="vertical-align: middle;cursor: pointer;">
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="FieldLabels">
                                                Contract Period Type
                                                <div>
                                                    <select class="step2LeftSelectWidth" style="width:134px;">
                                                        <option value="">mmmm</option>
                                                        <option value="">xiaodangjia</option>
                                                        <option value="">asdsa</option>
                                                        <option value="">fgdngjia</option>
                                                    </select>
                                                </div>
                                            </td>
                                            <td class="FieldLabels">
                                                <div>
                                                    <table style="padding:0px;margin:0px; border:0px; border-spacing:0px;" cellspacing="0" cellpadding="0">
                                                        <tbody>
                                                            <tr>
                                                                <td class="FieldLabels">
                                                                    Setup Fee
                                                                    <div style="width: 88px;padding:0;">
                                                                        <input type="text" value="0.00" style="width: 88px;padding:0;text-align: right;">
                                                                    </div>
                                                                </td>
                                                                <td class="FieldLabels" style="padding-left :16px">
                                                                    Setup Fee Billing Code
                                                                    <div style="padding:0;">
                                                                        <input type="text" disabled style="margin: 2px 0px; width:224px;">
                                                                        <img src="img/add.png" style="vertical-align: middle;cursor: pointer;">
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="FieldLabels">
                                                Start Date<span class="errorSmall">*</span>
                                                <div>
                                                    <input type="text" style="width:120px;" onclick="WdatePicker()" class="Wdate">
                                                </div>
                                            </td>
                                            <td class="CheckboxLabels">
                                                <input type="radio" checked name="rEnd">
                                                <span>End Date</span>
                                                <span class="errorSmall">*</span>
                                                <input type="text" onclick="WdatePicker()" class="Wdate">
                                            </td>
                                        </tr>
                                        <tr>
                                            <td colspan="1"></td>
                                            <td class="CheckboxLabels" style="padding-top:10px">
                                                <input type="radio" name="rEnd">
                                                <span>End After</span>
                                                <span class="errorSmall">*</span>
                                                <input type="text" style="margin-left: 2px;text-align:right;" size="3"> Occurrences
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
            <div class="ButtonBar WizardButtonBar" style="width:97%;">
                <ul>
                    <!--上一层-->
                    <li id="a1">
                        <a class="ImgLink">
                            <img class="ButtonImg" src="img/move-left.png">
                            <span class="Text">Back</span>
                        </a>
                    </li>
                    <!--下一层-->
                    <li class="right" id="b1">
                        <a class="ImgLink">
                            <span class="Text">Next</span>
                            <img class="ButtonRightImg" src="img/move-right.png">
                        </a>
                    </li>
                    <!--完成-->
                    <li class="right" style="display: none;" id="c1">
                        <a class="ImgLink">
                            <span class="Text">Finish</span>
                        </a>
                    </li>
                    <!--关闭-->
                    <li class="right" style="display: none;" id="d1">
                        <a class="ImgLink">
                            <img class="ButtonRightImg" src="img/cancel.png">
                            <span class="Text">Close</span>
                        </a>
                    </li>
                </ul>
            </div>
        </div>
        <!--第二页-->
        <div class="Workspace Workspace2" style="display: none;">
            <div class="PageInstructions">Please provide information for the new contract. Be certain to include start and end dates for the contract.</div>
            <div class="WizardSection">
                <table cellspacing="0" cellpadding="0" width="100%">
                    <tbody>
                    <tr height="85%">
                        <td width="90%" valign="top">
                            <!--第一页主体-->
                            <table cellspacing="0" cellpadding="0" width="100%" style="min-width: 722px;">
                                <tbody>
                                <tr>
                                    <td class="FieldLabels">
                                        公司<span class="errorSmall">*</span>
                                        <div>
                                            <input type="text" style="width: 278px; margin-right: 4px;">
                                        </div>
                                    </td>
                                    <td class="FieldLabels">
                                        Contract Description
                                        <div>
                                            <input type="text" style="width: 342px;">
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="FieldLabels">
                                        Company Name<span class="errorSmall">*</span>
                                        <div>
                                            <input type="text"style="width: 278px;">
                                            <img src="img/data-selector.png" style="vertical-align: middle;cursor: pointer;">
                                        </div>
                                    </td>
                                    <td class="FieldLabels">
                                        Contract Category
                                        <div>
                                            <select class="step2LeftSelectWidth" style="width:356px;">
                                                <option value=""></option>
                                                <option value="">Need</option>
                                                <option value="">Timing</option>
                                                <option value="">Price</option>
                                                <option value="">Competition</option>
                                                <option value="">Feature</option>
                                            </select>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="FieldLabels">
                                        <input type="checkbox" origchecked="true">
                                        <span>Default Service Desk Contract</span>
                                    </td>
                                    <td class="FieldLabels">
                                        <div>
                                            <table style="padding:0px;margin:0px; border:0px; border-spacing:0px;">
                                                <tbody>
                                                <tr>
                                                    <td class="FieldLabels">
                                                        External Contract Number
                                                        <br>
                                                        <input type="text" style="width: 155px;">
                                                    </td>
                                                    <td class="FieldLabels" style=" padding-left :16px;">
                                                        Purchase Order Number
                                                        <br>
                                                        <input type="text" style="width: 156px;">
                                                    </td>
                                                </tr>
                                                </tbody>
                                            </table>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="FieldLabels">
                                        Contact Name
                                        <div>
                                            <select class="step2LeftSelectWidth" style="width:134px;">
                                                <option value=""></option>
                                                <option value="">xiaodangjia</option>
                                                <option value="">asdsa</option>
                                                <option value="">fgdngjia</option>
                                            </select>
                                        </div>
                                    </td>
                                    <td class="FieldLabels">
                                        Service Level Agreement
                                        <div>
                                            <select style="width:356px;">
                                                <option value=""></option>
                                                <option value="">asdsad</option>
                                            </select>
                                            <img src="img/add.png" style="vertical-align: middle;cursor: pointer;">
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="FieldLabels">
                                        Start Date<span class="errorSmall">*</span>
                                        <div>
                                            <input type="text" style="width:120px;" onclick="WdatePicker()" class="Wdate">
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="FieldLabels">
                                        End Date<span class="errorSmall">*</span>
                                        <div>
                                            <input type="text" style="width:120px;" onclick="WdatePicker()" class="Wdate">
                                        </div>
                                    </td>
                                </tr>
                                </tbody>
                            </table>
                        </td>
                    </tr>
                    </tbody>
                </table>
            </div>
            <div class="ButtonBar WizardButtonBar" style="width:97%;">
                <ul>
                    <!--上一层-->
                    <li id="a2">
                        <a class="ImgLink">
                            <img class="ButtonImg" src="img/move-left.png">
                            <span class="Text">Back</span>
                        </a>
                    </li>
                    <!--下一层-->
                    <li class="right" id="b2">
                        <a class="ImgLink">
                            <span class="Text">Next</span>
                            <img class="ButtonRightImg" src="img/move-right.png">
                        </a>
                    </li>
                    <!--完成-->
                    <li class="right" style="display: none;" id="c2">
                        <a class="ImgLink">
                            <span class="Text">Finish</span>
                        </a>
                    </li>
                    <!--关闭-->
                    <li class="right" style="display: none;" id="d2">
                        <a class="ImgLink">
                            <img class="ButtonRightImg" src="img/cancel.png">
                            <span class="Text">Close</span>
                        </a>
                    </li>
                </ul>
            </div>
        </div>
        <!--第三页-->
        <div class="Workspace Workspace3" style="display: none;">
            <div class="PageInstructions" style="font-weight: bold;">USER-DEFINED FIELDS</div>
            <div class="WizardSection">
                <table cellspacing="0" cellpadding="0" width="100%" class="Searchareaborder">
                    <tbody>
                        <tr>
                            <td align="center">
                                <table  cellspacing="1" cellpadding="0" width="100%">
                                    <tbody>
                                        <tr>
                                            <td valign="top" class="FieldLabels">
                                                Test<span class="errorSmall">*</span>
                                                <div>
                                                    <input type="text" style="width:300px;">
                                                </div>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
            <div class="ButtonBar WizardButtonBar" style="width:97%;">
                <ul>
                    <!--上一层-->
                    <li id="a3">
                        <a class="ImgLink">
                            <img class="ButtonImg" src="img/move-left.png">
                            <span class="Text">Back</span>
                        </a>
                    </li>
                    <!--下一层-->
                    <li class="right" id="b3">
                        <a class="ImgLink">
                            <span class="Text">Next</span>
                            <img class="ButtonRightImg" src="img/move-right.png">
                        </a>
                    </li>
                    <!--完成-->
                    <li class="right" style="display: none;" id="c3">
                        <a class="ImgLink">
                            <span class="Text">Finish</span>
                        </a>
                    </li>
                    <!--关闭-->
                    <li class="right" style="display: none;" id="d3">
                        <a class="ImgLink">
                            <img class="ButtonRightImg" src="img/cancel.png">
                            <span class="Text">Close</span>
                        </a>
                    </li>
                </ul>
            </div>
        </div>
        <!--第四页-->
        <div class="Workspace Workspace4" style="display: none;">
            <div class="PageInstructions">Select the services and/or service bundles to include in your recurring contract. You can apply an overall discount to all services/bundles on this contract later by opening the contract and going to the Services page.</div>
            <div class="WizardSection">
                <table cellspacing="0" cellpadding="0" width="100%">
                    <tbody>
                        <tr>
                            <td colspan="9" valign="top">
                                <table cellspacing="0" cellpadding="0" width="100%">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <span class="contentButton">
                                                    <a class="ImgLink">
                                                        <img src="img/add.png" class="ButtonImg">
                                                        <span class="Text">New Service Bundle</span>
                                                    </a>
                                                </span>
                                                 <span class="contentButton">
                                                    <a class="ImgLink">
                                                        <img src="img/add.png" class="ButtonImg">
                                                        <span class="Text">New Service</span>
                                                    </a>
                                                </span>
                                            </td>
                                        </tr>
                                        <tr height="10px;"></tr>
                                        <tr>
                                            <td colspan="1" id="txtBlack8">
                                                这是个iframe海哥可自己加
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </td>
                        </tr>
                        <tr height="10px;"></tr>
                        <tr width="100%">
                            <td width="90%;" colspan="8" align="right">
                                <span class="FieldLabels">Average Monthly Billing Price</span>
                            </td>
                            <td class="FieldLabels" width="10%" style="padding-right:15px;">
                                <div style="width:130px;height: 24px; padding:0 0 0 10px;">
                                    <input type="text" value="0.00" style="text-align: right;">
                                </div>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
            <div class="ButtonBar WizardButtonBar" style="width:97%;">
                <ul>
                    <!--上一层-->
                    <li id="a4">
                        <a class="ImgLink">
                            <img class="ButtonImg" src="img/move-left.png">
                            <span class="Text">Back</span>
                        </a>
                    </li>
                    <!--下一层-->
                    <li class="right" id="b4">
                        <a class="ImgLink">
                            <span class="Text">Next</span>
                            <img class="ButtonRightImg" src="img/move-right.png">
                        </a>
                    </li>
                    <!--完成-->
                    <li class="right" style="display: none;" id="c4">
                        <a class="ImgLink">
                            <span class="Text">Finish</span>
                        </a>
                    </li>
                    <!--关闭-->
                    <li class="right" style="display: none;" id="d4">
                        <a class="ImgLink">
                            <img class="ButtonRightImg" src="img/cancel.png">
                            <span class="Text">Close</span>
                        </a>
                    </li>
                </ul>
            </div>
        </div>
        <!--第五页-->
        <div class="Workspace Workspace5" style="display: none;">
            <div class="PageInstructions">Please provide time reporting information for the new contract.</div>
            <div class="WizardSection">
                <table cellspacing="0" cellpadding="0" width="100%">
                    <tbody>
                        <tr height="85%">
                            <td width="90%">
                                <table cellspacing="1" cellpadding="0" width="100%">
                                    <tr>
                                        <td class="FieldLabels">
                                            Approve & Post Labour<span class="errorSmall">*</span>
                                            <div style="position:relative; visibility:visible; display:block;width:100%;">
                                                <select name="" id="" style="width:190px;">
                                                    <option value="">(Select)</option>
                                                    <option value="">Manually</option>
                                                    <option value="">On timesheet approval</option>
                                                    <option value="">Immediately without review</option>
                                                </select>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <div>
                                                <input type="checkbox" style="vertical-align: middle;">
                                                <span class="CheckboxLabels">Time reporting requires start and stop times</span>
                                            </div>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
            <div class="ButtonBar WizardButtonBar" style="width:97%;">
                <ul>
                    <!--上一层-->
                    <li id="a5">
                        <a class="ImgLink">
                            <img class="ButtonImg" src="img/move-left.png">
                            <span class="Text">Back</span>
                        </a>
                    </li>
                    <!--下一层-->
                    <li class="right" id="b5">
                        <a class="ImgLink">
                            <span class="Text">Next</span>
                            <img class="ButtonRightImg" src="img/move-right.png">
                        </a>
                    </li>
                    <!--完成-->
                    <li style="display: none;" class="right" id="c5">
                        <a class="ImgLink">
                            <span class="Text">Finish</span>
                        </a>
                    </li>
                    <!--关闭-->
                    <li class="right" style="display: none;" id="d5">
                        <a class="ImgLink">
                            <img class="ButtonRightImg" src="img/cancel.png">
                            <span class="Text">Close</span>
                        </a>
                    </li>
                </ul>
            </div>
        </div>
        <!--第六页-->
        <div class="Workspace Workspace6" style="display: none;">
            <div class="PageInstructions">By default, all roles will use the default billing rate. To override a role’s rate, check the role’s checkbox and enter the contract rate. To “lock in" a role’s current default rate for this contract, simply check that role’s checkbox. You can modify the contract rates later, if necessary.</div>
            <div class="WizardSection">
                <table cellspacing="0" cellpadding="0" width="100%">
                    <tbody>
                    <tr height="85%">
                        <td width="90%">
                            <div class="grid NoPagination">
                                <table cellspacing="1" cellpadding="0" width="100%">
                                    <thead>
                                        <tr>
                                            <td style="width:20px; text-align:center;">
                                                <input type="checkbox" style="vertical-align: middle;">
                                            </td>
                                            <td>Role Name</td>
                                            <td align="right">Role Hourly Billing Rate</td>
                                            <td align="right">Contract Hourly Billing Rate</td>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr>
                                            <td style="width:20px; text-align:center;">
                                                <input type="checkbox" style="vertical-align: middle;">
                                            </td>
                                            <td>Emergency Technician</td>
                                            <td align="right">
                                                <input type="text" size="5" value="50.00" disabled style="width: 97%;text-align: right;">
                                            </td>
                                            <td align="right">
                                                <input type="text" size="5" value="50.00" style="text-align: right;">
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="width:20px; text-align:center;">
                                                <input type="checkbox" style="vertical-align: middle;">
                                            </td>
                                            <td>Help Desk</td>
                                            <td align="right">
                                                <input type="text" size="5" value="150.00" disabled style="width: 97%;text-align: right;">
                                            </td>
                                            <td align="right">
                                                <input type="text" size="5" value="150.00" style="text-align: right;">
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="width:20px; text-align:center;">
                                                <input type="checkbox" style="vertical-align: middle;">
                                            </td>
                                            <td>Administration</td>
                                            <td align="right">
                                                <input type="text" size="5" value="250.00" disabled style="width: 97%;text-align: right;">
                                            </td>
                                            <td align="right">
                                                <input type="text" size="5" value="250.00" style="text-align: right;">
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                        </td>
                    </tr>
                    </tbody>
                </table>
            </div>
            <div class="ButtonBar WizardButtonBar" style="width:97%;">
                <ul>
                    <!--上一层-->
                    <li id="a6">
                        <a class="ImgLink">
                            <img class="ButtonImg" src="img/move-left.png">
                            <span class="Text">Back</span>
                        </a>
                    </li>
                    <!--下一层-->
                    <li class="right" id="b6">
                        <a class="ImgLink">
                            <span class="Text">Next</span>
                            <img class="ButtonRightImg" src="img/move-right.png">
                        </a>
                    </li>
                    <!--完成-->
                    <li style="display: none;" class="right" id="c6">
                        <a class="ImgLink">
                            <span class="Text">Finish</span>
                        </a>
                    </li>
                    <!--关闭-->
                    <li class="right" style="display: none;" id="d6">
                        <a class="ImgLink">
                            <img class="ButtonRightImg" src="img/cancel.png">
                            <span class="Text">Close</span>
                        </a>
                    </li>
                </ul>
            </div>
        </div>
        <!--第七页-->
        <div class="Workspace Workspace7" style="display: none;">
            <div class="PageInstructions">Please provide milestone information for the new contract.</div>
            <div class="WizardSection">
                <div style="position:relative;">
                    <div style="position:absolute;top:0px;left:0px;width:100%;">
                        <table width="100%" cellspacing="0" cellpadding="0" border="0">
                            <tbody>
                                <tr>
                                    <td colspan="2">
                                        <div style="height:400px;width:100%;"></div>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <table width="100%" cellspacing="0" cellpadding="0" border="0" style="padding-top:10px;">
                                            <tbody>
                                                <tr>
                                                    <td class="FieldLabels" align="right">
                                                        Estimated Revenue
                                                    </td>
                                                    <td align="left" style="padding-left:3px;">
                                                        <b>
                                                            <span>¥0.00</span>
                                                        </b>
                                                    </td>
                                                    <td class="FieldLabels" align="right">
                                                        Milestone Total
                                                    </td>
                                                    <td align="left" style="padding-left:3px;">
                                                        <b>
                                                            <span>¥0.00</span>
                                                        </b>
                                                    </td>
                                                    <td align="right">
                                                        <div class="ButtonContainer">
                                                            <ul>
                                                                <li class="Button ButtonIcon NormalState" id="AddButton" tabindex="0">
                                                                    <span class="Icon Add"></span>
                                                                    <span class="Text">新增</span>
                                                                </li>
                                                            </ul>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </tbody>
                                        </table>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                    <div style="position:absolute;top:0px;left:0px;">
                        <table width="100%" cellspacing="0" cellpadding="0" border="0">
                            <tbody>
                                <tr>
                                    <td class="FieldLabels" colspan="5">
                                        Name<span class="errorSmall">*</span>
                                        <div>
                                            <input type="text" style="width:100%;">
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="FieldLabels">
                                        Amount
                                        <div>
                                            <input type="text" style="width:80px;" value="0.00">
                                        </div>
                                    </td>
                                    <td width="30px"></td>
                                    <td class="FieldLabels">
                                        Billing Code Name
                                        <div>
                                            <input type="text" style="width:200px;" disabled>
                                            <a class="DataSelectorLinkIcon">
                                                <img src="img/data-selector.png" style="vertical-align: middle;">
                                            </a>
                                        </div>
                                    </td>
                                    <td width="10px"></td>
                                    <td class="FieldLabels">
                                        Due Date<span class="errorSmall">*</span>
                                        <div>
                                            <input type="text" style="width:90px;" onclick="WdatePicker()" class="Wdate">
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <div>
                                            <input type="checkbox">
                                            <span>Ready to Bill</span>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="FieldLabels" colspan="5">
                                        Description
                                        <div>
                                            <textarea rows="7" style="width:100%;"></textarea>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <div class="ButtonContainer">
                                            <ul>
                                                <li class="Button ButtonIcon Okey NormalState" id="OkButton" tabindex="0">
                                                    <span class="Icon Ok"></span>
                                                    <span class="Text">确认</span>
                                                </li>
                                                <li class="Button ButtonIcon Cancel NormalState" id="CancelButton" tabindex="0">
                                                    <span class="Icon Cancel"></span>
                                                    <span class="Text">取消</span>
                                                </li>
                                            </ul>
                                        </div>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
            <div class="ButtonBar WizardButtonBar" style="width:97%;">
                <ul>
                    <!--上一层-->
                    <li id="a7">
                        <a class="ImgLink">
                            <img class="ButtonImg" src="img/move-left.png">
                            <span class="Text">Back</span>
                        </a>
                    </li>
                    <!--下一层-->
                    <li class="right" id="b7">
                        <a class="ImgLink">
                            <span class="Text">Next</span>
                            <img class="ButtonRightImg" src="img/move-right.png">
                        </a>
                    </li>
                    <!--完成-->
                    <li style="display: none;" class="right" id="c7">
                        <a class="ImgLink">
                            <span class="Text">Finish</span>
                        </a>
                    </li>
                    <!--关闭-->
                    <li class="right" style="display: none;" id="d7">
                        <a class="ImgLink">
                            <img class="ButtonRightImg" src="img/cancel.png">
                            <span class="Text">Close</span>
                        </a>
                    </li>
                </ul>
            </div>
        </div>
        <!--第八页-->
        <div class="Workspace Workspace8" style="display: none;">
            <div class="PageInstructions">Select the people you would like to notify and create a message for this notification. Use "Other Email Addresses" field if you have a distribution list; for example, distribution@yourcompany.com.</div>
            <div class="WizardSection">
                <table cellspacing="0" cellpadding="0" width="100%">
                    <tbody>
                        <tr>
                            <td width="50%" valign="top">
                                <table cellspacing="0" cellpadding="0" width="90%">
                                    <tr>
                                        <td class="sectionBluebg">
                                            Resources
                                            <span style="font-weight: normal;">
                                                <a class="PrimaryLink">(Load)</a>
                                            </span>
                                            <div>
                                                <textarea style="width:99%;height:300px;border:1px solid silver;" rows="12"></textarea>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="FieldLabels">
                                            Other Email Addresses
                                            <span class="FieldLevelInstructions">
                                                (separate with a semi-colon)
                                            </span>
                                            <div style="margin-bottom:8px;">
                                                <input type="text" style="width: 100%">
                                            </div>
                                            <div>
                                                <input type="checkbox">
                                                <span style="cursor:pointer;" class="CheckboxLabels">Territory Team</span>
                                            </div>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                            <td width="50%" valign="top">
                                <table cellspacing="0" cellpadding="0" width="90%">
                                    <tbody>
                                        <tr>
                                            <td class="FieldLabels">
                                                Subject
                                                <div style="padding-right: 10px;">
                                                    <input type="text" style="width:99%;" value="Created Contract">
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="FieldLabels">
                                                Message
                                                <div style="padding-right: 10px;">
                                                    <textarea style="width: 99%; height: 291px;" rows="12"></textarea>
                                                </div>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
            <div class="ButtonBar WizardButtonBar" style="width:97%;">
                <ul>
                    <!--上一层-->
                    <li id="a8">
                        <a class="ImgLink">
                            <img class="ButtonImg" src="img/move-left.png">
                            <span class="Text">Back</span>
                        </a>
                    </li>
                    <!--下一层-->
                    <li style="display: none;" class="right" id="b8">
                        <a class="ImgLink">
                            <span class="Text">Next</span>
                            <img class="ButtonRightImg" src="img/move-right.png">
                        </a>
                    </li>
                    <!--完成-->
                    <li class="right" id="c8">
                        <a class="ImgLink">
                            <span class="Text">Finish</span>
                        </a>
                    </li>
                    <!--关闭-->
                    <li style="display: none;" class="right" id="d8">
                        <a class="ImgLink">
                            <img class="ButtonRightImg" src="img/cancel.png">
                            <span class="Text">Close</span>
                        </a>
                    </li>
                </ul>
            </div>
        </div>
        <!--第九页-->
        <div class="Workspace Workspace9" style="display: none;">
            <div class="PageInstructions">The Wizard has finished. What would you like to do next?</div>
            <div class="WizardSection">
                <table cellspacing="0" cellpadding="0" width="100%">
                    <tbody>
                    <tr height="85%">
                        <td width="90%">
                            Contract being created... please wait.
                        </td>
                    </tr>
                    </tbody>
                </table>
            </div>
            <div class="ButtonBar WizardButtonBar" style="width:97%;">
                <ul>
                    <!--上一层-->
                    <li style="display: none;" id="a9">
                        <a class="ImgLink">
                            <img class="ButtonImg" src="img/move-left.png">
                            <span class="Text">Back</span>
                        </a>
                    </li>
                    <!--下一层-->
                    <li style="display: none;" class="right" id="b9">
                        <a class="ImgLink">
                            <span class="Text">Next</span>
                            <img class="ButtonRightImg" src="img/move-right.png">
                        </a>
                    </li>
                    <!--完成-->
                    <li style="display: none;" class="right" id="c9">
                        <a class="ImgLink">
                            <span class="Text">Finish</span>
                        </a>
                    </li>
                    <!--关闭-->
                    <li class="right" id="d9">
                        <a class="ImgLink">
                            <img class="ButtonRightImg" src="img/cancel.png">
                            <span class="Text">Close</span>
                        </a>
                    </li>
                </ul>
            </div>
        </div>
    </form>
    <script type="text/javascript" src="../Scripts/jquery-3.1.0.min.js"></script>
    <script type="text/javascript" src="../Scripts/ContractWizard.js"></script>
    <script type="text/javascript" src="../Scripts/My97DatePicker/WdatePicker.js"></script>
</body>
</html>
