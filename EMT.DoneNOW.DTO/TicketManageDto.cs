using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using EMT.DoneNOW.Core;

namespace EMT.DoneNOW.DTO
{
    public class TicketManageDto
    {
        /// <summary>
        /// 工单实体类
        /// </summary>
        public sdk_task ticket;
        /// <summary>
        /// 任务其他负责人
        /// </summary>
        public string resDepIds;
        /// <summary>
        /// 自定义字段
        /// </summary>
        public List<UserDefinedFieldValue> udfList;
        /// <summary>
        /// 检查单信息
        /// </summary>
        public List<CheckListDto> ckList;
        /// <summary>
        /// 完成说明
        /// </summary>
        public string completeReason;
        /// <summary>
        /// 重新打开说明
        /// </summary>
        public string repeatReason;
        /// <summary>
        /// 是否附加解决方案
        /// </summary>
        public bool isAppSlo;
        #region 通知相关参数
        /// <summary>
        /// 通知模板Id
        /// </summary>
        public int notify_id;
        /// <summary>
        /// 通知员工Id
        /// </summary>
        public string ToResId;
        public string CCResId;
        public string BCCResId;
        public string Subject;
        /// <summary>
        /// 追加文本
        /// </summary>
        public string AdditionalEmailText;
        /// <summary>
        /// 是否以当前用户名义发送
        /// </summary>
        public bool EmailFrom;
        #endregion
    }
    public class CheckListDto
    {
        /// <summary>
        /// 检查单ID
        /// </summary>
        public long ckId;
        /// <summary>
        /// 关联的知识库的Id
        /// </summary>
        public long? realKnowId;
        /// <summary>
        /// 是否完成
        /// </summary>
        public bool isComplete;
        /// <summary>
        /// 检查单名称
        /// </summary>
        public string itemName;
        /// <summary>
        /// 是否重要
        /// </summary>
        public bool isImport;
        /// <summary>
        /// 排序号
        /// </summary>
        public decimal? sortOrder;
    }
}
