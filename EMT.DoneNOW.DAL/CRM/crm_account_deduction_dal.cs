﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DTO;

namespace EMT.DoneNOW.DAL
{
    public class crm_account_deduction_dal : BaseDAL<crm_account_deduction>
    {
        /// <summary>
        /// 查询该客户下的条目
        /// </summary>
        /// <param name="account_id"></param>
        /// <returns></returns>
        public List<crm_account_deduction> GetAccDed(long account_id)
        {
            return FindListBySql<crm_account_deduction>($"SELECT * from crm_account_deduction where account_id = {account_id} and delete_time = 0");
        }

        /// <summary>
        /// 根据条件查询出对应条目
        /// </summary>
        public List<crm_account_deduction> GetAccDed(string where)
        {
            return FindListBySql<crm_account_deduction>($"SELECT * from crm_account_deduction where  delete_time = 0 "+where);
        }
        /// <summary>
        /// 根据sql语句查询出符合条件的条目(从视图中查询)
        /// </summary>
        public List<InvoiceDeductionDto> GetInvDedDtoList(string where="")
        {
            return FindListBySql<InvoiceDeductionDto>("select * from v_posted_all where 1=1 " + where);
        }

        public InvoiceDeductionDto GetSinDto(string where = "")
        {
            return FindSignleBySql<InvoiceDeductionDto>("select * from v_posted_all where 1=1 " + where);
        }

        public List<crm_account_deduction> GetAccDeds(string ids)
        {
            return FindListBySql<crm_account_deduction>($"SELECT * from crm_account_deduction where id in ({ids}) and delete_time = 0");
        }
        /// <summary>
        /// 通过任务id获取相应条目信息
        /// </summary>
        public List<crm_account_deduction> GetDedListByTaskId(long taskId)
        {
            return FindListBySql<crm_account_deduction>($"SELECT * from crm_account_deduction where delete_time = 0 and task_id  = {taskId}");
        }
        /// <summary>
        /// 根据对象Id 获取相应的条目
        /// </summary>
        public List<crm_account_deduction> GetListByObjectId(long object_id)
        {
            return FindListBySql<crm_account_deduction>($"SELECT * from crm_account_deduction where delete_time = 0 and object_id = {object_id} ");
        }
        /// <summary>
        /// 获取指定时间内的合同的总和
        /// </summary>
        public decimal GetContractSum(long accountId,DateTime startDate,DateTime endDate)
        {
            return Convert.ToDecimal(GetSingle($"SELECT sum(dollars) from v_posted_all where posted_date<='{endDate.ToString("yyyy-MM-dd")}' and posted_date>='{startDate.ToString("yyyy-MM-dd")}' and account_id = {accountId} and contract_name is not NULL"));
        }
        /// <summary>
        /// 获取指定时间内的项目的总和
        /// </summary>
        public decimal GetProjectSum(long accountId, DateTime startDate, DateTime endDate)
        {
            return Convert.ToDecimal(GetSingle($"SELECT sum(dollars) from v_posted_all where posted_date<='{endDate.ToString("yyyy-MM-dd")}' and posted_date>='{startDate.ToString("yyyy-MM-dd")}' and account_id = {accountId} and project_id is not NULL"));
        }

    }

}