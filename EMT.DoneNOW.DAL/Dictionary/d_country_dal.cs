using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DTO;

namespace EMT.DoneNOW.DAL
{
    public class d_country_dal : BaseDAL<d_country>
    {
        public List<DictionaryEntryDto> GetDictionary()
        {
            var all = this.FindAll().OrderBy(_ => _.id); ;
            List<DictionaryEntryDto> list = new List<DictionaryEntryDto>();
            foreach (var entry in all)
            {
                if (entry.is_default == 1)
                    list.Add(new DictionaryEntryDto(entry.country_name_display, entry.country_name_display, 1));
                else
                    list.Add(new DictionaryEntryDto(entry.country_name_display, entry.country_name_display));
            }

            return list;
        }
    }
}
