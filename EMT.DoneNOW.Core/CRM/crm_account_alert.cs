using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
namespace EMT.DoneNOW.Core
{
    [Table("crm_account_alert")]
    [Serializable]
    public partial class crm_account_alert
    {

        [Key]
        [Column("id")]
        public Int64 id { get; set; }
        [Column("create_time")]
        public Int64? create_time { get; set; }
        [Column("create_by_id")]
        public Int64? create_by_id { get; set; }
        [Column("update_time")]
        public Int64? update_time { get; set; }
        [Column("update_by_id")]
        public Int64? update_by_id { get; set; }
        [Column("delete_time")]
        public Int64? delete_time { get; set; }
        [Column("delete_by_id")]
        public Int64? delete_by_id { get; set; }
        [Column("alert_text")]
        public String alert_text { get; set; }
        [Column("alert_type_id")]
        public String alert_type_id { get; set; }
        [Column("account_id")]
        public Int64? account_id { get; set; }


    }
}
