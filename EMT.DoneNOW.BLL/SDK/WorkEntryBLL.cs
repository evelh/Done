using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DAL;
using EMT.DoneNOW.DTO;

namespace EMT.DoneNOW.BLL
{
    public class WorkEntryBLL
    {
        private sdk_work_entry_dal dal = new sdk_work_entry_dal();

        /// <summary>
        /// 获取工时可选的工作类型，排除年休假、私人时间、浮动时间三项
        /// </summary>
        /// <returns></returns>
        public List<d_cost_code> GetTimeCostCodeList()
        {
            var list = new d_cost_code_dal().GetListCostCode((int)DicEnum.COST_CODE_CATE.INTERNAL_ALLOCATION_CODE);
            list = (from code in list where code.id != 25 && code.id != 35 && code.id != 27 select code).ToList();
            return list;
        }

        /// <summary>
        /// 按批号获取工时列表
        /// </summary>
        /// <param name="batchId"></param>
        /// <returns></returns>
        public List<sdk_work_entry> GetWorkEntryByBatchId(long batchId)
        {
            return dal.FindListBySql($"select * from sdk_work_entry where batch_id={batchId} and delete_time=0");
        }

        /// <summary>
        /// 新增工时
        /// </summary>
        /// <param name="weList"></param>
        /// <param name="userId"></param>
        /// <returns></returns>
        public bool AddWorkEntry(List<sdk_work_entry> weList, long userId)
        {
            long batchId = dal.GetNextId("seq_entry_batch");
            foreach (var we in weList)
            {
                we.id = dal.GetNextIdCom();
                we.create_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
                we.update_time = we.create_time;
                we.create_user_id = userId;
                we.update_user_id = userId;
                we.batch_id = batchId;

                dal.Insert(we);
                OperLogBLL.OperLogAdd<sdk_work_entry>(we, we.id, userId, DicEnum.OPER_LOG_OBJ_CATE.SDK_WORK_ENTRY, "新增工时");
            }

            return true;
        }

        /// <summary>
        /// 编辑工时
        /// </summary>
        /// <param name="weList">编辑后的工时列表</param>
        /// <param name="batchId"></param>
        /// <param name="userId"></param>
        /// <returns></returns>
        public bool EditWorkEntry(List<sdk_work_entry> weList,long batchId, long userId)
        {
            var weListOld = GetWorkEntryByBatchId(batchId);
            if (weListOld[0].approve_and_post_user_id != null) // 已审批提交不能编辑
                return false;

            foreach (var we in weListOld)
            {
                if (weList.Exists(_ => _.start_time == we.start_time))  // 原工时被编辑
                {
                    var weOld = dal.FindById(we.id);
                    var weEdit = weList.Find(_ => _.start_time == we.start_time);
                    we.internal_notes = weEdit.internal_notes;
                    we.summary_notes = weEdit.summary_notes;
                    we.hours_worked = weEdit.hours_worked;
                    we.hours_billed = weEdit.hours_billed;
                    we.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
                    we.update_user_id = userId;
                    var desc = OperLogBLL.CompareValue<sdk_work_entry>(weOld, we);
                    if (!string.IsNullOrEmpty(desc))
                    {
                        dal.Update(we);
                        OperLogBLL.OperLogUpdate(desc, we.id, userId, DicEnum.OPER_LOG_OBJ_CATE.SDK_WORK_ENTRY, "编辑工时");
                    }
                    weList.Remove(weEdit);
                }
                else    // 原工时被删除
                {
                    we.delete_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
                    we.delete_user_id = userId;
                    dal.Update(we);
                    OperLogBLL.OperLogDelete<sdk_work_entry>(we, we.id, userId, DicEnum.OPER_LOG_OBJ_CATE.SDK_WORK_ENTRY, "编辑工时删除");
                }
            }
            foreach (var we in weList)  // 剩余需要新增
            {
                we.id = dal.GetNextIdCom();
                we.batch_id = batchId;
                we.resource_id = weListOld[0].resource_id;
                we.cost_code_id = weListOld[0].cost_code_id;
                we.task_id = weListOld[0].task_id;
                we.create_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
                we.update_time = we.create_time;
                we.create_user_id = userId;
                we.update_user_id = userId;

                dal.Insert(we);
                OperLogBLL.OperLogAdd<sdk_work_entry>(we, we.id, userId, DicEnum.OPER_LOG_OBJ_CATE.SDK_WORK_ENTRY, "编辑工时新增");
            }

            return true;
        }

        /// <summary>
        /// 删除工时
        /// </summary>
        /// <param name="batchId"></param>
        /// <param name="userId"></param>
        /// <returns></returns>
        public bool DeleteWorkEntry(long batchId, long userId)
        {
            var weList = GetWorkEntryByBatchId(batchId);
            if (weList.Count == 0)
                return true;
            if (weList[0].approve_and_post_user_id != null) // 已审批提交不能删除
                return false;

            foreach (var we in weList)
            {
                we.delete_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
                we.delete_user_id = userId;
                dal.Update(we);
                OperLogBLL.OperLogDelete<sdk_work_entry>(we, we.id, userId, DicEnum.OPER_LOG_OBJ_CATE.SDK_WORK_ENTRY, "删除工时");
            }
            return true;
        }
    }
}
