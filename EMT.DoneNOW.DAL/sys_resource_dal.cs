using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DTO;

namespace EMT.DoneNOW.DAL
{
    public class sys_resource_dal : BaseDAL<sys_resource>
    {
        public List<DictionaryEntryDto> GetDictionary(bool isOnlyActive=false)
        {
            var all = this.FindAll().OrderBy(_ => _.id).ToList();
            if (isOnlyActive)
            {
                all = all.Where(_ => _.is_active == 1).ToList();
            }
            List<DictionaryEntryDto> list = new List<DictionaryEntryDto>();
            foreach (var entry in all)
            {
                //if (entry.is_default == 1)
                //    list.Add(new DictionaryEntryDto(entry.country_name_display, entry.country_name_display, 1));
                //else
                if (entry.delete_time != 0)
                {
                    continue;
                }
                list.Add(new DictionaryEntryDto(entry.id.ToString(), entry.name));
            }

            return list;
        }
        /// <summary>
        /// 获取到所有的员工
        /// </summary>
        /// <returns></returns>
        public List<sys_resource> GetSourceList()
        {
            return FindListBySql<sys_resource>("select * from sys_resource where is_active = 1 and delete_time = 0");
        }
    }
}
