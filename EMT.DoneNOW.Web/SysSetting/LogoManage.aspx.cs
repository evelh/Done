using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EMT.DoneNOW.DTO;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.BLL;
using System.IO;

namespace EMT.DoneNOW.Web.SysSetting
{
    public partial class LogoManage : BasePage
    {
        protected d_general thisGeneral;
        protected GeneralBLL genBll = new GeneralBLL();
        protected void Page_Load(object sender, EventArgs e)
        {
            long id = 0;
            if (!string.IsNullOrEmpty(Request.QueryString["id"]))
                if (long.TryParse(Request.QueryString["id"], out id))
                    thisGeneral = genBll.GetSingleGeneral(id);
            if (thisGeneral == null)
            {
                Response.Write("<script>alert('未获取到相关信息');window.close();</script>");
            }

        }

        protected void save_close_Click(object sender, EventArgs e)
        {
            bool result = false;
            var img = Request.Files["file"];
            if (img!=null)
            {
               
                if(!img.ContentType.Contains("image"))  //图片
                {
                    ClientScript.RegisterStartupScript(this.GetType(), "提示信息", $"<script>alert('请上传图片!');</script>");
                    return;
                }
                if(!(img.ContentLength < (10 << 20)))  // 大小
                {
                    ClientScript.RegisterStartupScript(this.GetType(), "提示信息", $"<script>alert('请上传小于10M的图片!');</script>");
                    return;
                }
                string fileExtension = Path.GetExtension(img.FileName).ToLower();
                string filepath = $"/Upload/Attachment/{DateTime.Now.ToString("yyyyMM")}/";
                if (Directory.Exists(Server.MapPath(filepath)) == false)    //如果不存在就创建文件夹
                {
                    Directory.CreateDirectory(Server.MapPath(filepath));
                }
                string virpath = filepath + Guid.NewGuid().ToString() + fileExtension;//这是存到服务器上的虚拟路径
                string mappath = Server.MapPath(virpath);//转换成服务器上的物理路径
                img.SaveAs(mappath);
                thisGeneral.ext2 = virpath;
                result = genBll.EditGeneral(thisGeneral,LoginUserId);
            }
            ClientScript.RegisterStartupScript(this.GetType(), "提示信息", $"<script>alert('保存{(result ? "成功" : "失败")}!');self.opener.location.reload();window.close();</script>");
        }
    }
}