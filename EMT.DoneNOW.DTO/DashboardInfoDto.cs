using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EMT.DoneNOW.DTO
{
    public class DashboardInfoDto
    {
        public long id;
        public string name;
        public int theme_id;
        public int widget_auto_place;
        public long? filter_id;
        public long? filter_default_value;
        public string filter_default_value_show;
        public int? limit_type_id;
        public string limit_value;
        public string limit_value_show;
    }
}
