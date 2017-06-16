using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
namespace EMT.DoneNOW.Core
{
    [Table("sys_region")]
    [Serializable]
    public partial class sys_region
    {

        [Key]
        [Column("id")]
        public Int32 id { get; set; }
        [Column("name")]
        public String name { get; set; }
        [Column("description")]
        public String description { get; set; }
        [Column("date_stamp")]
        public DateTime date_stamp { get; set; }
        [Column("create_time")]
        public Int64? create_time { get; set; }
        [Column("update_time")]
        public Int64? update_time { get; set; }
        [Column("delete_time")]
        public Int64? delete_time { get; set; }
        [Column("create_by_id")]
        public Int64? create_by_id { get; set; }
        [Column("update_by_id")]
        public Int64? update_by_id { get; set; }
        [Column("delete_by_id")]
        public Int64? delete_by_id { get; set; }


    }
}