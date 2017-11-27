using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DTO;
namespace EMT.DoneNOW.DAL
{
    public class sdk_task_milestone_dal : BaseDAL<sdk_task_milestone>
    {
        /// <summary>
        /// 获取到这个阶段的里程碑
        /// </summary>
        public List<PageMile> GetPhaMilList(long phaId)
        {
            return FindListBySql<PageMile>($"SELECT stm.id,'taskMile' as type,ccm.`name` as name ,d.`name` as status ,d.id as status_id,ccm.dollars as amount,due_date as dueDate,'√' as isAss from sdk_task_milestone as stm INNER JOIN sdk_task as st on stm.task_id = st.id INNER JOIN ctt_contract_milestone as ccm on stm.contract_milestone_id = ccm.id LEFT JOIN d_general as d on ccm.status_id = d.id where stm.delete_time = 0 and st.delete_time = 0 and st.id = {phaId} and st.type_id = {(int)DTO.DicEnum.TASK_TYPE.PROJECT_PHASE}");
            // 
        }
    }
}
