using System;
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
            string where = $"SELECT * FROM d_general WHERE general_table_id='{tableInfo.id}' and delete_time = 0 order by id";
            List<d_general> all = FindListBySql(QueryStringDeleteFlag(where));
            List<DictionaryEntryDto> list = new List<DictionaryEntryDto>();
            if (all == null)
                return list;
            foreach (var entry in all)
            {
                if (entry.is_default == 1)
                    list.Add(new DictionaryEntryDto(entry.id.ToString(), entry.name, 1));
                else
                    list.Add(new DictionaryEntryDto(entry.id.ToString(), entry.name));
            }

            return list;
        }

        public List<DictionaryEntryDto> GetDictionaryByCode(d_general_table tableInfo)
        {
            string where = $"SELECT * FROM d_general WHERE general_table_id='{tableInfo.id}' and delete_time = 0";
            List<d_general> all = FindListBySql(QueryStringDeleteFlag(where));
            List<DictionaryEntryDto> list = new List<DictionaryEntryDto>();
            if (all == null)
                return list;
            foreach (var entry in all)
            {
                //if (entry.is_default == 1)
                //    list.Add(new DictionaryEntryDto(entry.code.ToString(), entry.name, 1));
                //else  
                    list.Add(new DictionaryEntryDto(entry.code, entry.name));
            }

            return list;
        }
        public d_general GetGeneralById(long id)
        {
            return FindSignleBySql<d_general>($"select * from d_general where id = {id} and delete_time = 0");
        }
        /// <summary>
        /// 根据字典表ID 获取相应字典项
        /// </summary>
        public List<d_general> GetGeneralByTableId(long table_id)
        {
            return FindListBySql<d_general>($"select * from d_general where general_table_id = {table_id} and delete_time = 0");
        }

        /// <summary>
        /// 根据父ID 获取相应字典项
        /// </summary>
        public List<d_general> GetGeneralByParentId(long parent_id)
        {
            return FindListBySql<d_general>($"select * from d_general where  parent_id = {parent_id} and delete_time = 0");
        }




    }
}
