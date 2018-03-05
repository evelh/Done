<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ReportHomePage.aspx.cs" Inherits="EMT.DoneNOW.Web.Reports.ReportHomePage" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <link href="../Content/Admin.css" rel="stylesheet" />
    <link href="../Content/ClassificationIcons.css" rel="stylesheet" />
    <title></title>
    <style>
        .StandardText {
            display: none;
        }

        .Large {
            margin-top: 15px;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <div id="body">
                <!--顶部-->
                <div class="TitleBar">
                    <div class="Title">
                        <span class="text1">报表</span>
                        <a href="###" class="collection"></a>
                        <a href="###" class="help"></a>
                    </div>
                </div>
                <!--选择框-->
                <div class="TabBar">
                    <a class="Button ButtonIcon SelectedState">
                        <span class="Text">CRM</span>
                    </a>
                    <a class="Button ButtonIcon">
                        <span class="Text">项目</span>
                    </a>
                    <a class="Button ButtonIcon">
                        <span class="Text">服务台</span>
                    </a>
                    <a class="Button ButtonIcon">
                        <span class="Text">合同计费</span>
                    </a>
                </div>
                <div class="ScrollingContainer Active" style="top: 82px; bottom: 0;">
                    <!--第一部分-->
                    <div class="TabContainer TabContainer1 Active">
                        <div class="ButtonContainer">
                            <a class="Button ButtonIcon NormalState" tabindex="0" id="d1">
                                <span class="Text">展开所有</span>
                            </a>
                            <a class="Button ButtonIcon NormalState" tabindex="0" id="d2">
                                <span class="Text">折叠所有</span>
                            </a>
                        </div>
                        <!--第三个框-->
                        <%if (CheckAuth("SYS_FEATURES_RESOURCES"))
                            { %>
                        <div class="Normal Section Collapsed Normal1 col" id="b3">
                            <div class="Heading">
                                <div class="Toggle Expand Toggle1" id="a3">
                                    <div class="Vertical Vertical1"></div>
                                    <div class="Horizontal"></div>
                                </div>
                                <span class="Text">客户</span>
                                <span></span>
                            </div>
                            <div class="Content Content1" id="c3">
                                <div class="Large Column">
                                    <div class="PageNavigationLinkGroup">
                                       
                                    </div>
                                   
                                </div>
                            </div>
                        </div>
                        <%}%>
                        <!--第四个框-->
                        <%if (CheckAuth("SYS_FEATURES_COMPANY_CONTACT"))
                            { %>
                        <div class="Normal Section Collapsed Normal1 col" id="b4">
                            <div class="Heading">
                                <div class="Toggle Expand Toggle1" id="a4">
                                    <div class="Vertical Vertical1"></div>
                                    <div class="Horizontal"></div>
                                </div>
                                <span class="Text">配置项</span>
                                <span></span>
                            </div>
                            <div class="Content Content1" id="c4">
                                <div class="Large Column">
                                    <div class="PageNavigationLinkGroup">
                                       <div class="PageNavigationLinkColumn">
                                            
                                            <div class="PageNavigationLink">
                                                <a href="../Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.REPORT_CRM_INSPRO_DETAIL %>" target="PageFrame1" class="Button ButtonIcon Link NormalState chaxun">配置项详情</a>
                                                <div class="StandardText">介绍介绍</div>
                                            </div>
                                            
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <%}%>
                        <!--第五个框-->
                        <%if (CheckAuth("SYS_FEATURES_SALES_OPPS"))
                            { %>
                        <div class="Normal Section Collapsed Normal1 col" id="b5">
                            <div class="Heading">
                                <div class="Toggle Expand Toggle1" id="a5">
                                    <div class="Vertical Vertical1"></div>
                                    <div class="Horizontal"></div>
                                </div>
                                <span class="Text">商机</span>
                                <span></span>
                            </div>
                            <div class="Content Content1" id="c5">
                                <div class="Large Column">
                                    <div class="PageNavigationLinkGroup">
                                       
                                    </div>
                                   
                                </div>
                            </div>
                        </div>
                        <%}%>
                        <!--第六个框-->
                        <%if (CheckAuth("SYS_FEATURES_CONTRACT"))
                            { %>
                        <div class="Normal Section Collapsed Normal1 col" id="b6">
                            <div class="Heading">
                                <div class="Toggle Expand Toggle1" id="a6">
                                    <div class="Vertical Vertical1"></div>
                                    <div class="Horizontal"></div>
                                </div>
                                <span class="Text">导出</span>
                                <span></span>
                            </div>
                            <div class="Content Content1" id="c6">
                                <div class="Large Column">
                                    <div class="PageNavigationLinkGroup">
                                        <div class="PageNavigationLinkColumn">
                                            
                                            <div class="PageNavigationLink">
                                                <a href="../Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.REPORT_CRM_EXPORT_COMPANY %>" target="PageFrame1" class="Button ButtonIcon Link NormalState chaxun">导出客户</a>
                                                <div class="StandardText">介绍介绍</div>
                                            </div>
                                            
                                        </div>
                                        <div class="PageNavigationLinkColumn">
                                            
                                            <div class="PageNavigationLink">
                                                <a href="../Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.REPORT_CRM_EXPORT_CONTACT %>" target="PageFrame1" class="Button ButtonIcon Link NormalState chaxun">导出联系人</a>
                                                <div class="StandardText">介绍介绍</div>
                                            </div>
                                            
                                        </div>
                                    </div>
                                   
                                </div>
                            </div>
                        </div>
                        <%}%>
                    </div>
                    <!--第二部分-->
                    <div class="TabContainer TabContainer2">
                        <div class="ButtonContainer">
                            <a class="Button ButtonIcon NormalState" tabindex="0" id="d3">
                                <span class="Text">展开所有</span>
                            </a>
                            <a class="Button ButtonIcon NormalState" tabindex="0" id="d4">
                                <span class="Text">折叠所有</span>
                            </a>
                        </div>
                        <!--第一个框-->
                        <div class="Normal Collapsed Section Normal2 col" id="f1">
                            <div class="Heading">
                                <div class="Toggle Expand Toggle2" id="e1">
                                    <div class="Vertical Vertical2"></div>
                                    <div class="Horizontal"></div>
                                </div>
                                <span class="Text">自动任务加载项</span>
                                <span></span>
                            </div>
                            <div class="Content Content2" id="g1">
                                <div class="Large Column">
                                    <div class="PageNavigationLinkGroup">
                                        <div class="PageNavigationLinkColumn">
                                            <div class="PageNavigationLink">
                                                <a class="Button ButtonIcon Link NormalState chaxun">占位</a>
                                                <div class="StandardText">介绍介绍</div>
                                            </div>
                                            <div class="PageNavigationLink">
                                                <a class="Button ButtonIcon Link NormalState chaxun">占位</a>
                                                <div class="StandardText">介绍介绍</div>
                                            </div>
                                            <div class="PageNavigationLink">
                                                <a class="Button ButtonIcon Link NormalState chaxun">占位</a>
                                                <div class="StandardText">介绍介绍</div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <!--第二个框-->
                        <div class="Normal Collapsed Section Normal2 col" id="f2">
                            <div class="Heading">
                                <div class="Toggle Expand Toggle2" id="e2">
                                    <div class="Vertical Vertical2"></div>
                                    <div class="Horizontal"></div>
                                </div>
                                <span class="Text">端点管理</span>
                                <span></span>
                            </div>
                            <div class="Content Content2" id="g2">
                                <div class="Large Column">
                                    <div class="Resizable Instructions">
                                        <div class="InstructionItem oh">
                                            <p class="fl">如果您是当前端点管理用户，则必须从端点管理中启用自动任务集成。不使用端点管理了吗？</p>
                                            <a class="Button ButtonIcon Link NormalState fl">点击这里</a>
                                            <p class="fl">，了解它如何帮助您提高收入，同时更好地服务于客户最大限度地提高效率。</p>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <!--第三个框-->
                        <div class="Normal Collapsed Section Normal2 col" id="f3">
                            <div class="Heading">
                                <div class="Toggle Expand Toggle2" id="e3">
                                    <div class="Vertical Vertical2"></div>
                                    <div class="Horizontal"></div>
                                </div>
                                <span class="Text">客户端门户与TASKFIRE</span>
                                <span></span>
                            </div>
                            <div class="Content Content2" id="g3">
                                <div class="Large Column">
                                    <div class="PageNavigationLinkGroup">
                                        <div class="PageNavigationLinkColumn">
                                            <div class="PageNavigationLink">
                                                <a class="Button ButtonIcon Link NormalState chaxun">占位</a>
                                                <div class="StandardText">介绍介绍</div>
                                            </div>
                                            <div class="PageNavigationLink">
                                                <a class="Button ButtonIcon Link NormalState chaxun">占位</a>
                                                <div class="StandardText">介绍介绍</div>
                                            </div>
                                            <div class="PageNavigationLink">
                                                <a class="Button ButtonIcon Link NormalState chaxun">占位</a>
                                                <div class="StandardText">介绍介绍</div>
                                            </div>
                                            <div class="PageNavigationLink">
                                                <a class="Button ButtonIcon Link NormalState chaxun">占位</a>
                                                <div class="StandardText">介绍介绍</div>
                                            </div>
                                            <div class="PageNavigationLink">
                                                <a class="Button ButtonIcon Link NormalState chaxun">占位</a>
                                                <div class="StandardText">介绍介绍</div>
                                            </div>
                                        </div>
                                        <div class="PageNavigationLinkColumn">
                                            <div class="PageNavigationLink">
                                                <a class="Button ButtonIcon Link NormalState chaxun">占位</a>
                                                <div class="StandardText">介绍介绍</div>
                                            </div>
                                            <div class="PageNavigationLink">
                                                <a class="Button ButtonIcon Link NormalState chaxun">占位</a>
                                                <div class="StandardText">介绍介绍</div>
                                            </div>
                                            <div class="PageNavigationLink">
                                                <a class="Button ButtonIcon Link NormalState chaxun">占位</a>
                                                <div class="StandardText">介绍介绍</div>
                                            </div>
                                            <div class="PageNavigationLink">
                                                <a class="Button ButtonIcon Link NormalState chaxun">占位</a>
                                                <div class="StandardText">介绍介绍</div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <!--第三部分-->
                    <div class="TabContainer TabContainer3">
                        <div class="ButtonContainer">
                            <a class="Button ButtonIcon NormalState" tabindex="0" id="d5">
                                <span class="Text">展开所有</span>
                            </a>
                            <a class="Button ButtonIcon NormalState" tabindex="0" id="d6">
                                <span class="Text">折叠所有</span>
                            </a>
                        </div>
                        <!--第一个框-->
                        <div class="Normal Collapsed Section Normal3 col" id="">
                            <div class="Heading">
                                <div class="Toggle Expand Toggle3" id="">
                                    <div class="Vertical Vertical3"></div>
                                    <div class="Horizontal"></div>
                                </div>
                                <span class="Text">常规</span>
                                <span></span>
                            </div>
                            <div class="Content Content3" id="g1">
                                <div class="Large Column">
                                    <div class="PageNavigationLinkGroup">
                                        <div class="PageNavigationLinkColumn">
                                            <div class="PageNavigationLink">
                                                <a href="../Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.REPORT_SERVICEDESK_TICKETBYACCOUNT %>" target="PageFrame1" class="Button ButtonIcon Link NormalState chaxun">工单和任务按客户</a>
                                                <div class="StandardText">介绍介绍</div>
                                            </div>
                                            <div class="PageNavigationLink">
                                                <a class="Button ButtonIcon Link NormalState chaxun">占位</a>
                                                <div class="StandardText">介绍介绍</div>
                                            </div>
                                            <div class="PageNavigationLink">
                                                <a class="Button ButtonIcon Link NormalState chaxun">占位</a>
                                                <div class="StandardText">介绍介绍</div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <!--第四部分-->
                    <div class="TabContainer TabContainer4">
                        <div class="ButtonContainer">
                            <a class="Button ButtonIcon NormalState" tabindex="0" id="d7">
                                <span class="Text">展开所有</span>
                            </a>
                            <a class="Button ButtonIcon NormalState" tabindex="0" id="d8">
                                <span class="Text">折叠所有</span>
                            </a>
                        </div>
                        <!--第一个框-->
                        <div class="Normal Collapsed Section Normal4 col" id="f1">
                            <div class="Heading">
                                <div class="Toggle Expand Toggle4" id="e1">
                                    <div class="Vertical Vertical4"></div>
                                    <div class="Horizontal"></div>
                                </div>
                                <span class="Text">合同</span>
                                <span></span>
                            </div>
                            <div class="Content Content4" id="g1">
                                <div class="Large Column">
                                    <div class="PageNavigationLinkGroup">
                                        <div class="PageNavigationLinkColumn">
                                            <div class="PageNavigationLink">
                                                <a class="Button ButtonIcon Link NormalState chaxun">占位</a>
                                                <div class="StandardText">介绍介绍</div>
                                            </div>
                                            <div class="PageNavigationLink">
                                                <a class="Button ButtonIcon Link NormalState chaxun">占位</a>
                                                <div class="StandardText">介绍介绍</div>
                                            </div>
                                            <div class="PageNavigationLink">
                                                <a class="Button ButtonIcon Link NormalState chaxun">占位</a>
                                                <div class="StandardText">介绍介绍</div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <!--第二个框-->
                        <div class="Normal Collapsed Section Normal4 col" id="f2">
                            <div class="Heading">
                                <div class="Toggle Expand Toggle4" id="e2">
                                    <div class="Vertical Vertical4"></div>
                                    <div class="Horizontal"></div>
                                </div>
                                <span class="Text">计费</span>
                                <span></span>
                            </div>
                            <div class="Content Content4" id="g2">
                                <div class="Large Column">
                                   <div class="PageNavigationLinkGroup">
                                        <div class="PageNavigationLinkColumn">
                                            <div class="PageNavigationLink">
                                                <a href="../Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.REPORT_CONTRACT_BILLED %>" target="PageFrame1" class="Button ButtonIcon Link NormalState chaxun">已计费信息</a>
                                                <div class="StandardText">介绍介绍</div>
                                            </div>
                                            <div class="PageNavigationLink">
                                                <a class="Button ButtonIcon Link NormalState chaxun">占位</a>
                                                <div class="StandardText">介绍介绍</div>
                                            </div>
                                            <div class="PageNavigationLink">
                                                <a class="Button ButtonIcon Link NormalState chaxun">占位</a>
                                                <div class="StandardText">介绍介绍</div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <!--第三个框-->
                        <div class="Normal Collapsed Section Normal4" id="">
                            <div class="Heading">
                                <div class="Toggle Expand Toggle4" id="">
                                    <div class="Vertical Vertical4"></div>
                                    <div class="Horizontal"></div>
                                </div>
                                <span class="Text">客户端门户与TASKFIRE</span>
                                <span></span>
                            </div>
                            <div class="Content Content4" id="">
                                <div class="Large Column">
                                    <div class="PageNavigationLinkGroup">
                                        <div class="PageNavigationLinkColumn">
                                            <div class="PageNavigationLink">
                                                <a class="Button ButtonIcon Link NormalState chaxun">占位</a>
                                                <div class="StandardText">介绍介绍</div>
                                            </div>
                                            <div class="PageNavigationLink">
                                                <a class="Button ButtonIcon Link NormalState chaxun">占位</a>
                                                <div class="StandardText">介绍介绍</div>
                                            </div>
                                            <div class="PageNavigationLink">
                                                <a class="Button ButtonIcon Link NormalState chaxun">占位</a>
                                                <div class="StandardText">介绍介绍</div>
                                            </div>
                                            <div class="PageNavigationLink">
                                                <a class="Button ButtonIcon Link NormalState chaxun">占位</a>
                                                <div class="StandardText">介绍介绍</div>
                                            </div>
                                            <div class="PageNavigationLink">
                                                <a class="Button ButtonIcon Link NormalState chaxun">占位</a>
                                                <div class="StandardText">介绍介绍</div>
                                            </div>
                                        </div>
                                        <div class="PageNavigationLinkColumn">
                                            <div class="PageNavigationLink">
                                                <a class="Button ButtonIcon Link NormalState chaxun">占位</a>
                                                <div class="StandardText">介绍介绍</div>
                                            </div>
                                            <div class="PageNavigationLink">
                                                <a class="Button ButtonIcon Link NormalState chaxun">占位</a>
                                                <div class="StandardText">介绍介绍</div>
                                            </div>
                                            <div class="PageNavigationLink">
                                                <a class="Button ButtonIcon Link NormalState chaxun">占位</a>
                                                <div class="StandardText">介绍介绍</div>
                                            </div>
                                            <div class="PageNavigationLink">
                                                <a class="Button ButtonIcon Link NormalState chaxun">占位</a>
                                                <div class="StandardText">介绍介绍</div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div id="chaxun" style="display: none">
                <!--标题-->
                <div class="TitleBar">
                    <div class="Title">
                        <div class="TitleBarNavigationButton">
                            <a class="Button ButtonIcon NormalState" id="black">
                                <img src="../Images/move-left.png" /></a>
                        </div>
                        <span class="text1" id="opname"></span>
                        <a href="###" class="collection"></a>
                        <a href="###" class="help"></a>
                    </div>
                </div>
                <!--背景布-->
                <div id="WorkspaceContainer"></div>
                <div class="cont">
                    <iframe id="PageFrame1" style="width: 100%; border: none; margin: 0;" name="PageFrame1"></iframe>
                </div>
            </div>
        </div>
    </form>
    <script src="../Scripts/jquery-3.1.0.min.js"></script>
    <script src="../Scripts/Report.js"></script>
    <script src="Scripts/index.js" type="text/javascript" charset="utf-8"></script>
    <script>
        $(window).resize(function () {
            var Height = $(document).height() - 66 + "px";
            $("#PageFrame1").css("height", Height);
        })
        var Height = $(document).height() - 66 + "px";
        $("#PageFrame1").css("height", Height);

        $(".chaxun").on("click", function () {
            $("#body").hide();
            var kk = $(this).text();
            $("#opname").text(kk);
            var kkk = $("#opname").text();
            setTimeout(function () {
                $("#chaxun").show();
            }, 300)
        });
        $("#black").click(function () {
            $("#chaxun").hide();
            $("#body").show();
        });
        function black() {
            $("#chaxun").hide();
            $("#body").show();
        }
    </script>
</body>
</html>
