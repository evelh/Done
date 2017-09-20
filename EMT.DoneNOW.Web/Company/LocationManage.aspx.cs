using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.BLL;

namespace EMT.DoneNOW.Web.Company
{
    public partial class LocationManage : BasePage
    {
        protected string location_id = null;
        protected crm_location location = null;
        public string account_id = "";
        protected void Page_Load(object sender, EventArgs e)

        {
            location_id = Request.QueryString["id"];    // 传id进来代表修改，未传代表新增
            account_id = Request.QueryString["account_id"]; 
            if (!string.IsNullOrEmpty(location_id))   // 修改时
            {
                location = new LocationBLL().GetLocation(Convert.ToInt64(location_id));
                if (location != null)
                {
                   // is_default.Checked = location.is_default == 1;
                   // AreaCountyInit.Value = location.country_id.ToString();
                    province_idInit.Value = location.province_id.ToString();
                    city_idInit.Value = location.city_id.ToString();
                    district_idInit.Value = location.district_id.ToString();
                    address.Text = location.address;
                    additional_address.Text = location.additional_address;
                    postal_code.Text = location.postal_code;
                    location_label.Text = location.location_label;
                    if (!IsPostBack)
                    {
                        isDefault.Checked = location.is_default == 1;
                        isDefault.Enabled = false;
                    }
                }
            }
        }

        /// <summary>
        /// 地址的保存和修改事件
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void save_Click(object sender, EventArgs e)
        {
            var location = AssembleModel<crm_location>();
            location.is_default = (sbyte)(isDefault.Checked?1:0);
            if (location.id==0)
            {
                if(new LocationBLL().Insert(location, GetLoginUserId()))
                {
                    Response.Write("<script>alert('添加地址成功！');</script>");
                    //Response.Redirect("LocationManage?id="+location.id+"&account_id="+location.account_id);
                }
            }
            else
            {
               if(new LocationBLL().Update(location, GetLoginUserId()))
                {
                    Response.Write("<script>alert('修改地址成功！');</script>");
                }
            }
            // self.opener.location.reload();opener.
            Response.Write($"<script>window.opener.location.href='EditCompany?loaction=1&id={account_id}';window.close();</script>");
        }
    }
}