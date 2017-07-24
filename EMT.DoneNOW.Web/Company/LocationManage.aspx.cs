using EMT.DoneNOW.BLL.CRM;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EMT.DoneNOW.Core;

namespace EMT.DoneNOW.Web.Company
{
    public partial class LocationManage : BasePage
    {
        protected string location_id = null;
        protected crm_location location = null;
        protected void Page_Load(object sender, EventArgs e)

        {
            location_id = Request.QueryString["id"];    // 传id进来代表修改，未传代表新增
            var account = Request.QueryString["account_id"]; 
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

            if (location.id==0)
            {
                new LocationBLL().Insert(location, GetLoginUserId());
            }
            else
            {
                new LocationBLL().Update(location,GetLoginUserId());
            }
        }
    }
}