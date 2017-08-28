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
            id = 2;
            if (!IsPostBack) {
                bindresource();//第三个选项卡数据绑定
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
                if (id > 0)
                {
                    //获取角色 修改后可以更新报价模板名称
                    var SSL = sys_security.GetSecurityLevel(id);
                    SLName = SSL.name;
                    //系统角色不可修改
                    if (Convert.ToInt32(SSL.is_system) > 0)
                    {
                        this.sys_security_level_name.ReadOnly = true;
                    }
                    this.sys_security_level_name.Text = SLName;
                    //获取module
                    var modulelist = sys_security.GetSecurity_module((int)id);
                    if (modulelist.Count > 0) {
                        StringBuilder ii = new StringBuilder();
                        foreach (var i in modulelist) {
                            ii.Append(i.name+",");
                        }
                        this.module.Text = ii.ToString().TrimEnd(',');
                    }
                    if (SSL.is_active > 0)
                    {
                        this.active.Checked = true;
                    }
                    var limitdata = sys_security.GetSecurity_limit((int)id);
                    foreach (var i in limitdata)
                    {
                        string bindid = "id" + i.id.ToString();
                        var k = this.FindControl(bindid) as DropDownList;
                        var c = this.FindControl(bindid) as CheckBox;
                        if (k != null)
                        {
                            k.SelectedValue = i.limit_type_value_id.ToString();
                        }
                        if (c != null)
                        {
                            if (i.limit_type_value_id == (int)LIMIT_TYPE_VALUE.HAVE960)
                            {
                                c.Checked = true;
                            }
                            if (i.limit_type_value_id == (int)LIMIT_TYPE_VALUE.NO960)
                            {
                                c.Checked = false;
                            }
                        }

                    }

                }
                else {
                    Response.Write("<script>alert('获取权限等级id失败！');window.close();self.opener.location.reload();</script>");
                }
            }
        }
        private void bindresource() {
            var reslist = sys_security.GetResourceList((int)id);
            StringBuilder table = new StringBuilder();
            if (reslist.Count > 0) {
                foreach (var i in reslist)
                {
                    table.Append("<tr>");
                    table.Append("<td class=\"Command\" style=\"text-align:center;width:30px; \"><img src = \"../Images/edit.png\" style=\"vertical-align:middle;\"/></td>");
                    table.Append(" <td class=\"Text\">" + i.name + "</td>");
                    if (i.is_active > 0)
                    {
                        table.Append("<td class=\"Boolean\" style=\"width: 80px; \"><img src = \"../Images/check.png\" style=\"vertical-align:middle;\"/></td>");
                    }
                    else
                    {
                        table.Append("<td class=\"Boolean\" style=\"width: 80px; \"></td>");
                    }
                    table.Append("</tr>");
                }
            }
            else {
                table.Append("<tr><td><div class=\"NoDataMessage\">There are no records.</div></td></tr>");
            }
            this.table.Text = table.ToString();
          
        }
        private bool UpdateSecyurity() {
            sys_security_level sys = new sys_security_level();
            if (!string.IsNullOrEmpty(this.sys_security_level_name.Text.Trim().ToString()))
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
            sys.id = id;
            //更新sys_security_level表
            var res = sys_security.UpdateSecurityLevel(sys, GetLoginUserId());
            if (res == ERROR_CODE.ERROR)
            {
                Response.Write("<script>alert(\"权限等级名称修改失败\");</script>");
                return false;
            }
            if (res == ERROR_CODE.USER_NOT_FIND)               // 用户丢失
            {
                Response.Write("<script>alert('查询不到用户，请重新登陆');</script>");
                Response.Redirect("Login.aspx");
            }
            return true;
        }
        protected void SaveLevel_Click(object sender, EventArgs e)
        {
            var levellist = new List<SysSercyityLevelLimitDto>();
            try {
                if (UpdateSecyurity())
                {
                    sys_limitList = sys_security.GetAll();//按照model分组
                    foreach (var limit in sys_limitList)
                    {
                        string bindid = "id" + limit.id.ToString();
                        var k = this.FindControl(bindid) as DropDownList;
                        var c = this.FindControl(bindid) as CheckBox;
                        SysSecLimit.limit_id = limit.id;//权限id
                        SysSecLimit.security_level_id = id;
                        //下拉框选项
                        if (k != null)
                        {
                            SysSecLimit.limit_type_value_id = Convert.ToInt32(k.SelectedValue.ToString());
                        }
                        //check选项
                        if (c != null)
                        {
                            if (c.Checked)
                            {//选中就存986
                                SysSecLimit.limit_type_value_id = (int)LIMIT_TYPE_VALUE.HAVE960;
                            }
                            else
                            {//不选就存987
                                SysSecLimit.limit_type_value_id = (int)LIMIT_TYPE_VALUE.NO960;
                            }
                        }
                        //一条一条进行存储
                        var result = sys_security.Save(SysSecLimit, GetLoginUserId());
                    }

                }

            } catch {

            }
            
            Response.Write("<script>alert('权限修改添加成功！');window.close();self.opener.location.reload();</script>");
        }

        protected void Cancle_Click(object sender, EventArgs e)
        {
            Response.Write("<script>window.close();self.opener.location.reload();</script>");
        }
    }
}