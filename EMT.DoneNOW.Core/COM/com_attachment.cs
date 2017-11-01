
﻿using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Runtime.Serialization;

namespace EMT.DoneNOW.Core
{
    [Table("com_attachment")]
    [Serializable]
    [DataContract]
    public partial class com_attachment : SoftDeleteCore
    {

        [Key]
        [DataMember]
        public Int64 id { get; set; }
        [DataMember]
        public Int64 oid { get; set; }
        [DataMember]
        public Int64? account_id { get; set; }
        [DataMember]
        public Int64 object_id { get; set; }
        [DataMember]
        public Int32 object_type_id { get; set; }
        [DataMember]
        public String uncpath { get; set; }
        [DataMember]
        public String urlpath { get; set; }
        [DataMember]
        public String href { get; set; }
        [DataMember]
        public String filename { get; set; }
        [DataMember]
        public Int32? sizeinbyte { get; set; }
        [DataMember]
        public String title { get; set; }
        [DataMember]
        public Int32 type_id { get; set; }
        [DataMember]
        public Int32? publish_status_id { get; set; }
        [DataMember]
        public String content_type { get; set; }
        [DataMember]
        public Int64? parent_id { get; set; }
        [DataMember]
        public Int32? publish_type_id { get; set; }


    }


}

