using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EMT.DoneNOW.DTO;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.BLL;

namespace EMT.DoneNOW.Web.Company
{
    public partial class DeleteCompany : BasePage
    {
        protected crm_account crm_account = null;
        protected Dictionary<string, object> dic = null;
        protected CompanyBLL companyBll = new CompanyBLL();
        protected void Page_Load(object sender, EventArgs e)
        {
            var id = Request.QueryString["id"];
            if (id != null)
            {
                crm_account = new CompanyBLL().GetCompany(Convert.ToInt64(id));
                dic = companyBll.GetField();
                if (crm_account != null)
                {

                }
                else
                {
                    Response.End();
                }
            }
            else
            {
                Response.End();
            }
        }

        /// <summary>
        /// 获取到当前操作的客户
        /// </summary>
        /// <returns></returns>
        public  crm_account GetAccount()
        {
            return crm_account;
        }
        /// <summary>
        /// 获取到客户的默认地址
        /// </summary>
        /// <returns></returns>
        public crm_location GetDefaultLocation()
        {
            return new LocationBLL().GetLocationByAccountId(crm_account.id);
        }

        /// <summary>
        /// 获取到客户的主要联系人，可能为null
        /// </summary>
        /// <returns></returns>
        public crm_contact GetDefaultContact()
        {
            return new ContactBLL().GetDefaultByAccountId(crm_account.id);
        }

        protected void Delete_Click(object sender, EventArgs e)
        {
            var id = Convert.ToInt64(Request.QueryString["id"]);
            var result = new CompanyBLL().DeleteCompany(id, GetLoginUserId());
            if (result)
            {
                Response.Write("<script>alert('删除客户成功！');window.close();</script>");  //  关闭添加页面的同时，刷新父页面
                // self.opener.location.reload();
            }
            else
            {
                ClientScript.RegisterStartupScript(this.GetType(), "提示信息", "<script>alert('删除客户失败!');</script>");
                //Response.Write("<script>alert('删除客户失败！');</script>");
            }
        }
    }
}