using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DTO;
using EMT.DoneNOW.BLL;

namespace EMT.DoneNOW.Web.Contract
{
    public partial class ContractAdd : BasePage
    {
        protected int contractType; // 合同类型
        protected string contractTypeName;  // 合同类型名称
        protected List<DictionaryEntryDto> contractCate;    // 合同种类
        protected List<DictionaryEntryDto> periodType;      // 计费周期类型
        protected List<DictionaryEntryDto> billPostType;    // 工时计费设置
        protected List<d_sla> slaList;      // SLA列表
        protected List<UserDefinedFieldDto> udfList;        // 自定义字段信息
        protected long contractId = 0;      // 新增成功的合同id
        private ContractBLL bll = new ContractBLL();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (IsPostBack)
            {
                ContractAddDto dto = new ContractAddDto();
                dto.contract = AssembleModel<ctt_contract>();

                contractId = bll.Insert(dto, GetLoginUserId());
                contractType = 9;
            }
            else
            {
                if (!int.TryParse(Request.QueryString["type"], out contractType))
                    contractType = 0;
            }
            var generalBll = new GeneralBLL();
            contractCate = generalBll.GetDicValues(GeneralTableEnum.CONTRACT_CATE);
            periodType = generalBll.GetDicValues(GeneralTableEnum.QUOTE_ITEM_PERIOD_TYPE);
            slaList = bll.GetSLAList();
            udfList = new UserDefinedFieldsBLL().GetUdf(DicEnum.UDF_CATE.CONTRACTS);
            billPostType = generalBll.GetDicValues(GeneralTableEnum.BILL_POST_TYPE);

            InitContract();
        }

        private void InitContract()
        {
            switch(contractType)
            {
                case 1199:
                    contractTypeName = "(定期服务合同)";
                    break;
                case 1200:
                    contractTypeName = "(工时及物料合同)";
                    break;
                case 1201:
                    contractTypeName = "(固定价格合同)";
                    break;
                case 1202:
                    contractTypeName = "(预付时间合同)";
                    break;
                case 1203:
                    contractTypeName = "(预付费合同)";
                    break;
                case 1204:
                    contractTypeName = "(事件合同)";
                    break;
                default:
                    contractTypeName = "";
                    break;
            }
        }
    }
}