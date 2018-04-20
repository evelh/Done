
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using EMT.DoneNOW.Core;
namespace EMT.DoneNOW.DAL
{
    public class sys_notice_dal : BaseDAL<sys_notice>
    {
        /// <summary>
        /// 获取系统公告类通知
        /// </summary>
        public List<sys_notice> GetSysNotice(long userId)
        {
            var timeNow = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            return FindListBySql<sys_notice>($"SELECT * from sys_notice sn where begin_time<={timeNow} and end_time>={timeNow} and delete_time = 0 and ( (send_type_id ='1' and not EXISTS(SELECT 1 from sys_notice_resource snr where snr.notice_id=sn.id  and snr.resource_id={userId})) or ( EXISTS(SELECT 1 from sys_notice_resource snr where snr.notice_id=sn.id and snr.resource_id={userId} and is_show=1)))");
        }
    }
}
