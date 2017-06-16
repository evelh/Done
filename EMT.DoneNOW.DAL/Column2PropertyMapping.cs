using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Dapper;
using EMT.DoneNOW.Core;
using System.ComponentModel.DataAnnotations.Schema;
using EMT.Tools;

namespace EMT.DoneNOW.DAL
{
    public static class Column2PropertyMapping
    {
        static Column2PropertyMapping()
        {
            var assCore = typeof(EMT.DoneNOW.Core.crm_account).Assembly.GetExportedTypes();
            foreach (var t1 in assCore)
            {
                if (t1.IsClass && t1.GetCustomAttributes(typeof(TableAttribute), false).Count() > 0)
                {
                    var map1 = new CustomPropertyTypeMap(t1,
                        (type, columnName) => type.GetProperties().FirstOrDefault(prop => Utils.GetColumnAttributeName(prop) == columnName));
                    SqlMapper.SetTypeMap(t1, map1);
                }
            }
        }

        public static void Init()
        {

        }
    }
}
