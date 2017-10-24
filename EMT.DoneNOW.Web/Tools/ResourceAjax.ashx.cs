﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.SessionState;
using EMT.DoneNOW.DAL;
using System.Text;
using EMT.DoneNOW.Core;

namespace EMT.DoneNOW.Web
{
    /// <summary>
    /// ResourceAjax 的摘要说明
    /// </summary>
    public class ResourceAjax : IHttpHandler, IRequiresSessionState
    {

        public void ProcessRequest(HttpContext context)
        {
            try
            {
                var action = context.Request.QueryString["act"];
                switch (action)
                {
                    case "GetInfo":
                        var resou_id = context.Request.QueryString["id"];
                        GetResouInfo(context, long.Parse(resou_id));
                        break;
                    case "GetResouList":
                        var resIds = context.Request.QueryString["ids"];
                        var isReSouIds = context.Request.QueryString["isReSouIds"];
                        GetResousByResDepIds(context,resIds,!string.IsNullOrEmpty(isReSouIds));
                        break;
                    case "GetWorkName":
                        var wIds = context.Request.QueryString["ids"];
                        GetWorkName(context,wIds);
                        break;
                    default:
                        break;
                }
            }
            catch (Exception e)
            {
                context.Response.Write(e.Message);
                context.Response.End();

            }
        }
        /// <summary>
        /// 获取员工相关信息
        /// </summary>
        private void GetResouInfo(HttpContext context,long sys_resource_id)
        {
            var sys_res = new sys_resource_dal().FindNoDeleteById(sys_resource_id);
            if (sys_res != null)
            {
                context.Response.Write(new Tools.Serialize().SerializeJson(sys_res));
            }
        }
        /// <summary>
        /// 返回员工相关邮箱(根据 员工，角色关系表)
        /// </summary>
        private void GetResousByResDepIds(HttpContext context, string ids,bool isResoIds)
        {
            List<sys_resource> resList = null;
            if (isResoIds)
            {
                resList = new sys_resource_dal().GetListByIds(ids);
            }
            else
            {
                resList = new sys_resource_dal().GetListByDepIds(ids);
            }
             
            if (resList != null && resList.Count > 0)
            {
                StringBuilder emailStringBuilder = new StringBuilder();
                resList.ForEach(_ => emailStringBuilder.Append(_.name+";"));
                var emailString = emailStringBuilder.ToString();
                if (!string.IsNullOrEmpty(emailString))
                {
                    // emailString = emailString.Substring(0, emailString.Length - 1);
                    context.Response.Write(emailString);
                }
            }
        }

        private void GetWorkName(HttpContext context, string ids)
        {
            var workList = new sys_workgroup_dal().GetList($" and id in ({ids})");

            if (workList != null && workList.Count > 0)
            {
                StringBuilder workStringBuilder = new StringBuilder();
                workList.ForEach(_ => workStringBuilder.Append(_.name + ";"));
                var workString = workStringBuilder.ToString();
                if (!string.IsNullOrEmpty(workString))
                {
                    context.Response.Write(workString);
                }
            }
        }

        public bool IsReusable
        {
            get
            {
                return false;
            }
        }
    }
}