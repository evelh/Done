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
    public class ContractBLL
    {
        private readonly ctt_contract_dal dal = new ctt_contract_dal();

        /// <summary>
        /// 新增合同
        /// </summary>
        /// <param name="dto"></param>
        /// <param name="userId"></param>
        /// <returns>新增合同Id</returns>
        public long Insert(ContractAddDto dto, long userId)
        {
            // 新增合同
            dto.contract.id = dal.GetNextIdCom();
            dto.contract.create_time = EMT.Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            dto.contract.create_user_id = userId;
            dto.contract.update_time = dto.contract.create_time;
            dto.contract.update_user_id = userId;
            dal.Insert(dto.contract);

            var user = UserInfoBLL.GetUserInfo(userId);

            // 新增日志
            var add_contract_log = new sys_oper_log()
            {
                user_cate = "用户",
                user_id = user.id,
                name = "",
                phone = user.mobile == null ? "" : user.mobile,
                oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                oper_object_cate_id = (int)DicEnum.OPER_LOG_OBJ_CATE.CONTRACT,
                oper_object_id = dto.contract.id,// 操作对象id
                oper_type_id = (int)DicEnum.OPER_LOG_TYPE.ADD,
                oper_description = dal.AddValue(dto.contract),
                remark = "保存合同信息"
            };         // 创建日志
            new sys_oper_log_dal().Insert(add_contract_log);       // 插入日志

            // 合同自定义字段
            var udf_list = new UserDefinedFieldsBLL().GetUdf(DicEnum.UDF_CATE.CONTRACTS);  // 获取合同的自定义字段信息
            new UserDefinedFieldsBLL().SaveUdfValue(DicEnum.UDF_CATE.CONTRACTS, user.id,
                dto.contract.id, udf_list, dto.udf, DicEnum.OPER_LOG_OBJ_CATE.CONTRACT_EXTENSION); // 保存合同自定义字段值

            // TODO: 邮件通知

            #region 不同合同类型不同处理
            if (dto.contract.type_id == (int)DicEnum.CONTRACT_TYPE.SERVICE)
            {
                // 处理合同服务/服务包

            }
            else
            {
                if (dto.contract.type_id == (int)DicEnum.CONTRACT_TYPE.FIXED_PRICE)
                {
                    // 处理里程碑
                    if (dto.milestone != null && dto.milestone.Count > 0)
                    {
                        ctt_contract_milestone_dal milestoneDal = new ctt_contract_milestone_dal();
                        foreach (var milestone in dto.milestone)
                        {
                            milestone.id = milestoneDal.GetNextIdCom();
                            milestone.contract_id = dto.contract.id;
                            milestone.create_time = EMT.Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                            milestone.create_user_id = userId;
                            milestone.update_time = milestone.create_time;
                            milestone.update_user_id = userId;
                            milestoneDal.Insert(milestone);

                            // 新增日志
                            var log = new sys_oper_log()
                            {
                                user_cate = "用户",
                                user_id = user.id,
                                name = "",
                                phone = user.mobile == null ? "" : user.mobile,
                                oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                                oper_object_cate_id = (int)DicEnum.OPER_LOG_OBJ_CATE.CONTRACT_MILESTONE,
                                oper_object_id = milestone.id,// 操作对象id
                                oper_type_id = (int)DicEnum.OPER_LOG_TYPE.ADD,
                                oper_description = milestoneDal.AddValue(milestone),
                                remark = "保存合同里程碑信息"
                            };         // 创建日志
                            new sys_oper_log_dal().Insert(log);       // 插入日志
                        }
                    }
                }
            }
            #endregion

            return dto.contract.id;
        }

        /// <summary>
        /// 获取SLA列表
        /// </summary>
        /// <returns></returns>
        public List<d_sla> GetSLAList()
        {
            return new d_sla_dal().GetList();
        }
    }
}
