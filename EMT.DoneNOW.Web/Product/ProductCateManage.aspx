<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ProductCateManage.aspx.cs" Inherits="EMT.DoneNOW.Web.Product.ProductCateManage" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <link href="../Content/style.css" rel="stylesheet" />
    <link rel="stylesheet" type="text/css" href="../Content/ManageKnowledgebase.css" />
    <title></title>
    <style>
        body{
            font-size:12px;
        }
        #AllProductCate ul{
            padding-left:10px;
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
        <div class="header-title">
            <ul>

                <li onclick="Add('')"><%--<i style="background: url(../Images/ButtonBarIcons.png) no-repeat -96px 0;" class="icon-1"></i>--%>新增产品类别</li>
            </ul>
        </div>
        <div id="AllProductCate" style="padding-left:30px;width: 200px;float: left;">
            <p class="treep" data-id="">产品类别</p>
        </div>

        <div style="float: left;width: calc(100% - 240px);height:100%;">
            <iframe src="" id="Search" style="width:100%;height:100%;border:0px;min-height:700px;"></iframe>
        </div>
        <div id="Menu" class="menu">
        <ul style="width: 220px;">
            <li id="" onclick="EditProductCate()"><i class="menu-i1"></i>编辑产品种类    </li>
            <li id="" onclick="AddProductCate()"><i class="menu-i1"></i>新增产品种类    </li>
            <li id="" onclick="DeleteProductCate()"><i class="menu-i1"></i>删除产品种类    </li>
        </ul>
    </div>
    </form>
</body>
</html>

<script src="../Scripts/jquery-3.1.0.min.js"></script>
<script src="../Scripts/common.js"></script>
<script>
    $(function () {
        var data = <%=cateList==null?"":new EMT.Tools.Serialize().SerializeJson(cateList) %>;
       

        var list = document.createElement("ul");
        list.classList.add('treeul');
        create(list, data);
        var Tree = document.getElementById('AllProductCate');
        Tree.appendChild(list);
        addEv();

        function create(list, data) { //传入ul和数组
            for (var i = 0; i < data.length; i++) { //循环数组长度生成li和内容
                var li = document.createElement("li");
                li.classList.add('treeli');
                var p = document.createElement("p");
               
                p.classList.add('treep');
                p.innerHTML = data[i].name + "(" + data[i].productCnt + ")";
                p.setAttribute("data-id", data[i].id);
                li.appendChild(p);
        
                if (data[i].nodes.length>0) { //如果还有子项
                    var ul = document.createElement("ul"); //生成ul
                    create(ul, data[i].nodes); //传入ul，以及子项的数组，生成子项的li
                    li.appendChild(ul);
                    p.innerHTML = "<span><img src = '../Images/imgMinus.gif'></span>" + data[i].name + "(" + data[i].productCnt + ")";
                }
                list.appendChild(li);
            }
        }

        function addEv() {
            var span = document.querySelectorAll('span');
            for (var i = 0; i < span.length; i++) {
                span[i].onclick = function () {
                    var ul = this.parentNode.nextElementSibling; /*获取它下边的ul */
                    if (ul) { /*存在*/
                        var uls = this.parentNode.parentNode.parentNode.getElementsByTagName("ul");
                        for (var i = 0; i < uls.length; i++) {
                            //  if (uls[i] != ul) {
                            //      uls[i].style.display = "none"; //清除掉同级所有ul(排除当前个)
                            //  }
                        }
                        /* 操作当前个 */
                        if (getStyle(ul, "display") == "none") {
                            ul.style.display = "block";
                            this.innerHTML = "<img src = '../Images/imgMinus.gif'>";
                        } else {
                            ul.style.display = "none";
                            this.innerHTML = "<img src = '../Images/imgPlus.gif'>";
                        }
                    }
                }
            }
        }
        function getStyle(el, attr) {
            return getComputedStyle(el)[attr];
        }

        $('.line').css({ 'width': $('.heardnav ul li').eq(0).width() + 20, 'left': 11 })
        $('.heardnav ul li').each(function (i) {
            $('.heardnav ul li').eq(i).click(function () {
                $('.heardnav ul li').eq(i).addClass('navNow').siblings().removeClass('navNow');
                $('.contentrs ul li').eq(i).show().siblings().hide();
                var left = i == 0 ? 11 : i == 1 ? 11 * 2 + $('.heardnav ul li').eq(0).width() + 21 : i == 2 ? 11 * 3 + $('.heardnav ul li').eq(0).width() + $('.heardnav ul li').eq(1).width() + 42 : 10;
                $('.line').css({ 'width': $('.heardnav ul li').eq(i).width() + 20, 'left': left })
            })
        })
     
        $(".treep").click(function () {
            ShowProduct($(this).data("id"));
        })
        var entityid = "";
        var Times = 0;
        $(".treep").bind("contextmenu", function (event) {
            clearInterval(Times);
            //debugger;
            var oEvent = event;
            entityid = $(this).data("id");
            if (entityid == "") {
                return true;
            }
            var menu = document.getElementById("Menu");



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

        ShowProduct("");
    })

  


    function Add() {
        window.open("../General/GeneralManage?tableId=<%=(long)EMT.DoneNOW.DTO.GeneralTableEnum.PRODUCT_CATE %>", windowObj.general + windowType.add, 'left=200,top=200,width=600,height=800', false);
    }

    function AddProductCate() {
        if (entityid == undefined || entityid == null) {
            entityid = "";
        }
        window.open("../General/GeneralManage?tableId=<%=(long)EMT.DoneNOW.DTO.GeneralTableEnum.PRODUCT_CATE %>&parnetId=" + entityid, windowObj.general + windowType.add, 'left=200,top=200,width=600,height=800', false);
    }

    function EditProductCate() {
        if (entityid != "") {
            window.open("../General/GeneralManage?id=" + entityid, windowObj.general + windowType.edit, 'left=200,top=200,width=600,height=800', false);
        }
    }

    function DeleteProductCate() {
        LayerConfirm("删除会将该类别其下的产品类别设为空，删除不可恢复，是否继续？", "是", "否", function () {
            $.ajax({
                type: "GET",
                url: "../Tools/GeneralViewAjax.ashx?act=delete&GT_id=105&id=" + entityid,
                async: false,
                //dataType: "json",
                success: function (data) {
                    if (data == "success") {
                        LayerMsg("删除成功！");
                        setTimeout(function () { history.go(0); }, 800);
                    }
                    else if (data == "system") {
                        LayerMsg("删除失败！系统字段不能删除");
                    }
                    else {
                        LayerMsg("删除失败！");
                    }
                }
            })
        }, function () { });
    }
 
    function ShowProduct(cateId) {
        $("#Search").attr("src", "../Common/SearchBodyFrame.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.PRODUCT %>&type=<%=(int)EMT.DoneNOW.DTO.QueryType.Prouduct %>&con452=" + cateId);
    }
</script>
