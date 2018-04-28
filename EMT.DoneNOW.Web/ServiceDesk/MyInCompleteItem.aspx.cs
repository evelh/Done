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
    public partial class MyInCompleteItem :BasePage
    {
        protected List<com_activity> noComTodo;
        protected List<sdk_service_call> noComCall;
        protected CompanyBLL comBll = new CompanyBLL();
        protected void Page_Load(object sender, EventArgs e)
        {
            noComTodo = new com_activity_dal().GetNoCompleteTodo(LoginUserId);
            noComCall = new sdk_service_call_dal().GetNoComCall(LoginUserId);
        }
    }
}