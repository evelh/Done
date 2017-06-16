using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
namespace EMT.DoneNOW.Core
{
    [Table("sys_territory")]
    [Serializable]
    public partial class sys_territory
    {

        [Key]
        [Column("id")]
        public Int32 id { get; set; }
        [Column("region_object_id")]
        public Int32? region_object_id { get; set; }
        [Column("name")]
        public String name { get; set; }
        [Column("description")]
        public String description { get; set; }
        [Column("territory_type")]
        public Int32 territory_type { get; set; }
        [Column("status")]
        public Int32 status { get; set; }
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
