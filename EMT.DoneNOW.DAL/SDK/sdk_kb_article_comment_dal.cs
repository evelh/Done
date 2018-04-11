using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using EMT.DoneNOW.Core;
namespace EMT.DoneNOW.DAL
{
    public class sdk_kb_article_comment_dal : BaseDAL<sdk_kb_article_comment>
    {
        // 
        public List<sdk_kb_article_comment> GetCommByArt(long artId)
        {
            return FindListBySql<sdk_kb_article_comment>($"SELECT * FROM sdk_kb_article_comment  where kb_article_id = {artId} and delete_time = 0");
        }
    }

}