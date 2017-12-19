<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ApproveAndPost.aspx.cs" Inherits="EMT.DoneNOW.Web.ApproveAndPost" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title></title>
    <link href="../Content/reset.css" rel="stylesheet" />
    <link href="../Content/SysSettingRoles.css" rel="stylesheet" />
    <link rel="stylesheet" type="text/css" href="../Content/style.css" />
    <style>
        body {
    overflow: hidden;
    margin:0;
    background:#fff;
}
        #menu {
            position: absolute;
            z-index: 999;
            display: none;
        }

            #menu ul {
                margin: 0;
                padding: 0;
                position: relative;
                width: 150px;
                border: 1px solid gray;
                background-color: #F5F5F5;
                padding: 10px 0;
            }

                #menu ul li {
                    padding-left: 20px;
                    height: 25px;
                    line-height: 25px;
                    cursor: pointer;
                }

                    #menu ul li ul {
                        display: none;
                        position: absolute;
                        right: -150px;
                        top: -1px;
                        background-color: #F5F5F5;
                        min-height: 90%;
                    }

                        #menu ul li ul li:hover {
                            background: #e5e5e5;
                        }

                    #menu ul li:hover {
                        background: #e5e5e5;
                    }

                        #menu ul li:hover ul {
                            display: block;
                        }

                    #menu ul li .menu-i1 {
                        width: 20px;
                        height: 100%;
                        display: block;
                        float: left;
                    }

                    #menu ul li .menu-i2 {
                        width: 20px;
                        height: 100%;
                        display: block;
                        float: right;
                    }

                #menu ul .disabled {
                    color: #AAAAAA;
                }

        @media screen and (max-width: 1430px) {
            .cont {
                width: 1200px;
                margin: 60px 2% 0 2%;
                position: absolute;
                z-index: 1;
            }
        }
    </style>
</head>
<body>
    <form id="form1" runat="server" method="post">
        <div>
            <div class="TitleBar">
    <div class="Title">
        <span class="text1">审批并提交</span>
        <a href="#" class="help"></a>
    </div>
            </div>
            <!--切换按钮-->
            <div class="TabBar">
                <a class="Button ButtonIcon"  href="../Common/SearchFrameSet.aspx?isCheck=1&cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.APPROVE_LABOUR %>" target="PageFrame1" id="tab1">
                    <span class="Text">工时</span>
                </a>
                <a class="Button ButtonIcon SelectedState" href="../Common/SearchFrameSet.aspx?isCheck=1&cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.APPROVE_CHARGES %>" target="PageFrame1" id="tab2">
                    <span class="Text">成本</span>
                </a>
                <a class="Button ButtonIcon"  href="../Common/SearchFrameSet.aspx?isCheck=1&cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.APPROVE_EXPENSE %>" target="PageFrame1" id="tab3">
                    <span class="Text">费用</span>
                </a>
                <a class="Button ButtonIcon" href="../Common/SearchFrameSet.aspx?isCheck=1&cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.APPROVE_SUBSCRIPTIONS %>" target="PageFrame1" id="tab4">
                    <span class="Text">订阅</span>
                </a>
                <a class="Button ButtonIcon" href="../Common/SearchFrameSet.aspx?isCheck=1&cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.APPROVE_RECURRING_SERVICES %>" target="PageFrame1" id="tab5">    
                    <span class="Text">定期服务</span>
                </a>
                <a class="Button ButtonIcon"  href="../Common/SearchFrameSet.aspx?isCheck=1&cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.APPROVE_MILESTONES %>" target="PageFrame1" id="tab6">
                    <span class="Text">里程碑</span>
                </a>
            </div>
           <div class="TabContainer" style="min-width: 700px;" id="tabcont1">
                <div class="cont">
                    <iframe id="PageFrame1" name="PageFrame1" style="width:100%;" src="../Common/SearchFrameSet.aspx?isCheck=1&cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.APPROVE_CHARGES %>"></iframe>
                </div>
            </div>
        </div>
        <script src="../Scripts/jquery-3.1.0.min.js"></script>
        <script src="../Scripts/Common/SearchBody.js" type="text/javascript" charset="utf-8"></script>
        <script>
           
            $(window).resize(function () {
                var Height = $(document).height() - 66 + "px";
                $("#PageFrame1").css("height", Height);
            })
            var Height = $(document).height() - 66 + "px";
            $("#PageFrame1").css("height", Height);
            //工时
            $("#tab1").click(function () {
               
                $(this).addClass("SelectedState").siblings("a").removeClass("SelectedState");
            });
            //成本
            $("#tab2").click(function () {
                $(this).addClass("SelectedState").siblings("a").removeClass("SelectedState");               
            });
            //费用
            $("#tab3").click(function () {
               
                $(this).addClass("SelectedState").siblings("a").removeClass("SelectedState");
            });
            //订阅
            $("#tab4").click(function () {
                $(this).addClass("SelectedState").siblings("a").removeClass("SelectedState");
            });
            //定期服务
            $("#tab5").click(function () {
                $(this).addClass("SelectedState").siblings("a").removeClass("SelectedState");
            });
            //里程碑
            $("#tab6").click(function () {
                $(this).addClass("SelectedState").siblings("a").removeClass("SelectedState");
            });
        </script>       
    </form>
</body>
</html>
