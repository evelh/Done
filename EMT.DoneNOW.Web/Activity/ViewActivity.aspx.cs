using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DTO;
using EMT.DoneNOW.BLL;

namespace EMT.DoneNOW.Web.Activity
{
    public partial class ViewActivity : BasePage
    {
        protected com_activity thisActivity;
        protected sys_resource createUser;
        protected sys_resource assignUser;
        protected d_general actType;
        protected crm_account account;
        protected bool isTodo = false;
        protected void Page_Load(object sender, EventArgs e)
        {
            long id = 0;
            if (!string.IsNullOrEmpty(Request.QueryString["id"]) && long.TryParse(Request.QueryString["id"], out id))
                thisActivity = new ActivityBLL().GetActivity(id);


            if (thisActivity == null)
            {
                Response.Write("<script>alert('为获取到相关信息！请刷新页面后重试！');window.close();</script>");
            }
            else
            {
                if (thisActivity.account_id != null)
                    account = new CompanyBLL().GetCompany((long)thisActivity.account_id);
                if (thisActivity.resource_id != null)
                    assignUser = new UserResourceBLL().GetResourceById((long)thisActivity.resource_id);
                createUser = new UserResourceBLL().GetResourceById(thisActivity.create_user_id);

                actType = new GeneralBLL().GetSingleGeneral(thisActivity.action_type_id,true);

                if (thisActivity.action_type_id == (int)DTO.DicEnum.ACTIVITY_CATE.TODO)
                    isTodo = true;

            }
        }
    }
}