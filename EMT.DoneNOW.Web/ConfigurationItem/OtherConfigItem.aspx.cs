using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.BLL;

namespace EMT.DoneNOW.Web.ConfigurationItem
{
    public partial class OtherConfigItem : BasePage
    {
        protected crm_installed_product insPro;
        protected ivt_product product;
        protected void Page_Load(object sender, EventArgs e)
        {
            var insProId = Request.QueryString["insProId"];
            long id;
            if (!string.IsNullOrEmpty(insProId)&&long.TryParse(insProId,out id))
                insPro = new DAL.crm_installed_product_dal().FindNoDeleteById(id);
            if (insPro != null)
            {
                product = new DAL.ivt_product_dal().FindNoDeleteById(insPro.product_id);
            }
            else
            {
                Response.Write("<script>alert('未获取到相关配置项！');window.close();</script>");
                return;
            }
        }
    }
}