using EMT.DoneNOW.Core;
using EMT.DoneNOW.DAL;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EMT.DoneNOW.BLL
{
    /// <summary>
    /// 配置项类型
    /// </summary>
   public class ConfigTypeBLL
    {
        private readonly d_general_dal _dal = new d_general_dal();//字典项对象
        private readonly sys_udf_group_field_dal udf_group_dal = new sys_udf_group_field_dal();//用户自定义字段组
        private readonly sys_udf_field_dal udf_dal = new sys_udf_field_dal();//用户自定义字段
        /// <summary>
        /// 获取所有的用户自定义项
        /// </summary>
        /// <returns></returns>
        public List<sys_udf_field> GetAlludf() {
            return udf_dal.FindListBySql<sys_udf_field>($"select * from sys_udf_field where delete_time=0 order by sort_order,col_name");
        }
        /// <summary>
        /// 通过字段组id获取所有关联字段
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public List<sys_udf_group_field> GetUdfGroup(long id) {
            return udf_group_dal.FindListBySql<sys_udf_group_field>($"select * from sys_udf_group_field where group_id={id} and delete_time=0");
        }
    }
}
