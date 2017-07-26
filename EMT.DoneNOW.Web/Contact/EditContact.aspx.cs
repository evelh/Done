using EMT.DoneNOW.BLL;
using EMT.DoneNOW.BLL.CRM;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DTO;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace EMT.DoneNOW.Web
{
    public partial class EditContact : BasePage
    {
        /// <summary>
        /// 联系人自定义字段
        /// </summary>
        protected List<UserDefinedFieldDto> contact_udfList = null;
        protected List<UserDefinedFieldValue> contact_udfValueList = null; //contact
        protected crm_contact contact = null;
        protected List<crm_location> location_list = null;   // 用户的所有地址
        protected Dictionary<string, object> dic = null;
        protected void Page_Load(object sender, EventArgs e)
        {
            var contact_id = Convert.ToInt64(Request.QueryString["id"]);
            contact_udfList = new UserDefinedFieldsBLL().GetUdf(DicEnum.UDF_CATE.CONTACT);
            contact_udfValueList = new UserDefinedFieldsBLL().GetUdfValue(DicEnum.UDF_CATE.CONTACT, contact_id, contact_udfList);
            contact = new ContactBLL().GetContact(contact_id);
            location_list = new LocationBLL().GetLocationByCompany(contact_id);
            if (!IsPostBack)
            {
                if (contact != null)
                {
                    #region 为下拉框获取数据源
                    dic = new ContactBLL().GetField();
                    sufix.DataTextField = "show";
                    sufix.DataValueField = "val";
                    sufix.DataSource = dic.FirstOrDefault(_ => _.Key == "sufix").Value;
                    sufix.DataBind();
                    sufix.Items.Insert(0, new ListItem() { Value = "0", Text = "   ", Selected = true });
                    #endregion
                }

            }
        }
    }
}