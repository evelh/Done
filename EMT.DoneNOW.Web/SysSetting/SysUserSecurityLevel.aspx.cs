using EMT.DoneNOW.BLL;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DTO;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using static EMT.DoneNOW.DTO.DicEnum;

namespace EMT.DoneNOW.Web.SysSetting
{
    public partial class SysUserSecurityLevel : BasePage
    {
        public string SLName = "安全等级名称";
        private long id;
        private List<sys_limit> sys_limitList = new List<sys_limit>();
        private SysSecurityLevelBLL sys_security = new SysSecurityLevelBLL();
        protected Dictionary<string, List<sys_limit>> modulegroup = null;
        private sys_security_level_limit SysSecLimit = new sys_security_level_limit();
        protected void Page_Load(object sender, EventArgs e)
        {
            id = Convert.ToInt32(Request.QueryString["id"]);//获取角色id 
            id = 1;
            if (id > 0) {
                //获取角色 修改后可以更新报价模板名称
                var SSL = sys_security.GetSecurityLevel(id);
                SLName = SSL.name;
                this.sys_security_level_name.Text = SLName;

            }
            if (!IsPostBack) {
                sys_limitList = sys_security.GetAll();//按照model分组
                //给下拉框赋值
                foreach (var drop in sys_limitList) {                    
                        string bindid = "id" + drop.id.ToString();
                        var k =this.FindControl(bindid) as DropDownList;
                    if (k != null) {
                        k.DataTextField = "value";
                        k.DataValueField = "key";
                        k.DataSource = sys_security.GetDownList(drop.type_id);
                        k.DataBind();
                        k.SelectedIndex = 0;
                    }                       
                 
                }              

            }
        }
        protected void SaveLevel_Click(object sender, EventArgs e)
        {
            sys_security_level sys = new sys_security_level();
            if (this.sys_security_level_name.Text != null && !string.IsNullOrEmpty(this.sys_security_level_name.Text.Trim().ToString()) && this.sys_security_level_name.Text.Trim().ToString() != SLName)
            {
                sys.name = this.sys_security_level_name.Text.Trim().ToString();
            }
            //激活
            if (this.active.Checked)
            {
                sys.is_active = 1;
            }
            else
            {
                sys.is_active = 0;
            }
            //更新sys_security_level表
            var res=sys_security.UpdateSecurityLevel(sys,GetLoginUserId());
            if (res == ERROR_CODE.SUCCESS) { }



            //保存
            sys_limitList = sys_security.GetAll();//按照model分组
            foreach (var limit in sys_limitList) {
                string bindid = "id" + limit.id.ToString();
                var k = this.FindControl(bindid) as DropDownList;
                var c = this.FindControl(bindid) as CheckBox;
                SysSecLimit.limit_id = limit.id;//权限id
                SysSecLimit.security_level_id = id;
                //下拉框选项
                if (k != null) {
                   
                    SysSecLimit.limit_type_value_id =Convert.ToInt32(k.SelectedValue.ToString());
                }
                //check选项
                if (c != null) {
                    if (c.Checked) {//选中就存986
                        SysSecLimit.limit_type_value_id = (int)LIMIT_TYPE_VALUE.HAVE;
                    } else {//不选就存987
                        SysSecLimit.limit_type_value_id = (int)LIMIT_TYPE_VALUE.NO;
                    }
                }
                //存储
                var result = sys_security.Insert(SysSecLimit, GetLoginUserId());
                //if (result == ERROR_CODE.SUCCESS) {
                //    Response.Write("<script>alert(\"修改成功\");</script>");
                //}
            }

        }

       
    }
}