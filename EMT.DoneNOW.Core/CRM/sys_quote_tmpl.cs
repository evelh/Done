
using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Runtime.Serialization;

namespace EMT.DoneNOW.Core
{
    [Table("sys_quote_tmpl")]
    [Serializable]
    [DataContract]
    public partial class sys_quote_tmpl : SoftDeleteCore
    {

        [Key]
        [DataMember]
        public Int32 id { get; set; }
        [DataMember]
        public Int64 oid { get; set; }
        [DataMember]
        public String name { get; set; }
        [DataMember]
        public String description { get; set; }
        [DataMember]
        public SByte is_active { get; set; }
        [DataMember]
        public SByte is_default { get; set; }
        [DataMember]
        public SByte is_system { get; set; }
        [DataMember]
        public Int32 date_display_format_id { get; set; }
        [DataMember]
        public Int32 number_display_format_id { get; set; }
        [DataMember]
        public SByte show_each_tax_in_tax_period { get; set; }
        [DataMember]
        public SByte show_each_tax_in_tax_group { get; set; }
        [DataMember]
        public SByte show_tax_cate_superscript { get; set; }
        [DataMember]
        public SByte show_tax_cate { get; set; }
        [DataMember]
        public String tax_total_disp { get; set; }
        [DataMember]
        public Int32 paper_size_id { get; set; }
        [DataMember]
        public Int32 page_number_location_id { get; set; }
        [DataMember]
        public Int32 currency_positive_format_id { get; set; }
        [DataMember]
        public Int32 currency_negative_format_id { get; set; }
        [DataMember]
        public String page_header_html { get; set; }
        [DataMember]
        public String quote_header_html { get; set; }
        [DataMember]
        public String body_html { get; set; }
        [DataMember]
        public String page_footer_html { get; set; }
        [DataMember]
        public String quote_footer_html { get; set; }
        [DataMember]
        public String quote_footer_notes { get; set; }
        [DataMember]
        public Int32? body_group_by_id { get; set; }
        [DataMember]
        public Int32? body_order_by_id { get; set; }
        [DataMember]
        public Int32? body_itemize_id { get; set; }
        [DataMember]
        public SByte? is_custom { get; set; }
        [DataMember]
        public SByte? is_hidden { get; set; }
        [DataMember]
        public SByte? is_new { get; set; }
        [DataMember]
        public SByte? show_labels_when_grouped { get; set; }
        [DataMember]
        public Int32? time_display_format_id { get; set; }


    }
}
/*

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using EMT.DoneNOW.Core;
namespace EMT.DoneNOW.DAL
{
    public class sys_quote_tmpl_dal : BaseDAL<sys_quote_tmpl>
    {
    }

}

*/
