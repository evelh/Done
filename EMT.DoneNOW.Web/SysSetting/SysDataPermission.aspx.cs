using EMT.DoneNOW.BLL;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DTO;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace EMT.DoneNOW.Web.SysSetting
{
    public partial class SysDataPermission : BasePage
    {
        public List<sys_resource> resourcelist = new List<sys_resource>();
        public UserResourceBLL urbll = new UserResourceBLL();
        protected void Page_Load(object sender, EventArgs e)
        {
            resourcelist = urbll.GetAllSysResource();
 
        }
        protected void Save_Click(object sender, EventArgs e)
        {
            string t = Request.Form["data"].ToString();
            t = t.Replace("[,", "[").Replace(",]", "]");
            var kkk = new EMT.Tools.Serialize().DeserializeJson<DataPermissionDto.Resource_Permission>(t);
            foreach (var ii in resourcelist) {
                foreach (var i in kkk.permission)
                {
                    if (ii.id == Convert.ToInt64(i.id.Replace("id", string.Empty))) {
                        if (i.edit_protected_data == "yes")
                        {
                            ii.edit_protected_data = 1;
                        }
                        else
                        {
                            ii.edit_protected_data = 0;
                        }
                        if (i.view_protected_data == "yes")
                        {
                            ii.view_protected_data = 1;
                        }
                        else
                        {
                            ii.view_protected_data = 0;
                        }
                        if (i.edit_unprotected_data == "yes")
                        {
                            ii.edit_unprotected_data = 1;
                        }
                        else
                        {
                            ii.edit_unprotected_data = 0;
                        }
                        if (i.view_unprotected_data == "yes")
                        {
                            ii.view_unprotected_data = 1;
                        }
                        else
                        {
                            ii.view_unprotected_data = 0;
                        }
                        new UserResourceBLL().UpdatePermission(ii, GetLoginUserId());
                        continue;
                    }                   
                }
            }
            Response.Write("<script>alert('保存成功！');</script>");
        }

        protected void Cancle_Click(object sender, EventArgs e)
        {
            Response.Redirect("Admin.aspx");
        }
    }
}