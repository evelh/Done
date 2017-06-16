using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
namespace EMT.DoneNOW.Core
{
    [Table("sys_account_classification")]
    [Serializable]
    public partial class sys_account_classification
    {

        [Key]
        [Column("id")]
        public Int32 id { get; set; }
        [Column("name")]
        public String name { get; set; }
        [Column("description")]
        public String description { get; set; }
        [Column("sort_order")]
        public Int32? sort_order { get; set; }
        [Column("status")]
        public SByte? status { get; set; }
        [Column("icon_path")]
        public String icon_path { get; set; }
        [Column("font_style")]
        public String font_style { get; set; }
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
