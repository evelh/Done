using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using EMT.DoneNOW.Core;
namespace EMT.DoneNOW.DAL
{
    public class sys_resource_approver_dal : BaseDAL<sys_resource_approver>
    {
        /// <summary>
        /// 根据员工和审批员工获取审批信息
        /// </summary>
        public sys_resource_approver GetApproverByRes(long resId,long appResId,int appType)
        {
            return FindSignleBySql<sys_resource_approver>($"SELECT * from sys_resource_approver where resource_id = {resId} and approver_resource_id = {appResId} and approve_type_id = {appType}");
        }
    }

}
