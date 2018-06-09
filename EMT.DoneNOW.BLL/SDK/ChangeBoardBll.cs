using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using EMT.DoneNOW.DAL;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DTO;

namespace EMT.DoneNOW.BLL
{
    public class ChangeBoardBll
    {
        private d_change_board_dal _dal = new d_change_board_dal();

        /// <summary>
        /// 新增变更委员会
        /// </summary>
        public bool AddBoard(d_change_board board,string resIds,long userId)
        {
            if (!CheckBoardName(board.name))
                return false;
            board.id = _dal.GetNextIdCom();
            board.create_time = board.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            board.create_user_id = board.update_user_id = userId;
            _dal.Insert(board);
            OperLogBLL.OperLogAdd<d_change_board>(board, board.id,userId,DicEnum.OPER_LOG_OBJ_CATE.CHANGE_BOARD, "");
            BoardResourceManage(board.id,resIds,userId);
            return true;
        }
        /// <summary>
        /// 编辑变更委员会
        /// </summary>
        public bool EditBoard(d_change_board board, string resIds, long userId)
        {
            d_change_board oldBoard = GetBoard(board.id);
            if (oldBoard == null)
                return false;
            if (!CheckBoardName(board.name, board.id))
                return false;
            board.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            board.update_user_id = userId;
            _dal.Update(board);
            OperLogBLL.OperLogUpdate<d_change_board>(board, oldBoard, board.id, userId, DicEnum.OPER_LOG_OBJ_CATE.CHANGE_BOARD, "");
            BoardResourceManage(board.id, resIds, userId);
            return true;
        }
        /// <summary>
        /// 变更委员会员工管理
        /// </summary>
        public void BoardResourceManage(long boardId,string resIds,long userId)
        {
            d_change_board oldBoard = GetBoard(boardId);
            if (oldBoard == null)
                return;
            long timeNow = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            List<d_change_board_person> list = GerPersonList(boardId);
            d_change_board_person_dal cbpDal = new d_change_board_person_dal();
            if (list!=null&& list.Count > 0)
            {
                if (!string.IsNullOrEmpty(resIds))
                {
                    string[] resArr = resIds.Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries);
                    foreach (var resId in resArr)
                    {
                        d_change_board_person boaPerson = list.FirstOrDefault(_=>_.resource_id.ToString()==resId);
                        if (boaPerson != null)
                        {
                            list.Remove(boaPerson);
                            continue;
                        }
                        boaPerson = new d_change_board_person()
                        {
                            id = cbpDal.GetNextIdCom(),
                            change_board_id = boardId,
                            create_time = timeNow,
                            update_time = timeNow,
                            create_user_id = userId,
                            update_user_id = userId,
                            resource_id = long.Parse(resId),
                        };
                        cbpDal.Insert(boaPerson);
                        OperLogBLL.OperLogAdd<d_change_board_person>(boaPerson, boaPerson.id, userId, DicEnum.OPER_LOG_OBJ_CATE.CHANGE_BOARD_PERSON, "");
                    }
                }
                if (list.Count > 0)
                    list.ForEach(_ => {
                        cbpDal.SoftDelete(_,userId);
                        OperLogBLL.OperLogDelete<d_change_board_person>(_, _.id, userId, DicEnum.OPER_LOG_OBJ_CATE.CHANGE_BOARD_PERSON, "");
                    });
            }
            else
            {
                if (!string.IsNullOrEmpty(resIds))
                {
                    string[] resArr = resIds.Split(new char[] {','},StringSplitOptions.RemoveEmptyEntries);
                    foreach (var resId in resArr)
                    {
                        d_change_board_person boaPerson = cbpDal.GetSingleByBoardRes(boardId,long.Parse(resId));
                        if (boaPerson != null)
                            continue;
                        boaPerson = new d_change_board_person() {
                            id=cbpDal.GetNextIdCom(),
                            change_board_id = boardId,
                            create_time = timeNow,
                            update_time = timeNow,
                            create_user_id =userId,
                            update_user_id = userId,
                            resource_id = long.Parse(resId),
                        };
                        cbpDal.Insert(boaPerson);
                        OperLogBLL.OperLogAdd<d_change_board_person>(boaPerson, boaPerson.id, userId, DicEnum.OPER_LOG_OBJ_CATE.CHANGE_BOARD_PERSON, "");
                    }
                }

            }
        }
        /// <summary>
        /// 根据Id 获取
        /// </summary>
        public d_change_board GetBoard(long id)
        {
            return _dal.FindNoDeleteById(id);
        }
        /// <summary>
        /// 委员会名称校验
        /// </summary>
        public bool CheckBoardName(string name,long id=0)
        {
            d_change_board thisBoard = GetBoardByName(name);
            if (thisBoard != null&&thisBoard.id!=id)
                return false;
            return true;
        }
        /// <summary>
        /// 根据名称获取
        /// </summary>
        public d_change_board GetBoardByName(string name)
        {
            return _dal.FindSignleBySql<d_change_board>($"SELECT * from d_change_board where name = '{name}'");
        }
        /// <summary>
        /// 获取变更委员会成员
        /// </summary>
        public List<d_change_board_person> GerPersonList(long boardId)
        {
            return _dal.FindListBySql<d_change_board_person>($"SELECT * from d_change_board_person where delete_time =0 and change_board_id = {boardId}");
        }

    }
}
