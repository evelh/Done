<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="MoveDeduction.aspx.cs" Inherits="EMT.DoneNOW.Web.Contract.MoveDeduction" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>移动预览</title>
    <link rel="stylesheet" type="text/css" href="../Content/base.css" />
    <link rel="stylesheet" type="text/css" href="../Content/bootstrap.min.css" />
    <link href="../Content/index.css" rel="stylesheet" />
    <link href="../Content/style.css" rel="stylesheet" />
    <link rel="stylesheet" type="text/css" href="../Content/multipleList.css" />
    <style>
        .bold {
            display: inline-block;
            color: #151515;
            font-size: 14px;
            width: 170px;
            font-weight: 700;
            height: 30px;
            line-height: 30px;
            overflow: hidden;
        }

        .content input {
            margin-left: 0px;
        }

        .content select {
            margin-left: 0px;
        }

        .content textarea {
            margin-left: 0px;
        }

        td {
            padding-left: 35px;
            text-align: left;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="header">移动预览</div>
        <div class="header-title">
            <ul>
                <li><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -32px 0;" class="icon-1"></i>
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
                    <p class="informationTitle"><i></i>源条目信息</p>
                    <div>
                        <table border="none" cellspacing="" cellpadding="" style="width: 400px;">
                            <% if (block != null)
                                {%>
                            <tr>
                                <td>
                                    <span class="bold">合同名称</span>
                                    <div>
                                        <span><%=contract?.name %></span>
                                    </div>

                                </td>
                                <td>
                                    <%if (contract?.type_id == (int)EMT.DoneNOW.DTO.DicEnum.CONTRACT_TYPE.RETAINER) {%>
                                     <span class="bold">预付费</span>
                                    <div>
                                        <span><%=block.start_date.ToString("yyyy-MM-dd")+" - "+block.end_date.ToString("yyyy-MM-dd") %> <%=block.status_id==0?$"(停用)":"" %></span>
                                    </div>
                                    <% } %>
                                </td>
                            </tr>
                             <%if (contract?.type_id == (int)EMT.DoneNOW.DTO.DicEnum.CONTRACT_TYPE.RETAINER) {%>
                             <tr>
                               
                                <td>
                                    <span class="bold">扣除数量</span>
                                    <div>
                                        <span><%=(dedNum??0).ToString("#0.00") %></span>
                                    </div>
                                </td>
                                  <td>
                                   
                                </td>
                            </tr>
                                    <% } %>

                             <%if (contract?.type_id == (int)EMT.DoneNOW.DTO.DicEnum.CONTRACT_TYPE.BLOCK_HOURS) {%>
                               <tr>
                                <td>
                                    <span class="bold">预付时间/预付费有效期</span>
                                    <div>
                                        <span><%=block.start_date.ToString("yyyy-MM-dd")+" - "+block.end_date.ToString("yyyy-MM-dd") %><%=block.status_id==0?$"(停用)":"" %></span>
                                    </div>
                                </td>
                                <td>
                                    <span class="bold">扣除数量</span>
                                    <div>
                                          <span><%=(dedNum??0).ToString("#0.00") %></span>
                                    </div>
                                </td>
                            </tr>
                                    <% } %>
                         
                            <tr>
                                <td>
                                    <span class="bold">剩余数量</span>
                                    <div>
                                        <span><%=befotMoveNum.ToString("#0.00") %></span>
                                    </div>
                                </td>
                                <td>
                                    <span class="bold">移动后剩余数量</span>
                                    <div>
                                       <span><%=(befotMoveNum+(dedNum??0)).ToString("#0.00") %></span>
                                    </div>
                                </td>
                            </tr>
                            <%}
                                else
                                { %>
                            <tr>
                                <td><span>非预付时间扣除</span></td>
                            </tr>
                            <%} %>
                        </table>
                    </div>
                </div>
                <div class="information clear">
                    <p class="informationTitle"><i></i>目标信息</p>
                    <div>
                        <table border="none" cellspacing="" cellpadding="" style="width: 400px;">
                            <tr>
                                <td colspan="2">
                                    <span class="bold">移动条目到<span style="color: red;">*</span></span>
                                    <div>
                                        <select id="ToblockSelect" name="ToblockSelect" style="width: 280px; height: 25px;">
                                            <option></option>
                                            <%if (block != null)
                                                { %>
                                            <option value="0">不扣除</option>
                                            <%} %>
                                            <%if (dic != null && dic.Count > 0)
                                                {
                                                    foreach (var thisDic in dic)
                                                    {%>
                                            <option disabled="disabled" class="bold" ><%=thisDic.Value[0].contract_name %> <%=thisDic.Value[0].account_id!=deduction.account_id?"(父合同)":"" %> </option>
                                            <%  foreach (var thisList in thisDic.Value)
                                                {%>
                                            <option value="<%=thisList.id.ToString() %>">&nbsp;&nbsp;&nbsp; <%=thisList.balance.ToString("#0.0000")+$"[{thisList.start_date.ToString("yyyy-MM-dd")} - {thisList.end_date.ToString("yyyy-MM-dd")}]" %> <%=thisList.status_id!=1?"(停用)":"" %> </option>
                                            <%}
                                                    }
                                                } %>
                                        </select>
                                    </div>
                                </td>
                            </tr>
                            <tr class="ToBlockInfo">
                                <td>
                                    <span class="bold">合同名称</span>
                                    <div>
                                        <span id="ToBlockContractName"></span>
                                    </div>

                                </td>
                                <td></td>
                            </tr>
                            <tr class="ToBlockInfo">
                                <td>
                                    <span class="bold">预付时间/预付费有效期</span>
                                    <div>
                                        <span id="ToBlockDate"></span>
                                    </div>
                                </td>
                                <td>
                                    <span class="bold">扣除数量</span>
                                    <div>
                                        <span id="ToBlockDeductionNum"><%=(dedNum??0).ToString("#0.00") %></span>
                                    </div>
                                </td>
                            </tr>
                            <tr class="ToBlockInfo">
                                <td>
                                    <span class="bold">剩余数量</span>
                                    <div>
                                        <span id="ToBlockSurplusNum"></span>
                                    </div>
                                </td>
                                <td>
                                    <span class="bold">移动后剩余数量</span>
                                    <div>
                                        <span id="ToBlockMoveSurplusNum"></span>
                                    </div>
                                </td>
                            </tr>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </form>
</body>
</html>
<script src="../Scripts/jquery-3.1.0.min.js"></script>
<script src="../Scripts/common.js"></script>
<script src="../Scripts/index.js"></script>
<script>
    $(function () {
        $(".ToBlockInfo").hide();
    })
    $("#ToblockSelect").change(function () {
        var thisValue = $(this).val();
        if (thisValue == "" || thisValue == "0") {
            $(".ToBlockInfo").hide();
            $("#ToBlockContractName").text("");
            $("#ToBlockDate").text("");
            //$("#ToBlockDeductionNum").text("");
            $("#ToBlockSurplusNum").text("");
            $("#ToBlockMoveSurplusNum").text("");
        }
        else {
            $(".ToBlockInfo").show();
        }


        $.ajax({
            type: "GET",
            url: "../Tools/ContractAjax.ashx?act=GetBlockInfo&id=" + thisValue,
            dataType:"json",
            success: function (data) {
                if (data != "") {
                    $("#ToBlockContractName").text(data.contractName);
                    $("#ToBlockDate").text(data.date); 
                    $("#ToBlockSurplusNum").text(data.befotMoveNum);
                    var dedNum = '<%=dedNum??0 %>';
                    $("#ToBlockMoveSurplusNum").text(toDecimal4(Number(data.befotMoveNum) - Number(dedNum)));
                }
                else {
                    $(".ToBlockInfo").hide();
                    $("#ToBlockContractName").text("");
                    $("#ToBlockDate").text("");
                    //$("#ToBlockDeductionNum").text("");
                    $("#ToBlockSurplusNum").text("");
                    $("#ToBlockMoveSurplusNum").text("");
                }
            }

        })
    })
</script>
