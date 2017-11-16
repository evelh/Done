using EMT.DoneNOW.BLL;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DTO;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.SessionState;

namespace EMT.DoneNOW.Web
{
    /// <summary>
    /// ApproveAndPostAjax 的摘要说明
    /// </summary>
    public class ApproveAndPostAjax : BaseAjax
    {
        public override void AjaxProcess(HttpContext context)
        {
            var action = context.Request.QueryString["act"];
            var type = context.Request.QueryString["type"];
            var id = context.Request.QueryString["id"];
            var date = context.Request.QueryString["date"];
            switch (action)
            {
                case "init": Init(context, Convert.ToInt32(id), Convert.ToInt32(type)); break;
                case "nobilling": NoBilling(context, Convert.ToInt32(id), Convert.ToInt32(type)); break;
                case "billing": Billing(context, Convert.ToInt32(id), Convert.ToInt32(type)); break;
                case "post": Post(context, Convert.ToInt32(id), Convert.ToInt32(type), Convert.ToInt32(date)); ; break;
                //查看合同详情
                case "ContractDetails": ContractDetails(context, Convert.ToInt32(id), Convert.ToInt32(type), Convert.ToInt32(date)); ; break;
                //处理合同成本审批
                case "auto_block": auto_block(context, Convert.ToInt32(id), Convert.ToInt32(type), Convert.ToInt32(date)); ; break;
                case "force": force(context, Convert.ToInt32(id), Convert.ToInt32(type), Convert.ToInt32(date)); ; break;
                case "cost": Cost(context, Convert.ToInt32(id), Convert.ToInt32(type), Convert.ToInt32(date)); ; break;
                default: break;

            }
        }
        //合同成本
        public void Cost(HttpContext context, int id, int type, int date)
        {
            ApproveAndPostBLL aapbll = new ApproveAndPostBLL();

            var result = aapbll.ChargeBlock(id);
            if (result == ERROR_CODE.SUCCESS)
            {
                context.Response.Write("less");
            }
            else if (result == ERROR_CODE.NOTIFICATION_RULE)
            {
                context.Response.Write("rate_null");
            }
            else
            {

            }

        }
        //自动生成
        public void auto_block(HttpContext context, int id, int type, int date)
        {
            ApproveAndPostBLL aapbll = new ApproveAndPostBLL();

            if (aapbll.Post_Charges_a(id, date, LoginUserId) != ERROR_CODE.SUCCESS)
            {
                context.Response.Write("error");
            }

        }
        //强制生成
        public void force(HttpContext context, int id, int type, int date)
        {
            ApproveAndPostBLL aapbll = new ApproveAndPostBLL();


            if (aapbll.Post_Charges_b(id, date, LoginUserId) != ERROR_CODE.SUCCESS)
            {
                context.Response.Write("error");
            }

        }
        public void Post(HttpContext context, int id, int type, int date)
        {
            ApproveAndPostBLL aapbll = new ApproveAndPostBLL();

            var result = aapbll.Post(Convert.ToInt32(id), date, type, LoginUserId);
            if (result != DTO.ERROR_CODE.SUCCESS)
            {
                context.Response.Write("error");
            }

        }
        public void ContractDetails(HttpContext context, int id, int type, int date)
        {
            ApproveAndPostBLL aapbll = new ApproveAndPostBLL();

            var result = aapbll.ContractDetails(Convert.ToInt32(id), date, type, LoginUserId);
            if (result > 0)
            {
                context.Response.Write(result);
            }

        }
        /// <summary>
        /// 恢复初始值
        /// </summary>
        /// <param name="context"></param>
        /// <param name="id"></param>
        /// <param name="type"></param>
        public void Init(HttpContext context, int id, int type)
        {
            ApproveAndPostBLL aapbll = new ApproveAndPostBLL();

            if (aapbll.Restore_Initial(id, type, LoginUserId))
            {
                context.Response.Write("已经恢复初始值！");
            }
            else
            {
                context.Response.Write("失败！");
            }

        }
        public void NoBilling(HttpContext context, int id, int type)
        {
            ApproveAndPostBLL aapbll = new ApproveAndPostBLL();

            if (aapbll.NoBilling(id, type, LoginUserId))
            {
                context.Response.Write("设置为不可计费成功！");
            }
            else
            {
                context.Response.Write("失败！");
            }

        }
        public void Billing(HttpContext context, int id, int type)
        {
            ApproveAndPostBLL aapbll = new ApproveAndPostBLL();

            if (aapbll.Billing(id, type, LoginUserId))
            {
                context.Response.Write("设置为可计费成功！");
            }
            else
            {
                context.Response.Write("失败！");
            }

        }

    }
}