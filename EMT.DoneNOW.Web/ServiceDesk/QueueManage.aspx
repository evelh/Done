<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="QueueManage.aspx.cs" Inherits="EMT.DoneNOW.Web.ServiceDesk.QueueManage" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title><%=isAdd?"新增":"编辑" %>队列</title>
     <link href="../Content/SysSettingRoles.css" rel="stylesheet" />
    <link rel="stylesheet" type="text/css" href="../Content/base.css" />
    <link rel="stylesheet" type="text/css" href="../Content/bootstrap.min.css" />
    <link href="../Content/index.css" rel="stylesheet" />
    <link href="../Content/style.css" rel="stylesheet" />
   
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
        <div class="header"><%=isAdd?"新增":"编辑" %>队列</div>
        <div class="header-title">
            <ul>
                <li><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -32px 0;" class="icon-1"></i>
                    <asp:Button ID="save_close" runat="server" Text="保存并关闭" BorderStyle="None" OnClick="save_close_Click" />
                </li>
                <li onclick="javascript:window.close();"><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -96px 0;" class="icon-1"></i>关闭</li>
            </ul>
        </div>
        <div class="nav-title">
            <ul class="clear">
                <li class="boders" id="general">常规</li>
                <%if (!isAdd)
                    { %>
                <li id="resourceLi">员工</li>
                <%} %>
            </ul>
        </div>
        <div style="left: 0; overflow-x: auto; overflow-y: auto; position: fixed; right: 0; bottom: 0; top: 140px;">
            <div class="content clear" id="GeneralDiv">
                <div class="information clear">
                    <div>
                        <table border="none" cellspacing="" cellpadding="" style="width: 400px;">
                            <tr>
                                <td>
                                    <div class="clear">
                                        <label>名称<span class="red">*</span></label>
                                        <input type="text" name="name" id="name" value="<%=queue!=null?queue.name:"" %>" />

                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <div class="clear">
                                        <label>激活<span class="red"></span></label>
                                        <input type="checkbox" name="isActive" id="isActive" <%if (isAdd || (queue != null && queue.is_active == 1))
                                            {%>
                                            checked="checked" <%} %> />
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <div class="clear">
                                        <label>主要办公位置<span class="red">*</span></label>
                                        <select id="location_id" name="location_id">
                                            <option></option>
                                            <% if (locationDic != null && locationDic.Count > 0)
                                                {
                                                    foreach (var dic in locationDic)
                                                    {  %>
                                            <option value="<%=dic.Key %>" <%if (queue != null && queue.location_id == dic.Key)
                                                {%>
                                                selected="selected" <%} %>><%=dic.Value %></option>
                                            <% }
                                                } %>
                                        </select>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <div class="clear">
                                        <label>编号<span class="red"></span></label>
                                        <input type="text" name="no" id="no" value="<%=queue!=null?queue.no:"" %>" />
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <div class="clear">
                                        <label>描述<span class="red"></span></label>
                                        <textarea name="description" id="description" style="resize: vertical;"><%=queue!=null?queue.description:"" %></textarea>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <div class="clear">
                                        <label>显示在客户门户上<span class="red"></span></label>
                                        <input type="checkbox" name="isShow" id="isShow" <%if (isAdd || (queue != null && queue.is_show == 1))
                                            {%>
                                            checked="checked" <%} %> />
                                    </div>
                                </td>
                            </tr>
                        </table>
                    </div>
                </div>
                <div class="information clear">
                    <div>
                        <table border="none" cellspacing="" cellpadding="" style="width: 400px;">
                            <tr>
                                <td>
                                    <div class="clear">
                                        <label>地址</label>
                                        <span id="locationName"></span>

                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <div class="clear">
                                        <label>时区</label>
                                        <span id="TimeZone"></span>
                                    </div>
                                </td>
                            </tr>

                        </table>
                    </div>
                </div>
                <div class="information clear">
                    <div>
                        <table border="none" cellspacing="" cellpadding="" style="width: 400px;">
                            <tr>
                                <td>
                                    <div class="clear">
                                        <label>其他邮箱</label>
                                        <textarea name="other_email" id="other_email" style="resize: vertical;"><%=queue!=null?queue.other_email:"" %></textarea>

                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <div class="clear">
                                        <label>其他邮箱2</label>
                                        <textarea name="other_email2" id="other_email2" style="resize: vertical;"><%=queue!=null?queue.other_email2:"" %></textarea>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <div class="clear">
                                        <label>其他邮箱3</label>
                                        <textarea name="other_email3" id="other_email3" style="resize: vertical;"><%=queue!=null?queue.other_email3:"" %></textarea>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <div class="clear">
                                        <label>其他邮箱4</label>
                                        <textarea name="other_email4" id="other_email4" style="resize: vertical;"><%=queue!=null?queue.other_email4:"" %></textarea>
                                    </div>
                                </td>
                            </tr>
                        </table>
                    </div>
                </div>
            </div>
            <div class="content clear" style="display: none;" id="ResourceDiv">
                <%if (!isAdd)
                    { %>
                <div class="header-title">
                    <ul>
                        <li onclick="AddResource()"><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -32px 0;" class="icon-1"></i>新增</li>
                    </ul>
                </div>
                <div class="GridContainer">
                    <div style="height: 832px; width: 100%; overflow: auto; z-index: 0;">
                        <table class="dataGridBody" style="width: 100%; border-collapse: collapse;">
                            <tbody>
                                <tr class="dataGridHeader">
                                    <td style="width: 35%;">
                                        <span>员工名称</span>
                                    </td>
                                    <td style="width: 35%;">角色名称</td>
                                    <td align="center" style="width: 15%;">主要负责人</td>
                                    <td align="center" style="width: 15%;">激活</td>
                                </tr>

                                <% if (resDepList != null && resDepList.Count > 0 && resList != null && resList.Count > 0 && roleList != null && roleList.Count > 0)
                                    {
                                        foreach (var resDep in resDepList)
                                        {
                                            var thisRes = resList.FirstOrDefault(_ => _.id == resDep.resource_id);
                                            var thisRole = roleList.FirstOrDefault(_ => _.id == resDep.role_id);
                                            if (thisRes == null || thisRole == null) { continue; }
                                %>
                                <tr class="dataGridBody" style="cursor: pointer;" data-val="<%=resDep.id %>">
                                    <td align="center"><%=thisRes.name %></td>
                                    <td align="center"><%=thisRole.name %></td>
                                    <td align="center"><%=resDep.is_lead==1?"✓":"" %></td>
                                    <td align="center"><%=resDep.is_active==1?"✓":"" %></td>
                                </tr>
                                <% }
                                    } %>
                            </tbody>
                        </table>
                    </div>
                </div>
                <%} %>
            </div>
        </div>
        <div class="menu" id="menu">
            <ul style="width: 220px;">
                <li id="" onclick="EditResDep()"><i class="menu-i1"></i>编辑</li>
                <li id="ActiveLi" onclick="Active()"><i class="menu-i1"></i>激活</li>
                <li id="InActiveLi" onclick="InActive()"><i class="menu-i1"></i>失活</li>
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
    $(function () {
        $("#location_id").trigger("change");
        <%if (Request.QueryString["type"] == "res")
    { %>
        $("#resourceLi").trigger("click");
        <%} %>

    })
    $("#location_id").change(function () {
        var thisValue = $(this).val();
        if (thisValue != "") {
            $.ajax({
                type: "GET",
                url: "../Tools/DepartmentAjax.ashx?act=GetlocationInfo&id=" + thisValue,
                dataType: "json",
                success: function (data) {
                    if (data != "") {
                        $("#locationName").text(data.locaName);
                        $("#TimeZone").text(data.timeName);
                    }
                }
            });
        }
        else {
            $("#locationName").text("");
            $("#TimeZone").text("");
        }
    })

    $("#save_close").click(function () {
        var name = $("#name").val();
        if (name == "") {
            LayerMsg("请填写名称");
            return false;
        }
        var location_id = $("#location_id").val();
        if (location_id == "") {
            LayerMsg("请选择主要办公位置");
            return false;
        }
        return true;
    })

    $("#resourceLi").click(function () {
        $("#GeneralDiv").hide();
        $("#ResourceDiv").show();
        if (!$(this).hasClass("boders"))
        {
            $(this).addClass("boders");
        }
        $("#general").removeClass("boders");
    })
    $("#general").click(function () {
        $("#GeneralDiv").show();
        $("#ResourceDiv").hide();
        if (!$(this).hasClass("boders")) {
            $(this).addClass("boders");
        }
        $("#resourceLi").removeClass("boders");
    })
    

    function AddResource() {
        <%if (queue != null)
    {%>
        window.open('../ServiceDesk/QueueResourceManage?queId=<%=queue.id %>', 'AddDepRes', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
    <%} %>
    }
    var entityid = "";
    var Times = 0;
    $(".dataGridBody").bind("contextmenu", function (event) {
        clearInterval(Times);
        //debugger;
        var oEvent = event;
        var menu = document.getElementById("menu");
        entityid = $(this).data("val");


        
        $.ajax({
            type: "GET",
            url: "../Tools/DepartmentAjax.ashx?act=GetDepResource&id=" + entityid,
            dataType: "json",
            async: false,
            success: function (data) {
                if (data != "") {
                    if (data.is_active == 1) {
                        $("#InActiveLi").show();
                        $("#ActiveLi").hide();
                    }   
                    else {
                        $("#InActiveLi").hide();
                        $("#ActiveLi").show();
                    }
                }
            }
        });

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
    function EditResDep() {
        window.open('../ServiceDesk/QueueResourceManage?id=' + entityid, 'AddDepRes', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
    }
    function Active() {
        $.ajax({
            type: "GET",
            url: "../Tools/DepartmentAjax.ashx?act=ActiveResManage&id=" + entityid +"&isActive=1",
            dataType: "json",
            async: false,
            success: function (data) {
                if (data) {
                    LayerMsg("激活成功");
                    setTimeout(function () {
                        location.href = "QueueManage?id=<%=queue!=null?queue.id.ToString():"" %>&type=res";
                    }, 800);
                }
            }
        });
    }
    function InActive() {
        $.ajax({
            type: "GET",
            url: "../Tools/DepartmentAjax.ashx?act=ActiveResManage&id=" + entityid ,
            dataType: "json",
            async: false,
            success: function (data) {
                if (data) {
                    LayerMsg("失活成功");
                    setTimeout(function () {
                        location.href = "QueueManage?id=<%=queue!=null?queue.id.ToString():"" %>&type=res";
                    }, 800);
                }
            }
         });
    }
    function Remove() {
        $.ajax({
            type: "GET",
            url: "../Tools/DepartmentAjax.ashx?act=DeleteResource&id=" + entityid,
            dataType: "json",
            async: false,
            success: function (data) {
                if (data) {
                    LayerMsg("删除成功");
                    setTimeout(function () {
                        location.href = "QueueManage?id=<%=queue!=null?queue.id.ToString():"" %>&type=res";
                    }, 800);
                }
            }
        });
    }

</script>
