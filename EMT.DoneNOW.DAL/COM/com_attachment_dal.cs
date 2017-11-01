using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using EMT.DoneNOW.Core;
namespace EMT.DoneNOW.DAL
{
    public class com_attachment_dal : BaseDAL<com_attachment>
    {
        /// <summary>
        /// 根据对象Id获取附件相关信息
        /// </summary>
        public List<com_attachment> GetAttListByOid(long oid)
        {
            return FindListBySql<com_attachment>($"SELECT * from com_attachment where delete_time = 0 and object_id ={oid}");
        }
    }
}
