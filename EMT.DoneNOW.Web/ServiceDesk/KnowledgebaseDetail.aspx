<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="KnowledgebaseDetail.aspx.cs" Inherits="EMT.DoneNOW.Web.ServiceDesk.KnowledgebaseDetail" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
</head>
    <style lang="">
    *{margin: 0;padding: 0;font-family: "微软雅黑";font-size: 14px;list-style: none;}
    h2{font-size: 16px;font-weight: bold;padding: 5px 0; margin-top:10px;}
    body{padding: 10px;}
    .box{padding: 10px;border:1px solid #d3d3d3;margin-top:10px; }
    .box p{
        padding: 2px 4px 6px 6px;
        color: #666;
        height: 16px;
        font-size: 14px;
        font-weight: bold;
    }
    .box .item{padding:15px 30px;overflow: hidden; }
    .Information .item span:nth-of-type(1){color: #4F4F4F;font-weight: bold;font-size: 12px;width: 100px;display: block;float: left;}
    .Information .item span:nth-of-type(2){color: #4F4F4F;font-size: 12px;margin-left: 50px;display: block;float: left;}
    #comment{width: 100%;height: 100px;resize: none;}
    .btn{width:150px;float: right;height:  auto;margin-top:20px;}
    .btn div{float: left;overflow: hidden;}
    .btn div{
        padding: 3px 5px;
        cursor: pointer;
        border: 1px solid #BCBCBC;
        background: #d7d7d7;
        background: linear-gradient(to bottom,#fff 0,#d7d7d7 100%);
        color: #4F4F4F;
        line-height: 20px;
        margin-left: 10px;
        font-size: 14px;
    }
    .btn div img{float: left;display: block;margin-top:2px;margin-right: 5px;}
    .commentlist{margin-top:50px;width: 100%;height: auto;}
    .commentlist li{width: 100%;height: auto;color: gray;font-size: 12px;font-weight: bold;margin-top:10px;}
    .commentlist li .createdby img{display: block;float: left;margin-top: 1px;margin-right: 5px;cursor: pointer;}
    .commentlist li .createdby{font-size: 12px;}
    .commentlist li .commentitem{font-weight: normal;font-size: 14px;margin-top:10px;padding-left:21px; }

</style>
<body>
    <form id="form1" runat="server">
       <h2>texst</h2>
    <div class="Information box">
        <p>一般信息</p>
        <div class="item">
            <span>文档目录</span> <span><a style="color: #376597;">all</a> > <a style="color: #376597;">1a</a></span>
        </div>
         <div class="item">
            <span>文章ID</span> <span>3</span>
        </div>
         <div class="item">
            <span>发布对象</span> <span>所有用户</span>
        </div>
         <div class="item">
            <span>状态</span> <span>激活</span>
        </div>
         <div class="item">
            <span>创建信息</span> <span>LI，Hong (2018/3/3 12：11 PM)</span>
        </div>
    </div>
    <div class="content box">
        <p>文章内容</p>
        <div class="item">
            asdasd
        </div>
    </div>
    <div class="comments box">
        <p>评论</p>
        <div class="item">
           <p style="padding: 0;font-size: 12px;">输入你的评论:</p>
           <textarea name="comment" id="comment" ></textarea>
           <div class="btn">
               <div class="save">
                   <img src="../Images/save.png" alt="">
                   保存
               </div>
               <div class="cancel">
                   <img src="../Images/cancel.png" alt="">
                   取消
               </div>
           </div>
           <ul class="commentlist">
               <li>
                   <div class="createdby">
                       <img onclick="Delete()" src="../Images/delete.png" alt="">
                       2018/3/3 12：12 PM -li.li
                   </div>
                   <div class="commentitem">
                       55
                   </div>
               </li>
               <li>
                   <div class="createdby">
                       <img onclick="Delete()" src="../Images/delete.png" alt="">
                       2018/3/3 12：12 PM -li.li
                   </div>
                   <div class="commentitem">
                       55
                   </div>
               </li>
           </ul>
        </div>
    </div>
    </form>
</body>
<script src="../Scripts/jquery-3.1.0.min.js"></script>
<script>
    function Delete(){
        var r=confirm("删除无法恢复，你想继续吗？");
        if (r==true)
        {
        //    alert("You pressed OK!");
        }
        else
        {
            // alert("You pressed Cancel!");
        }
    }
</script>
</html>
