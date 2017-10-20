<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Notes.aspx.cs" Inherits="EMT.DoneNOW.Web.Activity.Notes" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
  <title></title>
  <link rel="stylesheet" type="text/css" href="../Content/base.css" />
  <link rel="stylesheet" type="text/css" href="../Content/bootstrap.min.css" />
  <link rel="stylesheet" href="../Content/index.css" />
  <link rel="stylesheet" href="../Content/style.css" />
</head>
<body>
  <form id="form1" runat="server">
    <div class="header"><%=action.Equals("edit")?"编辑备注":"新增备注" %></div>
    <div class="header-title">
      <ul>
        <li id="SaveClose">
          <i style="background: url(../Images/ButtonBarIcons.png) no-repeat -32px 0;"></i>
          <input type="button" value="保存并关闭" />
        </li>
        <li id="SaveNew">
          <i style="background: url(../Images/ButtonBarIcons.png) no-repeat -48px 0;"></i>
          <input type="button" value="保存并新建" />
        </li>
        <li id="Close">
          <i style="background: url(../Images/ButtonBarIcons.png) no-repeat -96px 0;"></i>
          <input type="button" value="关闭" />
        </li>
      </ul>
    </div>
    <div class="nav-title">
      <ul class="clear">
        <li class="boders" id="">常规</li>
        <li id="">通知</li>
      </ul>
    </div>
    <div style="left: 0; overflow-x: auto; overflow-y: auto; position: fixed; right: 0; bottom: 0; top: 132px;">
      <div class="content clear">
        <div class="information clear">
          <p class="informationTitle"><i></i>常规信息</p>
          <div>
            <table border="none" cellspacing="" cellpadding="" style="width: 871px;">
              <tr>
                <td>
                  <div class="clear">
                    <label>客户名称<span class="red">*</span></label>
                    <input type="hidden" id="AccountNameHidden" name="account_id" <%if (note != null) { %> value="<%=note.account_id %>" <%} %> />
                    <input type="text" id="AccountName" <%if (note != null && note.account_id != null) { %> value="<%=new EMT.DoneNOW.BLL.CompanyBLL().GetCompany((long)note.account_id).name %>" <%} %> />
                    <img src="../Images/data-selector.png" onclick="window.open('../Common/SelectCallBack.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.COMPANY_CALLBACK %>&field=AccountName&callBack=GetContactList', '<%=EMT.DoneNOW.DTO.OpenWindow.BillCodeCallback %>', 'left=200,top=200,width=600,height=800', false)" style="vertical-align: middle;cursor: pointer;" />
                    <img src="../Images/view.png" onclick="ViewCompany()" style="vertical-align: middle;cursor: pointer;" />
                  </div>
                </td>
              </tr>
            </table>
          </div>
        </div>
      </div>
    </div>
  </form>
  <script type="text/javascript">
    function GetContactList() {
      var account_id = $("#AccountNameHidden").val();
      if (account_id != "") {
        $("#contact_id").removeAttr("disabled");
        $("#contact_id").html("");
        $.ajax({
          type: "GET",
          async: false,
          url: "../Tools/CompanyAjax.ashx?act=contact&account_id=" + account_id,
          success: function (data) {
            if (data != "") {
              $("#contact_id").html(data);

            }
          },
        });
      }
    }
    function ViewCompany() {
      var account_id = $("#AccountNameHidden").val();
      if (account_id != "") {
        window.open('../Company/ViewCompany.aspx?id=' + account_id, '_blank', 'left=200,top=200,width=600,height=800', false);
      }
    }
  </script>
</body>
</html>
