using EMT.DoneNOW.Core;
using EMT.DoneNOW.DAL;
using EMT.DoneNOW.DTO;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EMT.DoneNOW.BLL
{
    public class ActionTypeBLL
    {
        private readonly d_general_dal _dal = new d_general_dal();

        public Dictionary<string, object> GetField()
        {
            Dictionary<string, object> dic = new Dictionary<string, object>();
            dic.Add("View", new d_general_dal().GetDictionary(new d_general_table_dal().GetById((int)GeneralTableEnum.CALENDAR_DISPLAY)));              // 日期格式
            return dic;

        }
        public ERROR_CODE InsertActionType(d_general data, long user_id)
        {
            data.general_table_id = (int)GeneralTableEnum.MARKET_SEGMENT;
            data.create_time = data.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            data.create_user_id = user_id;
            _dal.Insert(data);
            return ERROR_CODE.SUCCESS;
        }
        public ERROR_CODE UpdateActionType(d_general data, long user_id)
        {
            data.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            data.update_user_id = user_id;
            _dal.Update(data);
            return ERROR_CODE.SUCCESS;
        }
        public ERROR_CODE DeleteActionType(d_general data, long user_id)
        {
            data.delete_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            data.delete_user_id = user_id;
            _dal.Update(data);
            return ERROR_CODE.SUCCESS;
        }

    }
}
