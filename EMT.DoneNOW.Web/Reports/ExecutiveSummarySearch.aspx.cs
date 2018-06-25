using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EMT.DoneNOW.BLL;
using EMT.DoneNOW.Core;
using System.IO;
using System.Diagnostics;
using System.Text;

namespace EMT.DoneNOW.Web.Reports
{
    public partial class ExecutiveSummarySearch : BasePage
    {
        protected List<sys_resource> accManList = new DAL.sys_resource_dal().GetSourceList();
        protected List<d_general> terrList = new GeneralBLL().GetGeneralList((int)DTO.GeneralTableEnum.TERRITORY);
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void run_Click(object sender, EventArgs e)
        {
            if (!string.IsNullOrEmpty(Request.Form["accountIdHidden"])&& !string.IsNullOrEmpty(Request.Form["startDate"])&& !string.IsNullOrEmpty(Request.Form["endDate"]))
            {
                var url = "/ExecutiveSummaryResult?accountIds=" + Request.Form["accountIdHidden"] + "&startDate=" + Request.Form["startDate"] + "&endDate=" + Request.Form["endDate"];
                if (!string.IsNullOrEmpty(Request.Form["accManId"]))
                    url += "&searchResId="+ Request.Form["accManId"];
                if (!string.IsNullOrEmpty(Request.Form["terrId"]))
                    url += "&searchTerrId=" + Request.Form["terrId"];
                if (Request.Form["displayType"] == "type")
                    url += "&displayType=1";

                var rquUrl = Request.Url.ToString();
                url = rquUrl.Substring(0, rquUrl.LastIndexOf("/"))+ url;
                HtmlToPdf(url, "", "执行摘要");
            }
            
        }
        private bool HtmlToPdf(string url, string where = "", string fileName = "1")
        {
            bool success = true;
            // string dwbh = url.Split('?')[1].Split('=')[1];
            //CommonBllHelper.CreateUserDir(dwbh);
            //url = Request.Url.Host + "/html/" + url;
            string guid = DateTime.Now.ToString("yyyyMMddhhmmss");
            string pdfName = fileName + ".pdf";
            //string path = Server.MapPath("~/kehu/" + dwbh + "/pdf/") + pdfName;
            string path = Server.MapPath("\\" + pdfName);
            try
            {
                if (string.IsNullOrEmpty(url) || string.IsNullOrEmpty(path))
                    success = false;
                string str = Server.MapPath("~\\bin\\wkhtmltopdf.exe");
                Process p = System.Diagnostics.Process.Start(str + where, url + " " + path);
                p.WaitForExit();
                if (!System.IO.File.Exists(str))
                    success = false;
                if (System.IO.File.Exists(path))
                {
                    FileStream fs = new FileStream(path, FileMode.Open);
                    byte[] bytes = new byte[(int)fs.Length];
                    fs.Read(bytes, 0, bytes.Length);
                    fs.Close();
                    if (Request.UserAgent != null)
                    {
                        string userAgent = Request.UserAgent.ToUpper();
                        if (userAgent.IndexOf("FIREFOX", StringComparison.Ordinal) <= 0)
                        {
                            Response.AddHeader("Content-Disposition",
                                          "attachment;  filename=" + HttpUtility.UrlEncode(pdfName, Encoding.UTF8));
                        }
                        else
                        {
                            Response.AddHeader("Content-Disposition", "attachment;  filename=" + pdfName);
                        }
                    }
                    Response.ContentEncoding = Encoding.UTF8;
                    Response.ContentType = "application/octet-stream";
                    //通知浏览器下载文件而不是打开
                    Response.BinaryWrite(bytes);
                    Response.Buffer = true;
                    Response.Flush();

                    fs.Close();
                    System.IO.File.Delete(path);
                    //Response.End();
                }
                else
                {
                    Response.Write("文件未找到,可能已经被删除");
                    Response.Flush();
                    Response.End();
                }
            }
            catch (Exception ex)
            {
                success = false;
            }
            return success;
        }

    }
}