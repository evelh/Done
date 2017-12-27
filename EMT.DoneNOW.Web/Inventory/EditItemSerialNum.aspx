<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="EditItemSerialNum.aspx.cs" Inherits="EMT.DoneNOW.Web.Inventory.EditItemSerialNum" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
  <title>新增或编辑序列号</title>
  <link rel="stylesheet" type="text/css" href="../Content/base.css" />
  <link rel="stylesheet" type="text/css" href="../Content/bootstrap.min.css" />
  <link href="../Content/index.css" rel="stylesheet" />
  <link href="../Content/style.css" rel="stylesheet" />
</head>
<body>
  <div class="header">新增或编辑序列号</div>
  <div class="header-title">
    <ul>
      <li id="SaveClose">
        <i style="background: url(../Images/ButtonBarIcons.png) no-repeat -32px 0;" class="icon-1"></i>
        <input type="button" value="保存并关闭" />
      </li>
    </ul>
  </div>
  <form id="form1" runat="server">
    <div style="margin:0 10px 0 10px;">
      <label><%if (itemCnt > 0) { %>请输入或编辑你想接收的采购项序列号，每个序列号必须单独一行。<% } else{%>请选择你想要取消接收的采购项序列号。<%} %></label>
      <div style="margin-top:6px;">
        <div>
          <label>序列号：<span id="snCnt">0</span></label>
        </div>
        <textarea style="float:left;" id="sn" name="sn" <%if (itemCnt < 0) { %> readonly="readonly" <%} %>><%=editSn %></textarea>
        <input type="hidden" id="serailNum" />
        <input type="hidden" id="serailNumHidden" name="selectedSn" />
        <%if (itemCnt < 0) { %>
        <i onclick="window.open('../Common/SelectCallBack?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.SHIPPING_ITEM_SERIAL_NUM %>&field=serailNum&callBack=GetProductSn&muilt=1&con1224=<%=itemId %>','_blank','left=200,top=200,width=900,height=750', false);" style="width: 20px; height: 20px; float: left; margin-left: 2px; margin-top: 6px; background: url(../Images/data-selector.png) no-repeat;" id="purchaseCompanySelect"></i>
        <%} %>
      </div>
    </div>
  </form>
  <script src="../Scripts/jquery-3.1.0.min.js" type="text/javascript" charset="utf-8"></script>
  <script src="../Scripts/common.js"></script>
  <script>
    var pdtCnt = 0;
    function GetProductSn() {
      var sns = $("#serailNum").val();
      if (sns == "") {
        $("#sn").text("");
        $("#snCnt").val(0);
        return;
      }
      snList = sns.split(',');
      var sntext = "";
      pdtCnt = snList.length;
      for (var i = 0; i < snList.length; i++) {
        sntext = sntext + snList[i] + "\n";
      }
      $("#sn").text(sntext);
      $("#snCnt").val(pdtCnt);
    }
    $("#SaveClose").click(function () {
      <% if (itemCnt > 0) { %>
      if (<%=itemCnt%>!=getSNCnt()) {
        LayerMsg("序列号数应等于接收数");
        return;
      }
    <%} else { %>
      if (<%=itemCnt%>+getSNCnt() != 0) {
        LayerMsg("序列号数应等于接收数");
        return;
      }
    <%} %>
      $("#form1").submit();
    })
    $("#sn").change(function () {
      $("#snCnt").text("总数：" + getSNCnt());
    })
    function getSNCnt() {
      var sns = $("#sn").val().split("\n");
      var cnt = 0;
      var tmp;
      for (var i = 0; i < sns.length; ++i) {
        tmp = sns[i].replace("\n", "").replace(/ /g, "");
        if (tmp != "")
          cnt++;
      }
      return cnt;
    }
    $("#snCnt").text("总数：" + getSNCnt());
  </script>
</body>
</html>
