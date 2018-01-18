using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EMT.DoneNOW.DTO;
using EMT.DoneNOW.DAL;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.BLL;

namespace EMT.DoneNOW.Web.ServiceDesk
{
    public partial class TicketManage : BasePage
    {
        protected sdk_task thisTicket = null;   // 当前工单
        protected bool isAdd = true;            // 新增还是编辑
        protected void Page_Load(object sender, EventArgs e)
        {

        }
    }
}