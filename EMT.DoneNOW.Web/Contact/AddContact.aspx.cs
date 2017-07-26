using EMT.DoneNOW.BLL;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DTO;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace EMT.DoneNOW.Web
{
    public partial class AddContact : BasePage
    {
        protected List<UserDefinedFieldDto> contact_udfList = null;      // 联系人自定义
      
       

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {            
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
    }


}