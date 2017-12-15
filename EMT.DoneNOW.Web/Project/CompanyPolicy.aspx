<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="CompanyPolicy.aspx.cs" Inherits="EMT.DoneNOW.Web.Project.CompanyPolicy" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>客户策略</title>
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
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="workspace">
            <div class="HeaderRow">
                <table>
                    <tbody>
                        <tr>
                            <td><span>客户策略</span></td>
                        </tr>
                    </tbody>
                </table>
            </div>
            <div class="ButtonBar">
                <ul>
                    <li><a class="ImgLink" id="HREF_btnClose" name="HREF_btnClose" title="Close">
                        <span class="icon" style="background: url(../Images/ButtonBarIcons.png) no-repeat -96px 0; width: 16px; height: 16px; display: inline-block; margin: -2px 3px; margin-top: 3px;"></span>
                        <span class="Text">关闭</span></a><span></span>

                    </li>
                </ul>
            </div>
            <div style="top: 82px; width: 98%;" align="center" class="DivScrollingContainer">
             <iframe runat="server" id="AccountPolicy" name="AccountPolicy" style="width:100%;height:500px;border-width:0px;">

             </iframe>

                <input type="hidden" id="thisRuleId" name="thisRuleId" value="<%=thisRule!=null?thisRule.id.ToString():"" %>"/>
            </div>
        </div>
    </form>
</body>
</html>
<script src="../Scripts/jquery-3.1.0.min.js"></script>
<script>
    $("#HREF_btnClose").click(function () {
        window.close();
    })
</script>
