using EMT.DoneNOW.DTO;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EMT.DoneNOW.BLL;
using EMT.DoneNOW.Core;

namespace EMT.DoneNOW.Web
{
    public partial class AddCompany : BasePage
    {
        protected List<UserDefinedFieldDto> company_udfList = null;      // 客户自定义
        protected List<UserDefinedFieldDto> contact_udfList = null;      // 联系人自定义
        protected List<UserDefinedFieldDto> site_udfList = null; // 站点自定义
        protected crm_account parent_account = null;
        protected void Page_Load(object sender, EventArgs e)
        {

            #region 下拉框赋值

            var dic = new CompanyBLL().GetField();

            // 分类类别
            classification.DataTextField = "show";
            classification.DataValueField = "val";
            classification.DataSource = dic.FirstOrDefault(_ => _.Key == "classification").Value;
            classification.DataBind();
            classification.Items.Insert(0, new ListItem() { Value = "0", Text = "   ", Selected = true });
            // 公司类型
            company_type.DataTextField = "show";
            company_type.DataValueField = "val";
            company_type.DataSource = dic.FirstOrDefault(_ => _.Key == "company_type").Value;
            company_type.DataBind();
            company_type.Items.Insert(0, new ListItem() { Value = "0", Text = "   ", Selected = true });

            // 市场领域
            market_segment.DataTextField = "show";
            market_segment.DataValueField = "val";
            market_segment.DataSource = dic.FirstOrDefault(_ => _.Key == "market_segment").Value;
            market_segment.DataBind();
            market_segment.Items.Insert(0, new ListItem() { Value = "0", Text = "   ", Selected = true });
            // 销售区域
            territory_name.DataTextField = "show";
            territory_name.DataValueField = "val";
            territory_name.DataSource = dic.FirstOrDefault(_ => _.Key == "territory").Value;
            territory_name.DataBind();
            territory_name.Items.Insert(0, new ListItem() { Value = "0", Text = "   ", Selected = true });
            // 客户经理
            account_manage.DataTextField = "show";
            account_manage.DataValueField = "val";
            account_manage.DataSource = dic.FirstOrDefault(_ => _.Key == "sys_resource").Value;
            account_manage.DataBind();
            account_manage.Items.Insert(0, new ListItem() { Value = "0", Text = "   ", Selected = true });
            // 税区
            tax_region.DataTextField = "show";
            tax_region.DataValueField = "val";
            tax_region.DataSource = dic.FirstOrDefault(_ => _.Key == "taxRegion").Value;
            tax_region.DataBind();
            tax_region.Items.Insert(0, new ListItem() { Value = "0", Text = "   ", Selected = true });
            // 竞争对手
            competitor.DataTextField = "show";
            competitor.DataValueField = "val";
            competitor.DataSource = dic.FirstOrDefault(_ => _.Key == "competition").Value;
            competitor.DataBind();
            competitor.Items.Insert(0, new ListItem() { Value = "0", Text = "   ", Selected = true });
            // 称谓
            sufix.DataTextField = "show";
            sufix.DataValueField = "val";
            sufix.DataSource = dic.FirstOrDefault(_ => _.Key == "sufix").Value;
            sufix.DataBind();
            sufix.Items.Insert(0, new ListItem() { Value = "0", Text = "   ", Selected = true });

            // note_action_type
            note_action_type.DataTextField = "show";
            note_action_type.DataValueField = "val";
            note_action_type.DataSource = dic.FirstOrDefault(_ => _.Key == "action_type").Value;
            note_action_type.DataBind();
            note_action_type.Items.Insert(0, new ListItem() { Value = "0", Text = "   ", Selected = true });

            // todo_action_type
            todo_action_type.DataTextField = "show";
            todo_action_type.DataValueField = "val";
            todo_action_type.DataSource = dic.FirstOrDefault(_ => _.Key == "action_type").Value;
            todo_action_type.DataBind();
            todo_action_type.Items.Insert(0, new ListItem() { Value = "0", Text = "   ", Selected = true });
            #endregion
            try
            {
                var parent_id = Request.QueryString["parent_id"];
                if (!string.IsNullOrEmpty(parent_id))
                {
                    parent_account = new CompanyBLL().GetCompany(Convert.ToInt64(parent_id));
                }
            }
            catch (Exception)
            {

                throw;
            }

            company_udfList = new UserDefinedFieldsBLL().GetUdf(DicEnum.UDF_CATE.COMPANY);
            contact_udfList = new UserDefinedFieldsBLL().GetUdf(DicEnum.UDF_CATE.CONTACT);
            site_udfList = new UserDefinedFieldsBLL().GetUdf(DicEnum.UDF_CATE.SITE);
        }

