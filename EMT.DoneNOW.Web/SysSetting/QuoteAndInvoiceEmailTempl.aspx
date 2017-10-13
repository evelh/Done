<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="QuoteAndInvoiceEmailTempl.aspx.cs" Inherits="EMT.DoneNOW.Web.QuoteAndInvoiceEmailTempl" %>
<%--发票和报价的邮件模板--%>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <link href="../Content/reset.css" rel="stylesheet" />
    <link href="../Content/SysSettingRoles.css" rel="stylesheet" />
    <style>
        .header-title {
            width: 100%;
            margin: 10px;
            width: auto;
            height: 30px;
        }

            .header-title ul li {
                position: relative;
                height: 30px;
                line-height: 30px;
                padding: 0 10px;
                float: left;
                margin-right: 10px;
                border: 1px solid #CCCCCC;
                cursor: pointer;
                background: linear-gradient(to bottom,#fff 0,#d7d7d7 100%);
            }

                .header-title ul li input {
                    height: 28px;
                    line-height: 28px;
                }

                .header-title ul li:hover ul {
                    display: block;
                }

                .header-title ul li .icon-1 {
                    width: 16px;
                    height: 16px;
                    display: block;
                    float: left;
                    margin-top: 7px;
                    margin-right: 5px;
                }

                .header-title ul li ul {
                    display: none;
                    position: absolute;
                    left: -1px;
                    top: 28px;
                    border: 1px solid #CCCCCC;
                    background: #F5F5F5;
                    width: 160px;
                    padding: 10px 0;
                    z-index: 99;
                }

                    .header-title ul li ul li {
                        float: none;
                        border: none;
                        background: #F5F5F5;
                        height: 28px;
                        line-height: 28px;
                    }

                .header-title ul li input {
                    outline: none;
                    border: none;
                    background: linear-gradient(to bottom,#fff 0,#d7d7d7 100%);
                }

        .icon-1 {
            width: 16px;
            height: 16px;
            display: block;
            float: left;
            margin-top: 7px;
            margin-right: 5px;
        }
    </style>
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <!--顶部-->
            <div class="TitleBar">
                <div class="Title">
                    <span class="text1"><%=typename %></span>
                    <a href="###" class="help"></a>
                </div>
            </div>
            <!--按钮-->
            <div class="ButtonContainer header-title">
                <ul id="btn">
                    <li><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -32px 0;" class="icon-1"></i>
                        <asp:Button ID="Save_Close" OnClientClick="return save_deal()" runat="server" Text="保存并关闭" BorderStyle="None" OnClick="Save_Close_Click" />
                    </li>
                    <li><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -96px 0;" class="icon-1"></i>
                        <asp:Button ID="Cancel" OnClientClick="window.close();" runat="server" Text="取消" BorderStyle="None" />
                    </li>
                </ul>
            </div>


            名称
            <asp:TextBox ID="Name" runat="server"></asp:TextBox>
            描述
            <asp:TextBox ID="Description" runat="server"></asp:TextBox>
            激活
            <asp:CheckBox ID="Active" runat="server" />激活
            <asp:CheckBox ID="AttachPdf" runat="server" />Attach quote as PDF
            发送者-姓
            <asp:TextBox ID="SendFromFirstName" runat="server"></asp:TextBox>
            发送者-名
            <asp:TextBox ID="SendFromLastName" runat="server"></asp:TextBox>
            发送者-邮箱
            <asp:TextBox ID="SendFromEmail" runat="server"></asp:TextBox>
            CC
             <asp:TextBox ID="CC" runat="server"></asp:TextBox>
            BCC
            <asp:TextBox ID="BCC" runat="server"></asp:TextBox>
            Bcc Account Manager
            <asp:CheckBox ID="BccAccountManager" runat="server"></asp:CheckBox>
            Email Subject
            <asp:TextBox ID="Email_Subject" runat="server"></asp:TextBox>
            Email Format
            <asp:RadioButton ID="Html" runat="server" ValidationGroup="email_format" />HTML
            <asp:RadioButton ID="PlainText" runat="server" ValidationGroup="email_format" />PLAIN TEXT
            Body部分的内容
            <asp:TextBox ID="ContentText" runat="server"></asp:TextBox>



            <br />
            下拉框
           <asp:ScriptManager ID="ScriptManager1" runat="server">
         </asp:ScriptManager>
         <asp:UpdatePanel ID="UpdatePanel2" runat="server" ChildrenAsTriggers="True">
             <ContentTemplate>
              <asp:DropDownList ID="AlertVariableFilter" runat="server" OnSelectedIndexChanged="AlertVariableFilter_SelectedIndexChanged" AutoPostBack="True"></asp:DropDownList>              
                 <select name="" multiple="multiple" id="AlertVariableList">
                         <asp:Literal ID="VariableList" runat="server"></asp:Literal>
                    </select>
             </ContentTemplate>
         </asp:UpdatePanel>  

        </div>
    </form>
</body>
</html>
