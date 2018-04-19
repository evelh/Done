
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using EMT.DoneNOW.Core;
namespace EMT.DoneNOW.DAL
{
    public class sys_notice_resource_dal : BaseDAL<sys_notice_resource>
    {
        public sys_notice_resource GetByResNotic(long noticeId,long userId)
        {
            return FindSignleBySql<sys_notice_resource>($"SELECT * from sys_notice_resource where notice_id = {noticeId} and resource_id = {userId}");
        }
    }
}
