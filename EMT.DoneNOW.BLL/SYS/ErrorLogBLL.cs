using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DAL;

namespace EMT.DoneNOW.BLL
{
    public class ErrorLogBLL
    {
        public void AddLog(sys_error_log log)
        {
            new sys_error_log_dal().Insert(log);
        }

        public void AddLog(long userId, string url, string msg, string stackTrace)
        {
            sys_error_log log = new sys_error_log
            {
                user_id = userId,
                request_url = url,
                error_message = msg,
                stack_trace = stackTrace,
                add_time = DateTime.Now,
            };
            AddLog(log);
        }
    }
}
