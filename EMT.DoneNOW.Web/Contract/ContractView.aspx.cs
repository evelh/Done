using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DTO;
using EMT.DoneNOW.BLL;
using EMT.DoneNOW.DAL;

namespace EMT.DoneNOW.Web.Contract
{
    public partial class ContractView : System.Web.UI.Page
    {
        protected ctt_contract contract = null;
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                var contract_id = Request.QueryString["id"];
                contract = new ctt_contract_dal().FindNoDeleteById(long.Parse(contract_id));
                var type = Request.QueryString["type"];
                switch (type)
                {
                    case "cost":
                        viewContractIframe.Src = "../Common/SearchBodyFrame.aspx?cat=" + (int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.CONTRACT_INTERNAL_COST + "&type=" + (int)EMT.DoneNOW.DTO.QueryType.InternalCost + "&id=" + contract.id;
                        break;
                    case "item":
                        viewContractIframe.Src = "../Common/SearchBodyFrame.aspx?cat=" + (int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.RELATION_CONFIGITEM + "&type=" + (int)EMT.DoneNOW.DTO.QueryType.Relation_ConfigItem + "&id=" + contract_id;
                        second.Src = "../Common/SearchBodyFrame.aspx?cat=" + (int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.NORELATION_CONFIGITEM + "&type=" + (int)EMT.DoneNOW.DTO.QueryType.Norelation_ConfigItem + "&id=" + contract.account_id+"&contract_id="+contract.id;
                        break;
                    default:
                        break;
                }
            }
            catch (Exception)
            {

                Response.End();
            }

        }
    }
}