using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using EMT.DoneNOW.DAL;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DTO;
using Newtonsoft.Json.Linq;
using static EMT.DoneNOW.DTO.DicEnum;
using System.Text.RegularExpressions;
using EMT.DoneNOW.BLL.CRM;

namespace EMT.DoneNOW.BLL
{
    public class QuoteBLL
    {
        private readonly crm_quote_dal _dal = new crm_quote_dal();



        public ERROR_CODE Insert()
        {







            return ERROR_CODE.SUCCESS;
        }
    }
}
