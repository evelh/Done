using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using EMT.DoneNOW.Core;
namespace EMT.DoneNOW.DAL
{
    public class sdk_kb_article_dal : BaseDAL<sdk_kb_article>
    {
        /// <summary>
        /// 根据知识库类别获取相应知识库
        /// </summary>=
        public List<sdk_kb_article> GetArtByCate(long cateId)
        {
            return FindListBySql<sdk_kb_article>($"SELECT * from sdk_kb_article where delete_time =0 and kb_category_id = {cateId}");
        }
    }

}