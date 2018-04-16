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

namespace EMT.DoneNOW.Web.SysSetting
{
    public partial class SysUserAdd : BasePage
    {
        protected string avatarPath = "/Images/pop.jpg";
        private long id = 0;
        private SysUserAddDto param = new SysUserAddDto();
        private SysUserAddDto paramcopy = new SysUserAddDto();
        bool save_oper = false;
        // private long id
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                var user = UserInfoBLL.GetUserInfo(GetLoginUserId());
                this.username.Text = user.name;
                //常规tab页
                //下拉框
                Bind();
                Session["ResInternalCost"] = null;
            }
            else
            {
                avatarPath = SavePic();//保存头像
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
            //NumberFormat.Items.Insert(0, new ListItem() { Value = "0", Text = "   ", Selected = true });
            //TimeFormat时间格式
            this.TimeFormat.DataTextField = "show";
            this.TimeFormat.DataValueField = "val";
            this.TimeFormat.DataSource = dic.FirstOrDefault(_ => _.Key == "TimeFormat").Value;
            TimeFormat.DataBind();
            //TimeFormat.Items.Insert(0, new ListItem() { Value = "0", Text = "   ", Selected = true });
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
            //主要位置  location_id   sys_organization_location

            this.Position.DataTextField = "name";
            this.Position.DataValueField = "id";
            this.Position.DataSource = dic.FirstOrDefault(_ => _.Key == "Position").Value;
            Position.DataBind();
            Position.Items.Insert(0, new ListItem() { Value = "0", Text = "    ", Selected = true });
            //授权tab页

            //权限等级  有争议sys_security_level
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

            //员工类型
            var genBll = new GeneralBLL();
            var resType = genBll.GetDicValues(GeneralTableEnum.RESOURCE_TYPE);
            type_id.DataTextField = "show";
            type_id.DataValueField = "val";
            type_id.DataSource = resType;
            type_id.DataBind();

            //薪资类型
            var payType = genBll.GetDicValues(GeneralTableEnum.PAYROLL_TYPE);
            payroll_type_id.DataTextField = "show";
            payroll_type_id.DataValueField = "val";
            payroll_type_id.DataSource = payType;
            payroll_type_id.DataBind();

            hire_date.Text = DateTime.Now.ToString("yyyy-MM-dd");
            time_sheet_start_date.Text = DateTime.Now.ToString("yyyy-MM-dd");

            // 休假方案
            var policyList = new TimeOffPolicyBLL().GetPolicyList();
            timeoff_policy_id.DataTextField = "name";
            timeoff_policy_id.DataValueField = "id";
            timeoff_policy_id.DataSource = policyList;
            timeoff_policy_id.DataBind();
            timeoff_policy_id.Items.Insert(0, new ListItem() { Value = "0", Text = "", Selected = true });

            // 出差限度
            var travelRest = genBll.GetDicValues(GeneralTableEnum.TRAVEL_RESTRICTIONS);
            travel_restrictions_id.DataTextField = "show";
            travel_restrictions_id.DataValueField = "val";
            travel_restrictions_id.DataSource = travelRest;
            travel_restrictions_id.DataBind();
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
            if (!save_oper)
            {
                Save_Contact();
                Save_deal();
                save_oper = true;
            }
            else {
                Save_Contact();
                Update_deal();
            }
           
        }
        protected void Save_copy_Click(object sender, EventArgs e)
        {
            if (!save_oper)
            {
                Save_Contact();
                if (Save_deal()) {
                    save_oper = true;
                    Response.Write("<script>window.location.href = 'SysUserEdit.aspx?id=" + id + "&op=copy';</script>");
                }
               
            }
            else
            {
                Save_Contact();
                if (Update_deal()) {
                    Response.Write("<script>window.location.href = 'SysUserEdit.aspx?id=" + id + "&op=copy';</script>");
                }
            }
        }
        protected void Save_Cloes_Click(object sender, EventArgs e)
        {
            if (!save_oper)
            {
                Save_Contact();
                if (Save_deal()) {
                    save_oper = true;
                    Response.Write("<script>window.close();self.opener.location.reload();</script>");  //  关闭添加页面的同时，刷新父页面
                }
                
            }
            else
            {
                Save_Contact();
                if (Update_deal()) {
                    Response.Write("<script>window.close();self.opener.location.reload();</script>");  //  关闭添加页面的同时，刷新父页面
                }
            }
            
        }
        private void Save_Contact()
        {
            param.sys_res = AssembleModel<sys_resource>();
            param.availability = AssembleModel<sys_resource_availability>();
            param.sys_res.name = param.sys_res.first_name + param.sys_res.last_name;
            param.sys_res.avatar = SavePic();//保存头像
            if (timeoff_policy_id.SelectedValue != "0" && (!string.IsNullOrEmpty(effective_date.Text)))
            {
                param.timeoffPolicy = new tst_timeoff_policy_resource();
                param.timeoffPolicy.timeoff_policy_id = long.Parse(timeoff_policy_id.SelectedValue);
                param.timeoffPolicy.effective_date = DateTime.Parse(effective_date.Text);
            }
            param.internalCost = Session["ResInternalCost"] as List<sys_resource_internal_cost>;

            if (this.CanEditSkills.Checked)
            {
                param.sys_res.can_edit_skills = 1;
            }
            else {
                param.sys_res.can_edit_skills = 0;
            }
            if (this.ACTIVE.Checked)
            {
                param.sys_res.is_active = 1;
            }
            else {
                param.sys_res.is_active = 0;
            }
            if (this.CanManagekbarticles.Checked)
            {
                param.sys_res.can_manage_kb_articles = 1;
            }
            else {
                param.sys_res.can_manage_kb_articles = 0;
            }
            if (this.AllowSendbulkemail.Checked)
            {
                param.sys_res.allow_send_bulk_email = 1;
            }
            else {
                param.sys_res.allow_send_bulk_email = 0;
            }
            if (this.IsRequiredtosubmittimesheets.Checked)
            {
                param.sys_res.required_to_submit_timesheets = 1;
            }
            else {
                param.sys_res.required_to_submit_timesheets = 0;
            }
            param.sys_res.email_type_id=Convert.ToInt32(this.EmailType.SelectedValue.ToString());//保存邮件类型
            //param.sys_res.date_display_format_id = Convert.ToInt32(this.DateFormat.SelectedValue);
            //param.sys_res.number_display_format_id = Convert.ToInt32(this.NumberFormat.SelectedValue);
            if (Convert.ToInt32(this.Outsource_Security.SelectedValue) > 0)
            {
                param.sys_res.outsource_security_role_type_id = Convert.ToInt32(this.Outsource_Security.SelectedValue);
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
            param.sys_res.title = this.title.Text.Trim().ToString();
            if (Convert.ToInt32(this.EmailType1.SelectedValue) > 0)
                param.sys_res.email1_type_id = Convert.ToInt32(this.EmailType1.SelectedValue);
            if (Convert.ToInt32(this.EmailType2.SelectedValue) > 0)
                param.sys_res.email2_type_id = Convert.ToInt32(this.EmailType2.SelectedValue);
            if (Convert.ToInt32(this.NameSuffix.SelectedValue) > 0)
                param.sys_res.suffix_id = Convert.ToInt32(this.NameSuffix.SelectedValue);
            if(Convert.ToInt32(this.Security_Level.SelectedValue.ToString())>0)
           param.sys_res.security_level_id =Convert.ToInt32(this.Security_Level.SelectedValue.ToString());
                if (Convert.ToInt32(this.Position.SelectedValue.ToString()) > 0)
                param.sys_res.location_id =Convert.ToInt32(this.Position.SelectedValue.ToString());
            //新增
            param.sys_user = AssembleModel<sys_user>();
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
            if (result == ERROR_CODE.USER_NOT_FIND)               // 用户丢失
            {
                Response.Write("<script>alert('查询不到用户，请重新登陆');</script>");
                Response.Redirect("Login.aspx");
                return false;
            }
            else if (result == ERROR_CODE.EXIST)
            {
                Response.Write("<script>alert('存在相同用户名，请修改！');</script>");
                return false;
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
            if (result == ERROR_CODE.USER_NOT_FIND)               // 用户丢失
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
        /// 取消
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void Cancel_Click(object sender, EventArgs e)
        {
            Response.Write("<script>window.close();</script>");  //  关闭添加页面的同时，刷新父页面
        }
    }
}