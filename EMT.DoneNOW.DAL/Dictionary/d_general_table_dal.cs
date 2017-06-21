using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using EMT.DoneNOW.Core;
namespace EMT.DoneNOW.DAL
{
    public class d_general_table_dal : BaseDAL<d_general_table>
    {
        public d_general_table GetGeneralTableByRemark(string remark)
        {
            return FindSignleBySql<d_general_table>($"SELECT * FROM d_general_table WHERE remark='{remark}'");
        }
    }
}
