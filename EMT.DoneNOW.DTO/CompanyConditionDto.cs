using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EMT.DoneNOW.DTO
{
    public class CompanyConditionDto
    {
        public string company_name;
        public int? company_type;
        public long? account_manager;
        public int? territory_name;
        public string phone;
        public int? classification;
        public string region_name;
        public string country;
        public string last_activity_date_min;
        public string last_activity_date_max;
        public int? market_segment;
        // TODO: Total Opportunity Amount
        public string city;
        public int? competitor;
        public int? status;
        public int? state;
        public string stock_symbol;
        public string stock_market;
        public string sic_code;
        public string post_code;
        // TODO: Company Survey Rating
        public string asset_value;
    }
}
