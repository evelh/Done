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

        public List<sys_resource> GetListByIds(string ids)
        {
            return FindListBySql<sys_resource>($"select * from sys_resource where is_active = 1 and delete_time = 0 and id in ({ids})");
        }

        /// 根据关系表ID 获取员工相关信息 
        public List<sys_resource> GetListByDepIds(string ids)
        {
            return FindListBySql<sys_resource>($"SELECT * from sys_resource where id in ( SELECT resource_id from sys_resource_department where id in ({ids})) and delete_time = 0 ");
        }
        /// <summary>
        /// 根据部门获取相应的员工ID
        /// </summary>
        public List<sys_resource> GetListByDepId(string ids)
        {
            return FindListBySql<sys_resource>($"SELECT * from sys_resource where id in ( SELECT resource_id from sys_resource_department where department_id in ({ids}) and delete_time = 0)");
        }
        /// <summary>
        /// 根据项目Id 获取团队中的成员信息
        /// </summary>
        public List<sys_resource> GetResByProTeam(long project_id)
        {
            return FindListBySql<sys_resource>($"SELECT sr.* from pro_project_team ppt  INNER JOIN pro_project pp on ppt.project_id = pp.id inner JOIN sys_resource sr on ppt.resource_id = sr.id where pp.id = 5102 and ppt.delete_time = 0 and pp.delete_time = 0 and sr.delete_time = 0");
        }

    }
}
