using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DTO;

namespace EMT.DoneNOW.DAL
{
    public class d_district_dal : BaseDAL<d_district>
    {
        public List<DictionaryEntryDto> GetDictionary()
        {
            var all = this.FindAll().OrderBy(_ => _.id); ;
            List<DictionaryEntryDto> list = new List<DictionaryEntryDto>();
            foreach (var entry in all)
            {
                
                    list.Add(new DictionaryEntryDto(entry.id.ToString(), entry.name));
            }

            return list;
        }
    }
}
