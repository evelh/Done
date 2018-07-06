<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="TaxRateManage.aspx.cs" Inherits="EMT.DoneNOW.Web.SysSetting.TaxRateManage" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title><%=isAdd?"新增":"编辑" %>税收</title>
    <link href="../Content/reset.css" rel="stylesheet" />
    <link href="../Content/SysSettingRoles.css" rel="stylesheet" />
    <link rel="stylesheet" type="text/css" href="../Content/style.css" />
    <link href="../Content/index.css" rel="stylesheet" />
        <style>
        .menu {
            position: absolute;
            z-index: 999;
            display: none;
        }

            .menu ul {
                margin: 0;
                padding: 0;
                position: relative;
                width: 150px;
                border: 1px solid gray;
                background-color: #F5F5F5;
                padding: 10px 0;
            }

                .menu ul li {
                    padding-left: 20px;
                    height: 25px;
                    line-height: 25px;
                    cursor: pointer;
                }

                    .menu ul li ul {
                        display: none;
                        position: absolute;
                        right: -150px;
                        top: -1px;
                        background-color: #F5F5F5;
                        min-height: 90%;
                    }

                        .menu ul li ul li:hover {
                            background: #e5e5e5;
                        }

                    .menu ul li:hover {
                        background: #e5e5e5;
                    }

                        .menu ul li:hover ul {
                            display: block;
                        }

                    .menu ul li .menu-i1 {
                        width: 20px;
                        height: 100%;
                        display: block;
                        float: left;
                    }

                    .menu ul li .menu-i2 {
                        width: 20px;
                        height: 100%;
                        display: block;
                        float: right;
                    }

                .menu ul .disabled {
                    color: #AAAAAA;
                }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="TitleBar">
            <div class="Title">
                <span class="text1"><%=isAdd?"新增":"编辑" %>税收</span>
                <a href="###" class="help"></a>
            </div>
        </div>
        <div class="ButtonContainer header-title">
            <ul id="btn">
                <li id="SaveClose"><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -32px 0;" class="icon-1"></i>
                    <asp:Button ID="save_close" runat="server" Text="保存并关闭" BorderStyle="None" OnClick="save_close_Click" />

                </li>
                <li onclick="javascript:window.close();"><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -96px 0;" class="icon-1"></i>
                    取消
                </li>
            </ul>
        </div>
        <div style="left: 0; overflow-x: auto; overflow-y: auto; position: fixed; right: 0; bottom: 0; top: 110px;">
            <div class="content clear">
                <div class="information clear">
                    <p class="informationTitle">常规</p>
                    <div>
                        <table border="none" cellspacing="" cellpadding="" style="width: 400px;">
                            <tr>
                                <td width="30%" class="FieldLabels"><span style="margin-left: 15px;">税区</span><span style="color: red;">*</span>
                                    <span class="errorSmall"></span>
                                    <div>
                                        <select style="width: 220px;" id="tax_region_id" name="tax_region_id">
                                            <option></option>
                                            <%if (regionList != null && regionList.Count > 0)
                                                {
                                                    foreach (var region in regionList)
                                                    {%>
                                            <option value="<%=region.id %>" <%if (thisCate?.tax_region_id == region.id)
                                                {%> selected="selected" <%} %>><%=region.name %></option>
                                            <% }
                                                }%>
                                        </select>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td width="30%" class="FieldLabels"><span style="margin-left: 15px;">税种</span><span style="color: red;">*</span>
                                    <span class="errorSmall"></span>
                                    <div>
                                        <select style="width: 220px;" id="tax_cate_id" name="tax_cate_id">
                                            <option></option>
                                            <%if (cateList != null && cateList.Count > 0)
                                                {
                                                    foreach (var cate in cateList)
                                                    {%>
                                            <option value="<%=cate.id %>" <%if (thisCate?.tax_cate_id == cate.id)
                                                {%> selected="selected" <%} %>><%=cate.name %></option>
                                            <% }
                                                }%>
                                        </select>
                                    </div>
                                </td>
                            </tr>
                        </table>
                    </div>
                </div>
                <%if (!isAdd)
                    { %>
                <div class="information clear">
                    <p class="informationTitle">分税信息</p>
                    <div>
                        <div class="header-title">
                            <ul>
                                <li onclick="Add()"><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -32px 0;" class="icon-1"></i>新增</li>
                            </ul>
                            <span><%=thisCate.total_effective_tax_rate.ToString("#0.0000") %></span>
                        </div>
                        <div class="GridContainer">
                            <div style="height: 832px; width: 100%; overflow: auto; z-index: 0;">
                                <table class="dataGridBody" style="width: 100%; border-collapse: collapse;">
                                    <tbody>
                                        <tr class="dataGridHeader">
                                            <td style=""></td>
                                            <td style="">名称</td>
                                            <td align="center" style="">税率</td>
                                        </tr>
                                        <% if (taxList != null && taxList.Count > 0 )
                                            {
                                                foreach (var tax in taxList)
                                                {
                                        %>
                                        <tr class="dataGridBody" style="cursor: pointer;" data-val="<%=tax.id %>">
                                            <td align="center"><%=tax.sort_order %></td>
                                            <td align="center"><%=tax.tax_name %></td>
                                            <td align="center"><%=tax.tax_rate.ToString("#0.0000") %></td>
                                        </tr>
                                        <% }
                                            } %>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
                <%} %>
            </div>
        </div>
          <div class="menu" id="menu">
            <ul style="width: 220px;">
                <li id="" onclick="Edit()"><i class="menu-i1"></i>编辑</li>
                <li id="" onclick="Remove()"><i class="menu-i1"></i>删除</li>
            </ul>
        </div>
    </form>
