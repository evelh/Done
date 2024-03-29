﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using EMT.DoneNOW.BLL;

namespace EMT.DoneNOW.Web
{
    /// <summary>
    /// SLAAjax 的摘要说明
    /// </summary>
    public class SLAAjax : BaseAjax
    {
        private SLABLL slaBll = new SLABLL();
        public override void AjaxProcess(HttpContext context)
        {
            var action = context.Request.QueryString["act"];
            switch (action)
            {
                case "CheckSLAName": CheckSLAName(context); break;   // SLA 名称重复校验
                case "GetSLA": GetSLA(context); break;   // 获取到SLA 相关信息
                case "ActiveSLA": ActiveSLA(context); break;   // 激活/失活 SLA
                case "DeleteSLA": DeleteSLA(context); break;   // 删除 SLA
                case "DeleteSLAItem": DeleteSLAItem(context); break;   // 删除 SLA 条目
                default:
                    break; 

            }
        }
        /// <summary>
        /// SLA 名称重复校验
        /// </summary>
        void CheckSLAName(HttpContext context)
        {
            var name = context.Request.QueryString["name"];
            long id = 0;
            if (!string.IsNullOrEmpty(context.Request.QueryString["id"]))
                long.TryParse(context.Request.QueryString["id"],out id);
            var result = false;
            if (!string.IsNullOrEmpty(name))
                result = slaBll.CheckExist(name, id);
            WriteResponseJson(result);
        }
        /// <summary>
        /// 获取到SLA 相关信息
        /// </summary>
        void GetSLA(HttpContext context)
        {
            long id = 0;
            if(!string.IsNullOrEmpty(context.Request.QueryString["id"])&&long.TryParse(context.Request.QueryString["id"], out id))
            {
                var sla = slaBll.GetSlaById(id);
                if (sla != null)
                    WriteResponseJson(sla);
            }
        }
        /// <summary>
        /// 激活/失活 SLA
        /// </summary>
        void ActiveSLA(HttpContext context)
        {
            bool isActive = false;
            if (!string.IsNullOrEmpty(context.Request.QueryString["active"]))
                isActive = true;
            long id = 0;
            if (!string.IsNullOrEmpty(context.Request.QueryString["id"]))
                long.TryParse(context.Request.QueryString["id"], out id);
            var result = false;
            if (id != 0)
                result = slaBll.ActiveSLA(id,isActive,LoginUserId);
            WriteResponseJson(result);
        }
        /// <summary>
        /// 删除SLA
        /// </summary>
        void DeleteSLA(HttpContext context)
        {
            bool result = false;
            string reason = string.Empty;
            long id = 0;
            if (!string.IsNullOrEmpty(context.Request.QueryString["id"]) && long.TryParse(context.Request.QueryString["id"], out id))
                result = slaBll.DeleteSLA(id,LoginUserId,ref reason);
            WriteResponseJson(new {result = result,reason = reason });
        }

        /// <summary>
        /// 删除SLA条目
        /// </summary>
        void DeleteSLAItem(HttpContext context)
        {
            bool result = false;
            long id = 0;
            if (!string.IsNullOrEmpty(context.Request.QueryString["id"]) && long.TryParse(context.Request.QueryString["id"], out id))
                result = slaBll.DeleteItem(id, LoginUserId);
            WriteResponseJson(result);
        }

        

    }
}