using EMT.DoneNOW.DTO;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EMT.DoneNOW.BLL;

namespace EMT.DoneNOW.Web.ServiceDesk
{
    public partial class AddRepository : BasePage
    {
        protected List<KnowledgeCateDto> cateList;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (cateList == null)
                {
                    cateList = new List<KnowledgeCateDto>();
                }

                cateList.Clear();
                var list = new KnowledgeBLL().GetKnowledgeCateList();


                foreach (var item in list)
                {
                    AddNodes(item,item.leaval);
                }
                
            }
        }
        protected  void AddNodes(KnowledgeCateDto node,int leaval)
        {
            node.leaval = leaval;
            cateList.Add(node);

            foreach(var item in node.nodes)
            {
                AddNodes(item, item.leaval++);
            }
        }

        
    }
}