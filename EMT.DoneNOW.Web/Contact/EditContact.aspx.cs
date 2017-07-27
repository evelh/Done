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
            try
            {
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

                        externalID.Text = contact.external_id;
                        first_name.Value = contact.first_name;
                        last_name.Value = contact.last_name;
                        sufix.Text = contact.suffix_id==null?"": contact.suffix_id.ToString();
                        active.Checked = contact.is_active == 1;
                        title.Value = contact.title;
                        primaryContact.Checked = contact.is_primary_contact == 1;
                        address.Value = contact.location_id==null?"": contact.location_id.ToString();
                        AdditionalAddress.Value = contact.location_id2==null?"": contact.location_id2.ToString();
                        email.Value = contact.email;
                        email2.Value = contact.email2==null?"": contact.email2.ToString();
                        phone.Value = contact.phone;
                        alternatePhone.Value = contact.phone;
                        mobilePhone.Value = contact.phone;
                        fax.Value = contact.fax;

                        var location = new LocationBLL().GetLocationByAccountId(contact.id);
                        if (location != null)       
                        {
                            country_idInit.Value = location.country_id.ToString();
                            province_idInit.Value = location.province_id.ToString();
                            city_idInit.Value = location.city_id.ToString();
                            district_idInit.Value = location.district_id.ToString();
                            address.Value = location.address;
                            AdditionalAddress.Value = location.additional_address;
                        }
                    }
                    else
                    {
                        Response.Write("<script>alert('联系人不存在！');</script>");
                        Response.Redirect("index.aspx");
                    }
                }
            }catch (Exception)
            {
                Response.End();
            }
        }
        /// <summary>
        /// 保存并关闭 修改联系人的点击事件
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void save_close_Click(object sender, EventArgs e)
        {
            var param = new ContactAddAndUpdateDto();
            param.contact = AssembleModel<crm_contact>();
            param.location = AssembleModel<crm_location>();
            param.contact.name = param.contact.first_name + param.contact.last_name;
            if (contact_udfList != null && contact_udfList.Count > 0)                      // 首先判断是否有自定义信息
            {
                var list = new List<UserDefinedFieldValue>();
                foreach (var udf in contact_udfList)                            // 循环添加
                {
                    var new_udf = new UserDefinedFieldValue()
                    {
                        id = udf.id,
                        value = Request.Form[udf.id.ToString()] == null ? "" : Request.Form[udf.id.ToString()],
                    };
                    list.Add(new_udf);
                }
                param.udf = list;
            }

            var result = new ContactBLL().Insert(param, GetLoginUserId());
            if (result == ERROR_CODE.USER_NOT_FIND)   // 联系人为空，重写
            {
                Response.Write("<script>alert('联系人为空，请重新填写'); </script>");
            }
            else if (result == ERROR_CODE.PARAMS_ERROR)      // 必填项校验
            {
                Response.Write("<script>alert('必填项错误。'); </script>");
            }
            else if (result == ERROR_CODE.ERROR)               // 联系人已将存在
            {
                Response.Write("<script>alert('联系人已将存在');</script>");
                //Response.Redirect("Login.aspx");
            }
            else if (result == ERROR_CODE.SUCCESS)                    // 插入联系人成功，刷新前一个页面
            {
                Response.Write("<script>alert('添加联系人成功！');window.close();self.opener.location.reload();</script>");  //  关闭添加页面的同时，刷新父页面
            }
        }
        protected void save_newAdd_Click(object sender, EventArgs e)
        {

        }
    }
}