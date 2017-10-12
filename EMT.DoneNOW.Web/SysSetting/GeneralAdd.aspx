<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="GeneralAdd.aspx.cs" Inherits="EMT.DoneNOW.Web.GeneralAdd" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
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
                     <li id="newicon" style="display:none"><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -48px 0;" class="icon-1"></i>
                <asp:Button ID="Save_New" OnClientClick="return save_deal()" runat="server" Text="保存并新建" BorderStyle="None" OnClick="Save_New_Click" Visible="False"/>
            </li>
                    <li><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -96px 0;" class="icon-1"></i>
                        <asp:Button ID="Cancel" OnClientClick="window.close();" runat="server" Text="取消" BorderStyle="None" />
                    </li>
                </ul>
            </div>
            <div class="DivSection" style="border: none; padding-left: 0;">
                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tbody>
                        <tr>
                            <td width="30%" class="FieldLabels">名称
                        <span class="errorSmall">*</span>
                                <div>
                                    <asp:TextBox ID="Name" runat="server"></asp:TextBox>
                                </div>
                            </td>
                        </tr>
                    <%if (type ==(long)EMT.DoneNOW.DTO.QueryType.Project_Status||type == (long)EMT.DoneNOW.DTO.QueryType.Task_Type||type == (long)EMT.DoneNOW.DTO.QueryType.Payment_Term||type ==(long)EMT.DoneNOW.DTO.QueryType.Payment_Type||type ==(long)EMT.DoneNOW.DTO.QueryType.Payment_Ship_Type)
                            { %>
                        <tr>
                            <td width="30%" class="FieldLabels">
                                <div>
                                    <asp:CheckBox ID="Active" runat="server" />
                                    激活
                                </div>
                            </td>
                        </tr>
                        <%} %>    
                        <%if (type == (long)EMT.DoneNOW.DTO.QueryType.Line_Of_Business||type == (long)EMT.DoneNOW.DTO.QueryType.Task_Type||type == (long)EMT.DoneNOW.DTO.QueryType.Payment_Term||type ==(long)EMT.DoneNOW.DTO.QueryType.Payment_Type||type ==(long)EMT.DoneNOW.DTO.QueryType.Payment_Ship_Type)
                            { %>
                        <tr>
                            <td width="30%" class="FieldLabels">描述
                        <div>
                            <asp:TextBox ID="Description" runat="server" Height="90px" Width="300px" TextMode="MultiLine"></asp:TextBox>
                        </div>
                            </td>
                        </tr>
                        <%} %>                                           
                        <% if (type == (long)EMT.DoneNOW.DTO.QueryType.Line_Of_Business||type == (long)EMT.DoneNOW.DTO.QueryType.Task_Type)
                            {%>
                        <tr>
                            <td width="30%" class="FieldLabels">排序号
                        <span class="errorSmall">*</span>
                                <div>
                                    <asp:TextBox ID="Sort" runat="server"></asp:TextBox>
                                </div>
                            </td>
                        </tr>
                        <%} %>
                         <% if (type == (long)EMT.DoneNOW.DTO.QueryType.Payment_Term)
                            {%>
                        <tr>
                            <td width="30%" class="FieldLabels">付款期限(天数)
                        <span class="errorSmall">*</span>
                                <div>
                                    <asp:TextBox ID="termday" runat="server"></asp:TextBox>
                                </div>
                            </td>
                        </tr>
                        <%} %>
                         <%if (type ==(long)EMT.DoneNOW.DTO.QueryType.Payment_Type)
                            { %>
                        <tr>
                            <td width="30%" class="FieldLabels">
                                <div>
                                    <asp:CheckBox ID="Reimbursable" runat="server" />
                                   Reimbursable 
                                </div>
                            </td>
                        </tr>
                        <%} %>
                         <%if (type ==(long)EMT.DoneNOW.DTO.QueryType.Payment_Ship_Type)
                            { %>
                        <tr>
                            <td width="30%" class="FieldLabels">
                                物料成本
                                <div>
                                    <asp:DropDownList ID="Cost_Code" runat="server" Visible="false"></asp:DropDownList>                                  
                                </div>
                            </td>
                        </tr>
                        <%} %>

                    </tbody>
                </table>
            </div>
        </div>
        <script src="../Scripts/jquery-3.1.0.min.js"></script>
    <script src="../Scripts/SysSettingRoles.js"></script>
        <script>
            $("#Sort").change(function () {
            if ((/^\d{1,3}\.?\d{0,2}$/.test(this.value)) == false)
            {
                alert('请输入数字！');
                this.value =<%=general.sort_order%>;
                this.focus();
                return false;
            }
            var f = Math.round(this.value * 100) / 100;
            var s = f.toString();
            var rs = s.indexOf('.');
            if (rs < 0) {
                rs = s.length;
                s += '.';
            }
            while (s.length <= rs + 2) {
                s += '0';
            }
            if (s.length > 6) {
                alert('您输入的数字过大，只可以输入三位整数！');
                this.value =<%=general.sort_order%>;
                this.focus();
                return false;
            }
            });
            $("#termday").change(function () {
                if ((/^\d{1,3}$/.test(this.value)) == false) {
                    alert('请输入1-3位数字！');
                    this.value =<%=general.ext1%>;
                this.focus();
                return false;
                 }
            });
            </script>
    </form>        
</body>
</html>
