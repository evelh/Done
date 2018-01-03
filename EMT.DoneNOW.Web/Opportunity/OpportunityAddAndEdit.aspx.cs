using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DAL;
using EMT.DoneNOW.DTO;
using EMT.DoneNOW.BLL;
using static EMT.DoneNOW.DTO.DicEnum;

namespace EMT.DoneNOW.Web.Opportunity
{
    public partial class OopportunityAdd : BasePage
    {
        protected crm_opportunity opportunity = null;        // 用于修改时获取商机内容
        protected bool isAdd = true;                           // 用于判断新增或修改   
        protected List<UserDefinedFieldDto> opportunity_udfList = null;
        protected List<UserDefinedFieldValue> opportunity_udfValueList = null;
        protected List<UserDefinedFieldDto> company_udfList = null;
        protected List<UserDefinedFieldValue> company_udfValueList = null;
        protected Dictionary<string, object> dic = null;
        protected CompanyBLL conpamyBll = new CompanyBLL();
        protected crm_account account = null;
        protected crm_contact contact = null;
        protected string callBackFiled = "";
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                callBackFiled = Request.QueryString["callBackFiled"];

                var opportunity_id = Request.QueryString["opportunity_id"];
                if (!string.IsNullOrEmpty(opportunity_id))
                {
                    if (AuthBLL.GetUserOppAuth(LoginUserId, LoginUser.security_Level_id, Convert.ToInt64(opportunity_id)).CanEdit == false)
                    {
                        Response.End();
                        return;
                    }

                    opportunity = new crm_opportunity_dal().GetOpportunityById(Convert.ToInt64(opportunity_id));
                }
                dic = new OpportunityBLL().GetField();

                #region 配置下拉框的数据源
                // 商机负责人
                resource_id.DataTextField = "show";
                resource_id.DataValueField = "val";
                resource_id.DataSource = dic.FirstOrDefault(_ => _.Key == "sys_resource").Value;
                resource_id.DataBind();
                resource_id.Items.Insert(0, new ListItem() { Value = "0", Text = "   ", Selected = true });
                // 当前阶段
                stage_id.DataTextField = "show";
                stage_id.DataValueField = "val";
                stage_id.DataSource = dic.FirstOrDefault(_ => _.Key == "opportunity_stage").Value;
                stage_id.DataBind();
                stage_id.Items.Insert(0, new ListItem() { Value = "0", Text = "   ", Selected = true });
                stage_id.SelectedValue = ((int)OPPORTUNITY_STAGE.NEW_CLUE).ToString();       
                // 感兴趣等级
                interest_degree_id.DataTextField = "show";
                interest_degree_id.DataValueField = "val";
                interest_degree_id.DataSource = dic.FirstOrDefault(_ => _.Key == "opportunity_interest_degree").Value;
                interest_degree_id.DataBind();
                interest_degree_id.Items.Insert(0, new ListItem() { Value = "0", Text = "   ", Selected = true });
                // 商机来源
                source_id.DataTextField = "show";
                source_id.DataValueField = "val";
                source_id.DataSource = dic.FirstOrDefault(_ => _.Key == "opportunity_source").Value;
                source_id.DataBind();
                source_id.Items.Insert(0, new ListItem() { Value = "0", Text = "   ", Selected = true });
                // 状态
                status_id.DataTextField = "show";
                status_id.DataValueField = "val";
                status_id.DataSource = dic.FirstOrDefault(_ => _.Key == "oppportunity_status").Value;
                status_id.DataBind();
                status_id.SelectedValue = ((int)OPPORTUNITY_STATUS.ACTIVE).ToString();
                //status_id.Items.Insert(0, new ListItem() { Value = "0", Text = "   ", Selected = true });
                // 主要竞争对手
                competitor_id.DataTextField = "show";
                competitor_id.DataValueField = "val";
                competitor_id.DataSource = dic.FirstOrDefault(_ => _.Key == "competition").Value;
                competitor_id.DataBind();
                competitor_id.Items.Insert(0, new ListItem() { Value = "0", Text = "   ", Selected = true });
                // 赢单原因
                win_reason_type_id.DataTextField = "show";
                win_reason_type_id.DataValueField = "val";
                win_reason_type_id.DataSource = dic.FirstOrDefault(_ => _.Key == "oppportunity_win_reason_type").Value;
                win_reason_type_id.DataBind();
                win_reason_type_id.Items.Insert(0, new ListItem() { Value = "0", Text = "   ", Selected = true });
                // 丢单原因
                loss_reason_type_id.DataTextField = "show";
                loss_reason_type_id.DataValueField = "val";
                loss_reason_type_id.DataSource = dic.FirstOrDefault(_ => _.Key == "oppportunity_loss_reason_type").Value;
                loss_reason_type_id.DataBind();
                loss_reason_type_id.Items.Insert(0, new ListItem() { Value = "0", Text = "   ", Selected = true });
                // 通知模板   --todo 需要过滤商机创建或编辑相关的通知模板
                //notify_tmpl_id.DataTextField = "show";
                //notify_tmpl_id.DataValueField = "val";
                //notify_tmpl_id.DataSource = dic.FirstOrDefault(_ => _.Key == "notify_tmpl").Value;
                //notify_tmpl_id.DataBind();
                //notify_tmpl_id.Items.Insert(0, new ListItem() { Value = "0", Text = "   ", Selected = true });


