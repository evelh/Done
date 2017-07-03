using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Runtime.Serialization;

namespace EMT.DoneNOW.Core
{
    [Table("sys_udf_field")]
    [Serializable]
    [DataContract]
    public partial class sys_udf_field : SoftDeleteCore
    {

        [Key]
        [DataMember]
        public Int64 id { get; set; }
        [DataMember]
        public String col_name { get; set; }
        [DataMember]
        public String col_comment { get; set; }
        [DataMember]
        public String description { get; set; }
        [DataMember]
        public Int32 cate_id { get; set; }
        [DataMember]
        public Int32 data_type_id { get; set; }
        [DataMember]
        public String default_value { get; set; }
        [DataMember]
        public SByte? is_field_mapping { get; set; }
        [DataMember]
        public SByte is_protected { get; set; }
        [DataMember]
        public SByte is_required { get; set; }
        [DataMember]
        public SByte is_active { get; set; }
        [DataMember]
        public String merge_variable_name { get; set; }
        [DataMember]
        public Int32? crm_to_project_udf_id { get; set; }
        [DataMember]
        public Int32? display_format_id { get; set; }
        [DataMember]
        public String sort_order { get; set; }
        [DataMember]
        public Int32? decimal_length { get; set; }
        [DataMember]
        public SByte? is_visible_in_portal { get; set; }


    }
}
