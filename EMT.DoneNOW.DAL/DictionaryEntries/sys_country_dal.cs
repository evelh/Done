using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DTO;

namespace EMT.DoneNOW.DAL
{
    public class sys_country_dal : BaseDAL<sys_country>
    {
        public List<DictionaryEntryDto> GetDictionary()
        {
            var all = this.FindAll();
            List<DictionaryEntryDto> list = new List<DictionaryEntryDto>();
            foreach (var entry in all)
            {
                if (entry.is_default)
                    list.Add(new DictionaryEntryDto(entry.country_name_display, entry.country_name_display, 1));
                else
                    list.Add(new DictionaryEntryDto(entry.country_name_display, entry.country_name_display));
            }

            return list;
        }
    }
}