                var formTemplateList = new FormTemplateBLL().GetTemplateOpportunityByUser(GetLoginUserId());
                formTemplate.DataTextField = "speed_code";
                formTemplate.DataValueField = "id";
                formTemplate.DataSource = formTemplateList;
                formTemplate.DataBind();
                formTemplate.Items.Insert(0, new ListItem() { Value = "0", Text = "   ", Selected = true });
                #endregion

                spread_unit.SelectedValue = "Months";
                opportunity_udfList = new UserDefinedFieldsBLL().GetUdf(DicEnum.UDF_CATE.OPPORTUNITY);
                if (opportunity != null)
                {
                    isAdd = false;
                   
                    //company_udfList = new UserDefinedFieldsBLL().GetUdf(DicEnum.UDF_CATE.COMPANY);
            

                }

                if (!isAdd)
                {
                    opportunity_udfValueList = new UserDefinedFieldsBLL().GetUdfValue(DicEnum.UDF_CATE.OPPORTUNITY, opportunity.id, opportunity_udfList);
                    if (!IsPostBack)
                    {
                      
                    resource_id.SelectedValue = opportunity.resource_id.ToString();
                    stage_id.SelectedValue = opportunity.stage_id == null ? "0" : opportunity.stage_id.ToString();
                    interest_degree_id.SelectedValue = opportunity.interest_degree_id == null ? "0" : opportunity.interest_degree_id.ToString();
                    source_id.SelectedValue = opportunity.source_id == null ? "0" : opportunity.source_id.ToString();
                    status_id.SelectedValue = opportunity.status_id == null ? "0" : opportunity.status_id.ToString();
                    competitor_id.SelectedValue = opportunity.competitor_id == null ? "0" : opportunity.competitor_id.ToString();
                    win_reason_type_id.SelectedValue = opportunity.win_reason_type_id == null ? "0" : opportunity.win_reason_type_id.ToString();
                    loss_reason_type_id.SelectedValue = opportunity.loss_reason_type_id == null ? "0" : opportunity.loss_reason_type_id.ToString();
                    spread_unit.SelectedValue = opportunity.spread_unit;
                    
                        is_use_quote.Checked = opportunity.use_quote == 1;
                    }
                }
                else
                {
                    //  联系人查看的时候穿过来客户ID，和联系人ID，联系人不能更改，只有更改客户才可以更改联系人
                    var contact_id = Request.QueryString["oppo_contact_id"];
                    if (!string.IsNullOrEmpty(contact_id))
                    {
                        contact = new ContactBLL().GetContact(Convert.ToInt64(contact_id));
                    }

                    var account_id = Request.QueryString["oppo_account_id"];
                    if (!string.IsNullOrEmpty(account_id))
                    {
                        account = new CompanyBLL().GetCompany(Convert.ToInt64(account_id));
                    }


                }
            }
            catch (Exception msg)
            {

                Response.End();
            }
        }

        /// <summary>
        /// 保存不关闭
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void save_Click(object sender, EventArgs e)
        {
            //var param = new OpportunityAddOrUpdateDto()
            //{
            //    general = AssembleModel<crm_opportunity>(),
            //    notify = AssembleModel<com_notify_email>(),
            //};
            //if (opportunity_udfList != null && opportunity_udfList.Count > 0)                      // 首先判断是否有自定义信息
            //{
            //    var list = new List<UserDefinedFieldValue>();
            //    foreach (var udf in opportunity_udfList)                            // 循环添加
            //    {
            //        var new_udf = new UserDefinedFieldValue()
            //        {
            //            id = udf.id,
            //            value = Request.Form[udf.id.ToString()] == "" ? null : Request.Form[udf.id.ToString()],
            //        };
            //        list.Add(new_udf);
            //    }
            //    param.udf = list;
            //}

            var param = GetParam();

            if (isAdd)
            {
                var id = "";
                var result = new OpportunityBLL().Insert(param, GetLoginUserId(),out id);   // 根据参数插入商机
                if (result == ERROR_CODE.PARAMS_ERROR)   // 必填参数丢失，重写
                {
                    ClientScript.RegisterStartupScript(this.GetType(), "提示信息", "<script>alert('必填参数丢失，请重新填写'); </script>");
                    //Response.Write("<script>alert('必填参数丢失，请重新填写'); </script>");
                }
                else if (result == ERROR_CODE.USER_NOT_FIND)               // 用户丢失
                {
                    Response.Write("<script>alert('查询不到用户，请重新登陆');</script>");
                    Response.Redirect("Login.aspx");
                }
                else if (result == ERROR_CODE.SUCCESS)                    // 插入用户成功，刷新前一个页面
                {
                    // Response.Write("<script>alert('添加商机成功！');window.location.href=window.location.href;</script>");  //
                   
                  
                    if (!string.IsNullOrEmpty(callBackFiled))
                    {
                      
                        Response.Write("<script>window.opener."+callBackFiled+"('"+param.general.name+"','"+id+"');</script>");
                      
                    }
                    ClientScript.RegisterStartupScript(this.GetType(), "提示信息", "<script>alert('添加商机成功！');location.href='OpportunityAddAndEdit.aspx?opportunity_id=" + id + "';</script>");
                    //Response.Redirect("../Opportunity/OpportunityAddAndEdit.aspx?opportunity_id=" + id);

                }
            }
            else
            {
                param.general.id = opportunity.id;
                var result = new OpportunityBLL().Update(param, GetLoginUserId());
                if (result == ERROR_CODE.PARAMS_ERROR)   // 必填参数丢失，重写
                {
                    ClientScript.RegisterStartupScript(this.GetType(), "提示信息", "<script>alert('必填参数丢失，请重新填写'); </script>");
                }
                else if (result == ERROR_CODE.USER_NOT_FIND)               // 用户丢失
                {
                    Response.Write("<script>alert('查询不到用户，请重新登陆');</script>");
                    Response.Redirect("Login.aspx");
                }
                else if (result == ERROR_CODE.SUCCESS)                    // 插入用户成功，刷新前一个页面
                {
                    ClientScript.RegisterStartupScript(this.GetType(), "提示信息", "<script>alert('修改商机成功！');location.href='OpportunityAddAndEdit.aspx?opportunity_id="+ opportunity.id+ "';</script>");
                    //Response.Redirect("../Opportunity/OpportunityAddAndEdit.aspx?opportunity_id=" + opportunity.id);

                    //Response.Write("<script>alert('修改商机成功！');window.close();</script>");  //  关闭添加页面的同时，刷新父页面
                }
            }
        }
        /// <summary>
        /// 保存并关闭
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void save_close_Click(object sender, EventArgs e)
        {
            var param = GetParam();

            if (isAdd)
            {
                var id = "";
                var result = new OpportunityBLL().Insert(param, GetLoginUserId(),out id);   // 根据参数插入商机
                if (result == ERROR_CODE.PARAMS_ERROR)   // 必填参数丢失，重写
                {
                    ClientScript.RegisterStartupScript(this.GetType(), "提示信息", "<script>alert('必填参数丢失，请重新填写'); </script>");
                    //Response.Write("<script>alert('必填参数丢失，请重新填写'); </script>");
                }
                else if (result == ERROR_CODE.USER_NOT_FIND)               // 用户丢失
                {
                    Response.Write("<script>alert('查询不到用户，请重新登陆');</script>");
                    Response.Redirect("Login.aspx");
                }
                else if (result == ERROR_CODE.SUCCESS)                    // 插入用户成功，刷新前一个页面
                {
                    if (!string.IsNullOrEmpty(callBackFiled))
                    {

                        Response.Write("<script>debugger;window.opener." + callBackFiled + "('" + param.general.name + "','" + id + "');</script>");

                    }
                    Response.Write("<script>alert('添加商机成功！');window.close();self.opener.location.reload();</script>");  //  
                }
            }
            else
            {
                param.general.id = opportunity.id;
                var result = new OpportunityBLL().Update(param, GetLoginUserId());
                if (result == ERROR_CODE.PARAMS_ERROR)   // 必填参数丢失，重写
                {
                    ClientScript.RegisterStartupScript(this.GetType(), "提示信息", "<script>alert('必填参数丢失，请重新填写'); </script>");
                }
                else if (result == ERROR_CODE.USER_NOT_FIND)               // 用户丢失
                {
                    Response.Write("<script>alert('查询不到用户，请重新登陆');</script>");
                    Response.Redirect("Login.aspx");
                }
                else if (result == ERROR_CODE.SUCCESS)                    // 插入用户成功，刷新前一个页面
                {
                    ClientScript.RegisterStartupScript(this.GetType(), "提示信息", "<script>alert('修改商机成功！');window.close();self.opener.location.reload();</script>");
                    //Response.Write("<script>alert('修改商机成功！');window.close();</script>");  //  关闭添加页面的同时，刷新父页面
                }
            }
        }

        /// <summary>
        /// 保存并新增报价
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void save_newAdd_Click(object sender, EventArgs e)
        {
            var param = GetParam();

            string id = "";
            if (isAdd)
            {
                var result = new OpportunityBLL().Insert(param, GetLoginUserId(),out id);   // 根据参数插入商机
                if (result == ERROR_CODE.PARAMS_ERROR)   // 必填参数丢失，重写
                {
                    ClientScript.RegisterStartupScript(this.GetType(), "提示信息", "<script>alert('必填参数丢失，请重新填写'); </script>");
                    //Response.Write("<script>alert('必填参数丢失，请重新填写'); </script>");
                }
                else if (result == ERROR_CODE.USER_NOT_FIND)               // 用户丢失
                {
                    Response.Write("<script>alert('查询不到用户，请重新登陆');</script>");
                    Response.Redirect("Login.aspx");
                }
                else if (result == ERROR_CODE.SUCCESS)                    // 插入用户成功，刷新前一个页面
                {
                    if (!string.IsNullOrEmpty(callBackFiled))
                    {

                        Response.Write("<script>debugger;window.opener." + callBackFiled + "('" + param.general.name + "','" + id + "');</script>");

                    }
                    ClientScript.RegisterStartupScript(this.GetType(), "提示信息", "<script>alert('添加商机成功！');self.opener.location.reload();window.close();window.open('../Quote/QuoteAddAndUpdate?quote_opportunity_id=" + id + "','" + (int)EMT.DoneNOW.DTO.OpenWindow.QuoteAdd + "','left= 200, top = 200, width = 960, height = 750', false);</script>");
                    //Response.Write("<script></script>");
                    //Response.Write("<script>alert('添加商机成功！');</script>");  //  
                    //Response.Redirect("../Quote/QuoteAddAndUpdate?opportunity_id="+id);
                }
            }
            else
            {
                param.general.id = opportunity.id;
                var result = new OpportunityBLL().Update(param, GetLoginUserId());
                if (result == ERROR_CODE.PARAMS_ERROR)   // 必填参数丢失，重写
                {
                    ClientScript.RegisterStartupScript(this.GetType(), "提示信息", "<script>alert('必填参数丢失，请重新填写'); </script>");
                }
                else if (result == ERROR_CODE.USER_NOT_FIND)               // 用户丢失
                {
                    Response.Write("<script>alert('查询不到用户，请重新登陆');</script>");
                    Response.Redirect("Login.aspx");
                }
                else if (result == ERROR_CODE.SUCCESS)                    // 插入用户成功，刷新前一个页面
                {
                    ClientScript.RegisterStartupScript(this.GetType(), "提示信息", "<script>alert('修改商机成功！');self.opener.location.reload();window.close();window.open('../Quote/QuoteAddAndUpdate?quote_opportunity_id=" + opportunity.id + "','" + (int)EMT.DoneNOW.DTO.OpenWindow.QuoteAdd + "','left= 200, top = 200, width = 960, height = 750', false);</script>");
                    // Response.Redirect("../Quote/QuoteAddAndUpdate?quote_opportunity_id=" + opportunity.id);
                }
            }
        }
        /// <summary>
        /// 保存并新增备注
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void save_create_note_Click(object sender, EventArgs e)
        {
            var param = GetParam();

            if (isAdd)
            {
                var id = "";
                var result = new OpportunityBLL().Insert(param, GetLoginUserId(), out id);   // 根据参数插入商机
                if (result == ERROR_CODE.PARAMS_ERROR)   // 必填参数丢失，重写
                {
                    ClientScript.RegisterStartupScript(this.GetType(), "提示信息", "<script>alert('必填参数丢失，请重新填写'); </script>");
                    //Response.Write("<script>alert('必填参数丢失，请重新填写'); </script>");
                }
                else if (result == ERROR_CODE.USER_NOT_FIND)               // 用户丢失
                {
                    Response.Write("<script>alert('查询不到用户，请重新登陆');</script>");
                    Response.Redirect("Login.aspx");
                }
                else if (result == ERROR_CODE.SUCCESS)                    // 插入用户成功，刷新前一个页面
                {
                    if (!string.IsNullOrEmpty(callBackFiled))
                    {

                        Response.Write("<script>debugger;window.opener." + callBackFiled + "('" + param.general.name + "','" + id + "');</script>");

                    }
                    Response.Write("<script>alert('添加商机成功！');self.opener.location.reload();</script>");  //  
                    Response.Redirect("../Activity/AddActivity.aspx");
                }
            }
            else
            {
                param.general.id = opportunity.id;
                var result = new OpportunityBLL().Update(param, GetLoginUserId());
                if (result == ERROR_CODE.PARAMS_ERROR)   // 必填参数丢失，重写
                {
                    ClientScript.RegisterStartupScript(this.GetType(), "提示信息", "<script>alert('必填参数丢失，请重新填写'); </script>");
                }
                else if (result == ERROR_CODE.USER_NOT_FIND)               // 用户丢失
                {
                    Response.Write("<script>alert('查询不到用户，请重新登陆');</script>");
                    Response.Redirect("Login.aspx");
                }
                else if (result == ERROR_CODE.SUCCESS)                    // 插入用户成功，刷新前一个页面
                {
                    ClientScript.RegisterStartupScript(this.GetType(), "提示信息", "<script>alert('修改商机成功！');self.opener.location.reload();</script>");
                    Response.Redirect("../Activity/AddActivity.aspx");
                    //Response.Write("<script>alert('修改商机成功！');window.close();</script>");  //  关闭添加页面的同时，刷新父页面
                }
            }
        }

        /// <summary>
        /// 获取到表单参数
        /// </summary>
        /// <returns></returns>
        protected OpportunityAddOrUpdateDto GetParam()
        {
            var param = new OpportunityAddOrUpdateDto()
            {
                general = AssembleModel<crm_opportunity>(),
                notify = AssembleModel<com_notify_email>(),
            };
            param.general.use_quote = (sbyte)(is_use_quote.Checked ? 1 : 0);
            if (opportunity_udfList != null && opportunity_udfList.Count > 0)                      // 首先判断是否有自定义信息
            {
                var list = new List<UserDefinedFieldValue>();
                foreach (var udf in opportunity_udfList)                            // 循环添加
                {
                    var new_udf = new UserDefinedFieldValue()
                    {
                        id = udf.id,
                        value = Request.Form[udf.id.ToString()] == "" ? null : Request.Form[udf.id.ToString()],
                    };
                    list.Add(new_udf);
                }
                param.udf = list;
            }
            return param;
        }

    }
}