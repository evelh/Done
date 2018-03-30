using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EMT.DoneNOW.BLL;
using System.Text;

namespace EMT.DoneNOW.Web.ServiceDesk
{
    public partial class MyQueueList : BasePage
    {
        protected Dictionary<string, string> dic = null;
        protected DAL.sys_department_dal sdDal = new DAL.sys_department_dal();
        protected void Page_Load(object sender, EventArgs e)
        {
            
            dic = new TicketBLL().GetTicketTypeCount(LoginUserId);
            var depDic = dic.Where(_ => _.Key.Contains("dep_")).ToDictionary(_ => _.Key, _ => _.Value);
            StringBuilder depStr = new StringBuilder();
            foreach (var dep in depDic)
            {
                var thisDepArr = dep.Key.Split('_');
                if (thisDepArr.Length < 2)
                    continue;
                var thisDep = sdDal.FindNoDeleteById(long.Parse(thisDepArr[1]));
                if (thisDep == null)
                    continue;
                depStr.Append($"<li class='MenuLink' onclick='SearchTicket(\"{dep.Key}\")'><a>{thisDep.name} {dep.Value}</a></li>");
            }
            liAllTicket.Text = depStr.ToString();

            var noResDic = dic.Where(_ => _.Key.Contains("noRes_")).ToDictionary(_ => _.Key, _ => _.Value);
            StringBuilder noResStr = new StringBuilder();
            foreach (var noRes in noResDic)
            {
                var thisNoResArr = noRes.Key.Split('_');
                if (thisNoResArr.Length < 2)
                    continue;
                var thisDep = sdDal.FindNoDeleteById(long.Parse(thisNoResArr[1]));
                if (thisDep == null)
                    continue;
                noResStr.Append($"<li class='MenuLink' onclick='SearchTicket(\"{noRes.Key}\")'><a>{thisDep.name} {noRes.Value}</a></li>");
            }
            liNoResTicket.Text = noResStr.ToString();
        }
        
    }
}