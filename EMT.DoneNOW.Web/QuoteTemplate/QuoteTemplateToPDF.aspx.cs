using iTextSharp.text;
using iTextSharp.text.pdf;
using iTextSharp.tool.xml;
using System;
using System.Data;
using System.Diagnostics;
using System.IO;
using System.Text;

namespace EMT.DoneNOW.Web
{
    public partial class QuoteTemplateToPDF :BasePage
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }
        public void test1() {
            DataTable datatable = new DataTable("testpdf");
            try
            {
                Document document = new Document();
                PdfWriter.GetInstance(document, new FileStream(Server.MapPath("Test.pdf"), FileMode.Create));
                document.Open();
                BaseFont bfChinese = BaseFont.CreateFont("C:\\WINDOWS\\Fonts\\simsun.ttc,1", BaseFont.IDENTITY_H, BaseFont.NOT_EMBEDDED);
                Font fontChinese = new Font(bfChinese, 12, Font.BOLD, new BaseColor(0, 0, 0));

                //按设置的字体输出文本
                document.Add(new Paragraph("", fontChinese));
                //输出图片到PDF文件
                //Image jpeg01 = iTextSharp.text.Image.GetInstance(Server.MapPath("Images/gyl.jpg"));
                //document.Add(jpeg01);
                //iTextSharp.text.Image jpeg02 = iTextSharp.text.Image.GetInstance(Server.MapPath("Images/yy.jpg"));
                //document.Add(jpeg02);

                PdfPTable table = new PdfPTable(3);

                for (int i = 0; i < 4; i++)
                {
                    for (int j = 0; j < 3; j++)
                    {
                        table.AddCell(new Phrase("ceshi", fontChinese));
                    }
                }

                document.Add(table);
                document.Close();
                Response.Write("<script>alert('导出成功！');</script>");
            }
            catch (DocumentException de)
            {
                Response.Write(de.ToString());
            }
        }
        protected void Button1_Click(object sender, EventArgs e)
        {
            test2();
        }
        public void test2() {
            string fileName = Guid.NewGuid().ToString(); 
            string savepath = string.Format("C:\\DoneNowNET" + "\\" + fileName + ".pdf");//最终保存
            string url = Request.Url.ToString();
            try
            {
                if (!string.IsNullOrEmpty(url) || !string.IsNullOrEmpty(savepath))
                {
                    Process p = new Process();
                    string dllstr = string.Format("C:\\Program Files (x86)\\wkhtmltopdf\\bin\\wkhtmltopdf.exe");
                    if (System.IO.File.Exists(dllstr))
                    {
                        p.StartInfo.FileName = dllstr;
                        p.StartInfo.Arguments = " \"" + url + "\"  \"" + savepath + "\"";
                        p.StartInfo.UseShellExecute = false;
                        p.StartInfo.RedirectStandardInput = true;
                        p.StartInfo.RedirectStandardOutput = true;
                        p.StartInfo.RedirectStandardError = true;
                        p.StartInfo.CreateNoWindow = true;
                        p.Start();
                        p.WaitForExit();

                        try
                        {
                            FileStream fs = new FileStream(savepath, FileMode.Open);
                            byte[] file = new byte[fs.Length];
                            fs.Read(file, 0, file.Length);
                            fs.Close();
                            Response.Clear();
                            Response.AddHeader("content-disposition", "attachment; filename=" + fileName + ".pdf");//強制下載
                            Response.ContentType = "application/octet-stream";
                            Response.BinaryWrite(file);
                        }
                        catch (Exception ee)
                        {

                            throw new Exception(ee.ToString());
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                throw new Exception(ex.ToString());
            }
        }

    }
}