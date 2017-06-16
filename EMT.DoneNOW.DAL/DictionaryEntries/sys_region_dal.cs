using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DTO;

namespace EMT.DoneNOW.DAL
{
    public class sys_region_dal : BaseDAL<sys_region>
    {
        public List<DictionaryEntryDto> GetDictionary()
        {
            var all = this.FindAll();
            List<DictionaryEntryDto> list = new List<DictionaryEntryDto>();
            foreach (var entry in all)
            {
                list.Add(new DictionaryEntryDto(entry.name, entry.name));
            }

            return list;
        }
    }
}
