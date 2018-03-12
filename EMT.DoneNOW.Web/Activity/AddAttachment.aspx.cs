using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EMT.DoneNOW.BLL;
using EMT.DoneNOW.DTO;
using System.IO;

namespace EMT.DoneNOW.Web.Activity
{
    public partial class AddAttachment : BasePage
    {
        protected int objType = 0;
        protected long objId = 0;
        protected List<DictionaryEntryDto> attTypeList = null;    // 附件类型
        protected List<Core.d_general> pubTypeList = null;        // 发布类型- 工单使用
        protected bool isTicket = false;     // 是否是工单
        protected void Page_Load(object sender, EventArgs e)
        {
            attTypeList = new GeneralBLL().GetDicValues(GeneralTableEnum.ATTACHMENT_TYPE);
            pubTypeList = new DAL.d_general_dal().GetGeneralByTableId((int)GeneralTableEnum.ATTACHMENT_PUBLISH_TYPE);
            if (!IsPostBack)
            {
                objType = int.Parse(Request.QueryString["objType"]);
                objId = int.Parse(Request.QueryString["objId"]);

            }
            else
            {
                var action = Request.Form["action"];
                var actType = int.Parse(Request.Form["actType"]);
                var attName = Request.Form["attName"];
                var pubType = Request.Form["pubType"];
                objId = long.Parse(Request.Form["objId"]);
                objType = int.Parse(Request.Form["objType"]);
                string isNoFunc = Request.QueryString["noFunc"];
                if (actType == (int)DicEnum.ATTACHMENT_TYPE.ATTACHMENT)
                {
                    string saveName;
                    var file = Request.Files["attFile"];
                    string error = SavePic(file, out saveName);

                    if (string.IsNullOrEmpty(error))
                    {
                        if (new AttachmentBLL().AddAttachment(objType, objId, actType, attName, "", file.FileName, saveName, file.ContentType, file.ContentLength, GetLoginUserId()))
                        {
                            if (isNoFunc == "1")
                            {
                                if (action == "saveNew")
                                {
                                    Response.Write($"<script>alert('添加附件成功');window.location.href='AddAttachment?objType={objType}&objId={objId}';self.opener.location.reload();</script>");
                                }
                                else
                                {
                                    Response.Write($"<script>alert('添加附件成功');self.opener.location.reload();window.close();</script>");
                                }
                                return;
                            }
                            else if (!string.IsNullOrEmpty(isNoFunc))
                            {
                                if (action == "saveNew")
                                    Response.Write($"<script>alert('添加附件成功');window.location.href='AddAttachment?objType={objType}&objId={objId}&noFunc=1';self.opener.location.{isNoFunc}();</script>");
                                else
                                    Response.Write($"<script>alert('添加附件成功');self.opener.{isNoFunc}();window.close();</script>");
                                return;
                            }
                            else
                            {
                                if (action == "saveNew")
                                    Response.Write($"<script>alert('添加附件成功');window.location.href='AddAttachment?objType={objType}&objId={objId}';self.opener.RequestActivity();</script>");
                                else
                                    Response.Write($"<script>alert('添加附件成功');window.close();self.opener.RequestActivity();</script>");
                                return;
                            }
                        }
                        else
                        {
                            Response.Write($"<script>alert('新增附件失败');</script>");
                            return;
                        }
                    }
                    else
                    {
                        Response.Write($"<script>alert('{error}');</script>");
                        return;
                    }
                }
                else
                {
                    string attLink = Request.Form["attLink"];
                    if (new AttachmentBLL().AddAttachment(objType, objId, actType, attName, attLink, null, null, null, 0, GetLoginUserId()))
                    {
                        if (isNoFunc == "1")
                        {
                            if (action == "saveNew")
                                Response.Write($"<script>alert('添加附件成功');window.location.href='AddAttachment?objType={objType}&objId={objId}&noFunc=1';self.opener.location.reload();</script>");
                            else
                                Response.Write($"<script>alert('添加附件成功');self.opener.location.reload();window.close();</script>");
                            return;
                        }
                        else if (!string.IsNullOrEmpty(isNoFunc))
                        {
                            if (action == "saveNew")
                                Response.Write($"<script>alert('添加附件成功');window.location.href='AddAttachment?objType={objType}&objId={objId}&noFunc=1';self.opener.{isNoFunc}();</script>");
                            else
                                Response.Write($"<script>alert('添加附件成功');self.opener.{isNoFunc}();window.close();</script>");
                            return;
                        }
                        else
                        {
                            if (action == "saveNew")
                                Response.Write($"<script>alert('添加附件成功');window.location.href='AddAttachment?objType={objType}&objId={objId}';self.opener.RequestActivity();</script>");
                            else
                                Response.Write($"<script>alert('添加附件成功');window.close();self.opener.RequestActivity();</script>");
                            return;
                        }

                    }
                    else
                    {
                        Response.Write($"<script>alert('新增附件失败');</script>");
                        return;
                    }
                }
            }
        }

        /// <summary>
        /// 保存上传文件
        /// </summary>
        /// <param name="saveFileName">保存后的web路径</param>
        /// <returns>成功返回空字符串，否则返回错误信息</returns>
        private string SavePic(HttpPostedFile fileForm, out string saveFileName)
        {
            saveFileName = "";
            //var fileForm = Request.Files["attFile"];
            if (fileForm == null)
                return "请选择文件";
            if (fileForm.ContentLength == 0)    // 判断是否选择了文件
                return "请选择文件";

            string fileExtension = Path.GetExtension(fileForm.FileName).ToLower();    //取得文件的扩展名,并转换成小写

            if (fileForm.ContentLength > (10 << 20))     // 判断文件大小不超过10M
                return "文件大小不能超过10M";

            string filepath = $"/Upload/Attachment/{DateTime.Now.ToString("yyyyMM")}/";
            if (Directory.Exists(Server.MapPath(filepath)) == false)    //如果不存在就创建文件夹
            {
                Directory.CreateDirectory(Server.MapPath(filepath));
            }
            string virpath = filepath + Guid.NewGuid().ToString() + fileExtension;//这是存到服务器上的虚拟路径
            string mappath = Server.MapPath(virpath);//转换成服务器上的物理路径

            fileForm.SaveAs(mappath);//保存图片

            saveFileName = virpath;
            return "";
        }
    }
}