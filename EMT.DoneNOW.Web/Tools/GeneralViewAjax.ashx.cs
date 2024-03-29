﻿using EMT.DoneNOW.BLL;
using EMT.DoneNOW.Core;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.SessionState;

namespace EMT.DoneNOW.Web
{
    /// <summary>
    /// GeneralViewAjax 的摘要说明
    /// </summary>
    public class GeneralViewAjax : BaseAjax
    {

        public override void AjaxProcess(HttpContext context)
        {
            var action = context.Request.QueryString["act"];
            var general_id = context.Request.QueryString["id"];
            var general_table_id = context.Request.QueryString["GT_id"];
            if (string.IsNullOrEmpty(general_table_id))
            {
                var general = new GeneralBLL().GetSingleGeneral(Convert.ToInt64(general_id));
                general_table_id = general.general_table_id.ToString();
            }
            switch (action)
            {
                case "delete": Delete(context, Convert.ToInt64(general_id), Convert.ToInt64(general_table_id)); ; break;
                case "delete_validate": Delete_Validate(context, Convert.ToInt64(general_id), Convert.ToInt64(general_table_id)); ; break;
                case "active": Active(context, Convert.ToInt64(general_id)); break;
                case "noactive": NoActive(context, Convert.ToInt64(general_id)); break;
                default: break;

            }
        }
        public void Active(HttpContext context, long general_i)
        {

            var result = new GeneralBLL().Active(general_i, LoginUserId);
            if (result == DTO.ERROR_CODE.SUCCESS)
            {
                context.Response.Write("激活成功！");
            }
            else if (result == DTO.ERROR_CODE.ACTIVATION)
            {
                context.Response.Write("已经激活，无需此操作！");
            }
            else
            {
                context.Response.Write("激活失败！");
            }

        }
        public void NoActive(HttpContext context, long general_i)
        {

            var result = new GeneralBLL().NoActive(general_i, LoginUserId);
            if (result == DTO.ERROR_CODE.SUCCESS)
            {
                context.Response.Write("停用成功！");
            }
            else if (result == DTO.ERROR_CODE.NO_ACTIVATION)
            {
                context.Response.Write("已经是停用状态，无需此操作！");
            }
            else
            {
                context.Response.Write("停用失败！");
            }

        }
        public void Delete(HttpContext context, long general_id, long general_table_id)
        {
            //此处写复制逻辑

            var result = new GeneralBLL().Delete(general_id, LoginUserId, general_table_id);
            if (result == DTO.ERROR_CODE.SUCCESS)
            {
                context.Response.Write("success");
            }
            else if (result == DTO.ERROR_CODE.SYSTEM)
            {
                context.Response.Write("system");
            }
            else
            {
                context.Response.Write("error");
            }

        }
        //删除数据前进行验证
        public void Delete_Validate(HttpContext context, long general_id, long general_table_id)
        {
            //此处写复制逻辑

            int n;//记录受影响的个数
            var result = new GeneralBLL().Delete_Validate(general_id, LoginUserId, general_table_id, out n);
            if (result == DTO.ERROR_CODE.SYSTEM)
            {
                context.Response.Write("system");
            }
            else if (result == DTO.ERROR_CODE.MARKET_USED)
            {
                context.Response.Write("有" + n + "个客户关联此市场领域。如果删除，则相关客户上的市场领域信息将会被清空，是否继续?");
            }
            else if (result == DTO.ERROR_CODE.TERRITORY_USED)
            {
                context.Response.Write("有" + n + "个客户关联此客户地域。如果删除，则相关客户上的客户地域信息将会被清空，是否继续?");
            }
            else if (result == DTO.ERROR_CODE.COMPETITOR_USED)
            {
                context.Response.Write("有" + n + "个客户关联此竞争对手。如果删除，则相关客户上的竞争对手信息将会被清空，是否继续?");
            }
            else if (result == DTO.ERROR_CODE.OPPORTUNITY_SOURCE_USED)
            {
                context.Response.Write("有" + n + "个商机关联此商机来源。如果删除，则相关商机上的商机来源信息将会被清空，是否继续?");
            }
            else if (result == DTO.ERROR_CODE.REGION_USED)
            {
                context.Response.Write("有" + n + "个客户关联此区域。如果删除，则相关客户上的区域信息将会被清空，是否继续?");
            }
            else if (result == DTO.ERROR_CODE.OPPORTUNITY_STAGE_USED)
            {
                context.Response.Write("被" + n + "个商机引用不能删除!");
            }
            else if (result == DTO.ERROR_CODE.ACTION_TYPE_USED)
            {
                context.Response.Write("被" + n + "个活动引用不能删除!");
            }
            else if (result == DTO.ERROR_CODE.CONTRACT_TYPE_USED)
            {
                context.Response.Write("有" + n + "个合同关联此合同类别，不能删除!");
            }
            else if (result == DTO.ERROR_CODE.CONTRACT_MILESTONE_USED)
            {
                context.Response.Write("有" + n + "个里程碑关联此状态，不能删除!");
            }
            else if (result == DTO.ERROR_CODE.TICKET_SOURCE_USED)
            {
                context.Response.Write("有" + n + "个工单关联此来源，不能删除!");
            }
            else if (result == DTO.ERROR_CODE.TICKET_STATUS_USED)
            {
                context.Response.Write("有" + n + "个工单/任务关联此状态，不能删除!");
            }
            else if (result == DTO.ERROR_CODE.TICKET_PRIORITY_USED)
            {
                context.Response.Write("有" + n + "个工单关联此优先级，不能删除!");
            }
            else if (result == DTO.ERROR_CODE.TICKET_ISSUE_USED)
            {
                context.Response.Write("有" + n + "个工单关联此问题，不能删除!");
            }
            else if (result == DTO.ERROR_CODE.TICKET_ISSUE_HAS_SUB)
            {
                context.Response.Write("问题有相关子问题，不能删除!");
            }
            else if (result == DTO.ERROR_CODE.PROJECT_USED)
            {
                context.Response.Write("有" + n + "个项目关联此状态，不能删除!");
            }
            else if (result == DTO.ERROR_CODE.LEDGER_USED)
            {
                context.Response.Write("有" + n + "个计费成本关联此总账代码，不能删除!");
            }
            else if (result == DTO.ERROR_CODE.PAY_TERM_USED)
            {
                context.Response.Write("有" + n + "个报价项关联此付款期限 ，不能删除!");
            }
            else if (result == DTO.ERROR_CODE.PAY_TYPE_USED)
            {
                context.Response.Write("有" + n + "个报价项,费用，合同预付关联此付款类型，不能删除!");
            }
            else if (result == DTO.ERROR_CODE.SHIP_TYPE_USED)
            {
                context.Response.Write("有" + n + "个报价项关联此配送类型，不能删除!");
            }
            else if (result == DTO.ERROR_CODE.TAX_REGION_USED)
            {
                context.Response.Write("税区被使用，不能删除!");
            }
            else if (result == DTO.ERROR_CODE.TAX_CATE_USED)
            {
                context.Response.Write("税种被使用，不能删除!");
            }
            else if (result == DTO.ERROR_CODE.NOTE_TYPE_USED)
            {
                context.Response.Write("备注类型被使用，不能删除!");
            }
            else if (result == DTO.ERROR_CODE.SUCCESS)
            {
                Delete(context, general_id, general_table_id);
            }
            else
            {
                context.Response.Write("other");
            }

        }

    }
}