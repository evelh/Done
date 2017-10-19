using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DTO;

namespace EMT.DoneNOW.DAL
{
    public class sys_notify_tmpl_dal : BaseDAL<sys_notify_tmpl>
    {

        public List<DictionaryEntryDto> GetDictionary()
        {
            string where = $"SELECT * FROM sys_notify_tmpl WHERE delete_time = 0 ";
            List<sys_notify_tmpl> all = FindListBySql(where);
            List<DictionaryEntryDto> list = new List<DictionaryEntryDto>();
            if (all == null)
                return list;
            foreach (var entry in all)
            {
                //if (entry.is_default == 1)
                //    list.Add(new DictionaryEntryDto(entry.id.ToString(), entry.name, 1));
                //else
                list.Add(new DictionaryEntryDto(entry.id.ToString(), entry.name));
            }

            return list;
        }

        /// <summary>
        /// 根据不同的适用事件，选择不同的通知模板
        /// </summary>
        public List<sys_notify_tmpl> GetTempByEvent(DicEnum.NOTIFY_EVENT event_id)
        {
            return FindListBySql<sys_notify_tmpl>($"SELECT * from sys_notify_tmpl where id in ( SELECT notify_tmpl_id from sys_notify_tmpl_event where event_id = {(int)event_id})");
        }
        
    }
}
