<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="LogoSearch.aspx.cs" Inherits="EMT.DoneNOW.Web.SysSetting.LogoSearch" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <link rel="stylesheet" type="text/css" href="../Content/base.css" />
    <link href="../Content/style.css" rel="stylesheet" />
    <link href="../Content/bootstrap.min.css" rel="stylesheet" />
    <title></title>
      <style>
          img {
    max-width: 600px;
    max-height: 600px;
}
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
        <div style="width:800px;">
            <table class="table table-bordered table-hover">
                <tr style="background-color:#cbd9e4;">
                    <th style="text-align:center;width:30%;min-width:200px;">名称</th>
                    <th style="text-align:center;">Logo</th>
                </tr>
                <% if (logoList!=null&&logoList.Count>0) {
                        foreach (var logo in logoList)
                        {%>
                <tr class="logoTr" data-val="<%=logo.id %>">
                    <td><%=logo.name %></td>
                    <td><img src="<%=logo.ext2 %>"/></td>
                </tr>
                       <% }
                    } %>
                
            </table>
        </div>
          <div class="menu" id="menu">
            <ul style="width: 220px;">
                <li id="" onclick="Edit()"><i class="menu-i1"></i>编辑</li>
            </ul>
        </div>
    </form>
</body>
</html>
<script src="../Scripts/jquery-3.1.0.min.js"></script>
<script src="../Scripts/common.js"></script>
<script>
    var entityid = "";
    var logoType = "other";
    var Times = 0;
    $(".logoTr").bind("contextmenu", function (event) {
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

    function Edit() {
        if (entityid != "" && logoType != "") {
            window.open("../SysSetting/LogoManage?id=" + entityid, '_blank', 'left=0,top=0,location=no,status=no,width=400,height=350', false);
        }
    }
</script>
