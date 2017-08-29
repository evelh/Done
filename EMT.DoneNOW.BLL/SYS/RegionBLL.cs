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
   public class RegionBLL
    {
        private readonly d_general_dal _dal = new d_general_dal();
        public ERROR_CODE InsertRegion(d_general data, long user_id)
        {
            data.general_table_id = (int)GeneralTableEnum.REGION;
            data.create_time = data.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            data.create_user_id = user_id;

            _dal.Insert(data);
            return ERROR_CODE.SUCCESS;
        }
        public ERROR_CODE UpdateRegion(d_general data, long user_id)
        {
            data.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            data.update_user_id= user_id;

            _dal.Update(data);
            return ERROR_CODE.SUCCESS;
        }
    }
}
