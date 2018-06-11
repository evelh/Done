<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="CheckListLibrary.aspx.cs" Inherits="EMT.DoneNOW.Web.SysSetting.CheckListLibrary" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
 <title><%=isAdd?"新增":"编辑" %>检查单库</title>
         <link href="../Content/FromTemp.css" rel="stylesheet" />
     <link href="../Content/SysSettingRoles.css" rel="stylesheet" />
    <link rel="stylesheet" type="text/css" href="../Content/base.css" />
    <link rel="stylesheet" type="text/css" href="../Content/bootstrap.min.css" />
    <link href="../Content/index.css" rel="stylesheet" />
    <link href="../Content/style.css" rel="stylesheet" />

</head>
<body>
    <form id="form1" runat="server">
         <div class="header"><%=isAdd?"新增":"编辑" %>检查单库</div>
        <div class="header-title">
            <ul>
                <li><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -32px 0;" class="icon-1"></i>
                    <asp:Button ID="SaveClose" runat="server" Text="保存并关闭" OnClick="SaveClose_Click" />
                </li>
                <li onclick="javascript:window.close();"><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -96px 0;" class="icon-1"></i>关闭</li>
            </ul>
        </div>
        <div style="left: 0; overflow-x: auto; overflow-y: auto; position: fixed; right: 0; bottom: 0; top: 100px;">
            <div class="content clear" id="GeneralDiv">
                <div class="information clear" style="width:836px;margin-left:10px;">
                    <div>
                        <table border="none" cellspacing="" cellpadding="" style="width: 400px;">
                            <tr>
                                <td>
                                    <div class="clear">
                                        <label>名称<span class="red">*</span></label>
                                        <input type="text" name="name" id="name" value="<%=lib!=null?lib.name:"" %>" />

                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <div class="clear">
                                        <label>激活<span class="red"></span></label>
                                        <input type="checkbox" name="isActive" id="isActive" <%if (isAdd || (lib != null && lib.is_active == 1))
                                            {%>
                                            checked="checked" <%} %> />
                                    </div>
                                </td>
                            </tr>
                              <tr>
                                <td>
                                    <div class="clear">
                                        <label>描述<span class="red"></span></label>
                                        <textarea id="description" name="description"><%=lib!=null?lib.description:"" %></textarea>
                                    </div>
                                </td>
                            </tr>
                          
                        
                        </table>
                    </div>
                </div>

                <div class="Normal Section">
                <div class="Heading" data-toggle-enabled="true">
                    <div class="Left"><span class="Text">检查单</span></div>
                    <div class="Middle"></div>
                    <div class="Spacer"></div>
                    <div class="Right"></div>
                </div>
                <div class="Content">
                  <div class="DescriptionText">你最多可以输入20个条目.</div>
                       <div class="ToolBar">
                                    <div class="ToolBarItem Left ButtonGroupStart"><a class="Button ButtonIcon New NormalState" id="AddCheckListButton" tabindex="0" style="color:black;border:0px;"><span class="Text">新增检查单</span></a></div>
                                    <div class="Spacer"></div>
                                </div>
                         <div class="Grid Small" id="TicketChecklistItemsGrid">
                                    <div class="HeaderContainer">
                                        <table cellpadding="0" style="min-width:650px;">
                                            <thead class="HeaderContainer">
                                                <tr class="HeadingRow">
                                                    <td class=" Interaction DragEnabled" style="width: 60px;">
                                                        <div class="Standard"></div>
                                                    </td>
                                                    <td class=" Context" style="width: 45px;">
                                                        <div class="Standard">
                                                            <div></div>
                                                        </div>
                                                    </td>
                                                    <td class=" Image" style="width: 20px;">
                                                        <div class="Standard">
                                                            <div class="BookOpen ButtonIcon">
                                                                <div class="Icon"></div>
                                                            </div>
                                                        </div>
                                                    </td>
                                                    <%--<td class=" Boolean" style="text-align: center;">
                                                        <div class="Standard">
                                                            <div class="Heading">完成</div>
                                                        </div>
                                                    </td>--%>
                                                    <td class=" Text Dynamic">
                                                        <div class="Standard">
                                                            <div class="Heading">条目</div>
                                                        </div>
                                                    </td>
                                                    <td class=" Boolean" style="text-align: center;">
                                                        <div class="Standard">
                                                            <div class="Heading">重要</div>
                                                        </div>
                                                    </td>
                                                    <%--<td class="ScrollBarSpacer" style="width: 19px;"></td>--%>
                                                </tr>
                                            </thead>
                                            <div class="cover"></div>
                                            <tbody id="Drap" class="Drap RowContainer BodyContainer">
                                                <div class="border_left">
                                                </div>
                                                <div class="border_right">
                                                </div>
                                                <div class="border-line"></div>
                                                <% if (checkList != null && checkList.Count > 0)
                                                    {
                                                        int num = 0;
                                                        foreach (var item in checkList)
                                                        {
                                                            num++;
                                                %>
                                                <tr data-val="<%=item.id %>" id="<%=item.id %>" class="HighImportance D" draggable="true">
                                                    <td class="Interaction">
                                                        <div>
                                                            <div class="Decoration Icon DragHandle">
                                                            </div>
                                                            <div class="Num"><%=item.sort_order==null?"":((decimal)item.sort_order).ToString("#0") %></div>
                                                            <input type="hidden" id="<%=item.id %>_sort_order" name="<%=item.id %>_sort_order" value="<%=item.sort_order==null?"":((decimal)item.sort_order).ToString("#0") %>" />
                                                        </div>
                                                    </td>
                                                    <td>
                                                        <a class="ButtonIcon Button ContextMenu NormalState ">
                                                            <div class="Icon" style="background: url(../Images/ButtonBarIcons.png) no-repeat -193px -97px; width: 15px; height: 15px;">
                                                            </div>
                                                        </a>
                                                    </td>
                                                    <td></td>
                                                    <%--<td>
                                                    

                                                    </td>--%>
                                                    <td>
                                                        <input type="text" id="<%=item.id %>_item_name" name="<%=item.id %>_item_name" value="<%=item.item_name %>" /></td>
                                                    <td>
                                                        <%if (item.is_important == 1)
                                                            { %>
                                                        <input type="checkbox" id="<%=item.id %>_is_import" name="<%=item.id %>_is_import" checked="checked" />
                                                        <%}
                                                            else
                                                            { %>
                                                        <input type="checkbox" id="<%=item.id %>_is_import" name="<%=item.id %>_is_import" />
                                                        <%} %>
                                                    </td>
                                                </tr>
                                                <%
                                                        }
                                                    }
                                                    else
                                                    { %>
                                                <tr data-val="-1" id="-1" class="HighImportance D" draggable="true">
                                                    <td class="Interaction">
                                                        <div>
                                                            <div class="Decoration Icon DragHandle">
                                                            </div>
                                                            <div class="Num">1</div>
                                                            <input type="hidden" id="-1_sort_order" name="-1_sort_order" value="1" />
                                                        </div>
                                                    </td>
                                                    <td>
                                                        <a class="ButtonIcon Button ContextMenu NormalState ">
                                                            <div class="Icon" style="background: url(../Images/ButtonBarIcons.png) no-repeat -193px -97px; width: 15px; height: 15px;">
                                                            </div>
                                                        </a>
                                                    </td>
                                                    <td></td>
                                                  <%--  <td>
                                                        <input type="checkbox" id="-1_is_complete" name="-1_is_complete" /></td>--%>
                                                    <td>
                                                        <input type="text" id="-1_item_name" name="-1_item_name" /></td>
                                                    <td>
                                                        <input type="checkbox" id="-1_is_import" name="-1_is_import" /></td>

                                                </tr>
                                                <%} %>
                                            </tbody>
                                        </table>
                                    </div>
                                    <div class="ScrollingContentContainer">
                                        <div class="NoDataMessage">未查询到相关数据</div>
                                        <input type="hidden" id="CheckListIds" name="CheckListIds" />
                                    </div>
                                    <div class="FooterContainer"></div>
                                </div>
                </div>
            </div>
                </div>
            </div>
        
         <div class="menu" id="menu" style="background-color: #f8f8f8;">
            <%--菜单--%>
            <ul style="width: 220px;" id="menuUl">
                <li id="AddToAbove" onclick="AddAbove()">添加到条目上面</li>
                <li id="AddToBelow" onclick="AddBelow()">添加到条目下面</li>
                <li id="CopyItem" onclick="CopyThisItem()">复制</li>
                <li id="AssKonw">关联知识库</li>
                <li id="DeleteItem" onclick="Delete()">删除</li>
            </ul>
        </div>
    </form>
