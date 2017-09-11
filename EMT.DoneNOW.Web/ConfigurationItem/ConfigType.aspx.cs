using EMT.DoneNOW.BLL;
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
    public partial class ConfigType :BasePage
    {
        protected long id;//配置项id
        protected List<sys_udf_field> GetAlludf = new List<sys_udf_field>();
        protected List<sys_udf_group_field> GetGroupudf = new List<sys_udf_group_field>();
        private ConfigTypeBLL ctbll = new ConfigTypeBLL();
        private GeneralBLL configtypebll = new GeneralBLL();
        private d_general configtype = new d_general();
        protected void Page_Load(object sender, EventArgs e)
        {
            id =Convert.ToInt64(Request.QueryString["id"]);
            if (!IsPostBack) {
                long group_udf_id=0;
                if (id > 0) {//修改数据
                    configtype = configtypebll.GetSingleGeneral(id);
                    this.Config_name.Text = configtype.name;
                    if (configtype.is_active > 0) {
                        this.Active.Checked = true;
                    }
                    if (configtype.ext1 != null && !string.IsNullOrEmpty(configtype.ext1.ToString())) {
                        group_udf_id = Convert.ToInt64(configtype.ext1.ToString());
                    }            

                }
                GetAlludf = ctbll.GetAlludf(group_udf_id);
            }
        }

        protected void Save_Close_Click(object sender, EventArgs e)
        {
            long group_udf_id = 0;
            if (id > 0)
            {//修改数据
                configtype = configtypebll.GetSingleGeneral(id);
                if (configtype.ext1 != null && !string.IsNullOrEmpty(configtype.ext1.ToString()))
                {
                    group_udf_id = Convert.ToInt64(configtype.ext1.ToString());
                    GetGroupudf = ctbll.GetUdfGroup(group_udf_id);
                }
            }
            configtype.name = this.Config_name.Text.ToString();
            if (this.Active.Checked)
            {
                configtype.is_active = 1;
            }
            else {
                configtype.is_active = 0;
            }
            string t = Request.Form["UDFdata"].ToString();
            t = t.Replace("[,", "[").Replace(",]", "]");
            var tt = new EMT.Tools.Serialize().DeserializeJson<RootDefinedField>(t);
            if (id > 0) {
                //修改
                var result = ctbll.UpdateConfigType(configtype,tt.UDFGROUP, GetLoginUserId());

                if (result == DTO.ERROR_CODE.SUCCESS)
                {
                    Response.Write("<script>alert('配置类型修改成功！');window.close();self.opener.location.reload();</script>");
                }
                else if (result == DTO.ERROR_CODE.USER_NOT_FIND)
                {
                    Response.Write("<script>alert('查询不到用户，请重新登陆');</script>");
                    Response.Redirect("../Login.aspx");
                }
                else if (result == DTO.ERROR_CODE.EXIST)
                {
                    Response.Write("<script>alert('已经存在相同名称，请修改！');</script>");
                }
                else
                {
                    
                }

            } else
            {
                var result = ctbll.InsertConfigType(configtype, tt.UDFGROUP, GetLoginUserId());
                if (result == DTO.ERROR_CODE.SUCCESS)
                {
                    Response.Write("<script>alert('配置类型添加成功！');window.close();self.opener.location.reload();</script>");
                }
                else if (result == DTO.ERROR_CODE.USER_NOT_FIND)
                {
                    Response.Write("<script>alert('查询不到用户，请重新登陆');</script>");
                    Response.Redirect("../Login.aspx");
                }
                else if (result == DTO.ERROR_CODE.EXIST)
                {
                    Response.Write("<script>alert('已经存在相同名称，请修改！');</script>");
                }
                else
                {
                  
                }
            }


        }

        protected void Cancel_Click(object sender, EventArgs e)
        {
            Response.Write("<script>window.close();self.opener.location.reload();</script>");
        }
    }
}