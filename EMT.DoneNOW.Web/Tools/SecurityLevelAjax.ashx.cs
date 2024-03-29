﻿using EMT.DoneNOW.Core;
using EMT.DoneNOW.DAL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using static EMT.DoneNOW.DTO.DicEnum;
using EMT.Tools.Date;
using EMT.DoneNOW.BLL;
using System.Web.SessionState;

namespace EMT.DoneNOW.Web
{
    /// <summary>
    /// SecurityLevelAjax 的摘要说明
    /// </summary>
    public class SecurityLevelAjax : BaseAjax
    {

        public override void AjaxProcess(HttpContext context)
        {
            var action = context.Request.QueryString["act"];
            var securitylevel_id = context.Request.QueryString["id"];
            switch (action)
            {
                case "copy":
                    CopySecurityLevel(context, Convert.ToInt64(securitylevel_id));//复制安全等级
                    break;
                case "active":
                    ActiveSecurityLevel(context, Convert.ToInt64(securitylevel_id));//激活安全等级
                    ; break;
                case "delete":
                    DeleteSecurityLevel(context, Convert.ToInt64(securitylevel_id));//暂未实现，部分逻辑不明了。8-24
                    ; break;
                case "noactive":
                    NoActiveSecurityLevel(context, Convert.ToInt64(securitylevel_id));//设置为停用状态
                    ; break;
                default: break;
            }
        }
        public void CopySecurityLevel(HttpContext context, long securitylevel_id)
        {
            //此处写复制逻辑

            int copy_id = -1;
            if (new SecurityLevelBLL().CopySecurityLevel(LoginUserId, (int)securitylevel_id, out copy_id))
            {
                context.Response.Write(copy_id);
            }
            else
            {
                context.Response.Write("error");
            }

        }
        public void DeleteSecurityLevel(HttpContext context, long securitylevel_id)
        {
            //此处写删除逻辑

            var result = new SecurityLevelBLL().DeleteSecurityLevel(LoginUserId, (int)securitylevel_id);
            if (result == DTO.ERROR_CODE.SUCCESS)
            {
                context.Response.Write("删除安全等级成功！");
            }
            else if (result == DTO.ERROR_CODE.SYSTEM)
            {
                context.Response.Write("系统安全等级不能删除！");
            }
            else
            {
                context.Response.Write("删除安全等级失败！");
            }

        }
        public void ActiveSecurityLevel(HttpContext context, long securitylevel_id)
        {
            //此处激活逻辑

            var result = new SecurityLevelBLL().ActiveSecurityLevel(LoginUserId, (int)securitylevel_id);
            if (result == DTO.ERROR_CODE.SUCCESS)
            {
                context.Response.Write("激活安全等级成功！");
            }
            if (result == DTO.ERROR_CODE.ACTIVATION)
            {
                context.Response.Write("激活状态的模板不可以进行该操作！");
            }
            if (result == DTO.ERROR_CODE.ERROR)
            {
                context.Response.Write("激活安全等级失败！");
            }

        }
        public void NoActiveSecurityLevel(HttpContext context, long securitylevel_id)
        {
            //此处激活逻辑

            var result = new SecurityLevelBLL().NOActiveSecurityLevel(LoginUserId, (int)securitylevel_id);
            if (result == DTO.ERROR_CODE.SUCCESS)
            {
                context.Response.Write("停用安全等级成功！");
            }
            if (result == DTO.ERROR_CODE.NO_ACTIVATION)
            {
                context.Response.Write("停用状态的模板不可以进行该操作！");
            }
            if (result == DTO.ERROR_CODE.ERROR)
            {
                context.Response.Write("停用安全等级失败！");
            }

        }

    }
}