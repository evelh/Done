
using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Runtime.Serialization;

namespace EMT.DoneNOW.Core
{
    [Table("sdk_kb_article")]
    [Serializable]
    [DataContract]
    public partial class sdk_kb_article : SoftDeleteCore
    {

        [Key]
        [DataMember]
        public Int64 id { get; set; }
        [DataMember]
        public Int64 oid { get; set; }
        [DataMember]
        public UInt64 is_active { get; set; }
        [DataMember]
        public Int32 kb_category_id { get; set; }
        [DataMember]
        public String title { get; set; }
        [DataMember]
        public String keywords { get; set; }
        [DataMember]
        public String error_code { get; set; }
        [DataMember]
        public String article_body { get; set; }
        [DataMember]
        public String article_body_no_markup { get; set; }
        [DataMember]
        public Int32 view_count { get; set; }
        [DataMember]
        public Int32? article_image_collection_tag { get; set; }
        [DataMember]
        public Int32 publish_to_type_id { get; set; }
        [DataMember]
        public Int64? account_id { get; set; }
        [DataMember]
        public Int32? classification_id { get; set; }
        [DataMember]
        public Int32? territory_id { get; set; }


    }
}