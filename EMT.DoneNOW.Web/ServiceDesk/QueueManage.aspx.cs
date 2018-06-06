using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EMT.DoneNOW.BLL;
using EMT.DoneNOW.Core;

namespace EMT.DoneNOW.Web.ServiceDesk
{
    public partial class QueueManage : BasePage
    {
        protected bool isAdd = true;
        protected sys_department queue;
        protected List<sys_resource_department> resDepList;
        protected DepartmentBLL depBll = new DepartmentBLL();
        protected Dictionary<long, string> locationDic;
        protected List<sys_resource> resList = new DAL.sys_resource_dal().GetSourceList();
        protected List<sys_role> roleList = new DAL.sys_role_dal().GetList();
        protected void Page_Load(object sender, EventArgs e)
        {
            locationDic= depBll.GetDownList();
            long id = 0;
            if (!string.IsNullOrEmpty(Request.QueryString["id"]))
                if (long.TryParse(Request.QueryString["id"], out id))
                    queue = depBll.GetQueue(id);
            if (queue != null)
            { isAdd = false; resDepList = depBll.GetResDepList(queue.id); }

        }

        protected void save_close_Click(object sender, EventArgs e)
        {
            sys_department pageQueue = AssembleModel<sys_department>();
            if (!string.IsNullOrEmpty(Request.Form["isActive"]) && Request.Form["isActive"] == "on")
                pageQueue.is_active = 1;
            else
                pageQueue.is_active = 0;
            if (!string.IsNullOrEmpty(Request.Form["isShow"]) && Request.Form["isShow"] == "on")
                pageQueue.is_show = 1;
            else
                pageQueue.is_show = 0;
            pageQueue.cate_id = (int)DTO.DicEnum.DEPARTMENT_CATE.SERVICE_QUEUE;
            if (!isAdd)
            {
                queue.name = pageQueue.name;
                queue.location_id = pageQueue.location_id;
                queue.no = pageQueue.no;
                queue.description = pageQueue.description;
                queue.is_active = pageQueue.is_active;
                queue.is_show = pageQueue.is_show;
                queue.other_email = pageQueue.other_email;
                queue.other_email2 = pageQueue.other_email2;
                queue.other_email3 = pageQueue.other_email3;
                queue.other_email4 = pageQueue.other_email4;
            }
            var result = false;
            if (isAdd)
                result = depBll.AddQueue(pageQueue, LoginUserId);
            else
                result = depBll.EditQueue(queue,LoginUserId);

            ClientScript.RegisterStartupScript(this.GetType(), "提示信息", $"<script>alert('保存{(result ? "成功" : "失败")}!');window.close();</script>");

        }
    }
}