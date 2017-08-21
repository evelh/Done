using EMT.DoneNOW.BLL;
using EMT.DoneNOW.Core;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace EMT.DoneNOW.Web.SysSetting
{
    public partial class SysUserSecurityLevel : BasePage
    {
        public string SLName = "安全等级名称";
        private long id;
        private List<sys_limit> sys_limitList = new List<sys_limit>();
        private SysSecurityLevelBLL sys_security = new SysSecurityLevelBLL();
        protected Dictionary<string, List<sys_limit>> modulegroup = null;
        protected void Page_Load(object sender, EventArgs e)
        {
            id = Convert.ToInt32(Request.QueryString["id"]);//获取角色id 
            if (id > 0) {
                //获取角色 修改后可以更新name
                var SSL = sys_security.GetSecurityLevel(id);
                SLName = SSL.name;

            }
            if (!IsPostBack) {
                sys_limitList = sys_security.GetAll();//按照model分组
                 modulegroup = sys_limitList.GroupBy(d => d.module).ToDictionary(d => d.Key, d => d.ToList());
               



                int parent_id=0;

                //权限类型：有无 全部部分我的等'
                var dic = sys_security.GetDownList(parent_id);
               
            }
        }
    }
}