using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DAL;
using EMT.DoneNOW.DTO;

namespace EMT.DoneNOW.BLL
{
    /// <summary>
    /// 国家、省、市、区县地址处理
    /// </summary>
    public class DistrictBLL
    {
        d_district_dal dal = new d_district_dal();

        /// <summary>
        /// 获取国家列表
        /// </summary>
        /// <returns></returns>
        public List<DictionaryEntryDto> GetCountryList()
        {
            var list = new d_country_dal().GetCountryListActive();
            var result = new List<DictionaryEntryDto>();
            foreach (var c in list)
            {
                if (c.is_default == 1)
                    result.Add(new DictionaryEntryDto(c.id.ToString(), c.country_name_display, 1));
                else
                    result.Add(new DictionaryEntryDto(c.id.ToString(), c.country_name_display, 0));
            }

            return result;
        }

        /// <summary>
        /// 获取省列表
        /// </summary>
        /// <returns></returns>
        public List<DictionaryEntryDto> GetProvinceList()
        {
            var list = dal.GetDistrictByParent(1);
            var result = new List<DictionaryEntryDto>();
            foreach (var c in list)
            {
                result.Add(new DictionaryEntryDto(c.id.ToString(), c.name));
            }

            return result;
        }

        /// <summary>
        /// 根据父id获取可见的行政区列表
        /// </summary>
        /// <param name="parentId">父id</param>
        /// <returns></returns>
        public List<DictionaryEntryDto> GetDistrictList(int parentId)
        {
            var list = dal.GetDistrictByParent(parentId);
            var result = new List<DictionaryEntryDto>();
            foreach (var c in list)
            {
                result.Add(new DictionaryEntryDto(c.id.ToString(), c.name));
            }

            return result;
        }
    }
}
