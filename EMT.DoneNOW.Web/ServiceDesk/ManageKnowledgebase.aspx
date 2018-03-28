<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ManageKnowledgebase.aspx.cs" Inherits="EMT.DoneNOW.Web.ServiceDesk.ManageKnowledgebase" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
    <link rel="stylesheet" type="text/css" href="../Content/ManageKnowledgebase.css" />

</head>
<body>
    <form id="form1" runat="server">
        <div class="heardnav">
        <ul>
            <li class="navNow">常规</li>
            <li>目录设置</li>
            <li>安全设置</li>
        </ul>
        <div class="line"></div>
    </div>
    <div class="contentrs">
        <ul>
            <li  style="display: block;">
                <div class="EnableOrDisable">
                    <p>启用/禁用知识库</p>
                    <div class="leftitem">
                        <input type="checkbox">
                        启用知识库
                    </div>
                    <div class="rightitem">
                        <img src="../Images/import.png" alt="">
                        <a onclick='Down()' style="color: #376597;cursor: pointer;">点击这里</a> 导入知识库文档
                    </div>
                </div>
                <div class="ArticleSummary">
                    <p>文章总结</p>
                    <div class="tablecontent">
                        <table class="datagrid" cellpadding='0' cellspacing = '0' style="border-collapse: collapse;" >
                            <thead>
                                <tr style="height: 24px;">
                                    <th align="left">文章类型</th>
                                    <th align="right">总数</th>
                                    <th align="right">激活数</th>
                                    <th align="right">未激活数</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td>1111</td>
                                    <td>1111</td>
                                    <td>1111</td>
                                    <td>1111</td>
                                </tr>
                                <tr>
                                    <td>1111</td>
                                    <td>1111</td>
                                    <td>1111</td>
                                    <td>1111</td>
                                </tr>
                                <tr>
                                    <td>1111</td>
                                    <td>1111</td>
                                    <td>1111</td>
                                    <td>1111</td>
                                </tr>
                                <tr>
                                    <td>1111</td>
                                    <td>1111</td>
                                    <td>1111</td>
                                    <td>1111</td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </li>
            <li id='Tree'>
                <p style="font-size: 14px;padding: 10px 0; color: #666;">通过点击“添加子类别”链接，为你的知识库创建文章类别。在每个类别及其子类别中（活动/非活动的文章）的计数显示在类别名称之后.</p>

                <!--<div class="treebox"  id="treebox">
                    <div class="toogle">
                        <img src="../2018313/img/imgMinus.gif" alt="">
                    </div>
                    <div class="name">
                        All Articles (3/0)  
                    </div>
                    <div class="function">
                        <a onclick="add(this)">新增类别</a>  
                    </div>


                </div>-->

            </li>
            <li></li>
        </ul>
    </div>
    </form>
</body>
<script src="../Scripts/jquery-3.1.0.min.js"></script>
<script src='../Scripts/treedom.js'></script>

    <script>
    $('.line').css({'width':$('.heardnav ul li').eq(0).width()+20,'left':11})    
    $('.heardnav ul li').each(function(i){
        $('.heardnav ul li').eq(i).click(function(){
            $('.heardnav ul li').eq(i).addClass('navNow').siblings().removeClass('navNow');
            $('.contentrs ul li').eq(i).show().siblings().hide();
            var left = i == 0 ? 11:i == 1 ? 11*2+$('.heardnav ul li').eq(0).width()+21:i == 2 ? 11*3+$('.heardnav ul li').eq(0).width()+$('.heardnav ul li').eq(1).width()+42:10;
            $('.line').css({'width':$('.heardnav ul li').eq(i).width()+20,'left':left})
        })
    })
   $('.treeul .treeli').children('.treep').children('a').eq(0).remove()
   $('.treeul .treeli').children('.treep').children('a').eq(0).remove()
    
   $('.treeul .treeli').children('.treep').children('a').eq(0).html('新增类别')

    function Add(){
       window.open("Newsubcategory.aspx","_blank","toolbar=yes, location=yes, directories=no, status=no, menubar=yes, scrollbars=yes, resizable=no, copyhistory=yes, width=400,height=200")
    }
    function Edit(){
        window.open("Editsubcategory.aspx","_blank","toolbar=yes, location=yes, directories=no, status=no, menubar=yes, scrollbars=yes, resizable=no, copyhistory=yes, width=400,height=200")
    }
    function Delete(){
        var r=confirm("Press a button!");
        if (r==true)
        {
           alert("You pressed OK!");
        }
        else
        {
            alert("You pressed Cancel!");
        }
    }
    function Down(){
        window.open("ImportKnowledgebase.aspx","_blank","toolbar=yes, location=yes, directories=no, status=no, menubar=yes, scrollbars=yes, resizable=no, copyhistory=yes, width=500,height=450")
    }
</script>
</html>
