using EMT.DoneNOW.Core;
using EMT.DoneNOW.DAL;
using EMT.DoneNOW.DTO;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using static EMT.DoneNOW.DTO.DicEnum;

namespace EMT.DoneNOW.Web
{
    public partial class ContractMilestoneDetail :BasePage
    {
        private int id;
        protected ctt_contract_milestone ccm = new ctt_contract_milestone();
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!int.TryParse(Request.QueryString["id"], out id))
            {
               Response.Write("<script>alert('异常！');window.close();self.opener.location.reload();</script>");
            }
            ccm=new ctt_contract_milestone_dal().FindSignleBySql<ctt_contract_milestone>($"select * from ctt_contract_milestone where id={id} and delete_time=0");//里程碑
        }
    }
}