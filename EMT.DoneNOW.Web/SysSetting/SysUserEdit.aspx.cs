using EMT.DoneNOW.BLL;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DTO;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using static EMT.DoneNOW.DTO.DicEnum;

namespace EMT.DoneNOW.Web
{
    public partial class SysUserEdit : BasePage
    {
        protected string avatarPath = "/Images/pop.jpg";
        protected long id = 0;
        protected string op = string.Empty;
        private SysUserAddDto param=new SysUserAddDto();
        private SysUserAddDto paramcopy=new SysUserAddDto();
        private UserResourceBLL urbll=new UserResourceBLL ();
        private bool saveop=false;//保存状态
       protected void Page_Load(object sender, EventArgs e)
        {
            id = Convert.ToInt32(Request.QueryString["id"]);
            if (Request.QueryString["op"]!=null)
            op = Request.QueryString["op"].ToString();
            if (!IsPostBack)
            {
                var user = UserInfoBLL.GetUserInfo(GetLoginUserId());
                this.username.Text = user.name;
                //常规tab页
                //下拉框
                Bind();
                if (id > 0)
                {//改成修改界面
                    var resourcedata = urbll.GetSysResourceSingle(id);
                    var userdata = urbll.GetSysUserSingle(id);
                    param.sys_res = resourcedata;
                    param.sys_user = userdata;
                    if (resourcedata.avatar != null && !string.IsNullOrEmpty(resourcedata.avatar.ToString()))
                        avatarPath = resourcedata.avatar.ToString();
                    if (!string.IsNullOrEmpty(resourcedata.date_display_format_id.ToString()))//数据库存在日期格式
                        this.DateFormat.SelectedValue = resourcedata.date_display_format_id.ToString();
                    if (!string.IsNullOrEmpty(resourcedata.number_display_format_id.ToString()))//数据库存在数值格式
                        this.NumberFormat.SelectedValue = resourcedata.number_display_format_id.ToString();
                    if (!string.IsNullOrEmpty(resourcedata.time_display_format_id.ToString()))//数据库存在时间格式
                        this.TimeFormat.SelectedValue = resourcedata.time_display_format_id.ToString();
                    this.first_name.Text = resourcedata.first_name;
                    this.last_name.Text = resourcedata.last_name;
                    this.resource_name.Text = resourcedata.name;
                    if (resourcedata.title != null)
                    {
                        this.title.Text = resourcedata.title;
                    }
                    if (!string.IsNullOrEmpty(resourcedata.suffix_id.ToString())) //数据库存在称谓
                        this.NameSuffix.SelectedValue = resourcedata.suffix_id.ToString();
                    if (!string.IsNullOrEmpty(resourcedata.sex.ToString()))//数据库存在性别
                        this.Sex.SelectedValue = resourcedata.sex.ToString();
                    if (resourcedata.location_id != null && !string.IsNullOrEmpty(resourcedata.location_id.ToString()))
                    {//办公地址
                        this.Position.SelectedValue = resourcedata.location_id.ToString();
                    }
                    if (resourcedata.office_phone != null)//办公电话
                        this.office_phone.Text = resourcedata.office_phone.ToString();
                    if (resourcedata.home_phone != null)//家庭电话
                        this.home_phone.Text = resourcedata.home_phone.ToString();
                    if (resourcedata.mobile_phone != null && !string.IsNullOrEmpty(resourcedata.mobile_phone.ToString()))//移动电话
                        this.mobile_phone.Text = resourcedata.mobile_phone.ToString();
                    this.email.Text = resourcedata.email.ToString();//邮箱地址
                    this.EmailType.SelectedValue = resourcedata.email_type_id.ToString();//邮箱类型
                    if (resourcedata.email1 != null && !string.IsNullOrEmpty(resourcedata.email1.ToString()))//附加邮箱
                        this.email1.Text = resourcedata.email1.ToString();
                    if (resourcedata.email2 != null && !string.IsNullOrEmpty(resourcedata.email2.ToString()))
                        this.email2.Text = resourcedata.email2.ToString();
                    if (resourcedata.email1_type_id != null && !string.IsNullOrEmpty(resourcedata.email1_type_id.ToString()))//附加邮箱类型
                        this.EmailType1.SelectedValue = resourcedata.email1_type_id.ToString();
                    if (resourcedata.email2_type_id != null && !string.IsNullOrEmpty(resourcedata.email2_type_id.ToString()))
                        this.EmailType2.SelectedValue = resourcedata.email2_type_id.ToString();

                    this.name.Text = string.IsNullOrEmpty(userdata.name) ? "" : userdata.name.ToString();//用户名
                    if (resourcedata.is_active > 0)//是否激活
                        this.ACTIVE.Checked = true;
                    if (resourcedata.security_level_id != null && !string.IsNullOrEmpty(resourcedata.security_level_id.ToString()))//权限级别
                        this.Security_Level.SelectedValue = resourcedata.security_level_id.ToString();
                    //this.password.Text = userdata.password.ToString();
                    //this.password2.Text= userdata.password.ToString();
                    if (resourcedata.can_edit_skills > 0)//编辑技能
                        this.CanEditSkills.Checked = true;
                    if (resourcedata.can_manage_kb_articles > 0)//编辑或删除知识库文章
                        this.CanManagekbarticles.Checked = true;
                    if (resourcedata.allow_send_bulk_email > 0)//允许员工群发邮件
                        this.AllowSendbulkemail.Checked = true;
                    if (resourcedata.required_to_submit_timesheets > 0)//不要求用户提交工时表
                        this.IsRequiredtosubmittimesheets.Checked = true;
                    if (resourcedata.outsource_security_role_type_id != null && !string.IsNullOrEmpty(resourcedata.outsource_security_role_type_id.ToString()))//外部权限
                        this.Outsource_Security.SelectedValue = resourcedata.outsource_security_role_type_id.ToString();
                }
            }
            else {
                avatarPath=SavePic();//保存头像
            }

        }

