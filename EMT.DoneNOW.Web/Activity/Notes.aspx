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
  <style>
    .content label{width:120px;}
  </style>
</head>
<body>
  <form id="form1" runat="server">
    <div class="header"><%=note == null ? "新增备注" : "编辑备注" %></div>
    <div class="header-title">
      <ul>
        <li id="SaveClose">
          <i style="background: url(../Images/ButtonBarIcons.png) no-repeat -32px 0;" class="icon-1"></i>
          <input type="button" value="保存并关闭" />
        </li>
        <%if (note == null) { %>
        <li id="SaveNew">
          <i style="background: url(../Images/ButtonBarIcons.png) no-repeat -48px 0;" class="icon-1"></i>
          <input type="button" value="保存并新建" />
        </li>
        <%} else { %>
        <li id="DeleteClose">
          <i style="background: url(../Images/delete.png);" class="icon-1"></i>
          <input type="button" value="删除" />
        </li>
        <%} %>
        <li id="Close">
          <i style="background: url(../Images/ButtonBarIcons.png) no-repeat -96px 0;" class="icon-1"></i>
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
            <table border="none" cellspacing="" cellpadding="" style="width: 690px;">
              <tr>
                <td>
                  <div class="clear">
                    <label>客户名称<span class="red">*</span></label>
                    <input type="hidden" id="AccountNameHidden" name="account_id" <%if (note != null)
                        { %>
                      value="<%=note.account_id %>" <%} %> />
                    <input type="text" readonly="readonly" id="AccountName" <%if (note != null && note.account_id != null)
                        { %>
                      value="<%=new EMT.DoneNOW.BLL.CompanyBLL().GetCompany((long)note.account_id).name %>" <%} %> />
                    <i onclick="window.open('../Common/SelectCallBack.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.COMPANY_CALLBACK %>&field=AccountName&callBack=GetCtcOppt', '<%=EMT.DoneNOW.DTO.OpenWindow.BillCodeCallback %>', 'left=200,top=200,width=600,height=800', false)" style="width: 15px; height: 15px; float: left; margin-left: 5px; margin-top: 5px; background: url(../Images/data-selector.png) no-repeat;"></i>
                    <i onclick="ViewCompany()" style="width: 15px; height: 15px; float: left; margin-left: 5px; margin-top: 5px; background: url(../Images/view.png) no-repeat;"></i>
                  </div>
                </td>
              </tr>
              <tr>
                <td>
                  <div class="clear">
                    <label>联系人</label>
                    <select name="contact_id" id="contact_id">
                      <option value=""></option>
                      <%if (contactList != null)
                          {
                            foreach (var contact in contactList)
                            {
                      %>
                      <option value="<%=contact.id %>" <%if (note != null && note.contact_id != null && note.contact_id == contact.id)
                          { %>
                        selected="selected" <%} %>><%=contact.name %></option>
                      <%}
                          } %>
                    </select>
                    <i onclick="ViewContact()" style="width: 15px; height: 15px; float: left; margin-left: 5px; margin-top: 5px; background: url(../Images/view.png) no-repeat;"></i>
                  </div>
                </td>
              </tr>
              <tr>
                <td>
                  <div class="clear">
                    <label>商机</label>
                    <select name="opportunity_id" id="opportunity_id">
                      <option value=""></option>
                      <%if (opportunityList != null)
                          {
                            foreach (var opportunity in opportunityList)
                            {
                      %>
                      <option value="<%=opportunity.id %>" <%if (note != null && note.opportunity_id != null && note.opportunity_id == opportunity.id)
                          { %>
                        selected="selected" <%} %>><%=opportunity.name %></option>
                      <%}
                          } %>
                    </select>
                    <i onclick="ViewOpportunity()" style="width: 15px; height: 15px; float: left; margin-left: 5px; margin-top: 5px; background: url(../Images/view.png) no-repeat;"></i>
                  </div>
                </td>
              </tr>
              <tr>
                <td>
                  <div class="clear">
                    <label>活动类型<span class="red">*</span></label>
                    <select id="action_type_id" name="action_type_id">
                      <option value=""></option>
                      <%
                          foreach (var actionType in actionTypeList)
                          {
                      %>
                      <option value="<%=actionType.id %>" <%if (note != null && note.action_type_id == actionType.id)
                          { %>
                        selected="selected" <%} %>><%=actionType.name %></option>
                      <%} %>
                    </select>
                  </div>
                </td>
                <td>
                  <div class="clear">
                    <label>负责人</label>
                    <select name="resource_id">
                      <option value=""></option>
                      <%
                          foreach (var resource in resourceList)
                          {
                      %>
                      <option value="<%=resource.val %>" <%if (note != null && note.resource_id != null && resource.val.Equals(note.resource_id.ToString()))
                          { %>
                        selected="selected" <%} %>><%=resource.show %></option>
                      <%} %>
                    </select>
                  </div>
                </td>
              </tr>
              <tr>
                <td>
                  <div class="clear">
                    <label>开始时间<span class="red">*</span></label>
                    <input <%if (note != null) { %> value="<%=EMT.Tools.Date.DateHelper.TimeStampToDateTime(note.start_date).ToString("yyyy-MM-dd HH:mm") %>" <%} else { %> value="<%=DateTime.Now.ToString("yyyy-MM-dd HH:mm") %>" <%} %> onclick="WdatePicker({ el: this, dateFmt: 'yyyy-MM-dd HH:mm' })" type="text" class="sl_cdt Wdate" name="start_date2" id="start_date" />
                  </div>
                </td>
                <td>
                  <div class="clear">
                    <label>结束时间<span class="red">*</span></label>
                    <input <%if (note != null) { %> value="<%=EMT.Tools.Date.DateHelper.TimeStampToDateTime(note.end_date).ToString("yyyy-MM-dd HH:mm") %>" <%} else { %> value="<%=DateTime.Now.AddMinutes(15).ToString("yyyy-MM-dd HH:mm") %>" <%} %> onclick="WdatePicker({ el: this, dateFmt: 'yyyy-MM-dd HH:mm' })" type="text" class="sl_cdt Wdate" name="end_date2" id="end_date" />
                  </div>
                </td>
              </tr>
              <tr>
                <td>
                  <textarea name="description"><%=note==null?"":note.description %></textarea>
                </td>
              </tr>
            </table>
          </div>
        </div>
        <div class="information clear">
          <p class="informationTitle"><i></i>跟进待办</p>
          <div>
            <table border="none" cellspacing="" cellpadding="" style="width: 690px;">
              <tr>
                <td>
                  <label>创建跟进待办，必须输入开始时间、结束时间和活动类型</label>
                </td>
              </tr>
              <tr>
                <td>
                  <div class="clear">
                    <label>开始时间</label>
                    <input onclick="WdatePicker({ el: this, dateFmt: 'yyyy-MM-dd HH:mm' })" type="text" class="sl_cdt Wdate" name="start_date1" id="start_date1" />
                  </div>
                </td>
                <td>
                  <div class="clear">
                    <label>结束时间</label>
                    <input onclick="WdatePicker({ el: this, dateFmt: 'yyyy-MM-dd HH:mm' })" type="text" class="sl_cdt Wdate" name="end_date1" id="end_date1" />
                  </div>
                </td>
              </tr>
              <tr>
                <td>
                  <div class="clear">
                    <label>活动类型</label>
                    <select id="action_type_id1" name="action_type_id1">
                      <option value=""></option>
                      <%
                          foreach (var actionType in actionTypeList)
                          {
                      %>
                      <option value="<%=actionType.id %>"><%=actionType.name %></option>
                      <%} %>
                    </select>
                  </div>
                </td>
                <td>
                  <div class="clear">
                    <label>负责人</label>
                    <select name="resource_id1">
                      <option value=""></option>
                      <%
                          foreach (var resource in resourceList)
                          {
                      %>
                      <option value="<%=resource.val %>"><%=resource.show %></option>
                      <%} %>
                    </select>
                  </div>
                </td>
              </tr>
              <tr>
                <td>
                  <textarea name="description1"></textarea>
                </td>
              </tr>
            </table>
          </div>
        </div>
      </div>
      <div class="content clear" style="display: none;">
      </div>
    </div>
    <input type="hidden" id="action" name="action" />
    <input type="hidden" name="id" <%if (note != null) { %> value="<%=note.id %>" <%} %> />
  </form>
  <script type="text/javascript" src="../Scripts/jquery-3.1.0.min.js"></script>
  <script src="../Scripts/index.js"></script>
  <script type="text/javascript" src="../Scripts/common.js"></script>
  <script src="../Scripts/NewContact.js"></script>
  <script type="text/javascript" charset="utf-8" src="../Scripts/My97DatePicker/WdatePicker.js"></script>
  <script type="text/javascript">
    $("#SaveClose").click(function () {
      $("#action").val("SaveClose");
      CheckAndSubmit();
    })
    $("#SaveNew").click(function () {
      $("#action").val("SaveNew");
      CheckAndSubmit();
    })
    $("#Close").click(function () {
      window.close();
    })
    $("#DeleteClose").click(function () {
      LayerConfirm("删除后无法恢复，是否继续", "确定", "取消", function () {
        requestData("../Tools/ActivityAjax.ashx?act=Delete&id=" + $("#id").val(), null, function (data) {
          if (data == true) {
            LayerAlert("删除成功", "确定", function () {
              window.close();
              self.opener.location.reload();
            })
          }
          else {
            LayerMsg("删除失败");
          }
        })
      }, function () { })
    })
    function GetCtcOppt() {
      var account_id = $("#AccountNameHidden").val();
      $("#contact_id").html("");
      $("#opportunity_id").html("");
      if (account_id != "") {
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
        $.ajax({
          type: "GET",
          async: false,
          url: "../Tools/CompanyAjax.ashx?act=OpportunityList&account_id=" + account_id,
          success: function (data) {
            if (data != "") {
              $("#opportunity_id").html(data);
            }
          },
        });
      }
    }
    function ViewCompany() {
      var account_id = $("#AccountNameHidden").val();
      if (account_id != "") {
        window.open('../Company/ViewCompany.aspx?id=' + account_id, '_blank', 'left=200,top=200,width=1200,height=1000', false);
      }
    }
    function ViewContact() {
      var contact_id = $("#contact_id").val();
      if (contact_id != "") {
        window.open('../Contact/ViewContact.aspx?id=' + contact_id, '_blank', 'left=200,top=200,width=1200,height=1000', false);
      }
    }
    function ViewOpportunity() {
      var opportunity_id = $("#opportunity_id").val();
      if (opportunity_id != "") {
        window.open('../Opportunity/ViewOpportunity.aspx?id=' + opportunity_id, '_blank', 'left=200,top=200,width=1200,height=1000', false);
      }
    }
    function CheckAndSubmit() {
      if ($("#AccountNameHidden").val() == "") {
        LayerMsg("请选择客户");
        return;
      }
      if ($("#action_type_id").val() == "") {
        LayerMsg("请选择活动类型");
        return;
      }
      if ($("#start_date").val() == "") {
        LayerMsg("请选择开始时间");
        return;
      }
      if ($("#end_date").val() == "") {
        LayerMsg("请选择结束时间");
        return;
      }
      var dtStart = new Date($("#start_date").val());
      var dtEnd = new Date($("#end_date").val());
      if (dtStart.getTime() > dtEnd.getTime()) {
        LayerMsg("结束时间必须大于等于开始时间");
        return;
      }
      if ($("#action_type_id1").val() != "") {
        if ($("#start_date1").val() == "") {
          LayerMsg("选择待办跟进活动类型后请选择开始时间");
          return;
        }
        if ($("#end_date1").val() == "") {
          LayerMsg("选择待办跟进活动类型后请选择结束时间");
          return;
        }
        var dtStart1 = new Date($("#start_date1").val());
        var dtEnd1 = new Date($("#end_date1").val());
        if (dtStart1.getTime() > dtEnd1.getTime()) {
          LayerMsg("待办跟进结束时间必须大于等于开始时间");
          return;
        }
        if (dtEnd.getTime() >= dtStart1.getTime()) {
          LayerMsg("待办跟进开始时间必须大于备注结束时间");
          return;
        }
      }
      $("#form1").submit();
    }
  </script>
</body>
</html>
