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
        public List<DictionaryEntryDto> GetDictionary()
        {
            var all = this.FindAll().OrderBy(_ => _.id); 
            List<DictionaryEntryDto> list = new List<DictionaryEntryDto>();
            foreach (var entry in all)
            {
                //if (entry.is_default == 1)
                //    list.Add(new DictionaryEntryDto(entry.country_name_display, entry.country_name_display, 1));
                //else
                    list.Add(new DictionaryEntryDto(entry.id.ToString(), entry.name));
            }

            return list;
        }
    }
}
