using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EMT.DoneNOW.DTO
{
    public class DataPermissionDto
    {
        public class PermissionItem
        {
            /// <summary>
            /// 
            /// </summary>
            public string id { get; set; }
            /// <summary>
            /// 
            /// </summary>
            public string edit_protected_data { get; set; }
            /// <summary>
            /// 
            /// </summary>
            public string view_protected_data { get; set; }
            /// <summary>
            /// 
            /// </summary>
            public string edit_unprotected_data { get; set; }
            /// <summary>
            /// 
            /// </summary>
            public string view_unprotected_data { get; set; }
        }

        public class Resource_Permission
        {
            /// <summary>
            /// 
            /// </summary>
            public List<PermissionItem> permission { get; set; }
        }
    }
}
