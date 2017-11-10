using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Runtime.Serialization;

namespace EMT.DoneNOW.Core
{
    [Table("v_activity_sales_order")]
    [Serializable]
    [DataContract]
    public partial class v_activity_sales_order : v_activity
    {
        
        [DataMember]
        public Int64? sales_order_id { get; set; }


    }
}
