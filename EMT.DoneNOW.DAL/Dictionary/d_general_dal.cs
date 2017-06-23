﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DTO;
namespace EMT.DoneNOW.DAL
{
    public class d_general_dal : BaseDAL<d_general>
    {
        public List<DictionaryEntryDto> GetDictionary(d_general_table tableInfo)
        {
            string where = $"SELECT * FROM d_general WHERE general_table_id='{tableInfo.id}'";
            List<d_general> all = FindListBySql(QueryStringDeleteFlag(where));
            List<DictionaryEntryDto> list = new List<DictionaryEntryDto>();
            foreach (var entry in all)
            {
                if (entry.is_default == 1)
                    list.Add(new DictionaryEntryDto(entry.id.ToString(), entry.name, 1));
                else
                    list.Add(new DictionaryEntryDto(entry.id.ToString(), entry.name));
            }

            return list;
        }
    }
}