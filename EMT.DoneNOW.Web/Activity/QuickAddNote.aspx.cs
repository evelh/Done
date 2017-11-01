using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EMT.DoneNOW.BLL;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DTO;

namespace EMT.DoneNOW.Web.Activity
{
    public partial class QuickAddNote : BasePage
    {
        protected long cate = 0;        // 添加备注的种类
        protected int level = 0;        // 添加备注的层级
        protected int objType = 0;      // 备注object_type_id
        protected long objectId = 0;    // 添加备注的对象id
        protected string resouceName = "";
        private ActivityBLL bll = new ActivityBLL();
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                var cateType = Request.QueryString["cate"];
                var type = Request.QueryString["type"];
                var objId = Request.QueryString["objectId"];
                if (string.IsNullOrEmpty(cateType) || string.IsNullOrEmpty(type) || string.IsNullOrEmpty(objId))
                {
                    Response.Close();
                    return;
                }
                cate = long.Parse(cateType);
                objType = int.Parse(type);
                objectId = long.Parse(objId);
                level = int.Parse(Request.QueryString["level"]);

                //if (actType == (int)DicEnum.OBJECT_TYPE.CUSTOMER || actType == (int)DicEnum.OBJECT_TYPE.CONTACT
                //    || actType == (int)DicEnum.OBJECT_TYPE.OPPORTUNITY || actType == (int)DicEnum.OBJECT_TYPE.SALEORDER)
                //{
                //    var parentNote = bll.GetActivity(parentId);
                //    if (parentNote.parent_id != null)
                //        parentNote = bll.GetActivity((long)parentNote.parent_id);

                //    if (parentNote.resource_id != null)
                //        resouceName = new UserResourceBLL().GetSysResourceSingle((long)parentNote.resource_id).name;
                //}
            }
            else
            {
                objectId = long.Parse(Request.Form["objectId"]);
                cate = long.Parse(Request.Form["cate"]);
                objType = int.Parse(Request.Form["objType"]);
                level = int.Parse(Request.Form["level"]);
                bool isNotify = false;
                if (!string.IsNullOrEmpty(Request.Form["isNotify"]) && Request.Form["isNotify"].Equals("on"))
                    isNotify = true;
                if (bll.FastAddNote(objType,objectId, cate, level, Request.Form["desc"],isNotify,GetLoginUserId()))
                {
                    Response.Write("<script>alert('添加备注成功');window.close();self.opener.RequestActivity();</script>");
                }
                else
                {
                    Response.Write("<script>alert('添加备注失败');</script>");
                }
            }
        }
    }
}