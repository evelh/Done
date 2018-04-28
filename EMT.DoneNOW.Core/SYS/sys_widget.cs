using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Runtime.Serialization;

namespace EMT.DoneNOW.Core
{
    [Table("sys_widget")]
    [Serializable]
    [DataContract]
    public partial class sys_widget : SoftDeleteCore
    {

        [Key]
        [DataMember]
        public Int64 id { get; set; }
        [DataMember]
        public Int64 oid { get; set; }
        [DataMember]
        public Int64? dashboard_id { get; set; }
        [DataMember]
        public Int32 entity_id { get; set; }
        [DataMember]
        public Int32 type_id { get; set; }
        [DataMember]
        public String name { get; set; }
        [DataMember]
        public String description { get; set; }
        [DataMember]
        public SByte width { get; set; }
        [DataMember]
        public String filter_json { get; set; }
        [DataMember]
        public Int32? visual_type_id { get; set; }
        [DataMember]
        public Int32? color_scheme_id { get; set; }
        [DataMember]
        public Int64? report_on_id { get; set; }
        [DataMember]
        public Int32? aggregation_type_id { get; set; }
        [DataMember]
        public Int64? report_on_id2 { get; set; }
        [DataMember]
        public Int32? aggregation_type_id2 { get; set; }
        [DataMember]
        public SByte? show2axis { get; set; }
        [DataMember]
        public Int64? groupby_id { get; set; }
        [DataMember]
        public Int64? groupby_id2 { get; set; }
        [DataMember]
        public SByte? include_none { get; set; }
        [DataMember]
        public Int32? display_type_id { get; set; }
        [DataMember]
        public Int32? orderby_id { get; set; }
        [DataMember]
        public SByte? display_other { get; set; }
        [DataMember]
        public SByte? show_axis_label { get; set; }
        [DataMember]
        public SByte? show_trendline { get; set; }
        [DataMember]
        public SByte? show_legend { get; set; }
        [DataMember]
        public SByte? show_total { get; set; }
        [DataMember]
        public String primary_column_ids { get; set; }
        [DataMember]
        public String other_column_ids { get; set; }
        [DataMember]
        public Int64? orderby_grid_id { get; set; }
        [DataMember]
        public Int64? emphasis_column_id { get; set; }
        [DataMember]
        public SByte? show_action_column { get; set; }
        [DataMember]
        public SByte? show_column_header { get; set; }
        [DataMember]
        public String html { get; set; }


    }
}
