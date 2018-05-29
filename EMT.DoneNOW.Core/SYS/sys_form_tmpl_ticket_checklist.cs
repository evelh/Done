
using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Runtime.Serialization;

namespace EMT.DoneNOW.Core
{
    [Table("sys_form_tmpl_ticket_checklist")]
    [Serializable]
    [DataContract]
    public partial class sys_form_tmpl_ticket_checklist : SoftDeleteCore
    {

        [Key]
        [DataMember]
        public Int64 id { get; set; }
        [DataMember]
        public Int64 form_tmpl_ticket_id { get; set; }
        [DataMember]
        public String item_name { get; set; }
        [DataMember]
        public SByte? is_competed { get; set; }
        [DataMember]
        public SByte? is_important { get; set; }
        [DataMember]
        public Int64? kb_article_id { get; set; }
        [DataMember]
        public Decimal? sort_order { get; set; }


    }
}