</body>
</html>
<script src="../Scripts/jquery-3.1.0.min.js" type="text/javascript" charset="utf-8"></script>
<script src="../Scripts/common.js"></script>
<script>
    $("#SaveClose").click(function () {
        var name = $("#name").val();
        if (name == "") {
            LayerMsg("请填写名称");
            return false;
        }
        GetCheckIds();
        return true;
    })
    
</script>

<!--检查单信息js操作 -->
<script>
    var pageCheckId = -1;
    // 新增检查单
    function AddCheckList(copyNum, upOrDown, upOrDownId) {
        // copyNum 复制的Id 没有代表新增不复制--（复制不考虑其他，名称复制后名称加入‘复制’）
        var count = $(".HighImportance").length;
        if (count > 19) {
            LayerMsg("最多只可以添加20个相关条目");
            return;
        }
        pageCheckId--;
        var newCheckHtml = "<tr data-val='" + pageCheckId + "' id='" + pageCheckId + "'  class='HighImportance D' draggable='true'><td class='Interaction' ><div><div class='Decoration Icon DragHandle'></div><div class='Num'></div> <input type='hidden' id='" + pageCheckId + "_sort_order' name='" + pageCheckId + "_sort_order' value=''/></div></td ><td><a class='ButtonIcon Button ContextMenu NormalState'><div class='Icon' style='background: url(../Images/ButtonBarIcons.png) no-repeat -193px -97px; width: 15px;height:15px;'></div></a></td><td></td><td><input type='text' id='" + pageCheckId + "_item_name' name='" + pageCheckId + "_item_name' /></td><td><input type='checkbox' id='" + pageCheckId + "_is_import' name='" + pageCheckId + "_is_import' /></td></tr>";



        if (upOrDownId != "" && upOrDown != "") {
            if (upOrDown == "Up") {
                $("#" + upOrDownId).before(newCheckHtml);
            }
            else {
                $("#" + upOrDownId).after(newCheckHtml);
            }
        } else {
            $("#Drap").append(newCheckHtml);
        }

        SortNum();
        if (copyNum != "")  // 复制的  相关赋值  todo 关联的知识库的赋值
        {
            //if ($("#" + copyNum + "_is_complete").is(":checked")) {
            //    $("#" + pageCheckId + "_is_complete").prop("checked", true);
            //}
            if ($("#" + copyNum + "_is_import").is(":checked")) {
                $("#" + pageCheckId + "_is_import").prop("checked", true);
            }
            $("#" + pageCheckId + "_item_name").val($("#" + copyNum + "_item_name").val() + "(复制)");
        }
        BindMenu();

    }
    // 为页面的检查单数字排序
    function SortNum() {
        var sortNum = 1;
        $(".HighImportance").each(function () {
            $(this).find('.Num').text(sortNum);
            $(this).find('.Num').next().val(sortNum);
            sortNum++;
        })
    }

    $("#AddCheckListButton").click(function () {
        AddCheckList("", "", "");
    })
    var entityid = "";
    var Times = 0;
    function BindMenu() {
        $(".ContextMenu").bind("click", function (event) {
            clearInterval(Times);
            var oEvent = event;
            entityid = $(this).parent().parent().data("val");// data("val");
            var menu = document.getElementById("menu");
            (function () {
                menu.style.display = "block";
                Times = setTimeout(function () {
                    menu.style.display = "none";
                }, 800);
            }());
            menu.onmouseenter = function () {
                clearInterval(Times);
                menu.style.display = "block";
            };
            menu.onmouseleave = function () {
                Times = setTimeout(function () {
                    menu.style.display = "none";
                }, 800);
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
                menu.style.left = winWidth - menuWidth - 18 + 103 + scrLeft + "px";
            } else {
                menu.style.left = Left + 13 + "px";
            }


            if (winHeight < clientHeight && bottomHeight < menuHeight) {
                menu.style.top = winHeight - menuHeight - 55 + scrTop + "px";
            } else {
                menu.style.top = Top - 85 + "px";
            }
            document.onclick = function () {
                menu.style.display = "none";
            }
            return false;
        });
    }

    BindMenu();

    // 添加到上面
    function AddAbove() {

        if (entityid != "") {
            AddCheckList("", "Up", entityid);
        }
    }
    // 添加到下面
    function AddBelow() {
        if (entityid != "") {
            AddCheckList("", "Down", entityid);
        }
    }
    // 复制操作
    function CopyThisItem() {
        if (entityid != "") {
            AddCheckList(entityid, "", "");
        }
    }
    // 删除任务单
    function Delete() {
        if (entityid != "") {
            LayerConfirm("删除不可恢复，是否继续删除？", "是", "否", function () { $("#" + entityid).remove(); SortNum(); }, function () { });
            SortNum();
        }
    }
    // 获取到页面的检查单的Id
    function GetCheckIds() {
        var ckIds = "";
        $(".HighImportance").each(function () {
            var thisVal = $(this).data("val");
            if (thisVal != "" && thisVal != null && thisVal != undefined) {
                ckIds += thisVal + ',';
            }
        })
        if (ckIds != "") {
            ckIds = ckIds.substring(0, ckIds.length - 1);
        }
        $("#CheckListIds").val(ckIds);
    }
</script>