        /// <summary>
        /// 保存并关闭
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void save_Click(object sender, EventArgs e)
        {
            var param = new CompanyAddDto();
            param.general = AssembleModel<CompanyAddDto.General>();
            param.contact = AssembleModel<CompanyAddDto.Contact>();
            param.location = AssembleModel<CompanyAddDto.Location>();
            param.note = AssembleModel<CompanyAddDto.Note>();
            param.site = AssembleModel<CompanyAddDto.Site>();
            param.todo = AssembleModel<CompanyAddDto.Todo>();
            // var param = AssembleModel<CompanyAddDto>();
            if (company_udfList != null && company_udfList.Count > 0)                      // 首先判断是否有自定义信息
            {
                var list = new List<UserDefinedFieldValue>();
                foreach (var udf in company_udfList)                            // 循环添加
                {
                    var new_udf = new UserDefinedFieldValue()
                    {
                        id = udf.id,
                        value = Request.Form[udf.id.ToString()] == "" ? null : Request.Form[udf.id.ToString()],
                    };
                    list.Add(new_udf);

                }
                param.general.udf = list;
            }

            if (contact_udfList != null && contact_udfList.Count > 0)
            {
                var list = new List<UserDefinedFieldValue>();
                foreach (var udf in contact_udfList)
                {
                    var new_udf = new UserDefinedFieldValue()
                    {
                        id = udf.id,
                        value = Request.Form[udf.id.ToString()] == "" ? null : Request.Form[udf.id.ToString()],
                    };
                    list.Add(new_udf);
                }
                param.contact.udf = list;
            }

            if (site_udfList != null && site_udfList.Count > 0)
            {
                var list = new List<UserDefinedFieldValue>();
                foreach (var udf in site_udfList)
                {
                    var new_udf = new UserDefinedFieldValue()
                    {
                        id = udf.id,
                        value = Request.Form[udf.id.ToString()] == "" ? null : Request.Form[udf.id.ToString()],
                    };
                    list.Add(new_udf);
                }
                param.site.udf = list;
            }

            var result = new CompanyBLL().Insert(param, GetLoginUserId());


            if (result == ERROR_CODE.PARAMS_ERROR)   // 必填参数丢失，重写
            {

                ClientScript.RegisterStartupScript(this.GetType(), "提示信息", "<script>alert('必填参数丢失，请重新填写');</script>");
            }
            else if (result == ERROR_CODE.CRM_ACCOUNT_NAME_EXIST)      // 用户名称已经存在，重新填写用户名称
            {

                ClientScript.RegisterStartupScript(this.GetType(), "提示信息", "<script>alert('客户已经存在');</script>");
            }
            else if (result == ERROR_CODE.USER_NOT_FIND)               // 用户丢失
            {
                Response.Write("<script>alert('查询不到用户，请重新登陆');</script>");
                Response.Redirect("Login.aspx");
            }
            else if (result == ERROR_CODE.MOBILE_PHONE_OCCUPY)
            {

                ClientScript.RegisterStartupScript(this.GetType(), "提示信息", "<script>alert('电话名称重复');</script>");
            }
            else if (result == ERROR_CODE.SUCCESS)                    // 插入用户成功，刷新前一个页面
            {
                Response.Write("<script>alert('添加客户成功！');window.close();self.opener.location.reload();</script>");  //  关闭添加页面的同时，刷新父页面
            }
        }
        /// <summary>
        /// 保存并新建
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void save_newAdd_Click(object sender, EventArgs e)
        {
            var param = new CompanyAddDto();
            param.general = AssembleModel<CompanyAddDto.General>();
            param.contact = AssembleModel<CompanyAddDto.Contact>();
            param.location = AssembleModel<CompanyAddDto.Location>();
            param.note = AssembleModel<CompanyAddDto.Note>();
            param.site = AssembleModel<CompanyAddDto.Site>();
            param.todo = AssembleModel<CompanyAddDto.Todo>();
            // var param = AssembleModel<CompanyAddDto>();
            if (company_udfList != null && company_udfList.Count > 0)                      // 首先判断是否有自定义信息
            {
                var list = new List<UserDefinedFieldValue>();
                foreach (var udf in company_udfList)                            // 循环添加
                {
                    var new_udf = new UserDefinedFieldValue()
                    {
                        id = udf.id,
                        value = Request.Form[udf.id.ToString()] == "" ? null : Request.Form[udf.id.ToString()],
                    };
                    list.Add(new_udf);

                }
                param.general.udf = list;
            }

            if (contact_udfList != null && contact_udfList.Count > 0)
            {
                var list = new List<UserDefinedFieldValue>();
                foreach (var udf in contact_udfList)
                {
                    var new_udf = new UserDefinedFieldValue()
                    {
                        id = udf.id,
                        value = Request.Form[udf.id.ToString()] == "" ? null : Request.Form[udf.id.ToString()],
                    };
                    list.Add(new_udf);
                }
                param.contact.udf = list;
            }

            if (site_udfList != null && site_udfList.Count > 0)
            {
                var list = new List<UserDefinedFieldValue>();
                foreach (var udf in site_udfList)
                {
                    var new_udf = new UserDefinedFieldValue()
                    {
                        id = udf.id,
                        value = Request.Form[udf.id.ToString()] == "" ? null : Request.Form[udf.id.ToString()],
                    };
                    list.Add(new_udf);
                }
                param.site.udf = list;
            }

            var result = new CompanyBLL().Insert(param, GetLoginUserId());
            Response.Write("<script>document.getElementById(\"isCheckCompanyName\").value = 'yes';</script>");
            if (result == ERROR_CODE.PARAMS_ERROR)   // 必填参数丢失，重写
            {
                ClientScript.RegisterStartupScript(this.GetType(), "提示信息", "<script>alert('必填参数丢失，请重新填写');</script>");
            }
            else if (result == ERROR_CODE.CRM_ACCOUNT_NAME_EXIST)      // 用户名称已经存在，重新填写用户名称
            {
                ClientScript.RegisterStartupScript(this.GetType(), "提示信息", "<script>alert('客户已经存在');</script>");
            }
            else if (result == ERROR_CODE.USER_NOT_FIND)               // 用户丢失
            {
                Response.Write("<script>alert('查询不到用户，请重新登陆');</script>");
                Response.Redirect("Login.aspx");
            }
            else if (result == ERROR_CODE.MOBILE_PHONE_OCCUPY)
            {
                ClientScript.RegisterStartupScript(this.GetType(), "提示信息", "<script>alert('电话名称重复');</script>");
            }
            else if (result == ERROR_CODE.SUCCESS)                    // 插入用户成功，刷新前一个页面
            {
                Response.Write("<script>alert('添加客户成功！');</script>");
                Response.Redirect("AddCompany.aspx");

            }
        }
        /// <summary>
        /// 保存并创建商机
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void save_create_opportunity_Click(object sender, EventArgs e)
        {
            var param = new CompanyAddDto();
            param.general = AssembleModel<CompanyAddDto.General>();
            param.contact = AssembleModel<CompanyAddDto.Contact>();
            param.location = AssembleModel<CompanyAddDto.Location>();
            param.note = AssembleModel<CompanyAddDto.Note>();
            param.site = AssembleModel<CompanyAddDto.Site>();
            param.todo = AssembleModel<CompanyAddDto.Todo>();
            // var param = AssembleModel<CompanyAddDto>();
            if (company_udfList != null && company_udfList.Count > 0)                      // 首先判断是否有自定义信息
            {
                var list = new List<UserDefinedFieldValue>();
                foreach (var udf in company_udfList)                            // 循环添加
                {
                    var new_udf = new UserDefinedFieldValue()
                    {
                        id = udf.id,
                        value = Request.Form[udf.id.ToString()] == "" ? null : Request.Form[udf.id.ToString()],
                    };
                    list.Add(new_udf);

                }
                param.general.udf = list;
            }

            if (contact_udfList != null && contact_udfList.Count > 0)
            {
                var list = new List<UserDefinedFieldValue>();
                foreach (var udf in contact_udfList)
                {
                    var new_udf = new UserDefinedFieldValue()
                    {
                        id = udf.id,
                        value = Request.Form[udf.id.ToString()] == "" ? null : Request.Form[udf.id.ToString()],
                    };
                    list.Add(new_udf);
                }
                param.contact.udf = list;
            }

            if (site_udfList != null && site_udfList.Count > 0)
            {
                var list = new List<UserDefinedFieldValue>();
                foreach (var udf in site_udfList)
                {
                    var new_udf = new UserDefinedFieldValue()
                    {
                        id = udf.id,
                        value = Request.Form[udf.id.ToString()] == "" ? null : Request.Form[udf.id.ToString()],
                    };
                    list.Add(new_udf);
                }
                param.site.udf = list;
            }

            var result = new CompanyBLL().Insert(param, GetLoginUserId());
            // Response.Write("<script>document.getElementById(\"isCheckCompanyName\").value = 'yes';</script>");
            if (result == ERROR_CODE.PARAMS_ERROR)   // 必填参数丢失，重写
            {
                ClientScript.RegisterStartupScript(this.GetType(), "提示信息", "<script>alert('必填参数丢失，请重新填写');</script>");
            }
            else if (result == ERROR_CODE.CRM_ACCOUNT_NAME_EXIST)      // 用户名称已经存在，重新填写用户名称
            {
                ClientScript.RegisterStartupScript(this.GetType(), "提示信息", "<script>alert('客户已经存在');</script>");
            }
            else if (result == ERROR_CODE.USER_NOT_FIND)               // 用户丢失
            {
                Response.Write("<script>alert('查询不到用户，请重新登陆');</script>");
                Response.Redirect("Login.aspx");
            }
            else if (result == ERROR_CODE.MOBILE_PHONE_OCCUPY)
            {
                ClientScript.RegisterStartupScript(this.GetType(), "提示信息", "<script>alert('电话名称重复');</script>");
            }
            else if (result == ERROR_CODE.SUCCESS)                    // 
                Response.Write("<script>alert('添加客户成功！');</script>");  //  
            Response.Redirect("../Opportunity/OpportunityAddAndEdit.aspx"); // 跳转到新建商机

        }
    }
}
