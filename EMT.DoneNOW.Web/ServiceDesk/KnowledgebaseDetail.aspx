<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="KnowledgebaseDetail.aspx.cs" Inherits="EMT.DoneNOW.Web.ServiceDesk.KnowledgebaseDetail" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <link rel="stylesheet" type="text/css" href="../Content/repository.css" />
    <title>知识库详情</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            font-family: "微软雅黑";
            font-size: 14px;
            list-style: none;
        }

        h2 {
            font-size: 16px;
            font-weight: bold;
            padding: 5px 0;
            margin-top: 10px;
        }

        body {
            padding: 10px;
        }

        .box {
            padding: 10px;
            border: 1px solid #d3d3d3;
            margin-top: 10px;
        }

            .box p {
                padding: 2px 4px 6px 6px;
                color: #666;
                height: 16px;
                font-size: 14px;
                font-weight: bold;
            }

            .box .item {
                padding: 15px 30px;
                overflow: hidden;
            }

        .Information .item span:nth-of-type(1) {
            color: #4F4F4F;
            font-weight: bold;
            font-size: 12px;
            width: 100px;
            display: block;
            float: left;
        }

        .Information .item span:nth-of-type(2) {
            color: #4F4F4F;
            font-size: 12px;
            margin-left: 50px;
            display: block;
            float: left;
        }

        #comment {
            width: 100%;
            height: 100px;
            resize: none;
        }

        .btn {
            width: 150px;
            float: right;
            height: auto;
            margin-top: 20px;
        }

            .btn div {
                float: left;
                overflow: hidden;
            }

            .btn div {
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

                .btn div img {
                    float: left;
                    display: block;
                    margin-top: 2px;
                    margin-right: 5px;
                }

        .commentlist {
            margin-top: 50px;
            width: 100%;
            height: auto;
        }

            .commentlist li {
                width: 100%;
                height: auto;
                color: gray;
                font-size: 12px;
                font-weight: bold;
                margin-top: 10px;
            }

                .commentlist li .createdby img {
                    display: block;
                    float: left;
                    margin-top: 1px;
                    margin-right: 5px;
                    cursor: pointer;
                }

                .commentlist li .createdby {
                    font-size: 12px;
                }

                .commentlist li .commentitem {
                    font-weight: normal;
                    font-size: 14px;
                    margin-top: 10px;
                    padding-left: 21px;
                }

        .header {
            height: 40px;
            line-height: 40px;
            background: #346A95;
            padding: 0 10px;
            font-size: 18px;
            color: #FFFFFF;
        }

        .kbv_related_ticket_number_cell{font-size: 12px;}
        .kbv_related_ticket_number_cell a {
            text-decoration: none;
            color: #337ab7;
        }
        .kbv_attachment_cell{font-size: 12px;}
        .kbv_attachment_cell a {
            text-decoration: none;
            color: #337ab7;
        }
    </style>
</head>

<body>
    <form id="form1" runat="server">
        <div class="header"><%=thisArt.title %></div>
         <div class="heard">
            <ul>
                <li id="Edit" onclick="EditArt()">
                   编辑
                </li>
                <li onclick="DeleteArt()">
                    删除
                </li>
                <li>
                    <img src="../Images/print.png" alt="" />
                </li>
                <li onclick="javascript:window.close();">
                    <img src="../Images/cancel.png" alt="" />
                    取消
                </li>
            </ul>
        </div>
        <h2><%=thisArt.title %></h2>
        <div class="Information box">
            <p>文档信息</p>
            <div class="item">
                <span>文档目录</span> <span><a style="color: #376597;"><%=cataString %></a></span>
            </div>
            <div class="item">
                <span>关键字</span> <span><%=thisArt.keywords %></span>
            </div>
            <div class="item">
                <span>文章ID</span> <span><%=thisArt.oid %></span>
            </div>
            <div class="item">
                <span>错误代码</span> <span><%=thisArt.error_code %></span>
            </div>
            <div class="item">
                <span>发布对象</span> <span><%=publish!=null?publish.name:"" %></span>
            </div>
            <div class="item">
                <span>状态</span> <span><%=thisArt.is_active==1?"激活":"未激活"%></span>
            </div>
            <div class="item">
                <span>创建信息</span> <span><%=creater!=null?creater.name:"" %> (<%=EMT.Tools.Date.DateHelper.ConvertStringToDateTime(thisArt.create_time).ToString("yyyy-MM-dd HH:mm") %>)</span>
            </div>
            <div class="item">
                <span>最近更新</span> <span><%=update!=null?update.name:"" %> (<%=EMT.Tools.Date.DateHelper.ConvertStringToDateTime(thisArt.update_time).ToString("yyyy-MM-dd HH:mm") %>)</span>
            </div>
        </div>
        <div class="content box">
            <p>文章内容</p>
            <div class="item">
                <%=thisArt.article_body_no_markup %>
            </div>
        </div>
        <% if (ticList != null && ticList.Count > 0)
            { %>
        <div class="content box">
            <p>相关工单</p>
            <div id="kbv_related_ticket_item" class="Content">
                <table border="0">
                    <tbody>
                        <% foreach (var tic in ticList)
                            {
                                var thisTick = dtDal.FindNoDeleteById(tic.task_id);
                                if (thisTick == null)
                                {
                                    continue;
                                }
                                var thisAcc = comBLL.GetCompany(thisTick.account_id);

                        %>
                        <tr>
                            <td class="kbv_related_ticket_number_cell"><a onclick="ViewTicket('<%=thisTick.id %>')"><%=thisTick.no %></a></td>
                            <td class="kbv_related_ticket_title_cell"><span class="lblNormalClass" style="font-weight: bold;"></span></td>
                            <td><%=thisTick.title %> <%=thisAcc!=null?$"({thisAcc.name})":"" %> </td>
                        </tr>
                        <%} %>
                    </tbody>
                </table>
            </div>
        </div>
        <%} %>
        <%if (thisNoteAtt != null && thisNoteAtt.Count > 0)
            { %>
        <div class="content box">
            <p>附件</p>
            <div id="kbv_attachments_item" class="Content">
                <table border="0">
                    <tbody>
                        <%foreach (var att in thisNoteAtt)
                            {%>
                        <tr>
                            <td class="kbv_attachment_cell">
                                <a onclick="OpenAttach(<%=att.id %>)"><%=att.title %></a>
                                <span class="lblNormalClass" style="font-weight: normal;"><%=att.filename %></span>
                            </td>
                        </tr>
                        <%} %>
                    </tbody>
                </table>
            </div>
        </div>
        <%} %>
        <div class="comments box">
            <p>评论</p>
            <div class="item">
                <p style="padding: 0; font-size: 12px;">输入你的评论:</p>
                <textarea name="comment" id="comment"></textarea>
                <div class="btn">
                    <div class="save" onclick="SaveComment()">
                        <img src="../Images/save.png" alt="" />
                        保存
                    </div>
                    <div class="cancel" onclick="ClearComment()">
                        <img src="../Images/cancel.png" alt="" />
                        取消
                    </div>
                </div>
                <%if (commList != null && commList.Count > 0)
                    {
                        foreach (var thisComm in commList)
                        {
                            var thisRes = srDal.FindById(thisComm.create_user_id);
                %>
                <ul class="commentlist">
                    <li>
                        <div class="createdby">
                            <img onclick="Delete('<%=thisComm.id %>')" src="../Images/delete.png" alt="">
                            <%=EMT.Tools.Date.DateHelper.ConvertStringToDateTime(thisComm.create_time).ToString("yyyy-MM-dd HH:mm") %> -<%=thisRes!=null?thisRes.name:"" %>
                        </div>
                        <div class="commentitem">
                            <%=thisComm.comment %>
                        </div>
                    </li>

                </ul>
                <% }
                    } %>
            </div>
        </div>
    </form>
</body>
<script src="../Scripts/jquery-3.1.0.min.js"></script>
<script type="text/javascript" src="../Scripts/common.js"></script>
<script>
    function Delete(artComId) {
        LayerConfirm("删除无法恢复，你想继续吗？", "是", "否", function () {
            $.ajax({
                type: "GET",
                async: false,
                url: "../Tools/KnowledgeAjax.ashx?act=DeleteComment&artComId=" + artComId,
                dataType: 'json',
                success: function (data) {
                    if (data) {
                        LayerMsg("删除成功！");
                    } else {
                        LayerMsg("删除失败！");
                    }
                    setTimeout(function () { history.go(0); }, 800);
                },
            });
        }, function () { });
    }

    function ViewTicket(ticketId) {
        window.open("../ServiceDesk/TicketView?id=" + ticketId, windowType.blank, 'left=200,top=200,width=1280,height=800', false);
    }
    function SaveComment() {
        var comment = $("#comment").val();
        if (comment != "") {
            $.ajax({
                type: "GET",  
                async: false,
                url: "../Tools/KnowledgeAjax.ashx?act=SaveComment&artId=<%=thisArt.id %>&comment=" + comment,
                dataType: 'json',
                success: function (data) {
                    if (data) {
                        LayerMsg("保存成功！");
                    } else {
                        LayerMsg("保存失败！");
                    }
                    setTimeout(function () { history.go(0); }, 800);
                },
            });
        }
    }
    function ClearComment() {
        $("#comment").val("");
    }
    function OpenAttach(attId) {
        window.open("../Activity/OpenAttachment.aspx?id=" + attId, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.TASK_ATTACH %>', 'left=200,top=200,width=1080,height=800', false);

    }
    function EditArt() {
        window.open("../ServiceDesk/AddRepository.aspx?id=<%=thisArt.id %>", windowObj.kbArticle + windowType.edit, 'left=200,top=200,width=1080,height=800', false);
    }
    function DeleteArt() {
        LayerConfirm("删除无法恢复，你想继续吗？", "是", "否", function () {
            $.ajax({
                type: "GET",
                async: false,
                url: "../Tools/KnowledgeAjax.ashx?act=DeleteArt&artId=<%=thisArt.id %>",
                dataType: 'json',
                success: function (data) {
                    if (data) {
                        LayerMsg("删除成功！");
                    } else {
                        LayerMsg("删除失败！");
                    }
                    self.parent.location.reload();
                    window.close();
                },
            });
        }, function () { });
    }
</script>
</html>
