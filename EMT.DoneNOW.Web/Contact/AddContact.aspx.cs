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

        protected string aName;
        protected string account_id;
        protected string extId;
        protected string fName;
        protected string lName;
        protected string active;
        protected string title;
        protected string pContact;
        protected string location;
        protected string location2;
        protected string email;
        protected string email2;
        protected string phone;
        protected string al_phone;
        protected string mobile_phone;
        protected string fax;
        protected string fileAvatar;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (IsPostBack)
            {
                aName = HttpContext.Current.Request.Form["account_name"];
                account_id= HttpContext.Current.Request.Form["account_id"];
                extId = HttpContext.Current.Request.Form["external_id"];
                fName = HttpContext.Current.Request.Form["first_name"];
                lName = HttpContext.Current.Request.Form["last_name"];
                active = HttpContext.Current.Request.Form["is_active"];
                title = HttpContext.Current.Request.Form["title"];
                pContact = HttpContext.Current.Request.Form["is_primary_contact"];
                location = HttpContext.Current.Request.Form["location"];
                location2 = HttpContext.Current.Request.Form["location2"];
                email = HttpContext.Current.Request.Form["email"];
                email2 = HttpContext.Current.Request.Form["email2"];
                phone = HttpContext.Current.Request.Form["phone"];
                al_phone = HttpContext.Current.Request.Form["alternate_phone"];
                mobile_phone = HttpContext.Current.Request.Form["mobile_phone"];
                fax = HttpContext.Current.Request.Form["fax"];
            }
            else { 
                var dic = new ContactBLL().GetField();
                // 称谓
                sufix.DataTextField = "show";
                sufix.DataValueField = "val";
                sufix.DataSource = dic.FirstOrDefault(_ => _.Key == "sufix").Value;
                sufix.DataBind();
                sufix.Items.Insert(0, new ListItem() { Value = "0", Text = "   ", Selected = true });             
            }
            contact_udfList = new UserDefinedFieldsBLL().GetUdf(DicEnum.UDF_CATE.CONTACT);
        }

        /// <summary>
        /// 保存并关闭
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        /// 
        protected void save_Click(object sender, EventArgs e)
        {
            var param = new ContactAddAndUpdateDto();
            param.contact = AssembleModel<crm_contact>();
            param.location = AssembleModel<crm_location>();
            param.contact.name = param.contact.first_name + param.contact.last_name;
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
            
            var result = new ContactBLL().Insert(param, GetLoginUserId());
            if (result == ERROR_CODE.USER_NOT_FIND)   // 联系人为空，重写
            {
                Response.Write("<script>alert('联系人为空，请重新填写'); </script>");
            }
            else if (result == ERROR_CODE.PARAMS_ERROR)      // 必填项校验
            {
                Response.Write("<script>alert('必填项错误。'); </script>");
            }
            else if (result == ERROR_CODE.ERROR)               // 联系人已将存在
            {
                Response.Write("<script>alert('联系人已将存在');</script>");
                //Response.Redirect("Login.aspx");
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
            var param = new ContactAddAndUpdateDto();
            param.contact = AssembleModel<crm_contact>();
            param.location = AssembleModel<crm_location>();

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

            var result = new ContactBLL().Insert(param, GetLoginUserId());
            if (result == ERROR_CODE.USER_NOT_FIND)   // 联系人为空，重写
            {
                Response.Write("<script>alert('联系人为空，请重新填写'); </script>");
            }
            else if (result == ERROR_CODE.PARAMS_ERROR)      // 必填项校验
            {
                Response.Write("<script>alert('必填项错误。'); </script>");
            }
            else if (result == ERROR_CODE.ERROR)               // 联系人已将存在
            {
                Response.Write("<script>alert('联系人已将存在');</script>");
                //Response.Redirect("Login.aspx");
            }
            else if (result == ERROR_CODE.SUCCESS)                    // 插入联系人成功，刷新前一个页面
            {
                Response.Write("<script>alert('添加客户成功！');history.go(0);</script>");  //  关闭添加页面的同时，刷新父页面

            }
        }

        protected void Button1_Click(object sender, EventArgs e)
        {
            Boolean fileOk = false;
            if (pic_upload.HasFile)//验证是否包含文件
            {
                //取得文件的扩展名,并转换成小写
                string fileExtension = Path.GetExtension(pic_upload.FileName).ToLower();
                //验证上传文件是否图片格式
                fileOk = IsImage(fileExtension);
                if (fileOk)
                {
                    //对上传文件的大小进行检测，限定文件最大不超过8M
                    if (pic_upload.PostedFile.ContentLength < 8192000)
                    {
                        string filepath = "/images/";
                        if (Directory.Exists(Server.MapPath(filepath)) == false)//如果不存在就创建file文件夹
                        {
                            Directory.CreateDirectory(Server.MapPath(filepath));
                        }
                        string virpath = filepath + CreatePasswordHash(pic_upload.FileName, 4) + fileExtension;//这是存到服务器上的虚拟路径
                        string mappath = Server.MapPath(virpath);//转换成服务器上的物理路径
                        pic_upload.PostedFile.SaveAs(mappath);//保存图片
                        //显示图片
                        pic.ImageUrl = virpath;
                        fileAvatar = virpath;
                    }
                    else
                    {
                        pic.ImageUrl = "";
                    }
                }
                else
                {
                    pic.ImageUrl = "";
                }
            }
            else
            {
                pic.ImageUrl = "";
            }
        }
        /// <summary>
        /// 验证是否指定的图片格式
        /// </summary>
        /// <param name="str"></param>
        /// <returns></returns>
        public bool IsImage(string str)
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
        /// <summary>
        /// 创建一个指定长度的随机salt值
        /// </summary>
        public string CreateSalt(int saltLenght)
        {
            //生成一个加密的随机数
            RNGCryptoServiceProvider rng = new RNGCryptoServiceProvider();
            byte[] buff = new byte[saltLenght];
            rng.GetBytes(buff);
            //返回一个Base64随机数的字符串
            return Convert.ToBase64String(buff);
        }
        /// <summary>
        /// 返回加密后的字符串
        /// </summary>
        public string CreatePasswordHash(string pwd, int saltLenght)
        {
            string strSalt = CreateSalt(saltLenght);
            //把密码和Salt连起来
            string saltAndPwd = String.Concat(pwd, strSalt);
            //对密码进行哈希
            string hashenPwd = FormsAuthentication.HashPasswordForStoringInConfigFile(saltAndPwd, "sha1");
            //转为小写字符并截取前16个字符串
            hashenPwd = hashenPwd.ToLower().Substring(0, 16);
            //返回哈希后的值
            return hashenPwd;
        }
    }


}