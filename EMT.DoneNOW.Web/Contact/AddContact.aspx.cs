using EMT.DoneNOW.BLL;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DTO;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Security.Cryptography;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace EMT.DoneNOW.Web
{
    public partial class AddContact : BasePage
    {
        protected List<UserDefinedFieldDto> contact_udfList = null;      // 联系人自定义

        protected ContactAddAndUpdateDto dto = new ContactAddAndUpdateDto();
        protected long id = 0;
        protected string avatarPath = "../Images/pop.jpg";

        protected void Page_Load(object sender, EventArgs e)
        {
            bool is_edit = long.TryParse(Request.QueryString["id"], out id);
            if (IsPostBack)
            {
                SaveFormData();
            }
            else
            { 
                var dic = new ContactBLL().GetField();
                // 称谓
                sufix.DataTextField = "show";
                sufix.DataValueField = "val";
                sufix.DataSource = dic.FirstOrDefault(_ => _.Key == "sufix").Value;
                sufix.DataBind();
                sufix.Items.Insert(0, new ListItem() { Value = "0", Text = "   ", Selected = true });

                contact_udfList = new UserDefinedFieldsBLL().GetUdf(DicEnum.UDF_CATE.CONTACT);

                if (is_edit)
                {
                    dto = new ContactBLL().GetContactDto(long.Parse(Request.QueryString["id"]));
                    active.Checked = dto.contact.is_active == 1 ? true : false;
                    primary.Checked = dto.contact.is_primary_contact == 1 ? true : false;
                    allowEmail.Checked = dto.contact.allow_notify_email_task_ticket == 1 ? true : false;
                    optoutEmail.Checked = dto.contact.is_optout_contact_group_email == 1 ? true : false;
                    optoutSurvey.Checked = dto.contact.is_optout_survey == 1 ? true : false;
                }
                else
                {
                    dto.contact = new crm_contact();
                    dto.udf = new List<UserDefinedFieldValue>();
                    dto.location = new crm_location();
                    dto.location2 = new crm_location();
                    active.Checked = true;
                    allowEmail.Checked = true;
                }
            }
        }

        /// <summary>
        /// 保存并关闭
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        /// 
        protected void save_Click(object sender, EventArgs e)
        {
            var result = SaveContact();

            if (result == ERROR_CODE.USER_NOT_FIND)   // 联系人为空，重写
            {
                Response.Write("<script>alert('请重新登录！');window.close();</script>");
            }
            else if (result == ERROR_CODE.PARAMS_ERROR)      // 必填项校验
            {
                Response.Write("<script>alert('必填项错误！'); </script>");
            }
            else if (result == ERROR_CODE.ERROR)               // 联系人已存在
            {
                Response.Write("<script>alert('联系人已存在！');</script>");
            }           
            else if (result == ERROR_CODE.SUCCESS)                    // 插入联系人成功，刷新前一个页面
            {
                Response.Write("<script>alert('添加联系人成功！');window.close();self.opener.location.reload();</script>");  //  关闭添加页面的同时，刷新父页面
            }
        }

        /// <summary>
        /// 保存并新建
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void save_newAdd_Click(object sender, EventArgs e)
        {
            var result = SaveContact();

            if (result == ERROR_CODE.USER_NOT_FIND)   // 联系人为空，重写
            {
                Response.Write("<script>alert('联系人为空，请重新填写'); </script>");
            }
            else if (result == ERROR_CODE.PARAMS_ERROR)      // 必填项校验
            {
                Response.Write("<script>alert('必填项错误。'); </script>");
            }
            else if (result == ERROR_CODE.ERROR)               // 联系人已经存在
            {
                Response.Write("<script>alert('联系人已经存在');</script>");
            }
            else if (result == ERROR_CODE.SUCCESS)                    // 插入联系人成功，刷新前一个页面
            {
                Response.Write("<script>alert('添加客户成功！');history.go(0);</script>");  //  关闭添加页面的同时，刷新父页面
            }
        }

        /// <summary>
        /// 关闭
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void close_Click(object sender, EventArgs e)
        {
            Response.Write("<script>window.close();</script>");
        }

        /// <summary>
        /// 保存联系人信息
        /// </summary>
        /// <returns></returns>
        private ERROR_CODE SaveContact()
        {
            SaveFormData();
            if (dto.contact.id == 0)
                return new ContactBLL().Insert(dto, GetLoginUserId());
            else
                return new ContactBLL().Update(dto, GetLoginUserId());
        }

        /// <summary>
        /// 保存表单数据到对象
        /// </summary>
        private void SaveFormData()
        {
            var param = new ContactAddAndUpdateDto();
            param.contact = AssembleModel<crm_contact>();
            param.contact.name = param.contact.first_name + param.contact.last_name;
            param.contact.avatar = SavePic();
            param.contact.is_active = active.Checked ? 1 : 0;
            param.contact.is_primary_contact = (sbyte)(primary.Checked ? 1 : 0);
            param.contact.is_optout_survey = (sbyte)(optoutSurvey.Checked ? 1 : 0);
            param.contact.is_optout_contact_group_email = (sbyte)(optoutEmail.Checked ? 1 : 0);
            param.contact.allow_notify_email_task_ticket = (sbyte)(allowEmail.Checked ? 1 : 0);
            if (contact_udfList != null && contact_udfList.Count > 0)                      // 首先判断是否有自定义信息
            {
                var list = new List<UserDefinedFieldValue>();
                foreach (var udf in contact_udfList)                            // 循环添加
                {
                    var new_udf = new UserDefinedFieldValue()
                    {
                        id = udf.id,
                        value = Request.Form[udf.id.ToString()] == null ? "" : Request.Form[udf.id.ToString()],
                    };
                    list.Add(new_udf);
                }
                param.udf = list;
            }
            dto = param;
        }

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

            string filepath = $"/Upload/{DateTime.Now.Year.ToString()}{DateTime.Now.Month.ToString()}/Images/Avatar/";
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