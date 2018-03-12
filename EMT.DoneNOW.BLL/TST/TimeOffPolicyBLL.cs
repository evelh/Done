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
    public class TimeOffPolicyBLL
    {
        private tst_timeoff_policy_dal dal = new tst_timeoff_policy_dal();

        /// <summary>
        /// 获取休假策略的休假策略类别
        /// </summary>
        /// <param name="policyId"></param>
        /// <returns></returns>
        public List<tst_timeoff_policy_item> GetPolicyItemByPolicyId(long policyId)
        {
            if (policyId == 0)      // 新增休假策略
            {
                List<tst_timeoff_policy_item> items = new List<tst_timeoff_policy_item>();
                items.Add(new tst_timeoff_policy_item { cate_id = 35 });
                items.Add(new tst_timeoff_policy_item { cate_id = 25 });
                items.Add(new tst_timeoff_policy_item { cate_id = 23 });
                items.Add(new tst_timeoff_policy_item { cate_id = 27 });

                return items;
            }
            else
            {
                return dal.FindListBySql<tst_timeoff_policy_item>($"select * from tst_timeoff_policy_item where timeoff_policy_id={policyId} and delete_time=0 order by cate_id asc");
            }
        }
    }
}
