using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Runtime.Serialization;

namespace EMT.DoneNOW.Core
{
    [Table("v_pending_all")]
    [Serializable]
    [DataContract]
    public partial class v_pending_all
    {

        [DataMember]
        public Int64 id { get; set; }
        [DataMember]
        public Int64? account_id { get; set; }
        [DataMember]
        public Int64? contract_id { get; set; }
        [DataMember]
        public Int64? project_id { get; set; }
        [DataMember]
        public Int64? task_id { get; set; }
        [DataMember]
        public String item_date { get; set; }
        [DataMember]
        public Decimal? original_dollars { get; set; }
        [DataMember]
        public Decimal? dollars { get; set; }
        [DataMember]
        public Decimal? cost { get; set; }
        [DataMember]
        public Decimal? quantity { get; set; }
        [DataMember]
        public Decimal? unit_price { get; set; }
        [DataMember]
        public Decimal? unit_cost { get; set; }
        [DataMember]
        public Int64? cost_code_id { get; set; }
        [DataMember]
        public String purchase_order_no { get; set; }
        [DataMember]
        public Int64 item_type_id { get; set; }
        [DataMember]
        public Int64 item_sub_type_id { get; set; }
        [DataMember]
        public String item_name { get; set; }
        [DataMember]
        public String item_desc { get; set; }
        [DataMember]
        public Int64? service_id { get; set; }
        [DataMember]
        public Int64? service_bundle_id { get; set; }
        [DataMember]
        public Int64? role_id { get; set; }
        [DataMember]
        public Int64? resource_id { get; set; }
        [DataMember]
        public Decimal? hours_worked { get; set; }
        [DataMember]
        public Int64 is_billable { get; set; }
        [DataMember]
        public Int32? procurement_status_id { get; set; }
        [DataMember]
        public Int64 show_on_invoice { get; set; }
        [DataMember]
        public String invoice_internal_description { get; set; }


    }
}