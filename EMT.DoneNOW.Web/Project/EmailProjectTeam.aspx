<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="EmailProjectTeam.aspx.cs" Inherits="EMT.DoneNOW.Web.Project.EmailProjectTeam" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>通知团队和成员</title>
    <link href="../Content/DynamicContent.css" rel="stylesheet" />
    <style>
        body {
            font-size: 12px;
            overflow: auto;
            background: white;
            left: 0;
            top: 0;
            position: relative;
            margin: 0;
        }

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

        td {
            font-size: 12px;
        }

        #save_close, #save_new {
            border-style: none;
            background-color: #dddddd;
            background: linear-gradient(to bottom,#fff 0,#d7d7d7 100%);
        }
        .Required{
            color:red;
        }
        .Section .Column.Normal > .Editor.DateBox input, .Section .Column.Normal > .Editor.DecimalBox input, .Section .Column.Normal > .Editor.IntegerBox input, .Section .Column.Normal > .Editor.LongIntegerBox input, .Section .Column.Normal > .Editor.PercentageBox input, .Section .Column.Normal > .Editor.TimeBox input {
    width: 25px;
}
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="HeaderRow">
            <table>
                <tr>
                    <td><span>通知项目团队</span></td>
                    <td class="helpLink" style="text-align: right;"><a class="HelperLinkIcon">
                        <img src="/images/icons/context_help.png?v=41154" border="0" /></a></td>
                </tr>
            </table>
        </div>
        <div class="ButtonBar">
            <ul>
                <li><a class="ImgLink" id="HREF_btnSaveClose" name="HREF_btnSaveClose">
                    <span class="icon" style="background: url(../Images/ButtonBarIcons.png) no-repeat -32px 0; width: 16px; height: 16px; display: inline-block; margin: -2px 3px; margin-top: 3px;"></span><span class="Text">
                        <asp:Button ID="send" runat="server" Text="发送" OnClick="send_Click" /></span></a></li>
                <li style="margin-left: 20px;"><a class="ImgLink" id="HREF_btnCancel" name="HREF_btnCancel" title="Cancel">
                    <span class="icon" style="background: url(../Images/ButtonBarIcons.png) no-repeat -96px 0; width: 16px; height: 16px; display: inline-block; margin: -2px 3px; margin-top: 3px;"></span>
                    <span class="Text">取消</span></a></li>
            </ul>
        </div>
        <div style="left: 10px; overflow-x: auto; overflow-y: auto; position: fixed; right: 0; bottom: 0; top: 85px;">
            <div class="Normal Section">
                <div class="Content">
                    <div class="Normal Column">
                        <div class="EditorLabelContainer">
                            <div class="Label">
                                <label for="DailyCapacity">发出</label><span class="Required">*</span>
                            </div>
                        </div>
                        <div class="Editor DecimalBox" data-editor-id="DailyCapacity" data-rdp="DailyCapacity">
                            <div class="InputField">
                                <input id="fromEmail" type="text" value="<%=LoginUser.email %>" name="fromEmail" disabled="disabled" style="width:404px;" />
                            </div>
                        </div>
                          <div class="EditorLabelContainer">
                            <div class="Label">
                                <label for="DailyCapacity">主题</label><span class="Required">*</span>
                            </div>
                        </div>
                        <div class="Editor DecimalBox" data-editor-id="DailyCapacity" data-rdp="DailyCapacity">
                            <div class="InputField">
                                <input id="subject" type="text" value="" name="subject"  style="width:404px;"  />
                            </div>
                        </div>
                          <div class="EditorLabelContainer">
                            <div class="Label">
                                <label for="DailyCapacity">团队</label><span class="Required">*</span>
                            </div>
                        </div>
                        <div class="Editor DecimalBox" data-editor-id="DailyCapacity" data-rdp="DailyCapacity">
                            <div class="InputField">
                                <div style="float:left;">
                                    <asp:RadioButton ID="clinet" runat="server" GroupName="team" Width="25px" /> <span style="cursor:pointer;color:#333333;" >客户联系人</span>
                                </div>
                                <div style="float:left;">
                                <asp:RadioButton ID="interna" runat="server" GroupName="team" Width="25px"/> <span style="cursor:pointer;color:#333333;" >内部员工</span> </div>
                                 <div style="float:left;">
                                <asp:RadioButton ID="both" runat="server" GroupName="team" Width="25px"/> <span style="cursor:pointer;color:#333333;" >全部成员</span></div>
                            </div>
                        </div>
                         <div class="EditorLabelContainer">
                            <div class="Label">
                                <label for="DailyCapacity">内容</label><span class="Required">*</span>
                            </div>
                        </div>
                        <div class="Editor DecimalBox" data-editor-id="DailyCapacity" data-rdp="DailyCapacity">
                            <div class="InputField">
                                <textarea style="width:100%" rows="13" name="message" id="message"></textarea>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </form>
</body>
</html>
<script src="../Scripts/jquery-3.1.0.min.js"></script>
<script src="../Scripts/common.js"></script>
<script>
    $("#send").click(function () {

        var subject = $("#subject").val();
        if (subject == "") {
            LayerMsg("请填写主题");
            return false;
        }

        var clinet = $("#clinet").is(":checked");
        var internal = $("#interna").is(":checked");
        var both = $("#both").is(":checked");
        if ((!clinet) && (!internal) && (!both)) {
            LayerMsg("请选择发送团队");
            return false;
        }

        var message = $("#message").val();
        if (message == "") {
            LayerMsg("请填写内容");
            return false;
        }
    })

</script>
