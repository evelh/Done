using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DTO;

namespace EMT.DoneNOW.DAL
{
    public class d_account_classification_dal : BaseDAL<d_account_classification>
    {
        public List<DictionaryEntryDto> GetDictionary()
        {
            var all = FindAll().OrderBy(_=>_.id);
            List<DictionaryEntryDto> list = new List<DictionaryEntryDto>();
            foreach (var entry in all)
            {
                if (entry.delete_time != 0)
                    continue;
                list.Add(new DictionaryEntryDto(entry.id.ToString(), entry.name));
            }

            return list;
        }

    }
}