        private void Bind()
        {
            var dic = new UserResourceBLL().GetDownList();
            // 日期格式
            this.DateFormat.DataTextField = "show";
            this.DateFormat.DataValueField = "val";
            this.DateFormat.DataSource = dic.FirstOrDefault(_ => _.Key == "DateFormat").Value;
            this.DateFormat.DataBind();
           // DateFormat.Items.Insert(0, new ListItem() { Value = "0", Text = "   ", Selected = true });
            //数字格式
            this.NumberFormat.DataTextField = "show";
            this.NumberFormat.DataValueField = "val";
            this.NumberFormat.DataSource = dic.FirstOrDefault(_ => _.Key == "NumberFormat").Value;
            NumberFormat.DataBind();
           // NumberFormat.Items.Insert(0, new ListItem() { Value = "0", Text = "   ", Selected = true });
            //TimeFormat时间格式
            this.TimeFormat.DataTextField = "show";
            this.TimeFormat.DataValueField = "val";
            this.TimeFormat.DataSource = dic.FirstOrDefault(_ => _.Key == "TimeFormat").Value;
            TimeFormat.DataBind();
           // TimeFormat.Items.Insert(0, new ListItem() { Value = "0", Text = "   ", Selected = true });
            //EmailType50
            this.EmailType.DataTextField = "show";
            this.EmailType.DataValueField = "val";
            this.EmailType.DataSource = dic.FirstOrDefault(_ => _.Key == "EmailType").Value;
            EmailType.DataBind();
            EmailType.Items.Insert(0, new ListItem() { Value = "0", Text = "   ", Selected = true });
            this.EmailType1.DataTextField = "show";
            this.EmailType1.DataValueField = "val";
            this.EmailType1.DataSource = dic.FirstOrDefault(_ => _.Key == "EmailType").Value;
            EmailType1.DataBind();
            EmailType1.Items.Insert(0, new ListItem() { Value = "0", Text = "   ", Selected = true });
            this.EmailType2.DataTextField = "show";
            this.EmailType2.DataValueField = "val";
            this.EmailType2.DataSource = dic.FirstOrDefault(_ => _.Key == "EmailType").Value;
            EmailType2.DataBind();
            EmailType2.Items.Insert(0, new ListItem() { Value = "0", Text = "   ", Selected = true });
            //Sex49
            this.Sex.DataTextField = "show";
            this.Sex.DataValueField = "val";
            this.Sex.DataSource = dic.FirstOrDefault(_ => _.Key == "Sex").Value;
            Sex.DataBind();
            Sex.Items.Insert(0, new ListItem() { Value = "0", Text = "   ", Selected = true });
            //NameSuffix
            this.NameSuffix.DataTextField = "show";
            this.NameSuffix.DataValueField = "val";
            this.NameSuffix.DataSource = dic.FirstOrDefault(_ => _.Key == "NameSuffix").Value;
            NameSuffix.DataBind();
            NameSuffix.Items.Insert(0, new ListItem() { Value = "0", Text = "   ", Selected = true });
            //Prefix前缀
            //Prefix.Items.Insert(0, new ListItem() { Value = "0", Text = "   ", Selected = true });
            //Prefix.Items.Insert(1, new ListItem() { Value = "1", Text = "Mr." });
            //Prefix.Items.Insert(2, new ListItem() { Value = "2", Text = "Mrs." });
            //Prefix.Items.Insert(3, new ListItem() { Value = "3", Text = "Ms." });
            //主要位置  location_id

            this.Position.DataTextField = "name";
            this.Position.DataValueField = "id";
            this.Position.DataSource = dic.FirstOrDefault(_ => _.Key == "Position").Value;
            Position.DataBind();
            Position.Items.Insert(0, new ListItem() { Value = "0", Text = "   ", Selected = true });
            Position.Items.Insert(1, new ListItem() { Value = "1", Text = "总部" });
            //授权tab页

            //权限等级
            //this.Security_Level
            this.Security_Level.DataTextField = "name";
            this.Security_Level.DataValueField = "id";
            this.Security_Level.DataSource = dic.FirstOrDefault(_ => _.Key == "Security_Level").Value;
            Security_Level.DataBind();
            Security_Level.Items.Insert(0, new ListItem() { Value = "0", Text = "   ", Selected = true });
            //外包权限
            //this.Outsource_Security
            this.Outsource_Security.DataTextField = "show";
            this.Outsource_Security.DataValueField = "val";
            this.Outsource_Security.DataSource = dic.FirstOrDefault(_ => _.Key == "Outsource_Security").Value;
            Outsource_Security.DataBind();
            Outsource_Security.Items.Insert(0, new ListItem() { Value = "0", Text = "   ", Selected = true });
        }
        //protected void Avatar(object sender, ImageClickEventArgs e)
        //{

