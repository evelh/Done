using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EMT.DoneNOW.BLL;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DTO;

namespace EMT.DoneNOW.Web.Activity
{
    public partial class AddAttachment : BasePage
    {
        protected List<DictionaryEntryDto> attTypeList = null;    // 附件类型
        protected void Page_Load(object sender, EventArgs e)
        {
            attTypeList = new GeneralBLL().GetDicValues(GeneralTableEnum.ATTACHMENT_TYPE);
        }
    }
}