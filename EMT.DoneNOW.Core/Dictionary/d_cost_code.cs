
using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Runtime.Serialization;

namespace EMT.DoneNOW.Core
{
    [Table("d_cost_code")]
    [Serializable]
    [DataContract]
    public partial class d_cost_code : SoftDeleteCore
    {

        [Key]
        [DataMember]
        public Int64 id { get; set; }
        [DataMember]
        public String name { get; set; }
        [DataMember]
        public String description { get; set; }
        [DataMember]
        public Int32 cate_id { get; set; }
        [DataMember]
        public SByte is_active { get; set; }
        [DataMember]
        public String external_id { get; set; }
        [DataMember]
        public Int32? general_ledger_id { get; set; }
        [DataMember]
        public Int64? department_id { get; set; }
        [DataMember]
        public Int32? show_on_invoice { get; set; }
        [DataMember]
        public Int32? creditobjectid { get; set; }
        [DataMember]
        public Int32? categoryobjectid { get; set; }
        [DataMember]
        public String number { get; set; }
        [DataMember]
        public Int32? type { get; set; }
        [DataMember]
        public Decimal? rate { get; set; }
        [DataMember]
        public Decimal? charge { get; set; }
        [DataMember]
        public Decimal? unit_cost { get; set; }
        [DataMember]
        public Decimal? unit_price { get; set; }
        [DataMember]
        public Int16? timeoff { get; set; }
        [DataMember]
        public Int32? allocationcodetype { get; set; }
        [DataMember]
        public SByte? is_quick_cost { get; set; }
        [DataMember]
        public SByte? adp_exclude_from_regular_hours { get; set; }
        [DataMember]
        public String adp_other_hours_code { get; set; }
        [DataMember]
        public String quickbooks_internal_item_id { get; set; }
        [DataMember]
        public Decimal? rate_adjustment { get; set; }
        [DataMember]
        public Decimal? rate_multiplier { get; set; }
        [DataMember]
        public Decimal? custom_rate { get; set; }
        [DataMember]
        public Decimal? flat_rate { get; set; }
        [DataMember]
        public Decimal? min_hours { get; set; }
        [DataMember]
        public Decimal? max_hours { get; set; }
        [DataMember]
        public SByte? adp_is_unpaid { get; set; }
        [DataMember]
        public SByte? adp_contractor_hours_excluded_from_export { get; set; }
        [DataMember]
        public SByte? adp_hourly_hours_excluded_from_export { get; set; }
        [DataMember]
        public SByte? adp_salary_hours_excluded_from_export { get; set; }
        [DataMember]
        public SByte? adp_salary_non_exempt_hours_excluded_from_export { get; set; }
        [DataMember]
        public Int32? tax_category_id { get; set; }
        [DataMember]
        public Decimal? mileage_reimbursement_rate { get; set; }
        [DataMember]
        public Int32? expense_type_id { get; set; }
        [DataMember]
        public Int32? billing_method_id { get; set; }
        [DataMember]
        public SByte excluded_new_contract { get; set; }
        


    }
}