        //}
        #region 头像上传
        /// <summary>
        /// 保存头像图片到服务器
        /// </summary>
        /// <returns></returns>
        private string SavePic()
        {
            var fileForm = Request.Files["browsefile"];
            if (fileForm == null)
                return avatarPath;
            if (fileForm.ContentLength == 0)    // 判断是否选择了文件
                return avatarPath;
            if (fileForm.ContentType.ToLower().IndexOf("image") != 0)   // 判断文件类型
                return avatarPath;
            string fileExtension = Path.GetExtension(fileForm.FileName).ToLower();    //取得文件的扩展名,并转换成小写
            if (!IsImage(fileExtension))    //验证上传文件是否图片格式
                return avatarPath;

            if (fileForm.ContentLength > (8 << 20))     // 判断文件大小不超过8M
                return avatarPath;

            string filepath = $"/Upload/Images/Sys_user/{DateTime.Now.Year.ToString()}{DateTime.Now.Month.ToString()}/Avatar/";
            if (Directory.Exists(Server.MapPath(filepath)) == false)//如果不存在就创建file文件夹
            {
                Directory.CreateDirectory(Server.MapPath(filepath));
            }
            string virpath = filepath + Guid.NewGuid().ToString() + fileExtension;//这是存到服务器上的虚拟路径
            string mappath = Server.MapPath(virpath);//转换成服务器上的物理路径
            fileForm.SaveAs(mappath);//保存图片

            return virpath;
        }

        /// <summary>
        /// 验证是否指定的图片格式
        /// </summary>
        /// <param name="str"></param>
        /// <returns></returns>
        private bool IsImage(string str)
        {
            bool isimage = false;
            string thestr = str.ToLower();
            //限定只能上传jpg和gif图片
            string[] allowExtension = { ".jpg", ".gif", ".bmp", ".png" };
            //对上传的文件的类型进行一个个匹对
            for (int i = 0; i < allowExtension.Length; i++)
            {
                if (thestr == allowExtension[i])
                {
                    isimage = true;
                    break;
                }
            }
            return isimage;
        }

        #endregion

        protected void Save_Click(object sender, EventArgs e)
        {
            if (!saveop)
            {
                if (!string.IsNullOrEmpty(op))
                {
                    Save_Contact();
                    Save_deal();
                }
                else
                {
                    Save_Contact();
                    Update_deal();
                }
                saveop = true;
            }
            else
            {
                Save_Contact();
                Update_deal();
            }                
        }

