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
using EMT.DoneNOW.BLL.CRM;
using static EMT.DoneNOW.DTO.DicEnum;

namespace EMT.DoneNOW.Web.ConfigurationItem
{
    public partial class AddOrEditConfigItem : BasePage
    {
        public bool isAdd = true;
        public crm_installed_product iProduct = null;
        protected List<UserDefinedFieldDto> iProduct_udfList = null;
        protected List<UserDefinedFieldValue> iProduct_udfValueList = null; //company
        protected Dictionary<string, object> dic = new InstalledProductBLL().GetField();
        protected crm_account account = null;
        protected ivt_product product = null;
        protected ConfigurationItemAddDto param = new ConfigurationItemAddDto();
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                iProduct_udfList = new UserDefinedFieldsBLL().GetUdf(DicEnum.UDF_CATE.CONFIGURATION_ITEMS);
                var account_id = Request.QueryString["account_id"];
                account = new CompanyBLL().GetCompany(long.Parse(account_id));

                var contactList = new crm_contact_dal().GetContactByAccountId(long.Parse(account_id));
                var serviceList = new ivt_service_dal().GetServiceList($" and vendor_id = {account_id}");

                #region 配置下拉框数据源
                installed_product_cate_id.DataTextField = "show";
                installed_product_cate_id.DataValueField = "val";
                installed_product_cate_id.DataSource = dic.FirstOrDefault(_ => _.Key == "installed_product_cate").Value;
                installed_product_cate_id.DataBind();
                installed_product_cate_id.Items.Insert(0, new ListItem() { Value = "0", Text = "   ", Selected = true });

                contact_id.DataTextField = "name";
                contact_id.DataValueField = "id";
                contact_id.DataSource = contactList;
                contact_id.DataBind();
                contact_id.Items.Insert(0, new ListItem() { Value = "0", Text = "   ", Selected = true });

                // 
                service.DataTextField = "name";
                service.DataValueField = "id";
                service.DataSource = serviceList;
                service.DataBind();
                service.Items.Insert(0, new ListItem() { Value = "0", Text = "   ", Selected = true });


                service.Enabled = false; // 所选合同如果是服务类型的，则此下拉框可选。可选内容为合同项
                #endregion


                var id = Request.QueryString["id"];
                if (!string.IsNullOrEmpty(id))
                {
                    iProduct = new crm_installed_product_dal().GetInstalledProduct(long.Parse(id));
                    if (iProduct != null)
                    {
                        //account_id = iProduct.account_id.ToString();
                        iProduct_udfValueList = new UserDefinedFieldsBLL().GetUdfValue(DicEnum.UDF_CATE.CONFIGURATION_ITEMS, iProduct.id, iProduct_udfList);
                        isAdd = false;
                    
                       installed_product_cate_id.SelectedValue = iProduct.cate_id.ToString();
                       
                        if (iProduct.contact_id != null)
                        {
                            contact_id.SelectedValue = iProduct.contact_id.ToString();
                        }
                        viewSubscription_iframe.Src = "";
                        // todo 订阅的通用查询
                        // "../Common/SearchBodyFrame.aspx?cat=" + (int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.CONTACT_COMPANY_VIEW + "&type=" + (int)EMT.DoneNOW.DTO.QueryType.ContactCompanyView + "&id=" + id;

                    }
                }



                if (!IsPostBack)
                {
                    is_active_.Checked = true;
                    if (iProduct != null)
                    {
                        is_active_.Checked = iProduct.is_active == 1;
                    }
                }


            }
            catch (Exception)
            {

                Response.End();
            }
            
        }

        protected void save_Click(object sender, EventArgs e)
        {
            var result = false;
            if (isAdd)
            {
                 result = new InstalledProductBLL().ConfigurationItemAdd(GetPara(), GetLoginUserId());
                if (result)
                {
                    Response.Write("<script>alert('添加配置项成功！');location.href='AddOrEditConfigItem.aspx?id=" + param.id + "&account_id=" + account.id + "';</script>");
                }
                
            }
            else
            {
                 result = new InstalledProductBLL().EditConfigurationItem(GetPara(), GetLoginUserId());
                if (result)
                {
                    Response.Write("<script>alert('修改配置项成功！');location.href='AddOrEditConfigItem.aspx?id=" + param.id + "&account_id=" + account.id + "';</script>");
                }
                
            }
            
           
        }
        /// <summary>
        /// 获取到页面参数
        /// </summary>
        /// <returns></returns>
        private ConfigurationItemAddDto GetPara()
        {
            // ConfigurationItemAddDto param = new ConfigurationItemAddDto() {};
            param = AssembleModel<ConfigurationItemAddDto>();
            param.terms = AssembleModel<Terms>();
            param.status = is_active_.Checked ? 1 : 0;
            if (iProduct_udfList != null && iProduct_udfList.Count > 0)                      // 首先判断是否有自定义信息
            {
                var list = new List<UserDefinedFieldValue>();
                foreach (var udf in iProduct_udfList)                            // 循环添加
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

            if (isAdd)
            {

            }
            else
            {
                param.id = iProduct.id;
            }

            return param;
        }

        protected void save_close_Click(object sender, EventArgs e)
        {
            var result = false;
            if (isAdd)
            {
                result = new InstalledProductBLL().ConfigurationItemAdd(GetPara(), GetLoginUserId());
                if (result)
                {
                    Response.Write("<script>alert('添加配置项成功！');window.close();self.opener.location.reload();</script>");
                }

            }
            else
            {
                result = new InstalledProductBLL().EditConfigurationItem(GetPara(), GetLoginUserId());
                if (result)
                {
                    Response.Write("<script>alert('修改配置项成功！');window.close();self.opener.location.reload();</script>");
                }

            }
        }

        protected void save_add_Click(object sender, EventArgs e)
        {
            
            var result = false;
            if (isAdd)
            {
                result = new InstalledProductBLL().ConfigurationItemAdd(GetPara(), GetLoginUserId());
                if (result)
                {
                    Response.Write("<script>alert('添加配置项成功！');window.open('AddOrEditConfigItem.aspx?account_id=" + account.id + "','" + (int)EMT.DoneNOW.DTO.OpenWindow.AddInstalledProduct + "');</script>");
                }

            }
            else
            {
                result = new InstalledProductBLL().EditConfigurationItem(GetPara(), GetLoginUserId());
                if (result)
                {
                    Response.Write("<script>alert('修改配置项成功！');window.open('AddOrEditConfigItem.aspx?account_id=" + account.id + "','" + (int)EMT.DoneNOW.DTO.OpenWindow.AddInstalledProduct + "');</script>");
                }

            }
        }
    }
}