</body>
</html>
<script src="../Scripts/jquery-3.1.0.min.js" type="text/javascript" charset="utf-8"></script>
<script src="../Scripts/index.js"></script>
<script src="../Scripts/common.js"></script>
<script>
    var entityid = "";
    var Times = 0;
    $(".dataGridBody").bind("contextmenu", function (event) {
        clearInterval(Times);
        //debugger;
        var oEvent = event;
        var menu = document.getElementById("menu");
        entityid = $(this).data("val");
        
        (function () {
            menu.style.display = "block";
            Times = setTimeout(function () {
                menu.style.display = "none";
            }, 600);
        }());
        menu.onmouseenter = function () {
            clearInterval(Times);
            menu.style.display = "block";
        };
        menu.onmouseleave = function () {
            Times = setTimeout(function () {
                menu.style.display = "none";
            }, 600);
        };
        var Left = $(document).scrollLeft() + oEvent.clientX;
        var Top = $(document).scrollTop() + oEvent.clientY;
        var winWidth = window.innerWidth;
        var winHeight = window.innerHeight;
        var menuWidth = menu.clientWidth;
        var menuHeight = menu.clientHeight;
        var scrLeft = $(document).scrollLeft();
        var scrTop = $(document).scrollTop();
        var clientWidth = Left + menuWidth;
        var clientHeight = Top + menuHeight;
        var rightWidth = winWidth - oEvent.clientX;
        var bottomHeight = winHeight - oEvent.clientY;
        if (winWidth < clientWidth && rightWidth < menuWidth) {
            menu.style.left = winWidth - menuWidth - 18 + scrLeft + "px";
        } else {
            menu.style.left = Left + "px";
        }
        if (winHeight < clientHeight && bottomHeight < menuHeight) {
            menu.style.top = winHeight - menuHeight - 18 - 25 + scrTop + "px";
        } else {
            menu.style.top = Top - 25 + "px";
        }
        document.onclick = function () {
            menu.style.display = "none";
        }
        return false;
    });

    function Add() {
        <%if (thisCate != null)
    {%>
        window.open('../SysSetting/TaxRateTaxManage?regionCateId=<%=thisCate.id %>', 'AddRegionTax', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
        <%} %>
    }
    function Edit() {
        if (entityid != "" && entityid != undefined) {
            window.open('../SysSetting/TaxRateTaxManage?id=' + entityid, 'AddRegionTax', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
        }
    }
    function Remove() {
        LayerConfirm("删除不能撤消。 是否删除？", "是", "否", function () {
            $.ajax({
                type: "GET",
                url: "../Tools/GeneralAjax.ashx?act=DeleteRegionTax&id=" + entityid,
                dataType: "json",
                async: false,
                success: function (data) {
                    if (data) {
                        LayerMsg("删除成功");
                    }
                    setTimeout(function () { history.go(0); }, 800);
                }
            });
        });
    }

    $("#save_close").click(function () {
        var tax_region_id = $("#tax_region_id").val();
        if (tax_region_id == "") {
            LayerMsg("请选择相关税区");
            return false;
        }
        var tax_cate_id = $("#tax_cate_id").val();
        if (tax_cate_id == "") {
            LayerMsg("请选择相关税种");
            return false;
        }
        var isRepeat = "";

        $.ajax({
            type: "GET",
            url: "../Tools/GeneralAjax.ashx?act=CheckRegionCate&regionId=" + tax_region_id + "&cateId=" + tax_cate_id+"&id=<%=thisCate?.id %>",
            dataType: "json",
            async: false,
            success: function (data) {
                if (!data) {
                    isRepeat = "1";
                }
            }
        });
        if (isRepeat == "1") {
            LayerMsg("该税区税种已存在");
            return false;
        }

        return true;
    })
</script>
