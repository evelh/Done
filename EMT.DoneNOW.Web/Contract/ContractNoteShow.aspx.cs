using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DAL;
using EMT.DoneNOW.DTO;

namespace EMT.DoneNOW.Web.Contract
{
    public partial class ContractNoteShow : BasePage
    {
        protected ctt_contract thisContract = null;
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                var thisId = Request.QueryString["contract_id"];
                if (!string.IsNullOrEmpty(thisId))
                {
                    thisContract = new ctt_contract_dal().FindNoDeleteById(long.Parse(thisId));
                }
                if (thisContract != null)
                {
                    ShowNoteList.Src = "../Common/SearchBodyFrame.aspx?cat=" + (int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.PROJECT_NOTE + "&type=" + (int)EMT.DoneNOW.DTO.QueryType.PROJECT_NOTE + "&con1054=" + thisContract.id ;
                }
            }
            catch (Exception)
            {
                Response.End();
            }
        }
    }
}