using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using EMT.DoneNOW.Core;
namespace EMT.DoneNOW.DAL
{
    public class com_import_log_detail_dal : BaseDAL<com_import_log_detail>
    {
        long log_id;    // 导入日志id
        int rownum = 1; // 导入文件行号
        public com_import_log_detail_dal(long logId)
        {
            log_id = logId;
        }

        /// <summary>
        /// 添加成功导入日志详情
        /// </summary>
        public void AddSuccessLog()
        {
            AddLog(log_id, rownum++, 1, null);
        }

        /// <summary>
        /// 添加失败导入日志详情
        /// </summary>
        /// <param name="fail"></param>
        public void AddFailLog(string fail)
        {
            AddLog(log_id, rownum++, 0, fail);
        }

        /// <summary>
        /// 添加导入日志详情
        /// </summary>
        /// <param name="logId">导入日志id</param>
        /// <param name="row">对应导入文件行号</param>
        /// <param name="isSuccess"></param>
        /// <param name="fail">失败原因</param>
        public void AddLog(long logId, int row, int isSuccess, string fail)
        {
            com_import_log_detail log = new com_import_log_detail
            {
                id = GetNextIdCom(),
                log_id = logId,
                is_sucess = isSuccess,
                rownum = row,
                fail_desc = fail
            };
            base.Insert(log);
        }
    }

}
