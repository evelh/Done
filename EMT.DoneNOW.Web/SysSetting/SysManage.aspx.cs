using EMT.DoneNOW.BLL;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DAL;
using EMT.DoneNOW.DTO;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace EMT.DoneNOW.Web
{
    public partial class SysManage : BasePage
    {
        protected string avatarPath = "../Images/pop.jpg";
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack) {
                var user = UserInfoBLL.GetUserInfo(GetLoginUserId());
                this.username.Text= user.name;               
                //常规tab页
                //下拉框
                var dic = new UserResourceBLL().GetDownList();
                // 日期格式
                this.DateFormat.DataTextField = "show";
                this.DateFormat.DataValueField = "val";
                this.DateFormat.DataSource = dic.FirstOrDefault(_ => _.Key == "DateFormat").Value;
                this.DateFormat.DataBind();
                //数字格式
                this.NumberFormat.DataTextField = "show";
                this.NumberFormat.DataValueField = "val";
                this.NumberFormat.DataSource = dic.FirstOrDefault(_ => _.Key == "NumberFormat").Value;
                NumberFormat.DataBind();
                //TimeFormat时间格式
                this.TimeFormat.DataTextField = "show";
                this.TimeFormat.DataValueField = "val";
                this.TimeFormat.DataSource = dic.FirstOrDefault(_ => _.Key == "TimeFormat").Value;
                TimeFormat.DataBind();
                //EmailType50
                this.EmailType.DataTextField = "show";
                this.EmailType.DataValueField = "val";
                this.EmailType.DataSource = dic.FirstOrDefault(_ => _.Key == "EmailType").Value;
                EmailType.DataBind();
                this.EmailType1.DataTextField = "show";
                this.EmailType1.DataValueField = "val";
                this.EmailType1.DataSource = dic.FirstOrDefault(_ => _.Key == "EmailType").Value;
                EmailType1.DataBind();
                this.EmailType2.DataTextField = "show";
                this.EmailType2.DataValueField = "val";
                this.EmailType2.DataSource = dic.FirstOrDefault(_ => _.Key == "EmailType").Value;
                EmailType2.DataBind();
                //Sex49
                this.Sex.DataTextField = "show";
                this.Sex.DataValueField = "val";
                this.Sex.DataSource = dic.FirstOrDefault(_ => _.Key == "Sex").Value;
                Sex.DataBind();
                //NameSuffix
                this.NameSuffix.DataTextField = "show";
                this.NameSuffix.DataValueField = "val";
                this.NameSuffix.DataSource = dic.FirstOrDefault(_ => _.Key == "NameSuffix").Value;
                NameSuffix.DataBind();
                //Prefix前缀
                Prefix.Items.Insert(0, new ListItem() { Value = "0", Text = "   ", Selected = true });
                Prefix.Items.Insert(1, new ListItem() { Value = "0", Text = "Mr."});
                Prefix.Items.Insert(2, new ListItem() { Value = "0", Text = "Mrs."});
                Prefix.Items.Insert(3, new ListItem() { Value = "0", Text = "Ms."});
                //主要位置
                Position.Items.Insert(0, new ListItem() { Value = "0", Text = "   ", Selected = true });
                Position.Items.Insert(1, new ListItem() { Value = "0", Text = "总部"});
                //授权tab页

                //权限等级
                //this.Security_Level
                 this.Security_Level.DataTextField = "show";
                this.Security_Level.DataValueField = "val";
                this.Security_Level.DataSource = dic.FirstOrDefault(_ => _.Key == "Security_Level").Value;
                Security_Level.DataBind();
                //外包权限
                //this.Outsource_Security
                this.Outsource_Security.DataTextField = "show";
                this.Outsource_Security.DataValueField = "val";
                this.Outsource_Security.DataSource = dic.FirstOrDefault(_ => _.Key == "Outsource_Security").Value;
                Outsource_Security.DataBind();
            }

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

            string filepath = $"/Upload/Images/{DateTime.Now.Year.ToString()}{DateTime.Now.Month.ToString()}/Avatar/";
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
            if (SaveContact())
            { }
        }
        private bool SaveContact() {
            var param = new SysUserAddDto();
            param.sys_res= AssembleModel<sys_resource>();
            param.sys_res.name = param.sys_res.first_name + param.sys_res.last_name;
            param.sys_res.date_display_format_id = Convert.ToInt32(this.DateFormat.SelectedValue);
            param.sys_res.time_display_format_id = Convert.ToInt32(this.TimeFormat.SelectedValue);
            param.sys_res.number_display_format_id = Convert.ToInt32(this.NumberFormat.SelectedValue);
            param.sys_res.sex = Convert.ToInt32(this.Sex.SelectedValue);
            param.sys_res.email_type_id = Convert.ToInt32(this.EmailType.SelectedValue);
            param.sys_res.email1_type_id = Convert.ToInt32(this.EmailType1.SelectedValue);
            param.sys_res.email2_type_id = Convert.ToInt32(this.EmailType2.SelectedValue);
            param.sys_res.suffix_id = Convert.ToInt32(this.NameSuffix.SelectedValue);
            param.sys_res.location_id = Convert.ToInt32(this.Position.SelectedValue);
            //新增
            var result = new UserResourceBLL().Insert(param.sys_res, GetLoginUserId());
            if (result == ERROR_CODE.SUCCESS)                    // 插入员工成功，刷新前一个页面
            {
                Response.Write("<script>alert('报价模板添加成功！');window.close();self.opener.location.reload();</script>");  //  关闭添加页面的同时，刷新父页面
            }
            else if (result == ERROR_CODE.USER_NOT_FIND)               // 用户丢失
            {
                Response.Write("<script>alert('查询不到用户，请重新登陆');</script>");
                Response.Redirect("Login.aspx");
            }
            return true;
        }
    }
}