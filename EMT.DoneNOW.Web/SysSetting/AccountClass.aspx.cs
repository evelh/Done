using EMT.DoneNOW.BLL;
using EMT.DoneNOW.Core;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace EMT.DoneNOW.Web
{
    public partial class AccountClass : BasePage
    {
        protected long id;
        protected string avatarPath = "../Images/Classification/residential.png";
        private AccountClassBLL acbll = new AccountClassBLL();//客户类型的操作
        public d_account_classification dac = new d_account_classification();//客户类型的对象
        protected void Page_Load(object sender, EventArgs e)
        {
            id = Convert.ToInt64(Request.QueryString["id"]);
            //id = 16;测试
            if (!IsPostBack) {
                if (id > 0)
                {
                    //获取id对象，再进行修改
                    dac = acbll.GetSingel(id);
                    if (dac == null)
                    {
                        Response.Write("<script>alert('获取相关信息失败，无法修改！');window.close();self.opener.location.reload();</script>");
                    }
                    else
                    {
                        this.Name.Text = dac.name;
                        if (dac.icon_path != null && !string.IsNullOrEmpty(dac.icon_path.ToString()))
                        {
                            avatarPath = dac.icon_path.ToString();
                        }
                        if (dac.status_id != null && Convert.ToInt32(dac.status_id) > 0)
                        {
                            this.Active.Checked = true;
                        }
                        if (dac.remark != null && !string.IsNullOrEmpty(dac.remark.ToString()))
                        {
                            this.Description.Text = dac.remark.ToString();
                        }
                    }
                }
            }           
        }
        protected void Save_Close_Click(object sender, EventArgs e)
        {
            if (save_deal())
            {
                Response.Write("<script>alert('客户分类信息保存成功！');window.close();self.opener.location.reload();</script>");
            }
            else
            {
                Response.Write("<script>alert('客户分类信息保存失败！');window.close();self.opener.location.reload();</script>");
            }

        }

        protected void Save_New_Click(object sender, EventArgs e)
        {
            if (save_deal())
            {
                // Response.Redirect("SysMarket.aspx");
                Response.Write("<script>alert('客户分类信息保存成功！');window.location.href = 'AccountClass.aspx';</script>");
            }
            else
            {
                Response.Write("<script>alert('客户分类信息保存失败！');window.close();self.opener.location.reload();</script>");
            }
        }

        protected void Cancel_Click(object sender, EventArgs e)
        {
            Response.Write("<script>window.close();self.opener.location.reload();</script>");
        }
        //处理保存数据
        public bool save_deal() {
            if (id > 0) {
                dac = acbll.GetSingel(id);
            }
            dac.name = this.Name.Text.ToString();
            //激活状态判断
            if (this.Active.Checked)
            {
                dac.status_id = 1;
            }
            else {
                dac.status_id = 0;
            }
            if (!string.IsNullOrEmpty(this.Description.Text)) {
                dac.remark = this.Description.Text.Trim().ToString();
            }
            dac.icon_path = SavePic();
            if (id > 0)//修改
            {
                var result = acbll.Update(dac, GetLoginUserId());
                if (result == DTO.ERROR_CODE.SUCCESS) {
                    return true;
                }
                else if (result == DTO.ERROR_CODE.USER_NOT_FIND)               // 用户丢失
                {
                    Response.Write("<script>alert('查询不到用户，请重新登陆');</script>");
                    Response.Redirect("../Login.aspx");
                }
                else if (result == DTO.ERROR_CODE.EXIST)
                {
                    Response.Write("<script>alert('已经存在相同名称，请修改！');</script>");
                }
            }
            else {//新增
                var result = acbll.Insert(dac, GetLoginUserId());
                if (result == DTO.ERROR_CODE.SUCCESS) {
                    return true;
                }
                else if (result == DTO.ERROR_CODE.USER_NOT_FIND)               // 用户丢失
                {
                    Response.Write("<script>alert('查询不到用户，请重新登陆');</script>");
                    Response.Redirect("../Login.aspx");
                }
                else if (result == DTO.ERROR_CODE.EXIST)
                {
                    Response.Write("<script>alert('已经存在相同名称，请修改！');</script>");
                }
            }
            return false;
        }



        #region 上传
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
            ///Images/Classification
            string filepath = $"/Upload/Images/Classification/{DateTime.Now.Year.ToString()}{DateTime.Now.Month.ToString()}/icon/";
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
    }
}