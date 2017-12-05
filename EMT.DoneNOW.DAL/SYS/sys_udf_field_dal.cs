using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using EMT.DoneNOW.Core;
namespace EMT.DoneNOW.DAL
{
    public class sys_udf_field_dal : BaseDAL<sys_udf_field>
    {
        public sys_udf_field GetInfoByCateAndName(int cate_id,string colName)
        {
            return FindSignleBySql<sys_udf_field>($"SELECT * from sys_udf_field where cate_id = {cate_id} and col_comment = '{colName}' and delete_time = 0");
        }
    }
}
