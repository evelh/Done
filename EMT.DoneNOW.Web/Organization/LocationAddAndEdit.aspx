<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="LocationAddAndEdit.aspx.cs" Inherits="EMT.DoneNOW.Web.LocationAddAndEdit" %>

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
                    <span class="text1">操作名称</span>
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
                        <asp:Button ID="Cancel" runat="server" Text="取消" BorderStyle="None" OnClick="Cancel_Click" />
                    </li>
                </ul>
            </div>
                <!--切换按钮-->
    <div class="TabBar">
        <a class="Button ButtonIcon SelectedState">
            <span class="Text">一般的</span>
        </a>
        <a class="Button ButtonIcon">
            <span class="Text">小时</span>
        </a>
    </div>
    <!--切换项-->
    <div class="TabContainer">
        <div style="left: 0;overflow-x: auto;overflow-y: auto;position: fixed;right: 0;bottom: 0;top:110px;">
        <div class="DivSection" style="border:none;padding-left:0;">
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tbody>
                    <tr>
                        <td width="30%" class="FieldLabels">
                            区域名称
                            <span class="errorSmall">*</span>
                            <div>
                                <input type="text" style="width:250px;" value="Administration">
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td width="30%" class="FieldLabels">
                            地址1
                            <div>
                                <input type="text" style="width:250px;">
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td width="30%" class="FieldLabels">
                            地址2
                            <div>
                                <input type="text" style="width:250px;">
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td width="30%" class="FieldLabels">
                            城市
                            <div>
                                <input type="text" style="width:250px;">
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td width="30%" class="FieldLabels">
                            状态
                            <div>
                                <input type="text" style="width:250px;">
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td width="30%" class="FieldLabels">
                            邮政编码
                            <div>
                                <input type="text" style="width:250px;">
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td class="FieldLabels">
                            国家
                            <div>
                                <select style="width: 264px;">
                                    <option value="">中国</option>
                                    <option value="">美国</option>
                                    <option value="">俄罗斯</option>
                                </select>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td width="30%" class="FieldLabels">
                            额外的地址信息
                            <div>
                                <input type="text" style="width:250px;">
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td class="FieldLabels">
                            一周的第一天
                            <span class="errorSmall">*</span>
                            <div>
                                <select style="width: 264px;">
                                    <option value="">星期一</option>
                                    <option value="">星期天</option>
                                </select>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td class="FieldLabels">
                            日期格式
                            <span class="errorSmall">*</span>
                            <div>
                                <select style="width: 264px;">
                                    <option value="">selection</option>
                                    <option value="">dd/mm/yyy</option>
                                    <option value="">dd.mm.yyy</option>
                                </select>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td class="FieldLabels">
                            时间格式
                            <span class="errorSmall">*</span>
                            <div>
                                <select style="width: 264px;">
                                    <option value="">selection</option>
                                    <option value="">h:mm a</option>
                                    <option value="">hh:mm a</option>
                                    <option value="">HH:mm</option>
                                </select>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td class="FieldLabels">
                            数字格式
                            <span class="errorSmall">*</span>
                            <div>
                                <select style="width: 264px;">
                                    <option value="">selection</option>
                                    <option value="">x.xxx.xx</option>
                                    <option value="">X.XXX.XX</option>
                                </select>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td class="FieldLabels">
                            时区
                            <span class="errorSmall">*</span>
                            <div>
                                <select style="width: 264px;">
                                    <option value="">selection</option>
                                    <option value="">东八区</option>
                                    <option value="">东九区</option>
                                </select>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td class="FieldLabels">
                            假期设置
                            <span class="errorSmall">*</span>
                            <div>
                                <select style="width: 264px;vertical-align: middle;">
                                    <option value="">selection</option>
                                    <option value="">holiday</option>
                                    <option value="">东九区</option>
                                </select><img src="../Images/add.png" style="vertical-align: middle;"/>
                            </div>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
        </div>
    </div>
    <div class="TabContainer" style="display: none;">
        <div style="left: 0;overflow-x: auto;overflow-y: auto;position: fixed;right: 0;bottom: 0;top:116px;">
            <div style="margin: 12px 10px;">
                <span style="font-size: 12px;color: #666;line-height: 16px;">
		            Configure the business-hours for this location for each day of the week.
	            </span>
            </div>
            <table width="100%" border="0" cellspacing="0" cellpadding="3">
                <tbody>
                    <tr>
                        <td style="padding-left:10px;padding-right:10px;">
                            <div class="grid">
                                <table width="100%" border="0" cellspacing="0" cellpadding="3">
                                    <thead>
                                        <tr height="21">
                                            <td>
                                                每周的每天
                                            </td>
                                            <td>
                                                营业时间开始
                                            </td>
                                            <td>
                                                营业时间结束
                                            </td>
                                            <td>
                                                延长时间开始
                                            </td>
                                            <td>
                                                延长时间结束
                                            </td>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr class="dataGridBody">
                                            <td style="font-weight: normal;">星期一</td>
                                            <td style="font-weight: normal;">
                                                <input type="text" style="width: 50px;">
                                                <img src="../Images/time.png" style="vertical-align: middle;" class="time">
                                            </td>
                                            <td style="font-weight: normal;">
                                                <input type="text" style="width: 50px;">
                                                <img src="../Images/time.png" style="vertical-align: middle;" class="time">
                                            </td>
                                            <td style="font-weight: normal;">
                                                <input type="text" style="width: 50px;">
                                                <img src="../Images/time.png" style="vertical-align: middle;" class="time">
                                            </td>
                                            <td style="font-weight: normal;">
                                                <input type="text" style="width: 50px;">
                                                <img src="../Images/time.png" style="vertical-align: middle;" class="time">
                                            </td>
                                        </tr>
                                        <tr class="dataGridBody">
                                            <td style="font-weight: normal;">星期二</td>
                                            <td style="font-weight: normal;">
                                                <input type="text" style="width: 50px;">
                                                <img src="../Images/time.png" style="vertical-align: middle;" class="time">
                                            </td>
                                            <td style="font-weight: normal;">
                                                <input type="text" style="width: 50px;">
                                                <img src="../Images/time.png" style="vertical-align: middle;" class="time">
                                            </td>
                                            <td style="font-weight: normal;">
                                                <input type="text" style="width: 50px;">
                                                <img src="../Images/time.png" style="vertical-align: middle;" class="time">
                                            </td>
                                            <td style="font-weight: normal;">
                                                <input type="text" style="width: 50px;">
                                                <img src="../Images/time.png" style="vertical-align: middle;" class="time">
                                            </td>
                                        </tr>
                                        <tr class="dataGridBody">
                                            <td style="font-weight: normal;">星期三</td>
                                            <td style="font-weight: normal;">
                                                <input type="text" style="width: 50px;">
                                                <img src="../Images/time.png" style="vertical-align: middle;" class="time">
                                            </td>
                                            <td style="font-weight: normal;">
                                                <input type="text" style="width: 50px;">
                                                <img src="../Images/time.png" style="vertical-align: middle;" class="time">
                                            </td>
                                            <td style="font-weight: normal;">
                                                <input type="text" style="width: 50px;">
                                                <img src="../Images/time.png" style="vertical-align: middle;" class="time">
                                            </td>
                                            <td style="font-weight: normal;">
                                                <input type="text" style="width: 50px;">
                                                <img src="../Images/time.png" style="vertical-align: middle;" class="time">
                                            </td>
                                        </tr>
                                        <tr class="dataGridBody">
                                            <td style="font-weight: normal;">星期四</td>
                                            <td style="font-weight: normal;">
                                                <input type="text" style="width: 50px;">
                                                <img src="../Images/time.png" style="vertical-align: middle;" class="time">
                                            </td>
                                            <td style="font-weight: normal;">
                                                <input type="text" style="width: 50px;">
                                                <img src="../Images/time.png" style="vertical-align: middle;" class="time">
                                            </td>
                                            <td style="font-weight: normal;">
                                                <input type="text" style="width: 50px;">
                                                <img src="../Images/time.png" style="vertical-align: middle;" class="time">
                                            </td>
                                            <td style="font-weight: normal;">
                                                <input type="text" style="width: 50px;">
                                                <img src="../Images/time.png" style="vertical-align: middle;" class="time">
                                            </td>
                                        </tr>
                                        <tr class="dataGridBody">
                                            <td style="font-weight: normal;">星期五</td>
                                            <td style="font-weight: normal;">
                                                <input type="text" style="width: 50px;">
                                                <img src="../Images/time.png" style="vertical-align: middle;" class="time">
                                            </td>
                                            <td style="font-weight: normal;">
                                                <input type="text" style="width: 50px;">
                                                <img src="../Images/time.png" style="vertical-align: middle;" class="time">
                                            </td>
                                            <td style="font-weight: normal;">
                                                <input type="text" style="width: 50px;">
                                                <img src="../Images/time.png" style="vertical-align: middle;" class="time">
                                            </td>
                                            <td style="font-weight: normal;">
                                                <input type="text" style="width: 50px;">
                                                <img src="../Images/time.png" style="vertical-align: middle;" class="time">
                                            </td>
                                        </tr>
                                        <tr class="dataGridBody">
                                            <td style="font-weight: normal;">星期六</td>
                                            <td style="font-weight: normal;">
                                                <input type="text" style="width: 50px;">
                                                <img src="../Images/time.png" style="vertical-align: middle;" class="time">
                                            </td>
                                            <td style="font-weight: normal;">
                                                <input type="text" style="width: 50px;">
                                                <img src="../Images/time.png" style="vertical-align: middle;" class="time">
                                            </td>
                                            <td style="font-weight: normal;">
                                                <input type="text" style="width: 50px;">
                                                <img src="../Images/time.png" style="vertical-align: middle;" class="time">
                                            </td>
                                            <td style="font-weight: normal;">
                                                <input type="text" style="width: 50px;">
                                                <img src="../Images/time.png" style="vertical-align: middle;" class="time">
                                            </td>
                                        </tr>
                                        <tr class="dataGridBody">
                                            <td style="font-weight: normal;">星期日</td>
                                            <td style="font-weight: normal;">
                                                <input type="text" style="width: 50px;">
                                                <img src="../Images/time.png" style="vertical-align: middle;" class="time">
                                            </td>
                                            <td style="font-weight: normal;">
                                                <input type="text" style="width: 50px;">
                                                <img src="../Images/time.png" style="vertical-align: middle;" class="time">
                                            </td>
                                            <td style="font-weight: normal;">
                                                <input type="text" style="width: 50px;">
                                                <img src="../Images/time.png" style="vertical-align: middle;" class="time">
                                            </td>
                                            <td style="font-weight: normal;">
                                                <input type="text" style="width: 50px;">
                                                <img src="../Images/time.png" style="vertical-align: middle;" class="time">
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                        </td>
                    </tr>
                </tbody>
            </table>
            <div style="margin: 12px;">
                <div style="margin-bottom: 5px;">
                    <input type="radio" name="holidays" style="vertical-align: middle;margin-right: 5px;" checked>No hours on holidays
                </div>
                <div>
                    <input type="radio" name="holidays" style="vertical-align: middle;margin-right: 5px;">Use normal hours on holidays
                </div>
            </div>
        </div>
    </div>
        </div>
    </form>
        <script src="../Scripts/jquery-3.1.0.min.js"></script>
    <script src="../Scripts/SysSettingRoles.js"></script>
     <script>
        $(".time").on("click",function(){
            var NowData=new Date();
            console.log(NowData);
            var str='';
            str=NowData.getHours()+':'+NowData.getMinutes();
            $(this).prev().val(str);
        });
    </script>
</body>
</html>