        protected void Save_Cloes_Click(object sender, EventArgs e)
        {
            if (!saveop)
            {
                if (!string.IsNullOrEmpty(op))
                {
                    Save_Contact();
                    if (Save_deal())
                    {
                        Response.Write("<script>window.close();self.opener.location.reload();</script>");
                    }
                }
                else
                {
                    Save_Contact();
                    if (Update_deal())
                    {
                        //Response.Write("window.open(\"SysUserEdit.aspx?id ="+id+", '"+(int)EMT.DoneNOW.DTO.OpenWindow.Resource+"', 'left=0,top=0,location=no,status=no,width=900,height=750', false");
                        Response.Write("<script>window.close();self.opener.location.reload();</script>");
                    }
                }
                saveop = true;
            }
            else
            {
                Save_Contact();
                if (Update_deal())
                {
                    Response.Write("<script>window.close();self.opener.location.reload();</script>");
                }
            }
        }
        protected void Save_copy_Click(object sender, EventArgs e)
        {
            if (!saveop)
            {
                if (!string.IsNullOrEmpty(op))
                {
                    Save_Contact();
                    if (Save_deal())
                    {
                        //Response.Write("<script>window.open(\"SysUserEdit.aspx?id =" + id + ", '" + (int)EMT.DoneNOW.DTO.OpenWindow.Resource + "', 'left=0,top=0,location=no,status=no,width=900,height=750', false\");</script>");
                        Response.Write("<script>window.location.href = 'SysUserEdit.aspx?id=" + id + "&op=copy';</script>");
                    }
                }
                else
                {
                    Save_Contact();
                    if (Update_deal())
                    {
                        //Response.Write("<script>window.open(\"SysUserEdit.aspx?id =" + id + ", '" + (int)EMT.DoneNOW.DTO.OpenWindow.Resource + "', 'left=0,top=0,location=no,status=no,width=900,height=750', false\");</script>");
                        Response.Write("<script>window.location.href = 'SysUserEdit.aspx?id=" + id + "&op=copy';</script>");
                    }
                }
                saveop = true;
            }
            else
            {
                Save_Contact();
                if (Update_deal()) {
                    //Response.Write("<script>window.open(\"SysUserEdit.aspx?id =" + id + ", '" + (int)EMT.DoneNOW.DTO.OpenWindow.Resource + "', 'left=0,top=0,location=no,status=no,width=900,height=750', false\");</script>");
                    Response.Write("<script>window.close();window.location.href = 'SysUserEdit.aspx?id=" + id+ "&op=copy';</script>");
                }
            }
           
        }
        private void Save_Contact()
        {
            if (id > 0)
            {
                param.sys_res = urbll.GetSysResourceSingle(id);
                param.sys_user = urbll.GetSysUserSingle(id);
            }
            param.sys_res.first_name = this.first_name.Text.Trim().ToString();
            param.sys_res.last_name = this.last_name.Text.Trim().ToString();
            param.sys_res.name = param.sys_res.first_name + param.sys_res.last_name;
            param.sys_res.title = this.title.Text.Trim().ToString();
            param.sys_res.office_phone = this.office_phone.Text.Trim().ToString();
            param.sys_res.home_phone = this.home_phone.Text.Trim().ToString();
            param.sys_res.mobile_phone = this.mobile_phone.Text.Trim().ToString();

            param.sys_res.email = this.email.Text.Trim().ToString();
            param.sys_res.email1 = this.email1.Text.Trim().ToString();
            param.sys_res.email2 = this.email2.Text.Trim().ToString();
            param.sys_user.mobile_phone = this.mobile_phone.Text.Trim().ToString();
            param.sys_user.name = this.name.Text.Trim().ToString();


            param.sys_res.avatar = SavePic();//保存头像
            if (this.CanEditSkills.Checked)
            {
                param.sys_res.can_edit_skills = 1;
            }
            else
            {
                param.sys_res.can_edit_skills = 0;
            }
            if (this.ACTIVE.Checked)
            {
                param.sys_res.is_active = 1;
            }
            else
            {
                param.sys_res.is_active = 0;
            }
            if (this.CanManagekbarticles.Checked)
            {
                param.sys_res.can_manage_kb_articles = 1;
            }
            else
            {
                param.sys_res.can_manage_kb_articles = 0;
            }
            if (this.AllowSendbulkemail.Checked)
            {
                param.sys_res.allow_send_bulk_email = 1;
            }
            else
            {
                param.sys_res.allow_send_bulk_email = 0;
            }
            if (this.IsRequiredtosubmittimesheets.Checked)
            {
                param.sys_res.required_to_submit_timesheets = 1;
            }
            else
            {
                param.sys_res.required_to_submit_timesheets = 0;
            }
            //param.sys_res.date_display_format_id = Convert.ToInt32(this.DateFormat.SelectedValue);
            //param.sys_res.number_display_format_id = Convert.ToInt32(this.NumberFormat.SelectedValue);
            if (Convert.ToInt32(this.Outsource_Security.SelectedValue) > 0)
            {
                param.sys_res.outsource_security_role_type_id = Convert.ToInt32(this.Outsource_Security.SelectedValue);
            }
            if (Convert.ToInt32(this.Security_Level.SelectedValue.ToString()) >0) {
                param.sys_res.security_level_id = Convert.ToInt32(this.Security_Level.SelectedValue.ToString());
            }
            if (Convert.ToInt32(this.Position.SelectedValue.ToString()) > 0)
            {
                param.sys_res.location_id = Convert.ToInt32(this.Position.SelectedValue.ToString());
            }
            else {
                param.sys_res.location_id = null;
            }
            //if (Convert.ToInt32(this.TimeFormat.SelectedValue) > 0)
            //    param.sys_res.time_display_format_id = Convert.ToInt32(this.TimeFormat.SelectedValue);
            param.sys_res.date_display_format_id = 553;
            param.sys_res.number_display_format_id = 563;
            param.sys_res.time_display_format_id = 562;
            if (Convert.ToInt32(this.Sex.SelectedValue) > 0)
            {
                param.sys_res.sex = Convert.ToInt32(this.Sex.SelectedValue);
            }
            else
            {
                param.sys_res.sex = null;
            }
            if (this.NameSuffix.SelectedValue != "0") {
                param.sys_res.suffix_id = Convert.ToInt32(this.NameSuffix.SelectedValue);
            }
            param.sys_res.email_type_id = Convert.ToInt32(this.EmailType.SelectedValue);

            if (Convert.ToInt32(this.EmailType1.SelectedValue) > 0)
                param.sys_res.email1_type_id = Convert.ToInt32(this.EmailType1.SelectedValue);
            else param.sys_res.email1_type_id = null;
            if (Convert.ToInt32(this.EmailType2.SelectedValue) > 0)
                param.sys_res.email2_type_id = Convert.ToInt32(this.EmailType2.SelectedValue);
            else param.sys_res.email2_type_id = null;
            if (Convert.ToInt32(this.NameSuffix.SelectedValue) > 0)
                param.sys_res.suffix_id = Convert.ToInt32(this.NameSuffix.SelectedValue);
            //密码
            if (!string.IsNullOrEmpty(this.pass_word.Text.ToString()))
            {
                param.sys_user.password = this.pass_word.Text.ToString();
            }
            param.sys_user.status_id = (int)USER_STATUS.NORMAL;
            param.sys_user.email = param.sys_res.email;
            param.sys_user.mobile_phone = param.sys_res.mobile_phone;
            param.sys_user.cate_id = 1;//员工种类
        }
        /// <summary>
        /// 新增处理
        /// </summary>
        /// <returns></returns>
        private bool Save_deal()
        {
            var result = new UserResourceBLL().Insert(param, GetLoginUserId(), out id);
            if (result == ERROR_CODE.SYS_NAME_EXIST)
            {
                Response.Write("<script>alert('该姓名已存在！');</script>");
                return false;
            }
            if (result == ERROR_CODE.SUCCESS)
            {
                Response.Write("<script>alert('员工添加成功！');</script>");
                paramcopy = param;
                return true;
            }
            else if (result == ERROR_CODE.USER_NOT_FIND)               // 用户丢失
            {
                Response.Write("<script>alert('查询不到用户，请重新登陆');</script>");
                Response.Redirect("Login.aspx");
                return false;
            }
            else if (result == ERROR_CODE.EXIST)
            {
                Response.Write("<script>alert('存在相同用户名，请修改！');</script>");
            }
            return false;
        }
        /// <summary>
        /// 更新处理
        /// </summary>
        /// <returns></returns>
        private bool Update_deal()
        {
            var result = new UserResourceBLL().Update(param, GetLoginUserId(),id);
            if (result == ERROR_CODE.SUCCESS)
            {
                Response.Write("<script>alert('员工修改成功！');</script>");
                paramcopy = param;
                return true;
            }
            else if (result == ERROR_CODE.USER_NOT_FIND)// 用户丢失
            {
                Response.Write("<script>alert('查询不到用户，请重新登陆');</script>");
                Response.Redirect("Login.aspx");
                return false;
            }
            else if (result == ERROR_CODE.EXIST) {
                Response.Write("<script>alert('存在相同用户名，请修改！');</script>");
            }
            else if (result == ERROR_CODE.SYS_NAME_EXIST)
            {
                Response.Write("<script>alert('该姓名已存在！');</script>");
                return false;
            }
            return false;
        }
        /// <summary>
        /// 取消
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void Cancel_Click(object sender, EventArgs e)
        {
            Response.Write("<script>window.close();self.opener.location.reload();</script>");  //  关闭添加页面的同时，刷新父页面
        }
    }
}