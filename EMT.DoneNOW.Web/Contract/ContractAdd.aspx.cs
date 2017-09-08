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

                if (udfList != null && udfList.Count > 0)                      // 首先判断是否有自定义信息
                {
                    var list = new List<UserDefinedFieldValue>();
                    foreach (var udf in udfList)                            // 循环添加
                    {
                        var new_udf = new UserDefinedFieldValue()
                        {
                            id = udf.id,
                            value = Request.Form[udf.id.ToString()] == "" ? null : Request.Form[udf.id.ToString()],
                        };
                        list.Add(new_udf);

                    }
                    dto.udf = list;
                }

                contractId = bll.Insert(dto, GetLoginUserId());
                contractType = 9;
            }
            else
            {
                if (!int.TryParse(Request.QueryString["type"], out contractType))
                    contractType = 0;
            }
            
            Dictionary<string, object> dics = bll.GetField();
            contractCate = dics["cate"] as List<DictionaryEntryDto>;
            periodType = dics["periodType"] as List<DictionaryEntryDto>;
            billPostType = dics["billPostType"] as List<DictionaryEntryDto>;
            slaList = bll.GetSLAList();
            udfList = new UserDefinedFieldsBLL().GetUdf(DicEnum.UDF_CATE.CONTRACTS);

            contractTypeName = bll.GetContractTypeName(contractType);
        }
    }
}