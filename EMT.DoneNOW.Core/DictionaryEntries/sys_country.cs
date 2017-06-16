using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
namespace EMT.DoneNOW.Core
{
    // 国家表
    [Table("sys_country")]
    [Serializable]
    public partial class sys_country
    {

        [Key]
        [Column("id")]
        public Int32 id { get; set; }
        [Column("country_code")]
        public String country_code { get; set; }
        [Column("country_name_iso_standard")]
        public String country_name_iso_standard { get; set; }
        [Column("country_name_display")]
        public String country_name_display { get; set; }
        [Column("is_active")]
        public Boolean is_active { get; set; }
        [Column("is_default")]
        public Boolean is_default { get; set; }
        [Column("is_undefined_country")]
        public Boolean is_undefined_country { get; set; }
        [Column("address_format_id")]
        public Int32 address_format_id { get; set; }
        [Column("invoice_template_id")]
        public Int32? invoice_template_id { get; set; }


    }
}