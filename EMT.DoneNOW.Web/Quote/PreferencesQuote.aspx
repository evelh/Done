<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="PreferencesQuote.aspx.cs" Inherits="EMT.DoneNOW.Web.Quote.PreferencesQuote" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
  <title>报价参数设定</title>
  <link href="../../Content/reset.css" rel="stylesheet" />
  <link href="../../Content/NewConfigurationItem.css" rel="stylesheet" />
  <style>
    #_ctl3_chkTaxExempt_ATCheckBox {
      vertical-align: middle;
    }
  </style>
</head>
<body>
  <div class="TitleBar">
    <div class="Title">
      <span class="text1">报价参数设定</span>
    </div>
  </div>
  <div class="ButtonContainer">
    <ul id="btn">
      <li class="Button ButtonIcon NormalState" id="SaveAndCloneButton" tabindex="0">
        <span class="Icon SaveAndClone"></span>
        <span class="Text">保存并关闭</span>
      </li>
      <li class="Button ButtonIcon NormalState" id="CancelButton" tabindex="0">
        <span class="Icon Cancel"></span>
        <span class="Text">取消</span>
      </li>
    </ul>
  </div>
  <form id="form1" runat="server">
    <div class="DivScrollingContainer Tab" style="top: 82px;">
      <div class="DivSectionWithHeader">
        <div class="HeaderRow">
          <div class="Toggle Collapse Toggle1">
            <div class="Vertical"></div>
            <div class="Horizontal"></div>
          </div>
          <span class="lblNormalClass">常规</span>
        </div>
        <div class="Content">
          <table class="Neweditsubsection" style="width: 780px;" cellpadding="0" cellspacing="0">
            <tbody>
              <tr>
                <td>
                  <div>
                    <table cellpadding="0" cellspacing="0" style="width: 100%;">
                      <tbody>
                        <tr>
                          <td class="FieldLabel">报价模板<span class="errorSmallClass" style="color: red;">*</span>
                            <div>
                              <asp:DropDownList ID="quote_tmpl_id" runat="server" Width="250px"></asp:DropDownList>
                              <img src="../Images/add.png" style="vertical-align: middle;" />
                              <input type="hidden" name="account_id" value="<%=accountId %>" />
                              <input type="hidden" name="email_to_contacts" id="email_to_contacts" />
                              <input type="hidden" name="email_bcc_resources" id="email_bcc_resources" />
                            </div>
                          </td>
                        </tr>
                      </tbody>
                    </table>
                  </div>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>
      <div class="DivSectionWithHeader">
        <div class="HeaderRow">
          <div class="Toggle Collapse Toggle2">
            <div class="Vertical"></div>
            <div class="Horizontal"></div>
          </div>
          <span class="lblNormalClass">通知</span>
        </div>
        <div class="Content">
          <table class="Neweditsubsection" style="width: 780px;" cellpadding="0" cellspacing="0">
            <tbody>
              <tr>
                <td>
                  <div>
                    <table cellpadding="0" cellspacing="0" style="width: 100%;">
                      <tbody>
                        <tr>
                          <td class="FieldLabel" style="width: 390px;height:80px;">通知
                            <div>
                              <input type="checkbox" id="chooseQuoteContact" name="chooseQuoteContact" style="vertical-align: middle;" />
                              报价联系人（发送）
                            </div>
                            <div>
                              <input type="checkbox" id="chooseManage" name="chooseManage" style="vertical-align: middle;" />
                              客户经理（密送）
                            </div>
                          </td>
                          <td class="FieldLabel">邮件模板
                            <div>
                              <asp:DropDownList ID="quote_email_message_tmpl_id" runat="server" Width="260px"></asp:DropDownList>

                              <img src="../Images/add.png" alt="" />
                            </div>
                          </td>
                        </tr>
                        <tr>
                          <td class="FieldLabel">客户联系人（发送）
                            <span class="FieldLevelInstruction"></span>
                            <div style="height: 95px; width: 258px; overflow: auto; z-index: 0; border: 1px solid #d3d3d3;">
                              <table class="dataGridBody" cellspacing="0" style="width: 100%; border-collapse: collapse;" border="1">
                                <tbody>
                                  <%if (contactList != null && contactList.Count > 0)
                                      {
                                        foreach (var contract in contactList)
                                        {
                                  %>
                                  <tr class="dataGridBody dataGridBodyHover" style="height: 22px;">
                                    <td align="center">
                                      <span class="txtBlack8Class">
                                        <input type="checkbox" class="contractCheck" id="<%=contract.id %>_check" style="vertical-align: middle;" value="<%=contract.id %>" />
                                      </span>
                                    </td>
                                    <td>
                                      <span><%=contract.name %></span>
                                    </td>
                                    <td>
                                      <span><%=contract.email %></span>
                                    </td>
                                  </tr>
                                  <%}
                                    }%>
                                </tbody>
                              </table>
                            </div>
                          </td>
                          <td class="FieldLabel">员工（密送）
                            <span class="FieldLevelInstruction"></span>
                            <div style="height: 95px; width: 258px; overflow: auto; z-index: 0; border: 1px solid #d3d3d3;">
                              <table class="dataGridBody" cellspacing="0" style="width: 100%; border-collapse: collapse;" border="1">
                                <tbody>
                                  <%if (resourceList != null && resourceList.Count > 0)
                                      {
                                        foreach (var source in resourceList)
                                        {
                                  %>
                                  <tr class="dataGridBody dataGridBodyHover" style="height: 22px;">
                                    <td align="center">
                                      <span class="txtBlack8Class">
                                        <input type="checkbox" class="sourceCheck" id="<%=source.id %>_check" style="vertical-align: middle;" value="<%=source.id %>" />
                                      </span>
                                    </td>
                                    <td>
                                      <span><%=source.name %></span>
                                    </td>
                                    <td>
                                      <span><%=source.email %></span>
                                    </td>
                                  </tr>
                                  <%}
                                    }%>
                                </tbody>
                              </table>
                            </div>
                          </td>
                        </tr>
                        <tr>
                          <td class="FieldLabel" colspan="2">员工（发送，多个用半角逗号分隔）
                            <span class="FieldLevelInstruction"></span>
                            <div>
                              <input type="text" name="email_to_others" id="email_to_others" style="width: 636px;" value="" />
                            </div>
                          </td>
                        </tr>
                        <tr>
                          <td class="FieldLabel" colspan="2">
                            <span class="FieldLevelInstruction"></span>
                          </td>
                        </tr>
                      </tbody>
                    </table>
                  </div>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>
      <div class="DivSectionWithHeader">
        <div class="HeaderRow">
          <div class="Toggle Collapse Toggle3">
            <div class="Vertical"></div>
            <div class="Horizontal"></div>
          </div>
          <span class="lblNormalClass">邮件内容</span>
        </div>
        <div class="Content">
          <div>
            <span>如果[报价:邮件备注]出现在报价邮件模板内容定义中，则会替换该变量。否则邮件备注会出现在邮件的最上方。</span>
          </div>
          <div>
            <div>
              <label style="cursor:auto;font-weight:bold;color:#4F4F4F">邮件备注</label>
            </div>
            <textarea style="width:636px;height:86px;" name="email_notes"></textarea>
          </div>
        </div>
      </div>
    </div>
  </form>
  <script src="../Scripts/jquery-3.1.0.min.js"></script>
  <script src="../Scripts/NewConfigurationItem.js"></script>
  <script src="../Scripts/common.js"></script>
  <script>
    $("#SaveAndCloneButton").click(function () {
      var quote_tmpl_id = $("#quote_tmpl_id").val();
      if (quote_tmpl_id == undefined || quote_tmpl_id == "") {
        alert("请选择报价模板");
        return;
      }
      var email_tmpl_id = $("#quote_email_message_tmpl_id").val();
      if (email_tmpl_id == undefined || email_tmpl_id == "") {
        alert("请选择报价邮件模板");
        return;
      }
      
      GetCheckValue();
      $("#form1").submit();
    })
    
    $("#CancelButton").click(function () {
      window.close();
    })

    function GetCheckValue() {
        // 选中联系人
        var contactIds = "";
        $(".contractCheck").each(function () {
          if ($(this).is(":checked")) {
            contactIds += $(this).val() + ',';
          }
        })
        if (contactIds != "") {
          contactIds = contactIds.substring(0, contactIds.length - 1);
          $("#email_to_contacts").val(contactIds);
        }
        
        // 选中员工
        var sourceIds = "";
        $(".sourceCheck").each(function () {
          if ($(this).is(":checked")) {
            sourceIds += $(this).val() + ',';
          }
        })
        if (sourceIds != "") {
          sourceIds = sourceIds.substring(0, sourceIds.length - 1);
          $("#email_bcc_resources").val(sourceIds);
        }

    }
  </script>
</body>
</html>
