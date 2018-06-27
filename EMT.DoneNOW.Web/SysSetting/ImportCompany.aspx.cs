using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace EMT.DoneNOW.Web.SysSetting
{
    public partial class ImportCompany : BasePage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (IsPostBack)
            {
                var findOper = Request.Form["findOper"];
                bool isUpdate = false;
                if (!string.IsNullOrEmpty(findOper) && findOper == "1")
                    isUpdate = true;

                var file = Request.Files["importFile"];
                if (file == null)
                {
                    Response.Write("<script>alert('请选择模板文件！');</script>");
                    return;
                }

                string filepath = $"/Upload/Files/";
                if (Directory.Exists(Server.MapPath(filepath)) == false)//如果不存在就创建file文件夹
                {
                    Directory.CreateDirectory(Server.MapPath(filepath));
                }
                string virpath = filepath + Guid.NewGuid().ToString() + ".csv";//这是存到服务器上的虚拟路径
                string mappath = Server.MapPath(virpath);//转换成服务器上的物理路径
                file.SaveAs(mappath);//保存图片

                var rtn = new BLL.DataImportBLL().ImportCompany(mappath, isUpdate, LoginUserId);
                if (string.IsNullOrEmpty(rtn))
                    Response.Write("<script>alert('导入成功！');</script>");
                else
                    Response.Write("<script>alert('导入失败！" + rtn + "');</script>");
            }
        }
    }
}