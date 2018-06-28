using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EMT.DoneNOW.DTO
{
    /// <summary>
    /// 知识库目录
    /// </summary>
    public class KnowledgeCateDto
    {
        public long id;             // id
        public string name;         // 目录名称
        public int articleCnt;      // 文章个数
        public long? parent_id;      // 父目录id
        public int leaval;           // 层级标识

        public List<KnowledgeCateDto> nodes = new List<KnowledgeCateDto>(); // 子目录
    }
    /// <summary>
    /// 产品类别
    /// </summary>
    public class ProductCateDto
    {
        public long id;
        public string name;         // 名称
        public int productCnt;      // 文章个数
        public List<ProductCateDto> nodes = new List<ProductCateDto>(); // 子类别
    }

}
